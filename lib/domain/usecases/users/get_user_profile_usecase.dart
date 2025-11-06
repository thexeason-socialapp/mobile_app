import 'package:dartz/dartz.dart';

import '../../../core/errors/exceptions.dart';
import '../../../core/errors/failures.dart';
import '../../entities/user.dart';
import '../../repositories/user_repository.dart';

/// Get user profile use case - retrieves user profile by ID
class GetUserProfileUseCase {
  final UserRepository repository;

  const GetUserProfileUseCase(this.repository);

  /// Execute get user profile
  /// Returns [Right(User)] on success, [Left(Failure)] on error
  Future<Either<Failure, User>> call(String userId) async {
    try {
      final user = await repository.getUserById(userId);
      return Right(user);
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