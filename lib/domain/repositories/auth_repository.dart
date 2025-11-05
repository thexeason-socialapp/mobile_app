/// 🔐 AUTH REPOSITORY INTERFACE
/// Abstract contract defining authentication operations
/// Implementation will be in the data layer
/// No dependencies on Firebase or external packages

import '../entities/user.dart';

abstract class AuthRepository {
  /// Sign up a new user with email and password
  /// Returns the created [User] on success, throws exception on failure
  Future<User> signUp({
    required String email,
    required String password,
    required String username,
    required String displayName,
  });

  /// Login with email and password
  /// Returns the authenticated [User] on success, throws exception on failure
  Future<User> login({
    required String email,
    required String password,
  });

  /// Logout the current user
  /// Clears local session and Firebase auth state
  Future<void> logout();

  /// Send password reset email
  /// Returns true if email was sent successfully
  Future<bool> sendPasswordResetEmail(String email);

  /// Verify email address
  /// Sends verification email to the current user
  Future<void> verifyEmail();

  /// Get currently authenticated user
  /// Returns [User] if logged in, null if not authenticated
  Future<User?> getCurrentUser();

  /// Listen to authentication state changes
  /// Returns a stream that emits [User] when logged in, null when logged out
  Stream<User?> authStateChanges();

  /// Check if user is authenticated
  /// Returns true if user is currently logged in
  Future<bool> isAuthenticated();

  /// Update email
  /// Requires re-authentication for security
  Future<void> updateEmail(String newEmail);

  /// Update password
  /// Requires current password for verification
  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  });

  /// Delete account
  /// Permanently deletes user account and all associated data
  Future<void> deleteAccount(String password);

  /// Re-authenticate user (for sensitive operations)
  /// Returns true if re-authentication was successful
  Future<bool> reauthenticate(String password);
}