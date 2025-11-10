import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../models/user_model.dart';
import 'firebase_service.dart';

abstract class AuthDataSource {
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String username,
    required String displayName,
  });
  
  Future<UserModel> login({
    required String email,
    required String password,
  });
  
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
  Future<void> sendPasswordResetEmail(String email);
  Future<void> verifyEmail();
}

class AuthDataSourceImpl implements AuthDataSource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  
  AuthDataSourceImpl({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseService.instance.auth,
        _firestore = firestore ?? FirebaseService.instance.firestore;

  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String username,
    required String displayName,
  }) async {
    try {
      // Create auth account
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final user = credential.user!;
      
      // Create user document
      final userModel = UserModel(
        id: user.uid,
        email: email,
        username: username,
        displayName: displayName,
        bio: '',
        avatar: '',
        banner: '',
        followers: 0,
        following: 0,
        postsCount: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isPrivate: false,
        verified: false,
        blockedUsers: const [],
        preferences: const UserPreferencesModel(
          darkMode: false,
          notificationsEnabled: true,
          emailNotifications: true,
        ),
      );
      
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(userModel.toJson());
      
      // Send verification email
      await user.sendEmailVerification();
      
      return userModel;
      
    } on FirebaseAuthException catch (e) {
      throw AuthException(_handleAuthError(e));
    } catch (e) {
      throw ServerException('Failed to sign up: $e');
    }
  }
  
  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final doc = await _firestore
          .collection('users')
          .doc(credential.user!.uid)
          .get();
      
      if (!doc.exists) {
        throw const NotFoundException.userNotFound();
      }
      
      return UserModel.fromJson(doc.data()!);
      
    } on FirebaseAuthException catch (e) {
      throw AuthException(_handleAuthError(e));
    } catch (e) {
      if (e is AuthException || e is NotFoundException) rethrow;
      throw ServerException('Failed to login: $e');
    }
  }
  
  @override
  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw ServerException('Failed to logout: $e');
    }
  }
  
  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;
      
      final doc = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();
      
      if (!doc.exists) return null;
      
      return UserModel.fromJson(doc.data()!);
      
    } catch (e) {
      throw ServerException('Failed to get current user: $e');
    }
  }
  
  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthException(_handleAuthError(e));
    } catch (e) {
      throw ServerException('Failed to send reset email: $e');
    }
  }
  
  @override
  Future<void> verifyEmail() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw const AuthException('No user logged in');
      }
      await user.sendEmailVerification();
    } catch (e) {
      throw ServerException('Failed to send verification: $e');
    }
  }
  
  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email';
      case 'wrong-password':
        return 'Wrong password provided';
      case 'email-already-in-use':
        return 'An account already exists with this email';
      case 'invalid-email':
        return 'Invalid email address';
      case 'weak-password':
        return 'Password is too weak';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later';
      default:
        return 'Authentication error: ${e.message}';
    }
  }
}