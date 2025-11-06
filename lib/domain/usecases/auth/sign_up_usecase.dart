import 'package:dartz/dartz.dart';

import '../../../core/errors/exceptions.dart';
import '../../../core/errors/failures.dart';
import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';

/// Sign up use case - creates new user account
class SignUpUseCase {
  final AuthRepository repository;

  const SignUpUseCase(this.repository);

  /// Execute sign up
  /// Returns [Right(User)] on success, [Left(Failure)] on error
  Future<Either<Failure, User>> call({
    required String email,
    required String password,
    required String username,
    required String displayName,
  }) async {
    try {
      final user = await repository.signUp(
        email: email,
        password: password,
        username: username,
        displayName: displayName,
      );
      return Right(user);
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