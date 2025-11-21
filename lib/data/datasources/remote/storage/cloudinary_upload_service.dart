import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

/// Simple, reliable Cloudinary upload service
/// Handles file uploads with proper authentication
class CloudinaryUploadService {
  final String cloudName;
  final String apiKey;
  final String apiSecret;
  final Logger logger;

  CloudinaryUploadService({
    required this.cloudName,
    required this.apiKey,
    required this.apiSecret,
    required this.logger,
  });

  /// Upload file to Cloudinary
  /// Returns the secure URL of the uploaded file
  Future<String> uploadFile({
    required List<int> fileBytes,
    required String fileName,
    required String folder,
  }) async {
    try {
      logger.i('Starting Cloudinary upload: $fileName');

      // Create multipart request
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload'),
      );

      // Add file
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          fileBytes,
          filename: fileName,
        ),
      );

      // Add basic parameters
      request.fields['api_key'] = apiKey;
      request.fields['folder'] = folder;
      request.fields['public_id'] = _extractPublicId(fileName);

      // Generate timestamp and signature for overwrite
      final timestamp = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
      request.fields['timestamp'] = timestamp;
      request.fields['overwrite'] = 'true';

      // Create signature
      final signature = _generateSignature({
        'public_id': _extractPublicId(fileName),
        'folder': folder,
        'timestamp': timestamp,
        'overwrite': 'true',
      });
      request.fields['signature'] = signature;

      logger.d('Sending request to Cloudinary...');

      // Send request
      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 60),
        onTimeout: () => throw Exception('Upload timeout'),
      );

      final response = await http.Response.fromStream(streamedResponse);

      logger.d('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final secureUrl = data['secure_url'] as String?;

        if (secureUrl != null && secureUrl.isNotEmpty) {
          logger.i('Upload successful: $secureUrl');
          return secureUrl;
        } else {
          throw Exception('No secure_url in response');
        }
      } else {
        logger.e('Upload failed: ${response.statusCode}');
        logger.e('Response: ${response.body}');
        throw Exception('Upload failed: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      logger.e('Error uploading to Cloudinary: $e');
      rethrow;
    }
  }

  /// Extract public ID from filename
  String _extractPublicId(String fileName) {
    final lastDot = fileName.lastIndexOf('.');
    if (lastDot != -1) {
      return fileName.substring(0, lastDot);
    }
    return fileName;
  }

  /// Generate SHA-1 signature for authenticated upload
  String _generateSignature(Map<String, String> params) {
    // Sort parameters alphabetically
    final sortedKeys = params.keys.toList()..sort();
    final paramString = sortedKeys
        .map((key) => '$key=${params[key]}')
        .join('&');

    // Append API secret
    final signatureString = '$paramString$apiSecret';

    // Generate SHA-1 hash
    return sha1.convert(utf8.encode(signatureString)).toString();
  }
}
