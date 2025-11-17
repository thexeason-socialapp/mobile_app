import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'dart:async';

import '../../../../core/errors/failures.dart';
import '../../../../core/errors/error_messages.dart';
import '../../../../domain/entities/user.dart';
import '../../../../domain/usecases/auth/login_usecase.dart';
import '../../../../domain/usecases/auth/sign_up_usecase.dart';
import '../../../../domain/usecases/auth/logout_usecase.dart';
import '../../../../domain/usecases/auth/get_current_user_usecase.dart';
import '../../../../domain/usecases/auth/reset_password_usecase.dart';
import '../../../../domain/usecases/auth/verify_email_usecase.dart';
import '../../../../domain/usecases/auth/check_username_usecase.dart';

// Import your dependency injection providers
import '../../../../core/di/providers.dart';

// ===== AUTH STATE =====

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

class AuthState {
  final AuthStatus status;
  final User? user;
  final String? error;
  final bool isLoading;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.error,
    this.isLoading = false,
  });

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? error,
    bool? isLoading,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  String toString() {
    return 'AuthState(status: $status, user: ${user?.username}, error: $error, isLoading: $isLoading)';
  }
}

// ===== AUTH NOTIFIER =====

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref _ref;

  // ✅ ADD: Firebase listener protection
  bool _isPerformingAuth = false;
  StreamSubscription<firebase_auth.User?>? _authStateSubscription;

  AuthNotifier(this._ref) : super(const AuthState()) {
    // ✅ Setup Firebase auth listener with signup protection
    _setupSmartAuthListener();
  }

  // Lazy getters that only access dependencies when called
  LoginUseCase get _loginUseCase => _ref.read(loginUseCaseProvider);
  SignUpUseCase get _signUpUseCase => _ref.read(signUpUseCaseProvider);
  LogoutUseCase get _logoutUseCase => _ref.read(logoutUseCaseProvider);
  GetCurrentUserUseCase get _getCurrentUserUseCase => _ref.read(getCurrentUserUseCaseProvider);
  ResetPasswordUseCase get _resetPasswordUseCase => _ref.read(resetPasswordUseCaseProvider);
  VerifyEmailUseCase get _verifyEmailUseCase => _ref.read(verifyEmailUseCaseProvider);
  CheckUsernameUseCase get _checkUsernameUseCase => _ref.read(checkUsernameUseCaseProvider);

  // ✅ SMART FIREBASE AUTH LISTENER - Doesn't interfere with signup
  void _setupSmartAuthListener() {
    _authStateSubscription = firebase_auth.FirebaseAuth.instance
        .authStateChanges()
        .listen((firebase_auth.User? firebaseUser) {
      
      // ✅ CRITICAL: Don't interfere during signup process
      if ( _isPerformingAuth) {
        print('🚫 Firebase auth state change ignored - signup in progress');
        return;
      }
      
      print('🔄 Firebase auth state changed: ${firebaseUser?.uid ?? 'null'}');
      _handleFirebaseAuthChange(firebaseUser);
    });
  }

  /// Handle Firebase auth changes (when NOT signing up)
  Future<void> _handleFirebaseAuthChange(firebase_auth.User? firebaseUser) async {
    try {
      if (firebaseUser == null) {
        // User logged out
        print('👋 User logged out via Firebase');
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          user: null,
          error: null,
          isLoading: false,
        );
      } else {
        // User logged in - get full user data from Firestore
        print('👤 Firebase user detected: ${firebaseUser.uid}');
        
        // Only set loading if not already loading to prevent conflicts
        if (state.status != AuthStatus.loading) {
          state = state.copyWith(isLoading: true);
        }
        
        final result = await _getCurrentUserUseCase();
        result.fold(
          (failure) {
            print('❌ Failed to get user data: ${failure.message}');
            state = state.copyWith(
              status: AuthStatus.error,
              error: failure.message,
              isLoading: false,
            );
          },
          (user) {
            if (user != null) {
              print('✅ User data loaded: ${user.username}, verified: ${user.isEmailVerified}');
              state = state.copyWith(
                status: AuthStatus.authenticated,
                user: user,
                error: null,
                isLoading: false,
              );
            } else {
              state = state.copyWith(
                status: AuthStatus.unauthenticated,
                user: null,
                isLoading: false,
              );
            }
          },
        );
      }
    } catch (e) {
      print('❌ Error handling Firebase auth change: $e');
      state = state.copyWith(
        status: AuthStatus.error,
        error: 'Failed to sync auth state',
        isLoading: false,
      );
    }
  }

  // ===== INITIALIZE AUTH STATE =====
  
  Future<void> initializeAuth() async {
    // Don't initialize if signup is in progress
    if (_isPerformingAuth) {
      print('🚫 Skipping auth initialization - signup in progress');
      return;
    }

    try {
      state = state.copyWith(
        isLoading: true,
        status: AuthStatus.loading,
        error: null,
      );
      
      // Wait a bit to ensure Firebase is fully ready
      await Future.delayed(const Duration(milliseconds: 100));
      
      final result = await _getCurrentUserUseCase();
      
      result.fold(
        (failure) {
          // Don't show error on app start, just set unauthenticated
          state = state.copyWith(
            status: AuthStatus.unauthenticated,
            isLoading: false,
            error: null,
          );
        },
        (user) {
          if (user != null) {
            state = state.copyWith(
              status: AuthStatus.authenticated,
              user: user,
              isLoading: false,
              error: null,
            );
          } else {
            state = state.copyWith(
              status: AuthStatus.unauthenticated,
              isLoading: false,
              error: null,
            );
          }
        },
      );
    } catch (e) {
      // Handle any unexpected errors during initialization
      print('Auth initialization error: $e');
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        isLoading: false,
        error: null, // Don't show errors on startup
      );
    }
  }

  // ===== LOGIN =====
  
  Future<Either<Failure, User>> login({
  required String email,
  required String password,
}) async {
  try {
    _isPerformingAuth = true; // Start protection
    state = state.copyWith(
      isLoading: true,
      error: null,
      status: AuthStatus.loading,
    );

    final result = await _loginUseCase(
      email: email,
      password: password,
    );

    return result.fold(
      (failure) {
        _isPerformingAuth = false; // ✅ CRITICAL: Reset flag BEFORE setting state
        final errorMessage = _getErrorMessage(failure);
        state = state.copyWith(
          status: AuthStatus.error, // ✅ Set to error, not unauthenticated
          error: errorMessage,
          isLoading: false,
        );
        return Left(failure);
      },
      (user) {
        print('Login successful: ${user.username}, Email verified: ${user.isEmailVerified}');
        _isPerformingAuth = false; // Reset flag
        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          error: null,
          isLoading: false,
        );
        return Right(user);
      },
    );
  } catch (e) {
    _isPerformingAuth = false; // ✅ CRITICAL: Reset flag on exception
    print('Login error: $e');
    state = state.copyWith(
      status: AuthStatus.error, // ✅ Set to error
      error: 'An unexpected error occurred. Please try again.',
      isLoading: false,
    );
    return Left(ServerFailure('Login failed: ${e.toString()}'));
  }
}
  // ===== 🔥 PROTECTED SIGN UP =====
  
  Future<Either<Failure, User>> signUp({
    required String email,
    required String password,
    required String username,
    required String displayName,
  }) async {
    try {
      print('🚀 Starting PROTECTED signup process...');
      
      // ✅ CRITICAL: Prevent Firebase auth listener interference
       _isPerformingAuth= true;
      
      state = state.copyWith(
        isLoading: true,
        error: null,
        status: AuthStatus.loading,
      );

      final result = await _signUpUseCase(
        email: email,
        password: password,
        username: username,
        displayName: displayName,
      );

      return result.fold(
        (failure) {
          print('❌ Signup failed: ${failure.message}');
           _isPerformingAuth = false; // Reset flag
          
          final errorMessage = _getErrorMessage(failure);
          state = state.copyWith(
            status: AuthStatus.error,
            error: errorMessage,
            isLoading: false,
          );
          return Left(failure);
        },
        (user) {
          print('✅ PROTECTED signup successful: ${user.username}, Email verified: ${user.isEmailVerified}');
          
          // ✅ CRITICAL: Set authenticated state immediately
          state = state.copyWith(
            status: AuthStatus.authenticated,
            user: user,
            error: null,
            isLoading: false,
          );
          
           _isPerformingAuth = false; // Reset flag
          
          // Confirm state stability
          Future.delayed(const Duration(milliseconds: 200), () {
            if (state.user?.id == user.id) {
              print('✅ Protected signup state confirmed stable - router should redirect to verify-email');
            }
          });
          
          return Right(user);
        },
      );
    } catch (e) {
      print('❌ Signup exception: $e');
       _isPerformingAuth = false; // Always reset flag
      
      state = state.copyWith(
        status: AuthStatus.error,
        error: 'An unexpected error occurred. Please try again.',
        isLoading: false,
      );
      return Left(ServerFailure('Sign up failed: ${e.toString()}'));
    }
  }

  /// Clear auth state before signup (remove this - not needed anymore)
  void clearAuthState() {
    // Don't clear during signup protection
    if ( _isPerformingAuth) return;
    
    state = const AuthState(
      status: AuthStatus.unauthenticated,
      user: null,
      error: null,
      isLoading: false,
    );
  }

  // ===== LOGOUT =====
  
  Future<Either<Failure, void>> logout() async {
    try {
      state = state.copyWith(
        isLoading: true,
        error: null,
      );

      final result = await _logoutUseCase();

      return result.fold(
        (failure) {
          final errorMessage = _getErrorMessage(failure);
          state = state.copyWith(
            error: errorMessage,
            isLoading: false,
          );
          return Left(failure);
        },
        (_) {
          state = state.copyWith(
            status: AuthStatus.unauthenticated,
            user: null,
            error: null,
            isLoading: false,
          );
          return const Right(null);
        },
      );
    } catch (e) {
      print('Logout error: $e');
      state = state.copyWith(
        error: 'Failed to logout. Please try again.',
        isLoading: false,
      );
      return Left(ServerFailure('Logout failed: ${e.toString()}'));
    }
  }

  // ===== RESET PASSWORD =====
  
  Future<Either<Failure, bool>> resetPassword(String email) async {
    try {
      state = state.copyWith(
        isLoading: true,
        error: null,
      );

      final result = await _resetPasswordUseCase(email);

      return result.fold(
        (failure) {
          final errorMessage = _getErrorMessage(failure);
          state = state.copyWith(
            error: errorMessage,
            isLoading: false,
          );
          return Left(failure);
        },
        (success) {
          state = state.copyWith(
            error: null,
            isLoading: false,
          );
          return Right(success);
        },
      );
    } catch (e) {
      print('Reset password error: $e');
      state = state.copyWith(
        error: 'Failed to send reset email. Please try again.',
        isLoading: false,
      );
      return Left(ServerFailure('Reset password failed: ${e.toString()}'));
    }
  }

  // ===== VERIFY EMAIL =====
  
  Future<Either<Failure, void>> verifyEmail() async {
    try {
      state = state.copyWith(
        isLoading: true,
        error: null,
      );

      final result = await _verifyEmailUseCase();

      return result.fold(
        (failure) {
          final errorMessage = _getErrorMessage(failure);
          state = state.copyWith(
            error: errorMessage,
            isLoading: false,
          );
          return Left(failure);
        },
        (_) {
          state = state.copyWith(
            error: null,
            isLoading: false,
          );
          return const Right(null);
        },
      );
    } catch (e) {
      print('Verify email error: $e');
      state = state.copyWith(
        error: 'Failed to send verification email. Please try again.',
        isLoading: false,
      );
      return Left(ServerFailure('Verify email failed: ${e.toString()}'));
    }
  }

  // ===== CLEAR ERROR =====
  
  void clearError() {
    state = state.copyWith(error: null);
  }

  // ===== UPDATE USER =====
  
  void updateUser(User user) {
    state = state.copyWith(user: user);
  }

  // ===== RELOAD USER =====
  
  Future<void> reloadUser() async {
    try {
      print('🔄 reloadUser() called - checking verification status...');
      
      // Set loading state
      state = state.copyWith(isLoading: true, error: null);
      
      // Get updated user via use case
      final result = await _getCurrentUserUseCase();
      
      result.fold(
        (failure) {
          print('❌ Failed to reload user: ${failure.message}');
          state = state.copyWith(
            isLoading: false,
            error: failure.message,
          );
        },
        (user) {
          if (user != null) {
            print('✅ User reloaded successfully:');
            print('   Username: ${user.username}');
            print('   Email: ${user.email}');
            print('   Email verified: ${user.isEmailVerified}');
            
            // ✅ CRITICAL FIX: Create a completely new state to ensure change detection
            final oldVerificationStatus = state.user?.isEmailVerified ?? false;
            final newVerificationStatus = user.isEmailVerified;
            
            print('   Previous verification: $oldVerificationStatus');
            print('   New verification: $newVerificationStatus');
            
            state = AuthState(
              status: AuthStatus.authenticated,
              user: user,
              isLoading: false,
              error: null,
            );
            
            // ✅ Force a small delay and manual notification if email verification changed
            if (oldVerificationStatus != newVerificationStatus) {
              print('🔥 Email verification status changed! Forcing router refresh...');
              Future.delayed(const Duration(milliseconds: 100), () {
                // Trigger another state change to ensure router notification
                state = state.copyWith(user: user);
              });
            }
            
          } else {
            state = state.copyWith(
              status: AuthStatus.unauthenticated,
              user: null,
              isLoading: false,
              error: 'User not found',
            );
          }
        },
      );
    } catch (e) {
      print('❌ Exception in reloadUser: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to reload user: ${e.toString()}',
      );
    }
  }

  // ===== CHECK USERNAME AVAILABLE =====
  
  Future<Either<Failure, bool>> checkUsernameAvailable(String username) async {
    try {
      state = state.copyWith(isLoading: true);
      final result = await _checkUsernameUseCase(username);
      state = state.copyWith(isLoading: false);
      return result;
    } catch (e) {
      state = state.copyWith(isLoading: false);
      return Left(ServerFailure('Failed to check username: ${e.toString()}'));
    }
  }

  /// ✅ BONUS: Add method to check verification and force navigation
  Future<bool> checkEmailVerificationAndNavigate() async {
    try {
      await reloadUser();
      
      // Wait for state to update
      await Future.delayed(const Duration(milliseconds: 300));
      
      final user = state.user;
      return user != null && user.isEmailVerified;
      
    } catch (e) {
      print('❌ Error checking verification: $e');
      return false;
    }
  }

  // ===== PRIVATE HELPERS =====

  /// Convert failure to user-friendly error message
  String _getErrorMessage(Failure failure) {
    // Map specific failure codes to user-friendly messages
    switch (failure.code) {
      case 'USER_NOT_FOUND':
        return ErrorMessages.userNotFound;
      case 'WRONG_PASSWORD':
      case 'INVALID_CREDENTIAL':
        return ErrorMessages.invalidCredentials;
      case 'EMAIL_ALREADY_IN_USE':
        return ErrorMessages.emailAlreadyInUse;
      case 'WEAK_PASSWORD':
        return ErrorMessages.weakPassword;
      case 'USER_DISABLED':
        return ErrorMessages.userDisabled;
      case 'TOO_MANY_REQUESTS':
        return ErrorMessages.tooManyAttempts;
      case 'NETWORK_ERROR':
      case 'NO_INTERNET':
        return ErrorMessages.noInternet;
      case 'USERNAME_TAKEN':
        return 'This username is already taken. Please choose another.';
      default:
        // Use the generic error message helper
        return ErrorMessages.fromFailure(failure.message);
    }
  }

  @override
  void dispose() {
    _authStateSubscription?.cancel();
    super.dispose();
  }
}

// ===== MAIN AUTH PROVIDER =====

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});

// ===== CONVENIENCE PROVIDERS =====

/// Get current authenticated user
final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authProvider);
  return authState.user;
});

/// Check if user is authenticated
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  return authState.status == AuthStatus.authenticated;
});

/// Check if auth is loading
final isAuthLoadingProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  return authState.isLoading;
});

/// Get current auth error
final authErrorProvider = Provider<String?>((ref) {
  final authState = ref.watch(authProvider);
  return authState.error;
});