/// 🔐 AUTH REPOSITORY INTERFACE (UPDATED)
/// Abstract contract defining authentication operations
/// Returns Either<Failure, T> for consistent error handling
/// No dependencies on Firebase or external packages

import 'package:dartz/dartz.dart';
import '../entities/user.dart';
import '../../core/errors/failures.dart';

abstract class AuthRepository {
  /// Sign up a new user with email and password
  /// Returns [Right(User)] on success, [Left(Failure)] on error
  Future<Either<Failure, User>> signUp({
    required String email,
    required String password,
    required String username,
    required String displayName,
  });

  /// Login with email and password
  /// Returns [Right(User)] on success, [Left(Failure)] on error
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });

  /// Logout the current user
  /// Returns [Right(void)] on success, [Left(Failure)] on error
  Future<Either<Failure, void>> logout();

  /// Send password reset email
  /// Returns [Right(bool)] on success, [Left(Failure)] on error
  Future<Either<Failure, bool>> sendPasswordResetEmail(String email);

  /// Verify email address
  /// Returns [Right(void)] on success, [Left(Failure)] on error
  Future<Either<Failure, void>> verifyEmail();

  /// Get currently authenticated user
  /// Returns [Right(User?)] on success, [Left(Failure)] on error
  Future<Either<Failure, User?>> getCurrentUser();

  /// Listen to authentication state changes
  /// Returns a stream that emits [Right(User?)] on state change, [Left(Failure)] on error
  Stream<Either<Failure, User?>> authStateChanges();

  /// Check if user is authenticated
  /// Returns [Right(bool)] on success, [Left(Failure)] on error
  Future<Either<Failure, bool>> isAuthenticated();

  /// Update email (requires re-authentication for security)
  /// Returns [Right(void)] on success, [Left(Failure)] on error
  Future<Either<Failure, void>> updateEmail(String newEmail);

  /// Update password (requires current password for verification)
  /// Returns [Right(void)] on success, [Left(Failure)] on error
  Future<Either<Failure, void>> updatePassword({
    required String currentPassword,
    required String newPassword,
  });

  /// Delete account (permanently deletes user account and all associated data)
  /// Returns [Right(void)] on success, [Left(Failure)] on error
  Future<Either<Failure, void>> deleteAccount(String password);

  /// Re-authenticate user (for sensitive operations)
  /// Returns [Right(bool)] on success, [Left(Failure)] on error
  Future<Either<Failure, bool>> reauthenticate(String password);
}