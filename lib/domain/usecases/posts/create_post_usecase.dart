import 'package:dartz/dartz.dart';

import '../../../core/errors/exceptions.dart';
import '../../../core/errors/failures.dart';
import '../../entities/post.dart';
import '../../repositories/post_repository.dart';

/// Create post use case - creates new post with optional media
class CreatePostUseCase {
  final PostRepository repository;

  const CreatePostUseCase(this.repository);

  /// Execute create post
  /// Returns [Right(Post)] on success, [Left(Failure)] on error
  Future<Either<Failure, Post>> call({
    required String userId,
    required String content,
    List<String>? mediaPaths,
  }) async {
    try {
      final post = await repository.createPost(
        userId: userId,
        content: content,
        mediaPaths: mediaPaths,
      );
      return Right(post);
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message, code: e.code));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } on StorageException catch (e) {
      return Left(StorageFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }
}