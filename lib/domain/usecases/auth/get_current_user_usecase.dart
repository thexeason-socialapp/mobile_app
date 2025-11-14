import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';

/// Get current user use case - retrieves authenticated user
/// Simplified since repository now returns Either<Failure, T>
class GetCurrentUserUseCase {
  final AuthRepository repository;

  const GetCurrentUserUseCase(this.repository);

  /// Execute get current user
  /// Returns [Right(User?)] on success (null if not authenticated), [Left(Failure)] on error
  Future<Either<Failure, User?>> call() async {
    // Repository already handles error conversion, just pass through
    return repository.getCurrentUser();
  }
}