import 'package:dartz/dartz.dart';

import '../../../core/errors/exceptions.dart';
import '../../../core/errors/failures.dart';
import '../../entities/conversation.dart';
import '../../repositories/message_repository.dart';

/// Get conversations use case - retrieves user conversations list
class GetConversationsUseCase {
  final MessageRepository repository;

  const GetConversationsUseCase(this.repository);

  /// Execute get conversations
  /// Returns [Right(List<Conversation>)] on success, [Left(Failure)] on error
  Future<Either<Failure, List<Conversation>>> call(String userId) async {
    try {
      final conversations = await repository.getConversations(userId: userId);
      return Right(conversations);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message, code: e.code));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }
}