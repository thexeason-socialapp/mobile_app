import '../constants/regex_constants.dart';

class Validators {
  Validators._();
  
  // ===== Email Validator =====
  /// Validates email format
  /// Returns error message if invalid, null if valid
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    if (!RegExp(RegexConstants.email).hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    
    return null; // Valid
  }
  
  // ===== Username Validator =====
  /// Validates username (3-30 chars, alphanumeric + underscore)
  /// Returns error message if invalid, null if valid
  static String? username(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }
    
    final trimmed = value.trim();
    
    if (trimmed.length < 3) {
      return 'Username must be at least 3 characters';
    }
    
    if (trimmed.length > 30) {
      return 'Username must not exceed 30 characters';
    }
    
    if (!RegExp(RegexConstants.username).hasMatch(trimmed)) {
      return 'Username can only contain letters, numbers, and underscores';
    }
    
    return null; // Valid
  }
  
  // ===== Password Validator =====
  /// Validates password strength
  /// Requires: 8+ chars, 1 uppercase, 1 lowercase, 1 number, 1 special char
  /// Returns error message if invalid, null if valid
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }
    
    if (!RegExp(r'\d').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    
    if (!RegExp(r'[@$!%*?&#]').hasMatch(value)) {
      return 'Password must contain at least one special character (@\$!%*?&#)';
    }
    
    return null; // Valid
  }
  
  // ===== Confirm Password Validator =====
  /// Validates that password confirmation matches original
  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    
    if (value != password) {
      return 'Passwords do not match';
    }
    
    return null; // Valid
  }
  
  // ===== Phone Number Validator =====
  /// Validates phone number (international format)
  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    
    // Remove spaces and hyphens for validation
    final cleaned = value.replaceAll(RegExp(r'[\s-]'), '');
    
    if (!RegExp(RegexConstants.phone).hasMatch(cleaned)) {
      return 'Enter a valid phone number (e.g., +1234567890)';
    }
    
    return null; // Valid
  }
  
  // ===== Required Field Validator =====
  /// Generic validator for required fields
  static String? required(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }
  
  // ===== Min Length Validator =====
  /// Validates minimum length
  static String? minLength(String? value, int min, {String fieldName = 'This field'}) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    
    if (value.length < min) {
      return '$fieldName must be at least $min characters';
    }
    
    return null;
  }
  
  // ===== Max Length Validator =====
  /// Validates maximum length
  static String? maxLength(String? value, int max, {String fieldName = 'This field'}) {
    if (value == null || value.isEmpty) {
      return null; // Allow empty if not required
    }
    
    if (value.length > max) {
      return '$fieldName must not exceed $max characters';
    }
    
    return null;
  }
  
  // ===== URL Validator =====
  /// Validates URL format
  static String? url(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Allow empty if not required
    }
    
    if (!RegExp(RegexConstants.url).hasMatch(value.trim())) {
      return 'Enter a valid URL (e.g., https://example.com)';
    }
    
    return null;
  }
  
  // ===== Alphanumeric Validator =====
  /// Validates only letters and numbers
  static String? alphanumeric(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    
    if (!RegExp(RegexConstants.alphanumeric).hasMatch(value)) {
      return '$fieldName can only contain letters and numbers';
    }
    
    return null;
  }
  
  // ===== Number Validator =====
  /// Validates numeric input
  static String? number(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    
    if (!RegExp(RegexConstants.numbersOnly).hasMatch(value)) {
      return '$fieldName must be a valid number';
    }
    
    return null;
  }
  
  // ===== Range Validator =====
  /// Validates number is within range
  static String? range(String? value, int min, int max, {String fieldName = 'This field'}) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    
    final number = int.tryParse(value);
    if (number == null) {
      return '$fieldName must be a valid number';
    }
    
    if (number < min || number > max) {
      return '$fieldName must be between $min and $max';
    }
    
    return null;
  }
  
  // ===== Post Content Validator =====
  /// Validates post content (not empty, within limit)
  static String? postContent(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Post cannot be empty';
    }
    
    final trimmed = value.trim();
    
    if (trimmed.length > 2000) {
      return 'Post must not exceed 2000 characters';
    }
    
    return null;
  }
  
  // ===== Thread Content Validator =====
  /// Validates thread content (Twitter-style, 280 chars)
  static String? threadContent(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Thread cannot be empty';
    }
    
    final trimmed = value.trim();
    
    if (trimmed.length > 280) {
      return 'Thread must not exceed 280 characters';
    }
    
    return null;
  }
  
  // ===== Comment Validator =====
  /// Validates comment content
  static String? comment(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Comment cannot be empty';
    }
    
    final trimmed = value.trim();
    
    if (trimmed.length > 500) {
      return 'Comment must not exceed 500 characters';
    }
    
    return null;
  }
  
  // ===== Bio Validator =====
  /// Validates user bio
  static String? bio(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Bio is optional
    }
    
    if (value.length > 160) {
      return 'Bio must not exceed 160 characters';
    }
    
    return null;
  }
  
  // ===== Display Name Validator =====
  /// Validates display name
  static String? displayName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Display name is required';
    }
    
    final trimmed = value.trim();
    
    if (trimmed.length < 2) {
      return 'Display name must be at least 2 characters';
    }
    
    if (trimmed.length > 50) {
      return 'Display name must not exceed 50 characters';
    }
    
    return null;
  }
  
  // ===== Date Validator =====
  /// Validates date is not in the future
  static String? pastDate(DateTime? value, {String fieldName = 'Date'}) {
    if (value == null) {
      return '$fieldName is required';
    }
    
    if (value.isAfter(DateTime.now())) {
      return '$fieldName cannot be in the future';
    }
    
    return null;
  }
  
  // ===== Age Validator =====
  /// Validates user is at least minimum age
  static String? minimumAge(DateTime? birthDate, int minimumAge) {
    if (birthDate == null) {
      return 'Birth date is required';
    }
    
    final now = DateTime.now();
    final age = now.year - birthDate.year;
    
    if (age < minimumAge) {
      return 'You must be at least $minimumAge years old';
    }
    
    return null;
  }
  
  // ===== Multiple Validators Combiner =====
  /// Combines multiple validators (runs all, returns first error)
  static String? combine(String? value, List<String? Function(String?)> validators) {
    for (final validator in validators) {
      final error = validator(value);
      if (error != null) {
        return error; // Return first error found
      }
    }
    return null; // All validators passed
  }
}