import 'package:dartz/dartz.dart';

import '../../../core/errors/exceptions.dart';
import '../../../core/errors/failures.dart';
import '../../repositories/message_repository.dart';

/// Mark as read use case - marks messages in conversation as read
class MarkAsReadUseCase {
  final MessageRepository repository;

  const MarkAsReadUseCase(this.repository);

  /// Execute mark as read
  /// Returns [Right(void)] on success, [Left(Failure)] on error
  Future<Either<Failure, void>> call({
    required String messageId,
    required String userId,
  }) async {
    try {
      await repository.markAsRead(
        messageId: messageId,
        userId: userId,
      );
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message, code: e.code));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }
}