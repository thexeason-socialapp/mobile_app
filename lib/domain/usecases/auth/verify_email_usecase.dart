import 'package:dartz/dartz.dart';

import '../../../core/errors/exceptions.dart';
import '../../../core/errors/failures.dart';
import '../../repositories/auth_repository.dart';

/// Verify email use case - sends verification email to user
class VerifyEmailUseCase {
  final AuthRepository repository;

  const VerifyEmailUseCase(this.repository);

  /// Execute email verification
  /// Returns [Right(void)] on success, [Left(Failure)] on error
  Future<Either<Failure, void>> call() async {
    try {
      await repository.verifyEmail();
      return const Right(null);
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