import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/pages/verify_email_page.dart';
import '../features/auth/providers/auth_state_provider.dart';
import '../providers/auth_provider.dart';
import '../features/auth/pages/login_page.dart';
import '../features/auth/pages/signup_page.dart';
import '../features/auth/pages/forgot_password_page.dart';
// import '../features/auth/pages/email_verification_page.dart';
// import '../features/onboarding/pages/splash_page.dart';
// import '../features/onboarding/pages/welcome_page.dart';
// import '../features/home/pages/home_page.dart';
import '../features/feed/pages/feed_page.dart';
import '../features/profile/pages/profile_page.dart';
import '../features/profile/pages/edit_profile_page.dart';
// import '../features/messages/pages/messages_page.dart';
import '../features/messages/pages/chat_page.dart';
import '../features/notifications/pages/notifications_page.dart';
import '../features/settings/pages/settings_page.dart';

/// App Router Configuration with GoRouter
/// Handles authentication guards, deep linking, and navigation
class AppRouter {
  final Ref ref;

  AppRouter(this.ref);

  late final GoRouter router = GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,
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

      // ===== MAIN APP ROUTES (Protected) =====
      // ShellRoute(
      //   builder: (context, state, child) => MainShell(child: child),
      //   routes: [
      //     GoRoute(
      //       path: '/home',
      //       name: 'home',
      //       builder: (context, state) => const HomePage(),
      //     ),
      //     GoRoute(
      //       path: '/feed',
      //       name: 'feed',
      //       builder: (context, state) => const FeedPage(),
      //     ),
      //     GoRoute(
      //       path: '/messages',
      //       name: 'messages',
      //       builder: (context, state) => const MessagesPage(),
      //       routes: [
      //         GoRoute(
      //           path: '/chat/:userId',
      //           name: 'chat',
      //           builder: (context, state) {
      //             final userId = state.pathParameters['userId']!;
      //             final userName = state.uri.queryParameters['userName'] ?? 'User';
      //             return ChatPage(
      //               userId: userId,
      //               userName: userName,
      //             );
      //           },
      //         ),
      //       ],
      //     ),
      //     GoRoute(
      //       path: '/notifications',
      //       name: 'notifications',
      //       builder: (context, state) => const NotificationsPage(),
      //     ),
      //     GoRoute(
      //       path: '/profile',
      //       name: 'profile',
      //       builder: (context, state) => const ProfilePage(),
      //       routes: [
      //         GoRoute(
      //           path: '/edit',
      //           name: 'edit-profile',
      //           builder: (context, state) => const EditProfilePage(),
      //         ),
      //       ],
      //     ),
      //     GoRoute(
      //       path: '/settings',
      //       name: 'settings',
      //       builder: (context, state) => const SettingsPage(),
      //     ),
      //   ],
      // ),

      // ===== USER PROFILE ROUTES =====
      GoRoute(
        path: '/user/:userId',
        name: 'user-profile',
        builder: (context, state) {
          final userId = state.pathParameters['userId']!;
          return UserProfilePage(userId: userId);
        },
      ),

      // ===== POST ROUTES =====
      GoRoute(
        path: '/post/:postId',
        name: 'post-details',
        builder: (context, state) {
          final postId = state.pathParameters['postId']!;
          return PostDetailsPage(postId: postId);
        },
      ),
    ],
    errorBuilder: (context, state) => ErrorPage(error: state.error),
  );

  /// Handle authentication and route guards
  String? _handleRedirect(BuildContext context, GoRouterState state) {
    final authState = ref.read(authProvider);
    final currentLocation = state.uri.toString();
    
    // Don't redirect during splash
    if (currentLocation == '/splash') {
      return null;
    }

    // Handle authentication status
    switch (authState.status) {
      case AuthStatus.initial:
      case AuthStatus.loading:
        return '/splash';

      case AuthStatus.unauthenticated:
        // Allow access to auth pages when not logged in
        if (_isAuthRoute(currentLocation)) {
          return null;
        }
        // Redirect to login for protected routes
        return '/login';

      case AuthStatus.authenticated:
        // Redirect away from auth pages when logged in
        if (_isAuthRoute(currentLocation) || currentLocation == '/splash') {
          return '/home';
        }
        // Allow access to protected routes
        return null;

      case AuthStatus.error:
        // On error, allow auth pages or redirect to login
        if (_isAuthRoute(currentLocation)) {
          return null;
        }
        return '/login';
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
}

/// Main Shell for bottom navigation
class MainShell extends StatelessWidget {
  final Widget child;
  
  const MainShell({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
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
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search_outlined),
          activeIcon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.message_outlined),
          activeIcon: Icon(Icons.message),
          label: 'Messages',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications_outlined),
          activeIcon: Icon(Icons.notifications),
          label: 'Notifications',
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
    if (location.startsWith('/home') || location.startsWith('/feed')) return 0;
    if (location.startsWith('/search')) return 1;
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
        // TODO: Implement search page
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Search coming soon!')),
        );
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

/// Provider for the router
final routerProvider = Provider<GoRouter>((ref) {
  return AppRouter(ref).router;
});

/// Placeholder pages (to be implemented)
class ErrorPage extends StatelessWidget {
  final Exception? error;
  
  const ErrorPage({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text('Page not found', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 8),
            Text('${error ?? "Unknown error"}'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}

class UserProfilePage extends StatelessWidget {
  final String userId;
  
  const UserProfilePage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User $userId')),
      body: Center(
        child: Text('User Profile: $userId'),
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
      appBar: AppBar(title: const Text('Post')),
      body: Center(
        child: Text('Post: $postId'),
      ),
    );
  }
}