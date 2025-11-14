import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../repositories/auth_repository.dart';

/// Reset password use case - sends password reset email
/// Simplified since repository now returns Either<Failure, T>
class ResetPasswordUseCase {
  final AuthRepository repository;

  const ResetPasswordUseCase(this.repository);

  /// Execute password reset
  /// Returns [Right(bool)] on success, [Left(Failure)] on error
  Future<Either<Failure, bool>> call(String email) async {
    // Repository already handles error conversion, just pass through
    return repository.sendPasswordResetEmail(email);
  }
}