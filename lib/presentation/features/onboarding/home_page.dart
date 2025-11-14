import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../auth/providers/auth_state_provider.dart';

/// Home Page - Main landing page for authenticated users
/// Temporary implementation until full home page is built
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
          // Notifications
          IconButton(
            onPressed: () => context.go('/notifications'),
            icon: const Icon(
              Icons.notifications_outlined,
              color: Color(0xFF111827),
            ),
          ),
          
          // Settings
          IconButton(
            onPressed: () => context.go('/settings'),
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
                      onTap: () => context.go('/feed'),
                    ),
                    
                    _ActionCard(
                      icon: Icons.person_outlined,
                      title: 'Profile',
                      description: 'View your profile',
                      onTap: () => context.go('/profile'),
                    ),
                    
                    _ActionCard(
                      icon: Icons.message_outlined,
                      title: 'Messages',
                      description: 'Chat with friends',
                      onTap: () => context.go('/messages'),
                    ),
                    
                    _ActionCard(
                      icon: Icons.add_circle_outline,
                      title: 'Create Post',
                      description: 'Share something new',
                      onTap: () {
                        // TODO: Implement post creation
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Post creation coming soon!'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              
              // Logout Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _handleLogout(context, ref),
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
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

  /// Handle user logout
  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    final result = await ref.read(authProvider.notifier).logout();
    
    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout failed: ${failure.message}'),
            backgroundColor: Colors.red,
          ),
        );
      },
      (_) {
        // Navigation handled by router redirect
      },
    );
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