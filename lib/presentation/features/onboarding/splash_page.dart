import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../auth/providers/auth_state_provider.dart';

/// Splash Page - App startup screen
/// Initializes authentication state and determines initial route
class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
    ));

    // Start animations
    _animationController.forward();
    
    // Initialize auth state after a brief delay
    _initializeApp();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Initialize app and auth state
  Future<void> _initializeApp() async {
    try {
      // Wait for animations to start
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Initialize authentication
      await ref.read(authProvider.notifier).initializeAuth();
      
      // Wait for minimum splash duration for better UX
      await Future.delayed(const Duration(milliseconds: 1500));
      
      // Navigate based on auth state
      if (mounted) {
        _handleAuthState();
      }
    } catch (e) {
      // Handle any startup errors
      print('App initialization error: $e');
      if (mounted) {
        context.go('/login');
      }
    }
  }

  /// Handle navigation based on auth state
  void _handleAuthState() {
    final authState = ref.read(authProvider);
    
    switch (authState.status) {
      case AuthStatus.authenticated:
        context.go('/home');
        break;
      case AuthStatus.unauthenticated:
        context.go('/welcome');
        break;
      case AuthStatus.error:
        context.go('/login');
        break;
      case AuthStatus.initial:
      case AuthStatus.loading:
        // Wait a bit more
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) _handleAuthState();
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFC107), // Thexeason yellow
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // App Logo
                    Container(
                      width: 120,
                      height: 120,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.auto_awesome,
                        size: 60,
                        color: Color(0xFFFFC107),
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // App Name
                    const Text(
                      'Thexeason',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Tagline
                    const Text(
                      'Connect. Share. Inspire.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    
                    const SizedBox(height: 48),
                    
                    // Loading Indicator
                    const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}