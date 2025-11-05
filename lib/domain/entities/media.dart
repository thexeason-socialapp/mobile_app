/// 🎬 MEDIA ENTITY
/// Pure Dart class representing a media file (image, video, voice)
/// Used in posts, comments, and messages
/// No dependencies on external packages

enum MediaType {
  image,
  video,
  voice,
}

class Media {
  final MediaType type;
  final String url;
  final String? thumbnail;
  final int? duration; // seconds (for video/voice)
  final int? size; // bytes
  final int? width;
  final int? height;

  const Media({
    required this.type,
    required this.url,
    this.thumbnail,
    this.duration,
    this.size,
    this.width,
    this.height,
  });

  /// Create a copy of this media with updated fields
  Media copyWith({
    MediaType? type,
    String? url,
    String? thumbnail,
    int? duration,
    int? size,
    int? width,
    int? height,
  }) {
    return Media(
      type: type ?? this.type,
      url: url ?? this.url,
      thumbnail: thumbnail ?? this.thumbnail,
      duration: duration ?? this.duration,
      size: size ?? this.size,
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Media && other.url == url && other.type == type;
  }

  @override
  int get hashCode => url.hashCode ^ type.hashCode;

  @override
  String toString() {
    return 'Media(type: $type, url: $url, duration: $duration, size: $size)';
  }
}