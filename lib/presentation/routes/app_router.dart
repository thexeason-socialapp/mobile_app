import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Import all required pages
import '../../shared/widgets/responsive/responsive_shell.dart';
import '../features/auth/pages/login_page.dart';
import '../features/auth/pages/signup_page.dart';
import '../features/auth/pages/forgot_password_page.dart';
import '../features/auth/pages/verify_email_page.dart';
import '../features/auth/providers/auth_state_provider.dart';
import '../features/feed/pages/feed_page.dart';
import '../features/onboarding/home_page.dart';
import '../features/onboarding/splash_page.dart';
import '../features/onboarding/welcome_page.dart';
import '../features/profile/pages/profile_page.dart';
import '../features/profile/pages/edit_profile_page.dart';
import '../features/messages/pages/chat_page.dart';
import '../features/notifications/pages/notifications_page.dart';
import '../features/settings/pages/settings_page.dart';

/// Auth Change Notifier - Makes router reactive to auth changes
/// Auth Change Notifier - Makes router reactive to auth changes
class AuthChangeNotifier extends ChangeNotifier {
  final Ref _ref;
  late final ProviderSubscription<AuthState> _subscription;

  AuthChangeNotifier(this._ref) {
    // Listen to auth state changes
    _subscription = _ref.listen<AuthState>(
      authProvider,
      (previous, next) {
        // Only notify if auth status actually changed
        if (previous?.status != next.status) {
          print('🔄 Auth state changed: ${previous?.status} → ${next.status}');
          notifyListeners(); // This triggers router refresh
        }
      },
    );
  }

  @override
  void dispose() {
    _subscription.close();
    super.dispose();
  }
}

  

/// Secure App Router Configuration with Real-time Auth Reactivity
class AppRouter {
  final Ref ref;
  late final AuthChangeNotifier _authChangeNotifier;

  AppRouter(this.ref) {
    _authChangeNotifier = AuthChangeNotifier(ref);
  }

  late final GoRouter router = GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: false,
    
    // 🔥 KEY FIX: Make router reactive to auth state changes
    refreshListenable: _authChangeNotifier,
    
    redirect: _handleRedirect,
    routes: [
      // ===== SPLASH & ONBOARDING =====
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/welcome',
        name: 'welcome',
        builder: (context, state) => const WelcomePage(),
      ),

      // ===== AUTHENTICATION ROUTES =====
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignUpPage(),
      ),
      GoRoute(
        path: '/forgot-password',
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: '/verify-email',
        name: 'verify-email',
        builder: (context, state) => const EmailVerificationPage(),
      ),

      // ===== MAIN APP ROUTES (Protected with Shell) =====
      ShellRoute(
        builder: (context, state, child) => ResponsiveShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: '/feed',
            name: 'feed',
            builder: (context, state) => const FeedPage(),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfilePage(),
            routes: [
              GoRoute(
                path: 'edit',
                name: 'edit-profile',
                builder: (context, state) => const EditProfilePage(),
              ),
            ],
          ),
          GoRoute(
            path: '/messages',
            name: 'messages',
            builder: (context, state) => const ChatPage(), // Temporary
          ),
          GoRoute(
            path: '/notifications',
            name: 'notifications',
            builder: (context, state) => const NotificationsPage(),
          ),
          GoRoute(
            path: '/settings',
            name: 'settings',
            builder: (context, state) => const SettingsPage(),
          ),
        ],
      ),

      // ===== INDIVIDUAL ROUTES (Outside Shell) =====
      GoRoute(
        path: '/user/:userId',
        name: 'user-profile',
        builder: (context, state) {
          final userId = state.pathParameters['userId']!;
          return UserProfilePage(userId: userId);
        },
      ),
      GoRoute(
        path: '/post/:postId',
        name: 'post-details',
        builder: (context, state) {
          final postId = state.pathParameters['postId']!;
          return PostDetailsPage(postId: postId);
        },
      ),
      // GoRoute(
      //   path: '/chat/:userId',
      //   name: 'chat',
      //   builder: (context, state) {
      //     final userId = state.pathParameters['userId']!;
      //     final userName = state.uri.queryParameters['userName'] ?? 'User';
      //     return ChatPage(
      //       userId: userId,
      //       userName: userName,
      //     );
      //   },
      // ),
    ],
    
    // Error handling
    errorBuilder: (context, state) => ErrorPage(
      error: state.error?.toString() ?? 'Unknown error',
    ),
  );

  /// Enhanced redirect logic with better logging
  String? _handleRedirect(BuildContext context, GoRouterState state) {
    final authState = ref.read(authProvider);
    final currentLocation = state.uri.toString();
    
    print('🚦 Router redirect check: ${authState.status} at $currentLocation');
    
    // Always allow splash page during initial load
    if (currentLocation == '/splash' && authState.status == AuthStatus.initial) {
      print('   → Staying at splash (initial)');
      return null;
    }

    // Handle auth status
    switch (authState.status) {
      case AuthStatus.initial:
      case AuthStatus.loading:
        // Still loading, redirect to splash
        if (currentLocation != '/splash') {
          print('   → Redirecting to /splash (loading)');
          return '/splash';
        }
        return null;

      case AuthStatus.unauthenticated:
        // User not logged in
        if (_isAuthRoute(currentLocation)) {
          print('   → Staying at auth route: $currentLocation');
          return null; // Allow auth pages
        }
        if (_isProtectedRoute(currentLocation)) {
          print('   → Redirecting to /welcome (unauthenticated accessing protected)');
          return '/welcome'; // Redirect protected routes to welcome
        }
        return null;

      case AuthStatus.authenticated:
        // User is logged in
        if (_isAuthRoute(currentLocation) || currentLocation == '/splash' || currentLocation == '/welcome') {
          print('   → Redirecting to /home (authenticated at auth route)');
          return '/home'; // Redirect away from auth pages
        }
        print('   → Staying at protected route: $currentLocation');
        return null; // Allow protected routes

      case AuthStatus.error:
        // Auth error occurred
        if (_isAuthRoute(currentLocation)) {
          print('   → Staying at auth route (error): $currentLocation');
          return null; // Allow auth pages
        }
        print('   → Redirecting to /welcome (error)');
        return '/welcome'; // Redirect to welcome with option to login
    }
  }

  /// Check if route is an authentication route
  bool _isAuthRoute(String location) {
    final authRoutes = [
      '/welcome',
      '/login',
      '/signup',
      '/forgot-password',
      '/verify-email',
    ];
    return authRoutes.any((route) => location.startsWith(route));
  }

  /// Check if route is a protected route
  bool _isProtectedRoute(String location) {
    final protectedRoutes = [
      '/home',
      '/feed',
      '/profile',
      '/messages',
      '/notifications',
      '/settings',
      '/user',
      '/post',
      '/chat',
    ];
    return protectedRoutes.any((route) => location.startsWith(route));
  }

  /// Cleanup
  void dispose() {
    _authChangeNotifier.dispose();
  }
}

