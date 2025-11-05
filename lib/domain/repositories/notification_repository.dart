/// 🔔 NOTIFICATION REPOSITORY INTERFACE
/// Abstract contract defining notification operations
/// Implementation will be in the data layer
/// No dependencies on Firebase or external packages

import '../entities/notification.dart';

abstract class NotificationRepository {
  /// Get notifications for a user
  /// Returns list of [Notification] objects
  /// Supports pagination
  Future<List<Notification>> getNotifications({
    required String userId,
    int limit = 20,
    String? lastNotificationId,
  });

  /// Get a single notification by ID
  /// Returns [Notification] if found, throws exception if not found
  Future<Notification> getNotificationById(String notificationId);

  /// Get unread notification count
  /// Returns the number of unread notifications for a user
  Future<int> getUnreadCount(String userId);

  /// Mark notification as read
  /// Updates isRead and readAt fields
  Future<void> markAsRead(String notificationId);

  /// Mark all notifications as read
  /// Updates all unread notifications at once
  Future<void> markAllAsRead(String userId);

  /// Delete a notification
  Future<void> deleteNotification(String notificationId);

  /// Clear all notifications
  /// Deletes all notifications for a user
  Future<void> clearAllNotifications(String userId);

  /// Get notifications by type
  /// Returns list of [Notification] objects of a specific type
  /// Supports pagination
  Future<List<Notification>> getNotificationsByType({
    required String userId,
    required NotificationType type,
    int limit = 20,
    String? lastNotificationId,
  });

  /// Listen to new notifications (real-time)
  /// Returns a stream of [Notification] objects
  Stream<Notification> listenToNotifications(String userId);

  /// Listen to unread count changes (real-time)
  /// Returns a stream of unread count
  Stream<int> listenToUnreadCount(String userId);

  /// Create notification (used by Cloud Functions)
  /// Manually create a notification
  Future<Notification> createNotification({
    required String userId,
    required NotificationType type,
    required String fromUserId,
    required String title,
    required String body,
    String? postId,
    String? commentId,
    String? messageId,
    String? actionUrl,
    String? imageUrl,
  });

  /// Send push notification via FCM
  /// Triggers Firebase Cloud Messaging
  Future<void> sendPushNotification({
    required String userId,
    required String title,
    required String body,
    Map<String, String>? data,
  });

  /// Update FCM token for push notifications
  /// Stores device token for sending push notifications
  Future<void> updateFCMToken({
    required String userId,
    required String token,
  });

  /// Get notification settings for a user
  /// Returns map of notification preferences
  Future<Map<String, bool>> getNotificationSettings(String userId);

  /// Update notification settings
  /// Updates user's notification preferences
  Future<void> updateNotificationSettings({
    required String userId,
    required Map<String, bool> settings,
  });
}