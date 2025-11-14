import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../repositories/auth_repository.dart';

/// Logout use case - signs out current user
/// Simplified since repository now returns Either<Failure, T>
class LogoutUseCase {
  final AuthRepository repository;

  const LogoutUseCase(this.repository);

  /// Execute logout
  /// Returns [Right(void)] on success, [Left(Failure)] on error
  Future<Either<Failure, void>> call() async {
    // Repository already handles error conversion, just pass through
    return repository.logout();
  }
}