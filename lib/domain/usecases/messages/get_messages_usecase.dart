import 'package:dartz/dartz.dart';

import '../../../core/errors/exceptions.dart';
import '../../../core/errors/failures.dart';
import '../../entities/message.dart';
import '../../repositories/message_repository.dart';

/// Get messages use case - retrieves messages in a conversation
class GetMessagesUseCase {
  final MessageRepository repository;

  const GetMessagesUseCase(this.repository);

  /// Execute get messages
  /// Returns [Right(List<Message>)] on success, [Left(Failure)] on error
  Future<Either<Failure, List<Message>>> call({
    required String conversationId,
    int limit = 50,
    String? lastMessageId,
  }) async {
    try {
      final messages = await repository.getMessages(
        conversationId: conversationId,
        limit: limit,
        lastMessageId: lastMessageId,
      );
      return Right(messages);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message, code: e.code));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }
}