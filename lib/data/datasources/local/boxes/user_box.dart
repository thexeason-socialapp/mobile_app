import 'package:hive_flutter/hive_flutter.dart';
import '../../../models/user_model.dart';

/// =d USER BOX
/// Manages local caching of user data using Hive
class UserBox {
  static const String boxName = 'users';

  Box<UserModel>? _box;

  /// Initialize the user box
  Future<void> init() async {
    _box = await Hive.openBox<UserModel>(boxName);
  }

  /// Get the box instance (lazy open if not initialized)
  Future<Box<UserModel>> _getBox() async {
    if (_box == null || !_box!.isOpen) {
      _box = await Hive.openBox<UserModel>(boxName);
    }
    return _box!;
  }

  /// Save a user to cache
  Future<void> saveUser(UserModel user) async {
    final box = await _getBox();
    await box.put(user.id, user);
  }

  /// Get a user from cache by ID
  Future<UserModel?> getUser(String userId) async {
    final box = await _getBox();
    return box.get(userId);
  }

  /// Delete a user from cache
  Future<void> deleteUser(String userId) async {
    final box = await _getBox();
    await box.delete(userId);
  }

  /// Get all cached users
  Future<List<UserModel>> getAllUsers() async {
    final box = await _getBox();
    return box.values.toList();
  }

  /// Clear all cached users
  Future<void> clearAll() async {
    final box = await _getBox();
    await box.clear();
  }

  /// Check if a user exists in cache
  Future<bool> hasUser(String userId) async {
    final box = await _getBox();
    return box.containsKey(userId);
  }

  /// Get number of cached users
  Future<int> count() async {
    final box = await _getBox();
    return box.length;
  }

  /// Close the box
  Future<void> close() async {
    await _box?.close();
    _box = null;
  }
}
