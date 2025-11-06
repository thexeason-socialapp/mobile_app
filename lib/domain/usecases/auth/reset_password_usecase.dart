import 'package:dartz/dartz.dart';

import '../../../core/errors/exceptions.dart';
import '../../../core/errors/failures.dart';
import '../../repositories/auth_repository.dart';

/// Reset password use case - sends password reset email
class ResetPasswordUseCase {
  final AuthRepository repository;

  const ResetPasswordUseCase(this.repository);

  /// Execute password reset
  /// Returns [Right(bool)] on success, [Left(Failure)] on error
  Future<Either<Failure, bool>> call(String email) async {
    try {
      final result = await repository.sendPasswordResetEmail(email);
      return Right(result);
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