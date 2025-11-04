class RegexConstants {
  RegexConstants._();
  
  // ===== Email Validation =====
  // Validates proper email format
  static const String email = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  
  // Examples that PASS:
  // ✅ john@example.com
  // ✅ jane.doe@company.co.uk
  // ✅ user_123@mail.org
  
  // Examples that FAIL:
  // ❌ plaintext
  // ❌ @example.com
  // ❌ user@.com
  
  // ===== Username Validation =====
  // Alphanumeric + underscore, 3-30 characters
  static const String username = r'^[a-zA-Z0-9_]{3,30}$';
  
  // Examples that PASS:
  // ✅ john_doe
  // ✅ user123
  // ✅ JohnDoe2024
  
  // Examples that FAIL:
  // ❌ ab (too short)
  // ❌ john-doe (hyphen not allowed)
  // ❌ user@123 (@ not allowed)
  
  // ===== Password Validation =====
  // At least 8 characters, 1 uppercase, 1 lowercase, 1 number, 1 special char
  static const String password = 
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';
  
  // Examples that PASS:
  // ✅ Password123!
  // ✅ MyP@ss2024
  // ✅ Secure$123
  
  // Examples that FAIL:
  // ❌ password (no uppercase, no number, no special char)
  // ❌ PASSWORD123 (no lowercase, no special char)
  // ❌ Pass123 (too short, no special char)
  
  // ===== Phone Number Validation =====
  // International format: +[country code][number] (10-15 digits total)
  static const String phone = r'^\+?[1-9]\d{9,14}$';
  
  // Examples that PASS:
  // ✅ +1234567890
  // ✅ +442071234567
  // ✅ 9876543210
  
  // Examples that FAIL:
  // ❌ 123 (too short)
  // ❌ +0123456789 (can't start with 0 after +)
  // ❌ 12-345-6789 (hyphens not allowed)
  
  // ===== URL Validation =====
  // Validates http/https URLs
  static const String url = 
      r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$';
  
  // Examples that PASS:
  // ✅ https://example.com
  // ✅ http://sub.domain.com/path
  // ✅ www.example.com
  
  // Examples that FAIL:
  // ❌ example (no domain extension)
  // ❌ htp://wrong.com (invalid protocol)
  
  // ===== Hashtag Validation =====
  // # followed by alphanumeric characters (no spaces)
  static const String hashtag = r'#[a-zA-Z0-9_]+';
  
  // Examples that PASS:
  // ✅ #trending
  // ✅ #Tech2024
  // ✅ #flutter_dev
  
  // Examples that FAIL:
  // ❌ # (no text after #)
  // ❌ #hello world (space not allowed)
  // ❌ ##double (double # not matched)
  
  // ===== Mention Validation =====
  // @ followed by username (alphanumeric + underscore, 3-30 chars)
  static const String mention = r'@[a-zA-Z0-9_]{3,30}';
  
  // Examples that PASS:
  // ✅ @john_doe
  // ✅ @user123
  // ✅ @JaneDoe
  
  // Examples that FAIL:
  // ❌ @ (no username)
  // ❌ @ab (too short)
  // ❌ @user-name (hyphen not allowed)
  
  // ===== Alphanumeric Only =====
  // Only letters and numbers (no special chars)
  static const String alphanumeric = r'^[a-zA-Z0-9]+$';
  
  // Examples that PASS:
  // ✅ abc123
  // ✅ User2024
  
  // Examples that FAIL:
  // ❌ user_name (underscore not allowed)
  // ❌ hello! (exclamation not allowed)
  
  // ===== Letters Only =====
  // Only alphabetic characters (no numbers or special chars)
  static const String lettersOnly = r'^[a-zA-Z]+$';
  
  // Examples that PASS:
  // ✅ John
  // ✅ JaneDoe
  
  // Examples that FAIL:
  // ❌ John123 (numbers not allowed)
  // ❌ Jane-Doe (hyphen not allowed)
  
  // ===== Numbers Only =====
  // Only numeric digits
  static const String numbersOnly = r'^[0-9]+$';
  
  // Examples that PASS:
  // ✅ 12345
  // ✅ 0987
  
  // Examples that FAIL:
  // ❌ 123abc (letters not allowed)
  // ❌ 12.34 (decimal not allowed)
  
  // ===== Decimal Number =====
  // Validates decimal numbers (e.g., price, rating)
  static const String decimal = r'^\d+\.?\d*$';
  
  // Examples that PASS:
  // ✅ 123
  // ✅ 123.45
  // ✅ 0.99
  
  // Examples that FAIL:
  // ❌ .99 (must start with digit)
  // ❌ 12.34.56 (multiple decimals)
  
  // ===== Credit Card Number =====
  // 13-19 digits (optional spaces/hyphens every 4 digits)
  static const String creditCard = r'^[0-9]{13,19}$';
  
  // Examples that PASS:
  // ✅ 4111111111111111
  // ✅ 5500000000000004
  
  // Examples that FAIL:
  // ❌ 1234 (too short)
  // ❌ 1234-5678-9012-3456 (hyphens - use remove first)
  
  // ===== Date Format (YYYY-MM-DD) =====
  static const String dateYYYYMMDD = r'^\d{4}-\d{2}-\d{2}$';
  
  // Examples that PASS:
  // ✅ 2024-01-15
  // ✅ 2023-12-31
  
  // Examples that FAIL:
  // ❌ 24-01-15 (wrong year format)
  // ❌ 2024/01/15 (slashes instead of hyphens)
  
  // ===== Time Format (HH:MM) =====
  static const String timeHHMM = r'^([01]?[0-9]|2[0-3]):[0-5][0-9]$';
  
  // Examples that PASS:
  // ✅ 09:30
  // ✅ 23:59
  // ✅ 00:00
  
  // Examples that FAIL:
  // ❌ 25:00 (invalid hour)
  // ❌ 12:60 (invalid minute)
}