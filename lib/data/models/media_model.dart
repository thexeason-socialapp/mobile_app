import '../../domain/entities/media.dart';

/// Data model for Media with JSON serialization
/// Extends domain entity and adds fromJson/toJson for Firebase
class MediaModel extends Media {
  const MediaModel({
    required super.type,
    required super.url,
    super.thumbnail,
    super.duration,
    super.size,
    super.width,
    super.height,
  });

  /// Create MediaModel from domain entity
  factory MediaModel.fromEntity(Media entity) {
    return MediaModel(
      type: entity.type,
      url: entity.url,
      thumbnail: entity.thumbnail,
      duration: entity.duration,
      size: entity.size,
      width: entity.width,
      height: entity.height,
    );
  }

  /// Create MediaModel from Firestore JSON
  factory MediaModel.fromJson(Map<String, dynamic> json) {
    return MediaModel(
      type: _parseMediaType(json['type'] as String),
      url: json['url'] as String,
      thumbnail: json['thumbnail'] as String?,
      duration: json['duration'] as int?,
      size: json['size'] as int?,
      width: json['width'] as int?,
      height: json['height'] as int?,
    );
  }

  /// Convert to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'url': url,
      if (thumbnail != null) 'thumbnail': thumbnail,
      if (duration != null) 'duration': duration,
      if (size != null) 'size': size,
      if (width != null) 'width': width,
      if (height != null) 'height': height,
    };
  }

  /// Convert to domain entity
  Media toEntity() {
    return Media(
      type: type,
      url: url,
      thumbnail: thumbnail,
      duration: duration,
      size: size,
      width: width,
      height: height,
    );
  }

  /// Helper to parse MediaType from string
  static MediaType _parseMediaType(String type) {
    switch (type.toLowerCase()) {
      case 'image':
        return MediaType.image;
      case 'video':
        return MediaType.video;
      case 'voice':
        return MediaType.voice;
      default:
        throw ArgumentError('Invalid media type: $type');
    }
  }
}