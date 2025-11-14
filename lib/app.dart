import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'presentation/routes/app_router.dart';

/// Main Thexeason App
/// Uses GoRouter for navigation and Riverpod for state management
class ThexeasonApp extends ConsumerWidget {
  const ThexeasonApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    
    return MaterialApp.router(
      title: 'Thexeason',
      
      // Theme Configuration
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // TODO: Make this user-configurable
      
      // Router Configuration
      routerConfig: router,
      
      // Disable debug banner
      debugShowCheckedModeBanner: false,
      
      // App Configuration
      builder: (context, child) {
        return MediaQuery(
          // Ensure text scaling doesn't break the UI
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.3),
          ),
          child: child!,
        );
      },
    );
  }
}