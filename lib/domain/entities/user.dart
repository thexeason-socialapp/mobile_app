/// 👤 USER ENTITY
/// Pure Dart class representing a user in Thexeason
/// No dependencies on Flutter, Firebase, or external packages
/// Used across all layers as the source of truth for user data

class User {
  final String id;
  final String email;
  final String username;
  final String displayName;
  final String? bio;
  final String? avatar;
  final String? banner;
  final int followers;
  final int following;
  final int postsCount;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isPrivate;
  final String? location;
  final String? website;
  final String? phone;
  final bool verified;
  final List<String> blockedUsers;
  final UserPreferences preferences;

  const User({
    required this.id,
    required this.email,
    required this.username,
    required this.displayName,
    this.bio,
    this.avatar,
    this.banner,
    this.followers = 0,
    this.following = 0,
    this.postsCount = 0,
    required this.createdAt,
    this.updatedAt,
    this.isPrivate = false,
    this.location,
    this.website,
    this.phone,
    this.verified = false,
    this.blockedUsers = const [],
    this.preferences = const UserPreferences(),
  });

  /// Create a copy of this user with updated fields
  User copyWith({
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
    List<String>? blockedUsers,
    UserPreferences? preferences,
  }) {
    return User(
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
      blockedUsers: blockedUsers ?? this.blockedUsers,
      preferences: preferences ?? this.preferences,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User && other.id == id && other.email == email;
  }

  @override
  int get hashCode => id.hashCode ^ email.hashCode;

  @override
  String toString() {
    return 'User(id: $id, username: $username, email: $email, displayName: $displayName)';
  }
}

/// User preferences embedded object
class UserPreferences {
  final bool darkMode;
  final bool notificationsEnabled;
  final bool emailNotifications;
  final String language;
  final bool autoPlayVideos;
  final bool compressMediaOnUpload;

  const UserPreferences({
    this.darkMode = false,
    this.notificationsEnabled = true,
    this.emailNotifications = true,
    this.language = 'en',
    this.autoPlayVideos = true,
    this.compressMediaOnUpload = true,
  });

  UserPreferences copyWith({
    bool? darkMode,
    bool? notificationsEnabled,
    bool? emailNotifications,
    String? language,
    bool? autoPlayVideos,
    bool? compressMediaOnUpload,
  }) {
    return UserPreferences(
      darkMode: darkMode ?? this.darkMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      language: language ?? this.language,
      autoPlayVideos: autoPlayVideos ?? this.autoPlayVideos,
      compressMediaOnUpload: compressMediaOnUpload ?? this.compressMediaOnUpload,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserPreferences &&
        other.darkMode == darkMode &&
        other.notificationsEnabled == notificationsEnabled &&
        other.emailNotifications == emailNotifications &&
        other.language == language &&
        other.autoPlayVideos == autoPlayVideos &&
        other.compressMediaOnUpload == compressMediaOnUpload;
  }

  @override
  int get hashCode {
    return darkMode.hashCode ^
        notificationsEnabled.hashCode ^
        emailNotifications.hashCode ^
        language.hashCode ^
        autoPlayVideos.hashCode ^
        compressMediaOnUpload.hashCode;
  }

  @override
  String toString() {
    return 'UserPreferences(darkMode: $darkMode, notifications: $notificationsEnabled, language: $language)';
  }
}