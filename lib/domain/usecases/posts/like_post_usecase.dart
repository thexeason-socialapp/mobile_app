import 'package:dartz/dartz.dart';

import '../../../core/errors/exceptions.dart';
import '../../../core/errors/failures.dart';
import '../../repositories/post_repository.dart';

/// Like post use case - adds like to a post
class LikePostUseCase {
  final PostRepository repository;

  const LikePostUseCase(this.repository);

  /// Execute like post
  /// Returns [Right(void)] on success, [Left(Failure)] on error
  Future<Either<Failure, void>> call({
    required String postId,
    required String userId,
  }) async {
    try {
      await repository.likePost(
        postId: postId,
        userId: userId,
      );
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message, code: e.code));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }
}