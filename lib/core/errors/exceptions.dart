/// Base class for all custom exceptions in the app
/// Exceptions are thrown during runtime and caught by repositories
/// Repositories convert exceptions → Failures
abstract class AppException implements Exception {
  final String message;
  final String? code;
  
  const AppException({
    required this.message,
    this.code,
  });
  
  @override
  String toString() => 'AppException(message: $message, code: $code)';
}

// ===== SERVER EXCEPTIONS =====
// Thrown by: Firebase, API calls

/// Server-related exception (Firebase, API)
class ServerException extends AppException {
  const ServerException(String message, {super.code})
      : super(message: message);
}

/// Authentication exception (login, signup failed)
class AuthException extends AppException {
  const AuthException(String message, {super.code})
      : super(message: message);
  
  // Convenience constructors
  const AuthException.invalidCredentials()
      : super(
          message: 'Invalid email or password',
          code: 'INVALID_CREDENTIALS',
        );
  
  const AuthException.userNotFound()
      : super(
          message: 'User not found',
          code: 'USER_NOT_FOUND',
        );
  
  const AuthException.emailAlreadyInUse()
      : super(
          message: 'Email is already registered',
          code: 'EMAIL_IN_USE',
        );
  
  const AuthException.weakPassword()
      : super(
          message: 'Password is too weak',
          code: 'WEAK_PASSWORD',
        );
  
  const AuthException.userDisabled()
      : super(
          message: 'This account has been disabled',
          code: 'USER_DISABLED',
        );
  
  const AuthException.tooManyRequests()
      : super(
          message: 'Too many attempts. Please try again later.',
          code: 'TOO_MANY_REQUESTS',
        );
}

/// Resource not found exception
class NotFoundException extends AppException {
  const NotFoundException(String message, {super.code})
      : super(message: message);
  
  const NotFoundException.userNotFound()
      : super(
          message: 'User not found',
          code: 'USER_NOT_FOUND',
        );
  
  const NotFoundException.postNotFound()
      : super(
          message: 'Post not found',
          code: 'POST_NOT_FOUND',
        );
  
  const NotFoundException.commentNotFound()
      : super(
          message: 'Comment not found',
          code: 'COMMENT_NOT_FOUND',
        );
}

/// Permission denied exception
class PermissionDeniedException extends AppException {
  const PermissionDeniedException(String message, {super.code})
      : super(message: message);
  
  const PermissionDeniedException.accessDenied()
      : super(
          message: 'You do not have permission to perform this action',
          code: 'ACCESS_DENIED',
        );
}

/// Server timeout exception
class TimeoutException extends AppException {
  const TimeoutException(String message, {super.code})
      : super(message: message);
  
  const TimeoutException.requestTimeout()
      : super(
          message: 'Request timed out. Please try again.',
          code: 'REQUEST_TIMEOUT',
        );
}

// ===== NETWORK EXCEPTIONS =====
// Thrown by: Network calls

/// Network exception (no internet, connection failed)
class NetworkException extends AppException {
  const NetworkException(String message, {super.code})
      : super(message: message);
  
  const NetworkException.noInternet()
      : super(
          message: 'No internet connection',
          code: 'NO_INTERNET',
        );
  
  const NetworkException.connectionFailed()
      : super(
          message: 'Failed to connect to server',
          code: 'CONNECTION_FAILED',
        );
}

// ===== CACHE EXCEPTIONS =====
// Thrown by: Hive, SharedPreferences

/// Cache exception (Hive, local storage)
class CacheException extends AppException {
  const CacheException(String message, {super.code})
      : super(message: message);
  
  const CacheException.notFound()
      : super(
          message: 'Data not found in cache',
          code: 'CACHE_NOT_FOUND',
        );
  
  const CacheException.readFailed()
      : super(
          message: 'Failed to read from cache',
          code: 'CACHE_READ_FAILED',
        );
  
  const CacheException.writeFailed()
      : super(
          message: 'Failed to write to cache',
          code: 'CACHE_WRITE_FAILED',
        );
  
  const CacheException.expired()
      : super(
          message: 'Cached data has expired',
          code: 'CACHE_EXPIRED',
        );
}

// ===== VALIDATION EXCEPTIONS =====
// Thrown by: Input validation

/// Validation exception (invalid input)
class ValidationException extends AppException {
  final Map<String, String>? fieldErrors;
  
  const ValidationException(
    String message, {
    this.fieldErrors,
    super.code,
  }) : super(message: message);
  
