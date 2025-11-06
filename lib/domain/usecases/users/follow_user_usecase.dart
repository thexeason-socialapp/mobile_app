import 'package:dartz/dartz.dart';

import '../../../core/errors/exceptions.dart';
import '../../../core/errors/failures.dart';
import '../../repositories/user_repository.dart';

/// Follow user use case - follows another user
class FollowUserUseCase {
  final UserRepository repository;

  const FollowUserUseCase(this.repository);

  /// Execute follow user
  /// Returns [Right(void)] on success, [Left(Failure)] on error
  Future<Either<Failure, void>> call({
    required String followerId,
    required String followingId,
  }) async {
    try {
      await repository.followUser(
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