import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';

/// Firebase Service - Singleton for Firebase instances
/// Safe implementation that checks Firebase initialization
class FirebaseService {
  static FirebaseService? _instance;
  static FirebaseService get instance => _instance ??= FirebaseService._();
  
  FirebaseService._();

  /// Check if Firebase is properly initialized
  bool get isInitialized => Firebase.apps.isNotEmpty;

  /// Firebase Auth instance - safe access
  firebase_auth.FirebaseAuth get auth {
    if (!isInitialized) {
      throw StateError('Firebase not initialized. Ensure Firebase.initializeApp() is called first.');
    }
    return firebase_auth.FirebaseAuth.instance;
  }

  /// Cloud Firestore instance - safe access
  FirebaseFirestore get firestore {
    if (!isInitialized) {
      throw StateError('Firebase not initialized. Ensure Firebase.initializeApp() is called first.');
    }
    return FirebaseFirestore.instance;
  }

  /// Firebase Storage instance - safe access
  FirebaseStorage get storage {
    if (!isInitialized) {
      throw StateError('Firebase not initialized. Ensure Firebase.initializeApp() is called first.');
    }
    return FirebaseStorage.instance;
  }

  /// Firebase Messaging instance - safe access
  FirebaseMessaging get messaging {
    if (!isInitialized) {
      throw StateError('Firebase not initialized. Ensure Firebase.initializeApp() is called first.');
    }
    return FirebaseMessaging.instance;
  }
}