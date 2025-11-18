import 'package:flutter/material.dart';

/// PostsGrid Widget - Displays user posts in a grid layout
/// This is a placeholder implementation that can be enhanced later
class PostsGrid extends StatelessWidget {
  final String userId;
  final bool isOwnProfile;

  const PostsGrid({
    super.key,
    required this.userId,
    this.isOwnProfile = false,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: Implement actual posts grid with data from posts repository
    // For now, show a placeholder grid
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: 0, // No posts for now
      itemBuilder: (context, index) {
        return _buildPostItem(context, index);
      },
    );
  }

  Widget _buildPostItem(BuildContext context, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to post details
        },
        child: const Center(
          child: Icon(Icons.image, size: 32, color: Colors.grey),
        ),
      ),
    );
  }
}
