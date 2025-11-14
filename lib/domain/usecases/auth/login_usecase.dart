import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';

/// Login use case - authenticates user with credentials
/// Simplified since repository now returns Either<Failure, T>
class LoginUseCase {
  final AuthRepository repository;

  const LoginUseCase(this.repository);

  /// Execute login
  /// Returns [Right(User)] on success, [Left(Failure)] on error
  Future<Either<Failure, User>> call({
    required String email,
    required String password,
  }) async {
    // Repository already handles error conversion, just pass through
    return repository.login(
      email: email,
      password: password,
    );
  }
}