import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../../core/errors/exceptions.dart';
import 'firebase_service.dart';

abstract class StorageDataSource {
  Future<String> uploadImage(File file, String userId);
  Future<String> uploadVideo(File file, String userId);
  Future<String> uploadVoiceNote(File file, String userId);
  Future<String> uploadAvatar(File file, String userId);
  Future<String> uploadBanner(File file, String userId);
  Future<void> deleteFile(String fileUrl);
}

class StorageDataSourceImpl implements StorageDataSource {
  final FirebaseStorage _storage;
  
  StorageDataSourceImpl({FirebaseStorage? storage})
      : _storage = storage ?? FirebaseService.instance.storage;

  @override
  Future<String> uploadImage(File file, String userId) async {
    try {
      final filename = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = _storage.ref().child('posts/$userId/images/$filename');
      
      final uploadTask = await ref.putFile(
        file,
        SettableMetadata(contentType: 'image/jpeg'),
      );
      
      return await uploadTask.ref.getDownloadURL();
      
    } catch (e) {
      throw ServerException('Failed to upload image: $e');
    }
  }
  
  @override
  Future<String> uploadVideo(File file, String userId) async {
    try {
      final filename = '${DateTime.now().millisecondsSinceEpoch}.mp4';
      final ref = _storage.ref().child('posts/$userId/videos/$filename');
      
      final uploadTask = await ref.putFile(
        file,
        SettableMetadata(contentType: 'video/mp4'),
      );
      
      return await uploadTask.ref.getDownloadURL();
      
    } catch (e) {
      throw ServerException('Failed to upload video: $e');
    }
  }
  
  @override
  Future<String> uploadVoiceNote(File file, String userId) async {
    try {
      final filename = '${DateTime.now().millisecondsSinceEpoch}.m4a';
      final ref = _storage.ref().child('posts/$userId/voice/$filename');
      
      final uploadTask = await ref.putFile(
        file,
        SettableMetadata(contentType: 'audio/m4a'),
      );
      
      return await uploadTask.ref.getDownloadURL();
      
    } catch (e) {
      throw ServerException('Failed to upload voice note: $e');
    }
  }
  
  @override
  Future<String> uploadAvatar(File file, String userId) async {
    try {
      final ref = _storage.ref().child('avatars/$userId/avatar.jpg');
      
      final uploadTask = await ref.putFile(
        file,
        SettableMetadata(contentType: 'image/jpeg'),
      );
      
      return await uploadTask.ref.getDownloadURL();
      
    } catch (e) {
      throw ServerException('Failed to upload avatar: $e');
    }
  }
  
  @override
  Future<String> uploadBanner(File file, String userId) async {
    try {
      final ref = _storage.ref().child('banners/$userId/banner.jpg');
      
      final uploadTask = await ref.putFile(
        file,
        SettableMetadata(contentType: 'image/jpeg'),
      );
      
      return await uploadTask.ref.getDownloadURL();
      
    } catch (e) {
      throw ServerException('Failed to upload banner: $e');
    }
  }
  
  @override
  Future<void> deleteFile(String fileUrl) async {
    try {
      final ref = _storage.refFromURL(fileUrl);
      await ref.delete();
    } catch (e) {
      throw ServerException('Failed to delete file: $e');
    }
  }
}