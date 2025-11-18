import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../../domain/entities/post.dart';
import '../../../../domain/entities/user.dart';
import '../../../../domain/repositories/user_repository.dart';
import '../../../../core/di/providers.dart';
import '../../auth/providers/auth_state_provider.dart';
import '../../profile/widgets/avatar_widget.dart';
import '../providers/post_interaction_provider.dart';

/// PostCard - Displays a single post in the feed
class PostCard extends ConsumerStatefulWidget {
  final Post post;

  const PostCard({
    super.key,
    required this.post,
  });

  @override
  ConsumerState<PostCard> createState() => _PostCardState();
}

class _PostCardState extends ConsumerState<PostCard> {
  User? _postAuthor;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAuthor();
  }

  Future<void> _loadAuthor() async {
    try {
      final userRepo = ref.read(userRepositoryProvider);
      final author = await userRepo.getUserById(widget.post.userId);
      if (mounted) {
        setState(() {
          _postAuthor = author;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final currentUserId = authState.user?.id ?? '';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header (User info + timestamp)
            _buildHeader(context),
            const SizedBox(height: 12),

            // Content
            Text(
              widget.post.content,
              style: const TextStyle(
                fontSize: 15,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),

            // Media (if present)
            if (widget.post.media.isNotEmpty) _buildMedia(),

            // Actions (like, comment, share)
            _buildActions(context, currentUserId),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    if (_isLoading || _postAuthor == null) {
      return Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey[300],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 120,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  width: 80,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        GestureDetector(
          onTap: () => context.push('/user/${_postAuthor!.id}'),
          child: AvatarWidget(
            imageUrl: _postAuthor!.avatar,
            displayName: _postAuthor!.displayName,
            size: 40,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => context.push('/user/${_postAuthor!.id}'),
                    child: Text(
                      _postAuthor!.displayName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  if (_postAuthor!.verified) ...[
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.verified,
                      size: 16,
                      color: Color(0xFFFFC107),
                    ),
                  ],
                ],
              ),
              Text(
                timeago.format(widget.post.createdAt),
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () => _showPostMenu(context),
        ),
      ],
    );
  }

  Widget _buildMedia() {
    final media = widget.post.media.first;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[200],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          media.url,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Icon(Icons.broken_image, size: 48, color: Colors.grey),
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context, String currentUserId) {
    final isLiked = widget.post.isLikedBy(currentUserId);

    return Row(
      children: [
        // Like button
        IconButton(
          icon: Icon(
            isLiked ? Icons.favorite : Icons.favorite_border,
            color: isLiked ? Colors.red : Colors.grey[700],
          ),
          onPressed: () {
            ref.read(postInteractionProvider.notifier).toggleLike(widget.post);
          },
        ),
        Text(
          '${widget.post.likes}',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(width: 16),

        // Comment button
        IconButton(
          icon: Icon(Icons.comment_outlined, color: Colors.grey[700]),
          onPressed: () {
            // TODO: Navigate to comments
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Comments - Coming soon')),
            );
          },
        ),
        Text(
          '${widget.post.commentsCount}',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(width: 16),

        // Share button
        IconButton(
          icon: Icon(Icons.share_outlined, color: Colors.grey[700]),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Share - Coming soon')),
            );
          },
        ),
        const Spacer(),

        // Bookmark button
        IconButton(
          icon: Icon(Icons.bookmark_border, color: Colors.grey[700]),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Save - Coming soon')),
            );
          },
        ),
      ],
    );
  }

  void _showPostMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.link),
              title: const Text('Copy link'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Link copied')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share post'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.flag, color: Colors.red),
              title: const Text('Report post'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
