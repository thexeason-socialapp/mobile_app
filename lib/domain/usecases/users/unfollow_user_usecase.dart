import 'package:dartz/dartz.dart';

import '../../../core/errors/exceptions.dart';
import '../../../core/errors/failures.dart';
import '../../repositories/user_repository.dart';

/// Unfollow user use case - unfollows a user
class UnfollowUserUseCase {
  final UserRepository repository;

  const UnfollowUserUseCase(this.repository);

  /// Execute unfollow user
  /// Returns [Right(void)] on success, [Left(Failure)] on error
  Future<Either<Failure, void>> call({
    required String followerId,
    required String followingId,
  }) async {
    try {
      await repository.unfollowUser(
        followerId: followerId,
        followingId: followingId,
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