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
  
  // Track previous state to detect meaningful changes
  AuthState? _previousState;

  AuthChangeNotifier(this._ref) {
    // Listen to auth state changes with enhanced logic
    _subscription = _ref.listen<AuthState>(
      authProvider,
      (previous, next) {
        print('🔄 Auth state listener triggered');
        print('   Previous: ${previous?.status} | User: ${previous?.user?.username} | Email verified: ${previous?.user?.isEmailVerified}');
        print('   Next: ${next.status} | User: ${next.user?.username} | Email verified: ${next.user?.isEmailVerified}');
        
        // Check if we should trigger router refresh
        final shouldNotify = _shouldNotifyRouter(previous, next);
        
        if (shouldNotify) {
          print('🚦 Triggering router refresh due to meaningful auth state change');
          
          // Small delay to ensure state is fully updated
          Future.delayed(const Duration(milliseconds: 100), () {
            notifyListeners(); // This triggers router refresh
          });
        } else {
          print('   → No router refresh needed (no meaningful change)');
        }
        
        _previousState = next;
      },
    );
  }

  /// Determines if router should be notified based on auth state changes
  bool _shouldNotifyRouter(AuthState? previous, AuthState next) {
    // First time loading - always notify
    if (previous == null) {
      return true;
    }

    // ✅ CRITICAL CASES - Always trigger router refresh for these:
    
    // 1. Auth status changed (loading → authenticated, etc.)
    if (previous.status != next.status) {
      print('   → Status changed: ${previous.status} → ${next.status}');
      return true;
    }

    // 2. User went from null to having a user (signup/login completed)
    if (previous.user == null && next.user != null) {
      print('   → User loaded: null → ${next.user!.username}');
      return true;
    }

    // 3. User went from having a user to null (logout)
    if (previous.user != null && next.user == null) {
      print('   → User cleared: ${previous.user!.username} → null');
      return true;
    }

    // 4. ✅ EMAIL VERIFICATION STATUS CHANGED (most important for your case)
    if (previous.user != null && next.user != null) {
      final emailVerificationChanged = previous.user!.isEmailVerified != next.user!.isEmailVerified;
      if (emailVerificationChanged) {
        print('   → Email verification changed: ${previous.user!.isEmailVerified} → ${next.user!.isEmailVerified}');
        return true;
      }
    }

    // 5. Error state changes
    if (previous.error != next.error) {
      print('   → Error state changed: ${previous.error} → ${next.error}');
      return true;
    }

    // 6. Loading state changes (important for signup flow)
    if (previous.isLoading != next.isLoading) {
      print('   → Loading state changed: ${previous.isLoading} → ${next.isLoading}');
      // Only notify if loading finished and we have a user
      return !next.isLoading && next.user != null;
    }

    // No meaningful change
    return false;
  }

  /// Force router refresh (useful for manual triggers)
  void forceRefresh() {
    print('🔄 Forcing router refresh manually');
    notifyListeners();
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
  /// Enhanced redirect logic with EMAIL VERIFICATION CHECK
/// 🔥 BULLETPROOF ROUTER REDIRECT - Fixes signup and verification flows
String? _handleRedirect(BuildContext context, GoRouterState state) {
  final authState = ref.read(authProvider);
  final currentLocation = state.uri.toString();
  
  print('');
  print('🚦 =================== ROUTER DEBUG ===================');
  print('📍 Current Location: $currentLocation');
  print('🔐 Auth Status: ${authState.status}');
  print('👤 User: ${authState.user?.username ?? 'null'}');
  print('📧 Email Verified: ${authState.user?.isEmailVerified ?? 'null'}');
  print('🔄 Is Loading: ${authState.isLoading}');
  print('❌ Error: ${authState.error ?? 'null'}');

  // ✅ CRITICAL: Handle splash/initial states properly
  if (currentLocation == '/splash') {
    if (authState.status == AuthStatus.initial || authState.status == AuthStatus.loading) {
      print('✅ DECISION: Staying at splash (loading)');
      return null;
    }
  }

  // ✅ CORE ROUTING LOGIC - Priority order matters!
  
  if (authState.status == AuthStatus.loading || authState.status == AuthStatus.initial) {
  // ✅ FIX: Don't redirect auth routes to splash during loading
  if (_isAuthRoute(currentLocation)) {
    print('✅ DECISION: Staying at auth route during loading: $currentLocation');
    return null; // Stay on login/signup page during loading
  }
  
  if (currentLocation != '/splash') {
    print('✅ DECISION: Redirecting to /splash (loading)');
    return '/splash';
  }
  print('✅ DECISION: Staying at splash (loading)');
  return null;
}
  // 2. UNAUTHENTICATED - No user logged in
  if (authState.status == AuthStatus.unauthenticated || authState.user == null) {
    print('🚫 STATUS: Unauthenticated or no user');
    
    // Allow auth routes
    if (_isAuthRoute(currentLocation)) {
      print('✅ DECISION: Staying at auth route: $currentLocation');
      return null;
    }
    
    // Redirect protected routes to welcome
    if (_isProtectedRoute(currentLocation)) {
      print('✅ DECISION: Redirecting to /welcome (no user)');
      return '/welcome';
    }
    
    // Redirect splash to welcome when not authenticated
    if (currentLocation == '/splash') {
      print('✅ DECISION: Redirecting to /welcome (not authenticated)');
      return '/welcome';
    }
    
    print('✅ DECISION: No redirect needed (unauthenticated)');
    return null;
  }

  // 3. AUTHENTICATED - User is logged in
  if (authState.status == AuthStatus.authenticated && authState.user != null) {
    final user = authState.user!;
    print('🔐 STATUS: Authenticated user: ${user.username}');
    print('📧 Email verification status: ${user.isEmailVerified}');

    // ✅ EMAIL NOT VERIFIED - Force email verification
    if (!user.isEmailVerified) {
      print('📧 EMAIL NOT VERIFIED');
      
      // Already on verification page - stay there
      if (currentLocation == '/verify-email') {
        print('✅ DECISION: Staying at email verification page');
        return null;
      }
      
      // From any other location - go to verification
      print('✅ DECISION: Redirecting to /verify-email (email not verified)');
      return '/verify-email';
    }

    // ✅ EMAIL VERIFIED - Full access
    print('✅ EMAIL VERIFIED - Full access granted');
    
    // Redirect away from auth pages to home
    if (_isAuthRoute(currentLocation) || currentLocation == '/splash' || currentLocation == '/welcome') {
      print('✅ DECISION: Redirecting to /home (fully authenticated)');
      return '/home';
    }
    
    // Stay on protected routes
    if (_isProtectedRoute(currentLocation)) {
      print('✅ DECISION: Staying at protected route: $currentLocation');
      return null;
    }
    
    print('✅ DECISION: No redirect needed (authenticated)');
    return null;
  }

  // 4. ERROR STATE
  if (authState.status == AuthStatus.error) {
  print('❌ STATUS: Error state');
  print('🔍 Current location: $currentLocation');
  print('🔍 Is auth route check: ${_isAuthRoute(currentLocation)}');
  
  // Allow auth routes during error
  if (_isAuthRoute(currentLocation)) {
    print('✅ DECISION: Staying at auth route (error): $currentLocation');
    return null;
  }
  
  print('✅ DECISION: Redirecting to /welcome (error state)');
  return '/welcome';
}

  // 5. FALLBACK
  print('⚠️ FALLBACK: No specific routing rule matched');
  print('✅ DECISION: No redirect (fallback)');
  return null;
}

/// Check if route is an authentication route
bool _isAuthRoute(String location) {
  final authRoutes = [
    '/welcome',
    '/login',
    '/signup',
    '/forgot-password',
    '/verify-email', // Email verification is part of auth flow
  ];
  return authRoutes.any((route) => location.startsWith(route));
}

/// Check if route is a protected route (requires authentication)
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