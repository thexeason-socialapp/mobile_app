import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// CloudinaryVideoWidget
/// Displays videos from Cloudinary with playback controls and optimization
///
/// Features:
/// - Auto-optimized video URLs for mobile/web
/// - Built-in video player controls
/// - Thumbnail support
/// - Loading states
/// - Error handling
/// - Auto play/mute options
///
/// Example:
/// ```dart
/// CloudinaryVideoWidget(
///   videoUrl: 'https://res.cloudinary.com/.../video.mp4',
///   width: 300,
///   height: 200,
///   autoPlay: false,
/// )
/// ```
class CloudinaryVideoWidget extends StatefulWidget {
  /// Full Cloudinary video URL
  final String videoUrl;

  /// Widget width
  final double? width;

  /// Widget height
  final double? height;

  /// Auto-play video on load
  final bool autoPlay;

  /// Mute audio by default
  final bool muted;

  /// Show video player controls
  final bool showControls;

  /// Show loading indicator while initializing
  final bool showLoadingIndicator;

  /// Custom thumbnail URL (optional, Cloudinary generates one by default)
  final String? thumbnailUrl;

  /// Border radius for rounded corners
  final BorderRadius? borderRadius;

  /// Loop video playback
  final bool loop;

  const CloudinaryVideoWidget({
    Key? key,
    required this.videoUrl,
    this.width,
    this.height,
    this.autoPlay = false,
    this.muted = true,
    this.showControls = true,
    this.showLoadingIndicator = true,
    this.thumbnailUrl,
    this.borderRadius,
    this.loop = false,
  }) : super(key: key);

  @override
  State<CloudinaryVideoWidget> createState() => _CloudinaryVideoWidgetState();
}

class _CloudinaryVideoWidgetState extends State<CloudinaryVideoWidget> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      // Get optimized video URL
      final optimizedUrl = _optimizeVideoUrl(widget.videoUrl);

      _controller = VideoPlayerController.networkUrl(Uri.parse(optimizedUrl))
        ..initialize().then((_) {
          if (mounted) {
            setState(() {
              _isInitialized = true;
            });

            if (widget.autoPlay) {
              _controller.play();
              if (mounted) {
                setState(() => _isPlaying = true);
              }
            }

            _controller.setVolume(widget.muted ? 0.0 : 1.0);

            if (widget.loop) {
              _controller.setLooping(true);
            }

            // Listen to play state changes
            _controller.addListener(_onPlayerStateChanged);
          }
        }).catchError((error) {
          if (mounted) {
            setState(() {
              _errorMessage = 'Failed to load video: $error';
            });
          }
        });
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error initializing video: $e';
        });
      }
    }
  }

  void _onPlayerStateChanged() {
    if (mounted) {
      setState(() {
        _isPlaying = _controller.value.isPlaying;
      });

      // Loop video by restarting at the end
      if (widget.loop &&
          _controller.value.position >= _controller.value.duration) {
        _controller.seekTo(Duration.zero);
        _controller.play();
      }
    }
  }

  /// Get optimized video URL for mobile/web
  String _optimizeVideoUrl(String url) {
    if (!url.contains('cloudinary.com') && !url.contains('res.cloudinary.com')) {
      return url;
    }

    try {
      final uri = Uri.parse(url);
      final segments = uri.pathSegments.toList();

      // Find 'upload' segment
      final uploadIndex = segments.indexOf('upload');
      if (uploadIndex == -1) {
        return url; // Not a standard Cloudinary URL
      }

      // Extract public ID and path after upload
      final afterUpload = segments.sublist(uploadIndex + 1);
      final publicIdWithExt = afterUpload.join('/');

      // Add mobile optimization transformations
      // q_auto: auto quality
      // f_auto: auto format (mp4, webm, etc based on browser)
      // c_scale,w_640: scale to 640px width for mobile
      final transformations = 'q_auto,f_auto,c_scale,w_640';

      // Reconstruct URL with transformations
      final baseUrl = '${uri.scheme}://${uri.host}';
      return '$baseUrl/video/upload/$transformations/$publicIdWithExt';
    } catch (e) {
      // If parsing fails, return original URL
      return url;
    }
  }

  /// Get thumbnail URL from video
  String _getThumbnailUrl() {
    if (widget.thumbnailUrl != null) {
      return widget.thumbnailUrl!;
    }

    // Generate thumbnail from video URL
    if (!widget.videoUrl.contains('cloudinary.com') &&
        !widget.videoUrl.contains('res.cloudinary.com')) {
      return '';
    }

    try {
      final uri = Uri.parse(widget.videoUrl);
      final segments = uri.pathSegments.toList();

      final uploadIndex = segments.indexOf('upload');
      if (uploadIndex == -1) {
        return '';
      }

      final afterUpload = segments.sublist(uploadIndex + 1);
      final publicIdWithExt = afterUpload.join('/');

      // Create thumbnail transformation
      final transformations = 'c_fill,w_400,h_225,q_auto,f_auto';

      final baseUrl = '${uri.scheme}://${uri.host}';
      return '$baseUrl/video/upload/$transformations/$publicIdWithExt';
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show error state
    if (_errorMessage != null) {
      return Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: widget.borderRadius,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red[400],
                size: 48,
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Show loading state
    if (!_isInitialized && widget.showLoadingIndicator) {
      final thumbnailUrl = _getThumbnailUrl();

      return Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: widget.borderRadius,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Thumbnail background
            if (thumbnailUrl.isNotEmpty)
              ClipRRect(
                borderRadius: widget.borderRadius ?? BorderRadius.zero,
                child: Image.network(
                  thumbnailUrl,
                  width: widget.width,
                  height: widget.height,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[800],
                    );
                  },
                ),
              ),
            // Loading indicator
            Container(
              color: Colors.black.withValues(alpha: 0.3),
              child: const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Show initialized video player
    if (_isInitialized) {
      return Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: widget.borderRadius,
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Video player
            AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
            // Controls overlay
            if (widget.showControls)
              Positioned.fill(
                child: GestureDetector(
                  onTap: _togglePlayPause,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Play/Pause button
                      if (!_isPlaying)
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withValues(alpha: 0.7),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: const Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 48,
                          ),
                        ),
                      // Bottom controls bar
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.7),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Progress bar
                              _buildProgressBar(),
                              const SizedBox(height: 8),
                              // Time display
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _formatDuration(
                                        _controller.value.position),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    _formatDuration(
                                        _controller.value.duration),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      );
    }

    // Default loading state
    return Container(
      width: widget.width,
      height: widget.height,
      color: Colors.grey[900],
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  /// Build video progress bar
  Widget _buildProgressBar() {
    final position = _controller.value.position;
    final duration = _controller.value.duration;
    final progress = duration.inMilliseconds > 0
        ? position.inMilliseconds / duration.inMilliseconds
        : 0.0;

    return SliderTheme(
      data: SliderThemeData(
        trackHeight: 3,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 8),
      ),
      child: Slider(
        value: progress.clamp(0.0, 1.0),
        onChanged: (value) {
          final duration = _controller.value.duration;
          final position = Duration(
            milliseconds: (value * duration.inMilliseconds).toInt(),
          );
          _controller.seekTo(position);
        },
        activeColor: Colors.red,
        inactiveColor: Colors.white.withValues(alpha: 0.3),
      ),
    );
  }

  /// Toggle play/pause
  void _togglePlayPause() {
    if (_isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
  }

  /// Format duration to MM:SS
  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _controller.removeListener(_onPlayerStateChanged);
    _controller.dispose();
    super.dispose();
  }
}
