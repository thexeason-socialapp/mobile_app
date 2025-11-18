import 'package:flutter/material.dart';
import 'shimmer_widget.dart';

/// Skeleton Loader - Pre-built skeleton loading screens
class SkeletonLoader extends StatelessWidget {
  final SkeletonType type;

  const SkeletonLoader({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case SkeletonType.feed:
        return const FeedSkeleton();
      case SkeletonType.profile:
        return const ProfileSkeleton();
      case SkeletonType.userList:
        return const UserListSkeleton();
      case SkeletonType.grid:
        return const GridSkeleton();
    }
  }
}

enum SkeletonType {
  feed,
  profile,
  userList,
  grid,
}

/// Feed Skeleton - For feed loading
class FeedSkeleton extends StatelessWidget {
  const FeedSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 3,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) => const FeedItemSkeleton(),
    );
  }
}

class FeedItemSkeleton extends StatelessWidget {
  const FeedItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const ShimmerCircle(size: 40),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerLine(width: MediaQuery.of(context).size.width * 0.4),
                    const SizedBox(height: 4),
                    ShimmerLine(width: MediaQuery.of(context).size.width * 0.25, height: 12),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ShimmerLine(width: MediaQuery.of(context).size.width * 0.9),
          const SizedBox(height: 8),
          ShimmerLine(width: MediaQuery.of(context).size.width * 0.7),
          const SizedBox(height: 12),
          ShimmerWidget(
            width: double.infinity,
            height: 200,
            borderRadius: BorderRadius.circular(8),
          ),
        ],
      ),
    );
  }
}

/// Profile Skeleton - For profile loading
class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ShimmerWidget(
          width: double.infinity,
          height: 150,
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
        ),
        const SizedBox(height: 16),
        const ShimmerCircle(size: 100),
        const SizedBox(height: 16),
        ShimmerLine(width: MediaQuery.of(context).size.width * 0.5),
        const SizedBox(height: 8),
        ShimmerLine(width: MediaQuery.of(context).size.width * 0.3, height: 12),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ShimmerLine(width: MediaQuery.of(context).size.width * 0.25),
            ShimmerLine(width: MediaQuery.of(context).size.width * 0.25),
            ShimmerLine(width: MediaQuery.of(context).size.width * 0.25),
          ],
        ),
      ],
    );
  }
}

/// User List Skeleton - For followers/following loading
class UserListSkeleton extends StatelessWidget {
  const UserListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 10,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) => const UserItemSkeleton(),
    );
  }
}

class UserItemSkeleton extends StatelessWidget {
  const UserItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          const ShimmerCircle(size: 56),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerLine(width: MediaQuery.of(context).size.width * 0.4),
                const SizedBox(height: 4),
                ShimmerLine(width: MediaQuery.of(context).size.width * 0.25, height: 12),
              ],
            ),
          ),
          ShimmerWidget(
            width: 80,
            height: 36,
            borderRadius: BorderRadius.circular(8),
          ),
        ],
      ),
    );
  }
}

/// Grid Skeleton - For grid loading
class GridSkeleton extends StatelessWidget {
  const GridSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: 9,
      itemBuilder: (context, index) {
        return ShimmerWidget(
          width: double.infinity,
          height: double.infinity,
          borderRadius: BorderRadius.circular(8),
        );
      },
    );
  }
}
