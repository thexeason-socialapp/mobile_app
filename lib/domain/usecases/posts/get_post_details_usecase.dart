import 'package:dartz/dartz.dart';

import '../../../core/errors/exceptions.dart';
import '../../../core/errors/failures.dart';
import '../../entities/post.dart';
import '../../repositories/post_repository.dart';

/// Get post details use case - retrieves single post with full details
class GetPostDetailsUseCase {
  final PostRepository repository;

  const GetPostDetailsUseCase(this.repository);

  /// Execute get post details
  /// Returns [Right(Post)] on success, [Left(Failure)] on error
  Future<Either<Failure, Post>> call(String postId) async {
    try {
      final post = await repository.getPostById(postId);
      return Right(post);
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message, code: e.code));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }
}