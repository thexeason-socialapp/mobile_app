import 'package:equatable/equatable.dart';

/// Base class for all failures in the app
/// Failures represent expected errors in business logic
/// They are returned as results, not thrown as exceptions
abstract class Failure extends Equatable {
  final String message;
  final String? code;
  
  const Failure({
    required this.message,
    this.code,
  });
  
  @override
  List<Object?> get props => [message, code];
  
  @override
  String toString() => 'Failure(message: $message, code: $code)';
}

// ===== SERVER FAILURES =====
// Used for: Firebase errors, API errors, backend errors

/// Generic server failure (Firebase, API, backend)
class ServerFailure extends Failure {
  const ServerFailure(String message, {super.code})
      : super(message: message);
}

/// Authentication failure (login, signup, password reset)
class AuthFailure extends Failure {
  const AuthFailure(String message, {super.code})
      : super(message: message);
}

/// Resource not found (user, post, comment doesn't exist)
class NotFoundFailure extends Failure {
  const NotFoundFailure(String message, {super.code})
      : super(message: message);
}

/// Permission denied (user doesn't have access)
class PermissionDeniedFailure extends Failure {
  const PermissionDeniedFailure(String message, {super.code})
      : super(message: message);
}

/// Server timeout (request took too long)
class TimeoutFailure extends Failure {
  const TimeoutFailure(String message, {super.code})
      : super(message: message);
}

// ===== NETWORK FAILURES =====
// Used for: No internet, connection issues

/// No internet connection
class NetworkFailure extends Failure {
  const NetworkFailure(String message, {super.code})
      : super(message: message);
  
  // Convenience constructor
  const NetworkFailure.noInternet()
      : super(
          message: 'No internet connection. Please check your network.',
          code: 'NO_INTERNET',
        );
}

/// Weak/unstable connection
class ConnectionFailure extends Failure {
  const ConnectionFailure(String message, {super.code})
      : super(message: message);
}

// ===== CACHE FAILURES =====
// Used for: Hive errors, local storage issues

/// Cache read/write failure (Hive, SharedPreferences)
class CacheFailure extends Failure {
  const CacheFailure(String message, {super.code})
      : super(message: message);
  
  // Convenience constructors
  const CacheFailure.notFound()
      : super(
          message: 'Data not found in cache',
          code: 'CACHE_NOT_FOUND',
        );
  
  const CacheFailure.expired()
      : super(
          message: 'Cached data has expired',
          code: 'CACHE_EXPIRED',
        );
}

// ===== VALIDATION FAILURES =====
// Used for: Form validation, input validation

/// Validation failure (invalid email, weak password, etc.)
class ValidationFailure extends Failure {
  final Map<String, String>? fieldErrors; // Field-specific errors
  
  const ValidationFailure(
    String message, {
    this.fieldErrors,
    super.code,
  }) : super(message: message);
  
  @override
  List<Object?> get props => [message, code, fieldErrors];
}

// ===== STORAGE FAILURES =====
// Used for: File upload/download errors, media storage

/// File storage failure (upload/download errors)
class StorageFailure extends Failure {
  const StorageFailure(String message, {super.code})
      : super(message: message);
  
  // Convenience constructors
  const StorageFailure.uploadFailed()
      : super(
          message: 'Failed to upload file',
          code: 'UPLOAD_FAILED',
        );
  
  const StorageFailure.downloadFailed()
      : super(
          message: 'Failed to download file',
          code: 'DOWNLOAD_FAILED',
        );
  
  const StorageFailure.fileTooLarge()
      : super(
          message: 'File size exceeds maximum allowed',
          code: 'FILE_TOO_LARGE',
        );
}

// ===== DATA FAILURES =====
// Used for: Data parsing errors, unexpected data format

/// Data parsing failure (JSON decode error, unexpected format)
class DataParsingFailure extends Failure {
  const DataParsingFailure(String message, {super.code})
      : super(message: message);
}

/// Data format failure (missing required fields)
class DataFormatFailure extends Failure {
  const DataFormatFailure(String message, {super.code})
      : super(message: message);
}

// ===== SYNC FAILURES =====
// Used for: Offline sync errors, pending action failures

/// Sync failure (failed to sync offline actions)
class SyncFailure extends Failure {
  const SyncFailure(String message, {super.code})
      : super(message: message);
  
  const SyncFailure.conflict()
      : super(
          message: 'Data conflict during sync',
          code: 'SYNC_CONFLICT',
        );
}

// ===== MEDIA FAILURES =====
// Used for: Image/video processing errors

/// Media processing failure (compression, conversion)
class MediaFailure extends Failure {
  const MediaFailure(String message, {super.code})
      : super(message: message);
  
  // Convenience constructors
  const MediaFailure.compressionFailed()
      : super(
          message: 'Failed to compress media',
          code: 'COMPRESSION_FAILED',
        );
  
  const MediaFailure.invalidFormat()
      : super(
          message: 'Unsupported media format',
          code: 'INVALID_FORMAT',
        );
}

// ===== RATE LIMIT FAILURES =====
// Used for: Too many requests

/// Rate limit exceeded
class RateLimitFailure extends Failure {
  const RateLimitFailure(String message, {super.code})
      : super(message: message);
  
  const RateLimitFailure.tooManyRequests()
      : super(
          message: 'Too many requests. Please try again later.',
          code: 'RATE_LIMIT_EXCEEDED',
        );
}

// ===== UNKNOWN FAILURES =====
// Used for: Unexpected errors

/// Unknown/unexpected failure
class UnknownFailure extends Failure {
  const UnknownFailure(String message, {super.code})
      : super(message: message);
  
  const UnknownFailure.unexpected()
      : super(
          message: 'An unexpected error occurred',
          code: 'UNKNOWN_ERROR',
        );
}