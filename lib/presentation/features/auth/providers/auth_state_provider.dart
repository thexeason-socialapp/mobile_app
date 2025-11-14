import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/errors/error_messages.dart';
import '../../../../domain/entities/user.dart';
import '../../../../domain/usecases/auth/login_usecase.dart';
import '../../../../domain/usecases/auth/sign_up_usecase.dart';
import '../../../../domain/usecases/auth/logout_usecase.dart';
import '../../../../domain/usecases/auth/get_current_user_usecase.dart';
import '../../../../domain/usecases/auth/reset_password_usecase.dart';
import '../../../../domain/usecases/auth/verify_email_usecase.dart';

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

  AuthNotifier(this._ref) : super(const AuthState());

  // Lazy getters that only access dependencies when called
  LoginUseCase get _loginUseCase => _ref.read(loginUseCaseProvider);
  SignUpUseCase get _signUpUseCase => _ref.read(signUpUseCaseProvider);
  LogoutUseCase get _logoutUseCase => _ref.read(logoutUseCaseProvider);
  GetCurrentUserUseCase get _getCurrentUserUseCase => _ref.read(getCurrentUserUseCaseProvider);
  ResetPasswordUseCase get _resetPasswordUseCase => _ref.read(resetPasswordUseCaseProvider);
  VerifyEmailUseCase get _verifyEmailUseCase => _ref.read(verifyEmailUseCaseProvider);

  // ===== INITIALIZE AUTH STATE =====
  
  Future<void> initializeAuth() async {
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
          final errorMessage = _getErrorMessage(failure);
          state = state.copyWith(
            status: AuthStatus.error,
            error: errorMessage,
            isLoading: false,
          );
          return Left(failure);
        },
        (user) {
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
      print('Login error: $e');
      state = state.copyWith(
        status: AuthStatus.error,
        error: 'An unexpected error occurred. Please try again.',
        isLoading: false,
      );
      return Left(ServerFailure('Login failed: ${e.toString()}'));
    }
  }

  // ===== SIGN UP =====
  
  Future<Either<Failure, User>> signUp({
    required String email,
    required String password,
    required String username,
    required String displayName,
  }) async {
    try {
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
          final errorMessage = _getErrorMessage(failure);
          state = state.copyWith(
            status: AuthStatus.error,
            error: errorMessage,
            isLoading: false,
          );
          return Left(failure);
        },
        (user) {
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
      print('Sign up error: $e');
      state = state.copyWith(
        status: AuthStatus.error,
        error: 'An unexpected error occurred. Please try again.',
        isLoading: false,
      );
      return Left(ServerFailure('Sign up failed: ${e.toString()}'));
    }
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