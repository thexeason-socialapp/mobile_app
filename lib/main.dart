import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Import your app files
import 'data/datasources/remote/firebase/firebase_service.dart';
import 'firebase_options.dart';
import 'app.dart';

/// Main entry point for Thexeason App
/// Handles initialization and app startup
void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    // Verify Firebase services are working
    print('✅ Firebase initialized successfully');
    print('✅ Firebase Auth: ${FirebaseService.instance.auth.currentUser?.uid ?? "No user"}');
    print('✅ Firestore: ${FirebaseService.instance.firestore.app.name}');
    
  } catch (e) {
    print('❌ Firebase initialization failed: $e');
    // Don't crash the app, let it handle the error gracefully
  }
  
  // Set system UI overlay style (status bar, navigation bar)
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      // Status bar (top)
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      
      // Navigation bar (bottom) - Android only
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarDividerColor: Colors.transparent,
    ),
  );
  
  // Lock orientation to portrait only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set edge-to-edge display
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
  );

  print('🚀 Starting Thexeason App...');
  
  // Run the app with Riverpod provider scope
  runApp(
    const ProviderScope(
      child: ThexeasonApp(),
    ),
  );
}