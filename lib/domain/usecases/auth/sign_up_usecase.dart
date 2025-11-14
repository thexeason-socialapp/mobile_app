import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';

/// Sign up use case - creates new user account
/// Simplified since repository now returns Either<Failure, T>
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
    // Repository already handles error conversion, just pass through
    return repository.signUp(
      email: email,
      password: password,
      username: username,
      displayName: displayName,
    );
  }
}