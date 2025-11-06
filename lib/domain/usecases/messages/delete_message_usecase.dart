import 'package:dartz/dartz.dart';

import '../../../core/errors/exceptions.dart';
import '../../../core/errors/failures.dart';
import '../../repositories/message_repository.dart';

/// Delete message use case - deletes a message
class DeleteMessageUseCase {
  final MessageRepository repository;

  const DeleteMessageUseCase(this.repository);

  /// Execute delete message
  /// Returns [Right(void)] on success, [Left(Failure)] on error
  Future<Either<Failure, void>> call({
    required String messageId,
    required String userId,
  }) async {
    try {
      await repository.deleteMessage(
        messageId: messageId,
        userId: userId,
      );
      return const Right(null);
    } on PermissionDeniedException catch (e) {
      return Left(PermissionDeniedFailure(e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message, code: e.code));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }
}