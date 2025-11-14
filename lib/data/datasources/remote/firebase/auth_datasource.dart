import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../models/user_model.dart';
import 'firebase_service.dart';

/// Firebase Authentication Data Source
/// Handles all Firebase Auth and Firestore operations
/// Converts Firebase errors to app-specific exceptions
class FirebaseAuthDataSource {
  final firebase_auth.FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  FirebaseAuthDataSource({
    firebase_auth.FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseService.instance.auth,
        _firestore = firestore ?? FirebaseService.instance.firestore;

  /// Sign up a new user with email and password
  /// Creates Firebase Auth user and Firestore user document
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String username,
    required String displayName,
  }) async {
    try {
      // Check if username is already taken
      final usernameExists = await _isUsernameTaken(username);
      if (usernameExists) {
        throw const AuthException('Username is already taken', code: 'USERNAME_TAKEN');
      }

      // Create Firebase Auth user
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw const AuthException('Failed to create user account');
      }

      final userId = credential.user!.uid;
      final now = DateTime.now();

      // Create user document in Firestore
      final userModel = UserModel(
        id: userId,
        email: email,
        username: username,
        displayName: displayName,
        createdAt: now,
        updatedAt: now,
      );

      await _firestore
          .collection('users')
          .doc(userId)
          .set(userModel.toJson());

      // Update Firebase Auth display name
      await credential.user!.updateDisplayName(displayName);

      return userModel;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(e);
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Failed to create account: ${e.toString()}');
    }
  }

  /// Login with email and password
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw const AuthException('Login failed');
      }

      // Get user data from Firestore
      final userDoc = await _firestore
          .collection('users')
          .doc(credential.user!.uid)
          .get();

      if (!userDoc.exists) {
        // User exists in Auth but not in Firestore, create missing document
        final userModel = UserModel(
          id: credential.user!.uid,
          email: credential.user!.email!,
          username: credential.user!.email!.split('@')[0], // Fallback username
          displayName: credential.user!.displayName ?? 'User',
          createdAt: DateTime.now(),
        );

        await _firestore
            .collection('users')
            .doc(credential.user!.uid)
            .set(userModel.toJson());

        return userModel;
      }

      return UserModel.fromJson(userDoc.data()!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(e);
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Login failed: ${e.toString()}');
    }
  }

  /// Logout current user
  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw AuthException('Failed to logout: ${e.toString()}');
    }
  }

  /// Send password reset email
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(e);
    } catch (e) {
      throw AuthException('Failed to send password reset email: ${e.toString()}');
    }
  }

  /// Send email verification
  Future<void> verifyEmail() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw const AuthException('No user is currently signed in');
      }

      await user.sendEmailVerification();
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(e);
    } catch (e) {
      throw AuthException('Failed to send verification email: ${e.toString()}');
    }
  }

  /// Get current authenticated user
  Future<UserModel?> getCurrentUser() async {
    try {
      final firebaseUser = _auth.currentUser;
      if (firebaseUser == null) {
        return null;
      }

      // Get user data from Firestore
      final userDoc = await _firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      if (!userDoc.exists) {
        return null;
      }

      return UserModel.fromJson(userDoc.data()!);
    } catch (e) {
      throw AuthException('Failed to get current user: ${e.toString()}');
    }
  }

  /// Listen to authentication state changes
  Stream<UserModel?> authStateChanges() {
    return _auth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) {
        return null;
      }

      try {
        final userDoc = await _firestore
            .collection('users')
            .doc(firebaseUser.uid)
            .get();

        if (!userDoc.exists) {
          return null;
        }

        return UserModel.fromJson(userDoc.data()!);
      } catch (e) {
        return null;
      }
    });
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    return _auth.currentUser != null;
  }

  /// Check if username is already taken
  Future<bool> _isUsernameTaken(String username) async {
    try {
      final query = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      return query.docs.isNotEmpty;
    } catch (e) {
      // If we can't check, assume it's not taken to avoid blocking signup
      return false;
    }
  }

  /// Map Firebase Auth exceptions to app exceptions
  AuthException _mapFirebaseAuthException(firebase_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return const AuthException('No account found with this email', code: 'USER_NOT_FOUND');
      case 'wrong-password':
        return const AuthException('Incorrect password', code: 'WRONG_PASSWORD');
      case 'invalid-email':
        return const AuthException('Invalid email address', code: 'INVALID_EMAIL');
      case 'user-disabled':
        return const AuthException('This account has been disabled', code: 'USER_DISABLED');
      case 'too-many-requests':
        return const AuthException('Too many failed attempts. Try again later.', code: 'TOO_MANY_REQUESTS');
      case 'operation-not-allowed':
        return const AuthException('Email/password sign-in is not enabled', code: 'OPERATION_NOT_ALLOWED');
      case 'email-already-in-use':
        return const AuthException('An account already exists with this email', code: 'EMAIL_ALREADY_IN_USE');
      case 'weak-password':
        return const AuthException('Password is too weak', code: 'WEAK_PASSWORD');
      case 'invalid-credential':
        return const AuthException('Invalid email or password', code: 'INVALID_CREDENTIAL');
      // case 'network-request-failed':
      //   return const NetworkException('Network error. Check your connection and try again.', code: 'NETWORK_ERROR');
      default:
        return AuthException(e.message ?? 'Authentication failed', code: e.code);
    }
  }
}