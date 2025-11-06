import 'package:dartz/dartz.dart';

import '../../../core/errors/exceptions.dart';
import '../../../core/errors/failures.dart';
import '../../repositories/notification_repository.dart';

/// Mark notification read use case - marks single notification as read
class MarkNotificationReadUseCase {
  final NotificationRepository repository;

  const MarkNotificationReadUseCase(this.repository);

  /// Execute mark notification read
  /// Returns [Right(void)] on success, [Left(Failure)] on error
  Future<Either<Failure, void>> call(String notificationId) async {
    try {
      await repository.markAsRead(notificationId);
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