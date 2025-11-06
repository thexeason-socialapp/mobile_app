import 'package:dartz/dartz.dart';

import '../../../core/errors/exceptions.dart';
import '../../../core/errors/failures.dart';
import '../../entities/post.dart';
import '../../repositories/post_repository.dart';

/// Get feed posts use case - retrieves paginated feed
class GetFeedPostsUseCase {
  final PostRepository repository;

  const GetFeedPostsUseCase(this.repository);

  /// Execute get feed posts
  /// Returns [Right(List<Post>)] on success, [Left(Failure)] on error
  Future<Either<Failure, List<Post>>> call({
    required String userId,
    int limit = 20,
    String? lastPostId,
  }) async {
    try {
      final posts = await repository.getFeedPosts(
        userId: userId,
        limit: limit,
        lastPostId: lastPostId,
      );
      return Right(posts);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message, code: e.code));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }
}