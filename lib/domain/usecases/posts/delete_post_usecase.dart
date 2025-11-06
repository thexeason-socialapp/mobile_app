import 'package:dartz/dartz.dart';

import '../../../core/errors/exceptions.dart';
import '../../../core/errors/failures.dart';
import '../../repositories/comment_repository.dart';

/// Like comment use case - adds like to a comment
class LikeCommentUseCase {
  final CommentRepository repository;

  const LikeCommentUseCase(this.repository);

  /// Execute like comment
  /// Returns [Right(void)] on success, [Left(Failure)] on error
  Future<Either<Failure, void>> call({
    required String commentId,
    required String userId,
  }) async {
    try {
      await repository.likeComment(
        commentId: commentId,
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