import 'package:dartz/dartz.dart';

import '../../../core/errors/exceptions.dart';
import '../../../core/errors/failures.dart';
import '../../entities/user.dart';
import '../../repositories/user_repository.dart';

/// Update profile use case - updates user profile information
class UpdateProfileUseCase {
  final UserRepository repository;

  const UpdateProfileUseCase(this.repository);

  /// Execute update profile
  /// Returns [Right(User)] on success, [Left(Failure)] on error
  Future<Either<Failure, User>> call({
    required String userId,
    String? displayName,
    String? bio,
    String? location,
    String? website,
    String? phone,
  }) async {
    try {
      final user = await repository.updateProfile(
        userId: userId,
        displayName: displayName,
        bio: bio,
        location: location,
        website: website,
        phone: phone,
      );
      return Right(user);
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