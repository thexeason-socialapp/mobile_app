import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../data/datasources/remote/storage/cloudinary_upload_service.dart';

// Upload state
class UploadState {
  final bool isLoading;
  final String? uploadedUrl;
  final String? error;

  const UploadState({
    this.isLoading = false,
    this.uploadedUrl,
    this.error,
  });

  UploadState copyWith({
    bool? isLoading,
    String? uploadedUrl,
    String? error,
  }) {
    return UploadState(
      isLoading: isLoading ?? this.isLoading,
      uploadedUrl: uploadedUrl ?? this.uploadedUrl,
      error: error ?? this.error,
    );
  }
}

// Upload notifier
class UploadNotifier extends StateNotifier<UploadState> {
  final CloudinaryUploadService _cloudinary;
  final Logger _logger;

  UploadNotifier({
    required CloudinaryUploadService cloudinary,
    required Logger logger,
  })  : _cloudinary = cloudinary,
        _logger = logger,
        super(const UploadState());

  Future<void> uploadImage(XFile imageFile) async {
    try {
      state = const UploadState(isLoading: true);

      // Read file bytes
      final bytes = await imageFile.readAsBytes();
      _logger.i('File size: ${bytes.length} bytes');

      // Upload to Cloudinary
      final url = await _cloudinary.uploadFile(
        fileBytes: bytes,
        fileName: 'test_${DateTime.now().millisecondsSinceEpoch}.jpg',
        folder: 'test_uploads',
      );

      state = UploadState(uploadedUrl: url);
    } catch (e) {
      _logger.e('Upload error: $e');
      state = UploadState(error: e.toString());
    }
  }

  void reset() {
    state = const UploadState();
  }
}

// Provider
final uploadProvider = StateNotifierProvider<UploadNotifier, UploadState>((ref) {
  final logger = Logger();

  final cloudinary = CloudinaryUploadService(
    cloudName: dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '',
    apiKey: dotenv.env['CLOUDINARY_API_KEY'] ?? '',
    apiSecret: dotenv.env['CLOUDINARY_API_SECRET'] ?? '',
    logger: logger,
  );

  return UploadNotifier(
    cloudinary: cloudinary,
    logger: logger,
  );
});
