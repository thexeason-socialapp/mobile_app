import 'package:dartz/dartz.dart';

import '../../../core/errors/exceptions.dart';
import '../../../core/errors/failures.dart';
import '../../entities/comment.dart';
import '../../repositories/comment_repository.dart';

/// Add comment use case - adds new comment to a post
class AddCommentUseCase {
  final CommentRepository repository;

  const AddCommentUseCase(this.repository);

  /// Execute add comment
  /// Returns [Right(Comment)] on success, [Left(Failure)] on error
  Future<Either<Failure, Comment>> call({
    required String postId,
    required String userId,
    required String content,
  }) async {
    try {
      final comment = await repository.addComment(
        postId: postId,
        userId: userId,
        content: content,
      );
      return Right(comment);
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message, code: e.code));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }
}