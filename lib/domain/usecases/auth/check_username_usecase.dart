import 'package:dartz/dartz.dart';

import '../../../core/errors/exceptions.dart';
import '../../../core/errors/failures.dart';
import '../../repositories/auth_repository.dart';

/// Check username availability use case
/// Validates if a username is available for registration
class CheckUsernameUseCase {
  final AuthRepository repository;

  const CheckUsernameUseCase(this.repository);

  /// Execute username availability check
  /// Returns [Right(bool)] on success (true = available, false = taken), [Left(Failure)] on error
  Future<Either<Failure, bool>> call(String username) async {
    try {
      final isAvailable = await repository.isUsernameAvailable(username);
      return Right(isAvailable);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message, code: e.code));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }
}