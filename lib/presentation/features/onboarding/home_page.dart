import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/providers/auth_state_provider.dart';

/// Home Page - Main landing page for authenticated users
/// Enhanced with better logout handling and auth state awareness
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Thexeason',
          style: TextStyle(
            color: Color(0xFF111827),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // Auth status indicator (for debugging)
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(authState.status),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _getStatusText(authState.status),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          
          // Settings
          IconButton(
            onPressed: () {
              // TODO: Navigate to settings
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings coming soon!')),
              );
            },
            icon: const Icon(
              Icons.settings_outlined,
              color: Color(0xFF111827),
            ),
          ),
        ],
      ),
      
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Welcome Message
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFFFC107),
                      Color(0xFFFFB300),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back${user?.displayName != null ? ', ${user!.displayName}' : ''}!',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    const Text(
                      'Ready to connect and share?',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    
                    if (user?.username != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        '@${user!.username}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Quick Actions
              const Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Action Buttons Grid
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _ActionCard(
                      icon: Icons.feed_outlined,
                      title: 'Feed',
                      description: 'See latest posts',
                      onTap: () {
                        // TODO: Navigate to feed
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Feed coming soon!')),
                        );
                      },
                    ),
                    
                    _ActionCard(
                      icon: Icons.person_outlined,
                      title: 'Profile',
                      description: 'View your profile',
                      onTap: () {
                        // TODO: Navigate to profile
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Profile coming soon!')),
                        );
                      },
                    ),
                    
                    _ActionCard(
                      icon: Icons.message_outlined,
                      title: 'Messages',
                      description: 'Chat with friends',
                      onTap: () {
                        // TODO: Navigate to messages
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Messages coming soon!')),
                        );
                      },
                    ),
                    
                    _ActionCard(
                      icon: Icons.add_circle_outline,
                      title: 'Create Post',
                      description: 'Share something new',
                      onTap: () {
                        // TODO: Navigate to post creation
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Post creation coming soon!')),
                        );
                      },
                    ),
                  ],
                ),
              ),
              
              // Auth Debug Info (remove in production)
              if (authState.status != AuthStatus.authenticated) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '⚠️ Auth Status Debug:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      Text('Status: ${authState.status}'),
                      if (authState.error != null) 
                        Text('Error: ${authState.error}'),
                      Text('User: ${user?.username ?? 'null'}'),
                    ],
                  ),
                ),
              ],
              
              // Logout Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: authState.isLoading 
                      ? null 
                      : () => _handleLogout(context, ref),
                  icon: authState.isLoading 
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.logout),
                  label: Text(authState.isLoading ? 'Logging out...' : 'Logout'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Enhanced logout handler with better feedback
  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    print('🔴 Logout button pressed');
    
    try {
      final result = await ref.read(authProvider.notifier).logout();
      
      result.fold(
        (failure) {
          print('❌ Logout failed: ${failure.message}');
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Logout failed: ${failure.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        (_) {
          print('✅ Logout successful - router should redirect automatically');
          // Don't manually navigate - let the reactive router handle it
        },
      );
    } catch (e) {
      print('❌ Logout error: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Get color for auth status indicator
  Color _getStatusColor(AuthStatus status) {
    switch (status) {
      case AuthStatus.authenticated:
        return Colors.green;
      case AuthStatus.unauthenticated:
        return Colors.red;
      case AuthStatus.loading:
        return Colors.orange;
      case AuthStatus.error:
        return Colors.red;
      case AuthStatus.initial:
        return Colors.grey;
    }
  }

  /// Get text for auth status indicator
  String _getStatusText(AuthStatus status) {
    switch (status) {
      case AuthStatus.authenticated:
        return 'AUTH';
      case AuthStatus.unauthenticated:
        return 'UNAUTH';
      case AuthStatus.loading:
        return 'LOAD';
      case AuthStatus.error:
        return 'ERROR';
      case AuthStatus.initial:
        return 'INIT';
    }
  }
}

/// Action Card Widget
class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;
  
  const _ActionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32,
                color: const Color(0xFFFFC107),
              ),
              
              const SizedBox(height: 12),
              
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
              ),
              
              const SizedBox(height: 4),
              
              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}