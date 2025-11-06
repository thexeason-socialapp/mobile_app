import 'package:dartz/dartz.dart';

import '../../../core/errors/exceptions.dart';
import '../../../core/errors/failures.dart';
import '../../entities/notification.dart';
import '../../repositories/notification_repository.dart';

/// Get notifications use case - retrieves user notifications
class GetNotificationsUseCase {
  final NotificationRepository repository;

  const GetNotificationsUseCase(this.repository);

  /// Execute get notifications
  /// Returns [Right(List<Notification>)] on success, [Left(Failure)] on error
  Future<Either<Failure, List<Notification>>> call({
    required String userId,
    int limit = 50,
    String? lastNotificationId,
  }) async {
    try {
      final notifications = await repository.getNotifications(
        userId: userId,
        limit: limit,
        lastNotificationId: lastNotificationId,
      );
      return Right(notifications);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message, code: e.code));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }
}