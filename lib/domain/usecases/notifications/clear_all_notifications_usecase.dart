import 'package:dartz/dartz.dart';

import '../../../core/errors/exceptions.dart';
import '../../../core/errors/failures.dart';
import '../../repositories/notification_repository.dart';

/// Clear all notifications use case - deletes all user notifications
class ClearAllNotificationsUseCase {
  final NotificationRepository repository;

  const ClearAllNotificationsUseCase(this.repository);

  /// Execute clear all notifications
  /// Returns [Right(void)] on success, [Left(Failure)] on error
  Future<Either<Failure, void>> call(String userId) async {
    try {
      await repository.clearAllNotifications(userId);
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