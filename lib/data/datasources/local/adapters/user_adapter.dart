import 'package:hive/hive.dart';
import '../../../models/user_model.dart';
import '../../../../domain/entities/user.dart';

/// =d USER HIVE ADAPTER
/// TypeAdapter for storing UserModel in Hive
/// Type ID: 1 (make sure this doesn't conflict with other adapters)
class UserAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 1;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return UserModel(
      id: fields[0] as String,
      email: fields[1] as String,
      username: fields[2] as String,
      displayName: fields[3] as String,
      bio: fields[4] as String?,
      avatar: fields[5] as String?,
      banner: fields[6] as String?,
      followers: fields[7] as int? ?? 0,
      following: fields[8] as int? ?? 0,
      postsCount: fields[9] as int? ?? 0,
      createdAt: fields[10] as DateTime,
      updatedAt: fields[11] as DateTime?,
      isPrivate: fields[12] as bool? ?? false,
      location: fields[13] as String?,
      website: fields[14] as String?,
      phone: fields[15] as String?,
      verified: fields[16] as bool? ?? false,
      isEmailVerified: fields[17] as bool? ?? false,
      blockedUsers: (fields[18] as List?)?.cast<String>() ?? const [],
      preferences: fields[19] as UserPreferences? ?? const UserPreferences(),
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(20) // number of fields
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.username)
      ..writeByte(3)
      ..write(obj.displayName)
      ..writeByte(4)
      ..write(obj.bio)
      ..writeByte(5)
      ..write(obj.avatar)
      ..writeByte(6)
      ..write(obj.banner)
      ..writeByte(7)
      ..write(obj.followers)
      ..writeByte(8)
      ..write(obj.following)
      ..writeByte(9)
      ..write(obj.postsCount)
      ..writeByte(10)
      ..write(obj.createdAt)
      ..writeByte(11)
      ..write(obj.updatedAt)
      ..writeByte(12)
      ..write(obj.isPrivate)
      ..writeByte(13)
      ..write(obj.location)
      ..writeByte(14)
      ..write(obj.website)
      ..writeByte(15)
      ..write(obj.phone)
      ..writeByte(16)
      ..write(obj.verified)
      ..writeByte(17)
      ..write(obj.isEmailVerified)
      ..writeByte(18)
      ..write(obj.blockedUsers)
      ..writeByte(19)
      ..write(obj.preferences);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

/// =� USER PREFERENCES HIVE ADAPTER
/// TypeAdapter for storing UserPreferences in Hive
/// Type ID: 2
class UserPreferencesAdapter extends TypeAdapter<UserPreferences> {
  @override
  final int typeId = 2;

  @override
  UserPreferences read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return UserPreferences(
      darkMode: fields[0] as bool? ?? false,
      notificationsEnabled: fields[1] as bool? ?? true,
      emailNotifications: fields[2] as bool? ?? true,
      language: fields[3] as String? ?? 'en',
      autoPlayVideos: fields[4] as bool? ?? true,
      compressMediaOnUpload: fields[5] as bool? ?? true,
    );
  }

  @override
  void write(BinaryWriter writer, UserPreferences obj) {
    writer
      ..writeByte(6) // number of fields
      ..writeByte(0)
      ..write(obj.darkMode)
      ..writeByte(1)
      ..write(obj.notificationsEnabled)
      ..writeByte(2)
      ..write(obj.emailNotifications)
      ..writeByte(3)
      ..write(obj.language)
      ..writeByte(4)
      ..write(obj.autoPlayVideos)
      ..writeByte(5)
      ..write(obj.compressMediaOnUpload);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserPreferencesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