  const ValidationException.invalidEmail()
      : fieldErrors = null,
        super(
          message: 'Invalid email address',
          code: 'INVALID_EMAIL',
        );
  
  const ValidationException.invalidPassword()
      : fieldErrors = null,
        super(
          message: 'Invalid password',
          code: 'INVALID_PASSWORD',
        );
  
  const ValidationException.invalidUsername()
      : fieldErrors = null,
        super(
          message: 'Invalid username',
          code: 'INVALID_USERNAME',
        );
}

// ===== STORAGE EXCEPTIONS =====
// Thrown by: File operations, media upload/download

/// Storage exception (file upload/download)
class StorageException extends AppException {
  const StorageException(String message, {super.code})
      : super(message: message);
  
  const StorageException.uploadFailed()
      : super(
          message: 'Failed to upload file',
          code: 'UPLOAD_FAILED',
        );
  
  const StorageException.downloadFailed()
      : super(
          message: 'Failed to download file',
          code: 'DOWNLOAD_FAILED',
        );
  
  const StorageException.fileTooLarge()
      : super(
          message: 'File size exceeds limit',
          code: 'FILE_TOO_LARGE',
        );
  
  const StorageException.invalidFileType()
      : super(
          message: 'Invalid file type',
          code: 'INVALID_FILE_TYPE',
        );
}

// ===== DATA EXCEPTIONS =====
// Thrown by: JSON parsing, data conversion

/// Data parsing exception (JSON decode error)
class DataParsingException extends AppException {
  const DataParsingException(String message, {super.code})
      : super(message: message);
  
  const DataParsingException.invalidJson()
      : super(
          message: 'Failed to parse JSON data',
          code: 'INVALID_JSON',
        );
  
  const DataParsingException.missingField(String field)
      : super(
          message: 'Missing required field: $field',
          code: 'MISSING_FIELD',
        );
}

/// Data format exception (unexpected data structure)
class DataFormatException extends AppException {
  const DataFormatException(String message, {super.code})
      : super(message: message);
}

// ===== SYNC EXCEPTIONS =====
// Thrown by: Offline sync operations

/// Sync exception (failed to sync offline data)
class SyncException extends AppException {
  const SyncException(String message, {super.code})
      : super(message: message);
  
  const SyncException.conflict()
      : super(
          message: 'Data conflict during sync',
          code: 'SYNC_CONFLICT',
        );
  
  const SyncException.failed()
      : super(
          message: 'Failed to sync data',
          code: 'SYNC_FAILED',
        );
}

// ===== MEDIA EXCEPTIONS =====
// Thrown by: Image/video processing

/// Media processing exception (compression, conversion)
class MediaException extends AppException {
  const MediaException(String message, {super.code})
      : super(message: message);
  
  const MediaException.compressionFailed()
      : super(
          message: 'Failed to compress media',
          code: 'COMPRESSION_FAILED',
        );
  
  const MediaException.invalidFormat()
      : super(
          message: 'Unsupported media format',
          code: 'INVALID_FORMAT',
        );
  
  const MediaException.processingFailed()
      : super(
          message: 'Failed to process media',
          code: 'PROCESSING_FAILED',
        );
}

// ===== RATE LIMIT EXCEPTIONS =====
// Thrown by: API rate limiting

/// Rate limit exception (too many requests)
class RateLimitException extends AppException {
  const RateLimitException(String message, {super.code})
      : super(message: message);
  
  const RateLimitException.exceeded()
      : super(
          message: 'Rate limit exceeded. Please try again later.',
          code: 'RATE_LIMIT_EXCEEDED',
        );
}

// ===== PLATFORM EXCEPTIONS =====
// Thrown by: Platform-specific operations

/// Platform exception (camera, permissions, etc.)
class PlatformException extends AppException {
  const PlatformException(String message, {super.code})
      : super(message: message);
  
  const PlatformException.cameraUnavailable()
      : super(
          message: 'Camera is not available',
          code: 'CAMERA_UNAVAILABLE',
        );
  
  const PlatformException.permissionDenied(String permission)
      : super(
          message: '$permission permission denied',
          code: 'PERMISSION_DENIED',
        );
}

// ===== UNKNOWN EXCEPTIONS =====
// Thrown by: Unexpected errors

/// Unknown exception (unexpected error)
class UnknownException extends AppException {
  const UnknownException(String message, {super.code})
      : super(message: message);
  
  const UnknownException.unexpected()
      : super(
          message: 'An unexpected error occurred',
          code: 'UNKNOWN_ERROR',
        );
}