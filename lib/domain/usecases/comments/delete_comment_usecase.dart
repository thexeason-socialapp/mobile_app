import 'package:dartz/dartz.dart';

import '../../../core/errors/exceptions.dart';
import '../../../core/errors/failures.dart';
import '../../repositories/comment_repository.dart';

/// Delete comment use case - removes a comment
class DeleteCommentUseCase {
  final CommentRepository repository;

  const DeleteCommentUseCase(this.repository);

  /// Execute delete comment
  /// Returns [Right(void)] on success, [Left(Failure)] on error
  Future<Either<Failure, void>> call(String commentId) async {
    try {
      await repository.deleteComment(commentId);
      return const Right(null);
    } on PermissionDeniedException catch (e) {
      return Left(PermissionDeniedFailure(e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message, code: e.code));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }
}