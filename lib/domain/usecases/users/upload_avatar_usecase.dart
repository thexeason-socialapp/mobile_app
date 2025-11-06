import 'package:dartz/dartz.dart';

import '../../../core/errors/exceptions.dart';
import '../../../core/errors/failures.dart';
import '../../repositories/user_repository.dart';

/// Upload avatar use case - uploads user profile picture
class UploadAvatarUseCase {
  final UserRepository repository;

  const UploadAvatarUseCase(this.repository);

  /// Execute upload avatar
  /// Returns [Right(String)] avatar URL on success, [Left(Failure)] on error
  Future<Either<Failure, String>> call({
    required String userId,
    required String imagePath,
  }) async {
    try {
      final avatarUrl = await repository.uploadAvatar(
        userId: userId,
        imagePath: imagePath,
      );
      return Right(avatarUrl);
    } on StorageException catch (e) {
      return Left(StorageFailure(e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message, code: e.code));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }
}