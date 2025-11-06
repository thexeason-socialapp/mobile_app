import 'package:dartz/dartz.dart';

import '../../../core/errors/exceptions.dart';
import '../../../core/errors/failures.dart';
import '../../entities/message.dart';
import '../../repositories/message_repository.dart';

/// Send message use case - sends a new message
class SendMessageUseCase {
  final MessageRepository repository;

  const SendMessageUseCase(this.repository);

  /// Execute send message
  /// Returns [Right(Message)] on success, [Left(Failure)] on error
  Future<Either<Failure, Message>> call({
    required String conversationId,
    required String senderId,
    required String receiverId,
    required String content,
  }) async {
    try {
      final message = await repository.sendMessage(
        conversationId: conversationId,
        senderId: senderId,
        receiverId: receiverId,
        content: content,
      );
      return Right(message);
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message, code: e.code));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }
}