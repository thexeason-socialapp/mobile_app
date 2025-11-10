import 'package:firebase_messaging/firebase_messaging.dart';
import '../../../../core/errors/exceptions.dart';
import 'firebase_service.dart';

abstract class FCMDataSource {
  Future<String?> getToken();
  Future<void> subscribeToTopic(String topic);
  Future<void> unsubscribeFromTopic(String topic);
  Stream<String> onTokenRefresh();
  Future<void> requestPermission();
}

class FCMDataSourceImpl implements FCMDataSource {
  final FirebaseMessaging _messaging;
  
  FCMDataSourceImpl({FirebaseMessaging? messaging})
      : _messaging = messaging ?? FirebaseService.instance.messaging;

  @override
  Future<String?> getToken() async {
    try {
      return await _messaging.getToken();
    } catch (e) {
      throw ServerException('Failed to get FCM token: $e');
    }
  }
  
  @override
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
    } catch (e) {
      throw ServerException('Failed to subscribe to topic: $e');
    }
  }
  
  @override
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
    } catch (e) {
      throw ServerException('Failed to unsubscribe from topic: $e');
    }
  }
  
  @override
  Stream<String> onTokenRefresh() {
    try {
      return _messaging.onTokenRefresh;
    } catch (e) {
      throw ServerException('Failed to listen to token refresh: $e');
    }
  }
  
  @override
  Future<void> requestPermission() async {
    try {
      await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );
    } catch (e) {
      throw ServerException('Failed to request notification permission: $e');
    }
  }
}