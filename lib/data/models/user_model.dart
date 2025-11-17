import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/user.dart';

/// Data model for UserPreferences with JSON serialization
class UserPreferencesModel extends UserPreferences {
  const UserPreferencesModel({
    super.darkMode,
    super.notificationsEnabled,
    super.emailNotifications,
    super.language,
    super.autoPlayVideos,
    super.compressMediaOnUpload,
  });

  factory UserPreferencesModel.fromEntity(UserPreferences entity) {
    return UserPreferencesModel(
      darkMode: entity.darkMode,
      notificationsEnabled: entity.notificationsEnabled,
      emailNotifications: entity.emailNotifications,
      language: entity.language,
      autoPlayVideos: entity.autoPlayVideos,
      compressMediaOnUpload: entity.compressMediaOnUpload,
    );
  }

  factory UserPreferencesModel.fromJson(Map<String, dynamic> json) {
    return UserPreferencesModel(
      darkMode: json['darkMode'] as bool? ?? false,
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      emailNotifications: json['emailNotifications'] as bool? ?? true,
      language: json['language'] as String? ?? 'en',
      autoPlayVideos: json['autoPlayVideos'] as bool? ?? true,
      compressMediaOnUpload: json['compressMediaOnUpload'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'darkMode': darkMode,
      'notificationsEnabled': notificationsEnabled,
      'emailNotifications': emailNotifications,
      'language': language,
      'autoPlayVideos': autoPlayVideos,
      'compressMediaOnUpload': compressMediaOnUpload,
    };
  }

  UserPreferences toEntity() {
    return UserPreferences(
      darkMode: darkMode,
      notificationsEnabled: notificationsEnabled,
      emailNotifications: emailNotifications,
      language: language,
      autoPlayVideos: autoPlayVideos,
      compressMediaOnUpload: compressMediaOnUpload,
    );
  }
}

/// Data model for User with JSON serialization
/// Extends domain entity and adds fromJson/toJson for Firebase
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.username,
    required super.displayName,
    super.bio,
    super.avatar,
    super.banner,
    super.followers,
    super.following,
    super.postsCount,
    required super.createdAt,
    super.updatedAt,
    super.isPrivate,
    super.location,
    super.website,
    super.phone,
    super.verified,
    super.isEmailVerified,
    super.blockedUsers,
    super.preferences,
  });

  /// Create UserModel from domain entity
  factory UserModel.fromEntity(User entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      username: entity.username,
      displayName: entity.displayName,
      bio: entity.bio,
      avatar: entity.avatar,
      banner: entity.banner,
      followers: entity.followers,
      following: entity.following,
      postsCount: entity.postsCount,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      isPrivate: entity.isPrivate,
      location: entity.location,
      website: entity.website,
      phone: entity.phone,
      verified: entity.verified,
      blockedUsers: entity.blockedUsers,
      preferences: entity.preferences,
    );
  }

  /// Create UserModel from Firestore JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
  return UserModel(
    id: json['id'] as String,
    email: json['email'] as String,
    username: json['username'] as String,
    displayName: json['displayName'] as String,
    bio: json['bio'] as String?,
    avatar: json['avatar'] as String?,
    banner: json['banner'] as String?,
    followers: json['followers'] as int? ?? 0,
    following: json['following'] as int? ?? 0,
    postsCount: json['postsCount'] as int? ?? 0,
    
    // ✅ FIX: Handle both Timestamp and String for dates
    createdAt: _parseDateTime(json['createdAt']),
    updatedAt: json['updatedAt'] != null ? _parseDateTime(json['updatedAt']) : null,
    
    isPrivate: json['isPrivate'] as bool? ?? false,
    location: json['location'] as String?,
    website: json['website'] as String?,
    phone: json['phone'] as String?,
    verified: json['verified'] as bool? ?? false,
    isEmailVerified: json['isEmailVerified'] as bool? ?? false,
    blockedUsers: (json['blockedUsers'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList() ?? const [],
    preferences: json['preferences'] != null
        ? UserPreferencesModel.fromJson(json['preferences'] as Map<String, dynamic>)
        : const UserPreferences(),
  );
}

// ✅ ADD this helper method to your UserModel class:
static DateTime _parseDateTime(dynamic value) {
  if (value == null) return DateTime.now();
  
  // Handle Firestore Timestamp
  if (value is Timestamp) {
    return value.toDate();
  }
  
  // Handle String format
  if (value is String) {
    return DateTime.parse(value);
  }
  
  // Fallback
  return DateTime.now();
}
  /// Convert to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'displayName': displayName,
      if (bio != null) 'bio': bio,
      if (avatar != null) 'avatar': avatar,
      if (banner != null) 'banner': banner,
      'followers': followers,
      'following': following,
      'postsCount': postsCount,
      'createdAt': createdAt.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
      'isPrivate': isPrivate,
      if (location != null) 'location': location,
      if (website != null) 'website': website,
      if (phone != null) 'phone': phone,
      'verified': verified,
      'isEmailVerified': isEmailVerified, 
      'blockedUsers': blockedUsers,
      'preferences': UserPreferencesModel.fromEntity(preferences).toJson(),
    };
  }

  /// Convert to domain entity
  User toEntity() {
    return User(
      id: id,
      email: email,
      username: username,
      displayName: displayName,
      bio: bio,
      avatar: avatar,
      banner: banner,
      followers: followers,
      following: following,
      postsCount: postsCount,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isPrivate: isPrivate,
      location: location,
      website: website,
      phone: phone,
      verified: verified,
      isEmailVerified: isEmailVerified,
      blockedUsers: blockedUsers,
      preferences: preferences,
    );
  }

@override
  UserModel copyWith({
  String? id,
  String? email,
  String? username,
  String? displayName,
  String? bio,
  String? avatar,
  String? banner,
  int? followers,
  int? following,
  int? postsCount,
  DateTime? createdAt,
  DateTime? updatedAt,
  bool? isPrivate,
  String? location,
  String? website,
  String? phone,
  bool? verified,
  bool? isEmailVerified,  // ✅ ADD THIS PARAMETER
  List<String>? blockedUsers,
  UserPreferences? preferences,
}) {
  return UserModel(
    id: id ?? this.id,
    email: email ?? this.email,
    username: username ?? this.username,
    displayName: displayName ?? this.displayName,
    bio: bio ?? this.bio,
    avatar: avatar ?? this.avatar,
    banner: banner ?? this.banner,
    followers: followers ?? this.followers,
    following: following ?? this.following,
    postsCount: postsCount ?? this.postsCount,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isPrivate: isPrivate ?? this.isPrivate,
    location: location ?? this.location,
    website: website ?? this.website,
    phone: phone ?? this.phone,
    verified: verified ?? this.verified,
    isEmailVerified: isEmailVerified ?? this.isEmailVerified,  // ✅ ADD THIS LINE
    blockedUsers: blockedUsers ?? this.blockedUsers,
    preferences: preferences ?? this.preferences,
  );
}
}