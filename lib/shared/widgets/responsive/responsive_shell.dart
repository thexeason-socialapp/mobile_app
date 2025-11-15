import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/responsive_utils.dart';
import '../../../presentation/features/auth/providers/auth_state_provider.dart';


/// 📱💻 RESPONSIVE SHELL
/// Main layout container that adapts between mobile and desktop layouts
/// Mobile: Bottom Navigation Bar
/// Desktop: Sidebar Navigation
class ResponsiveShell extends ConsumerWidget {
  final Widget child;
  
  const ResponsiveShell({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (BreakPoints.useMobileLayout(context)) {
          return MobileShell(child: child);
        } else {
          return DesktopShell(child: child);
        }
      },
    );
  }
}

/// 📱 MOBILE SHELL (Bottom Navigation)
class MobileShell extends ConsumerWidget {
  final Widget child;
  
  const MobileShell({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: child,
      bottomNavigationBar: const MobileBottomNavBar(),
    );
  }
}

/// 💻 DESKTOP SHELL (Sidebar Navigation)
class DesktopShell extends ConsumerWidget {
  final Widget child;
  
  const DesktopShell({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sidebarWidth = ResponsiveValues.sidebarWidth(context);
    
    return Scaffold(
      body: Row(
        children: [
          // Sidebar Navigation
          Container(
            width: sidebarWidth,
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                right: BorderSide(
                  color: Color(0xFFE5E7EB),
                  width: 1,
                ),
              ),
            ),
            child: const DesktopSidebar(),
          ),
          
          // Main Content Area
          Expanded(
            child: Container(
              color: const Color(0xFFF9FAFB),
              child: Column(
                children: [
                  // Top App Bar
                  const DesktopTopBar(),
                  
                  // Main Content
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      constraints: BoxConstraints(
                        maxWidth: ResponsiveValues.maxContentWidth(context),
                      ),
                      child: child,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 📱 MOBILE BOTTOM NAVIGATION BAR
class MobileBottomNavBar extends ConsumerWidget {
  const MobileBottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocation = GoRouterState.of(context).uri.toString();
    final tapTargetSize = DeviceUtils.tapTargetSize(context);
    
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Container(
          height: tapTargetSize + 16, // Adaptive height
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _getCurrentIndex(currentLocation),
            onTap: (index) => _onNavTap(context, index),
            selectedItemColor: const Color(0xFFFFC107),
            unselectedItemColor: Colors.grey[600],
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            items: [
              _buildNavItem(
                Icons.home_outlined, 
                Icons.home, 
                'Home',
                context,
              ),
              _buildNavItem(
                Icons.dynamic_feed_outlined, 
                Icons.dynamic_feed, 
                'Feed',
                context,
              ),
              _buildNavItem(
                Icons.message_outlined, 
                Icons.message, 
                'Messages',
                context,
              ),
              _buildNavItem(
                Icons.notifications_outlined, 
                Icons.notifications, 
                'Alerts',
                context,
              ),
              _buildNavItem(
                Icons.person_outline, 
                Icons.person, 
                'Profile',
                context,
              ),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
    IconData icon,
    IconData activeIcon,
    String label,
    BuildContext context,
  ) {
    final iconSize = ResponsiveValues.iconSize(context, baseSize: 24.0);
    
    return BottomNavigationBarItem(
      icon: Icon(icon, size: iconSize),
      activeIcon: Icon(activeIcon, size: iconSize),
      label: label,
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

/// 💻 DESKTOP SIDEBAR NAVIGATION
class DesktopSidebar extends ConsumerWidget {
  const DesktopSidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final currentLocation = GoRouterState.of(context).uri.toString();

    return Container(
      padding: ResponsiveValues.padding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // App Logo/Title
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFC107),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Thexeason',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Navigation Items
          Expanded(
            child: Column(
              children: [
                _SidebarItem(
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home,
                  label: 'Home',
                  isActive: currentLocation.startsWith('/home'),
                  onTap: () => context.go('/home'),
                ),
                
                _SidebarItem(
                  icon: Icons.dynamic_feed_outlined,
                  activeIcon: Icons.dynamic_feed,
                  label: 'Feed',
                  isActive: currentLocation.startsWith('/feed'),
                  onTap: () => context.go('/feed'),
                ),
                
                _SidebarItem(
                  icon: Icons.message_outlined,
                  activeIcon: Icons.message,
                  label: 'Messages',
                  isActive: currentLocation.startsWith('/messages'),
                  onTap: () => context.go('/messages'),
                ),
                
                _SidebarItem(
                  icon: Icons.notifications_outlined,
                  activeIcon: Icons.notifications,
                  label: 'Notifications',
                  isActive: currentLocation.startsWith('/notifications'),
                  onTap: () => context.go('/notifications'),
                ),
                
                _SidebarItem(
                  icon: Icons.person_outline,
                  activeIcon: Icons.person,
                  label: 'Profile',
                  isActive: currentLocation.startsWith('/profile'),
                  onTap: () => context.go('/profile'),
                ),
                
                const SizedBox(height: 16),
                
                _SidebarItem(
                  icon: Icons.settings_outlined,
                  activeIcon: Icons.settings,
                  label: 'Settings',
                  isActive: currentLocation.startsWith('/settings'),
                  onTap: () => context.go('/settings'),
                ),
              ],
            ),
          ),
          
          // User Info & Logout
          if (user != null) ...[
            const Divider(),
            const SizedBox(height: 16),
            
            // User Info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: const Color(0xFFFFC107),
                    child: Text(
                      user.displayName.isNotEmpty 
                          ? user.displayName[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.displayName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF111827),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '@${user.username}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 12),
            
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
                    : const Icon(Icons.logout, size: 18),
                label: Text(authState.isLoading ? 'Logging out...' : 'Logout'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    final result = await ref.read(authProvider.notifier).logout();
    
    result.fold(
      (failure) {
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
        // Router will handle navigation automatically
      },
    );
  }
}

/// 💻 DESKTOP TOP APP BAR
class DesktopTopBar extends StatelessWidget {
  const DesktopTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
      ),
      padding: ResponsiveValues.horizontalPadding(context),
      child: Row(
        children: [
          // Page Title (will be dynamic based on current page)
          const Text(
            'Home', // TODO: Make this dynamic
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          
          const Spacer(),
          
          // Search Bar (for later)
          Container(
            width: 300,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: 'Search Thexeason...',
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Action Buttons
          IconButton(
            onPressed: () {
              // TODO: Quick post creation
            },
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Create Post',
          ),
        ],
      ),
    );
  }
}

/// 📝 SIDEBAR NAVIGATION ITEM
class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  
  const _SidebarItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFFFFC107).withOpacity(0.1) : null,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  isActive ? activeIcon : icon,
                  color: isActive ? const Color(0xFFFFC107) : Colors.grey[600],
                  size: 24,
                ),
                const SizedBox(width: 16),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    color: isActive ? const Color(0xFF111827) : Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}