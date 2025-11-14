import '../../domain/entities/media.dart';

/// MediaModel - extends Media entity with JSON serialization
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

  /// Create MediaModel from JSON (from Firestore)
  factory MediaModel.fromJson(Map<String, dynamic> json) {
    return MediaModel(
      type: MediaType.values.byName(json['type'] as String),
      url: json['url'] as String,
      thumbnail: json['thumbnail'] as String?,
      duration: json['duration'] as int?,
      size: json['size'] as int?,
      width: json['width'] as int?,
      height: json['height'] as int?,
    );
  }

  /// Convert MediaModel to JSON (for Firestore)
  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'url': url,
      'thumbnail': thumbnail,
      'duration': duration,
      'size': size,
      'width': width,
      'height': height,
    };
  }

  /// Create MediaModel from Media entity
  factory MediaModel.fromEntity(Media media) {
    return MediaModel(
      type: media.type,
      url: media.url,
      thumbnail: media.thumbnail,
      duration: media.duration,
      size: media.size,
      width: media.width,
      height: media.height,
    );
  }
}