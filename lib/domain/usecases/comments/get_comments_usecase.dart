import 'package:dartz/dartz.dart';

import '../../../core/errors/exceptions.dart';
import '../../../core/errors/failures.dart';
import '../../entities/comment.dart';
import '../../repositories/comment_repository.dart';

/// Get comments use case - retrieves comments for a post
class GetCommentsUseCase {
  final CommentRepository repository;

  const GetCommentsUseCase(this.repository);

  /// Execute get comments
  /// Returns [Right(List<Comment>)] on success, [Left(Failure)] on error
  Future<Either<Failure, List<Comment>>> call({
    required String postId,
    int limit = 50,
    String? lastCommentId,
  }) async {
    try {
      final comments = await repository.getCommentsByPost(
        postId: postId,
        limit: limit,
        lastCommentId: lastCommentId,
      );
      return Right(comments);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message, code: e.code));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }
}