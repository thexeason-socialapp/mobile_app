import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../repositories/auth_repository.dart';

/// Verify email use case - sends verification email to user
/// Simplified since repository now returns Either<Failure, T>
class VerifyEmailUseCase {
  final AuthRepository repository;

  const VerifyEmailUseCase(this.repository);

  /// Execute email verification
  /// Returns [Right(void)] on success, [Left(Failure)] on error
  Future<Either<Failure, void>> call() async {
    // Repository already handles error conversion, just pass through
    return repository.verifyEmail();
  }
}