/// Main Shell for bottom navigation (Protected Routes Only)
class MainShell extends ConsumerWidget {
  final Widget child;
  
  const MainShell({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: child,
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}

/// Bottom Navigation Bar
class BottomNavBar extends ConsumerWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocation = GoRouterState.of(context).uri.toString();
    
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _getCurrentIndex(currentLocation),
      onTap: (index) => _onNavTap(context, index),
      selectedItemColor: const Color(0xFFFFC107),
      unselectedItemColor: Colors.grey[600],
      backgroundColor: Colors.white,
      elevation: 8,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.dynamic_feed_outlined),
          activeIcon: Icon(Icons.dynamic_feed),
          label: 'Feed',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.message_outlined),
          activeIcon: Icon(Icons.message),
          label: 'Messages',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications_outlined),
          activeIcon: Icon(Icons.notifications),
          label: 'Alerts',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }

  int _getCurrentIndex(String location) {
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/feed')) return 1;
    if (location.startsWith('/messages')) return 2;
    if (location.startsWith('/notifications')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0;
  }

  void _onNavTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/feed');
        break;
      case 2:
        context.go('/messages');
        break;
      case 3:
        context.go('/notifications');
        break;
      case 4:
        context.go('/profile');
        break;
    }
  }
}

/// Provider for the router (with proper cleanup)
final routerProvider = Provider<GoRouter>((ref) {
  final appRouter = AppRouter(ref);
  
  // Cleanup when provider is disposed
  ref.onDispose(() {
    appRouter.dispose();
  });
  
  return appRouter.router;
});

/// Error Page
class ErrorPage extends StatelessWidget {
  final String error;
  
  const ErrorPage({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              
              const SizedBox(height: 24),
              
              const Text(
                'Oops! Something went wrong',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              
              const SizedBox(height: 16),
              
              Text(
                error,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              
              const SizedBox(height: 32),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.go('/home'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFC107),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Go Home',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Temporary placeholder pages
class UserProfilePage extends StatelessWidget {
  final String userId;
  
  const UserProfilePage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User $userId'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF111827),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          'User Profile: $userId',
          style: const TextStyle(
            fontSize: 18,
            color: Color(0xFF111827),
          ),
        ),
      ),
    );
  }
}

class PostDetailsPage extends StatelessWidget {
  final String postId;
  
  const PostDetailsPage({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Details'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF111827),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          'Post: $postId',
          style: const TextStyle(
            fontSize: 18,
            color: Color(0xFF111827),
          ),
        ),
      ),
    );
  }
}