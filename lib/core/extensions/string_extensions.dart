import '../constants/regex_constants.dart';

extension StringExtensions on String {
  
  // ===== Validation =====
  
  /// Check if string is a valid email
  /// Example: "john@example.com".isValidEmail → true
  bool get isValidEmail {
    return RegExp(RegexConstants.email).hasMatch(trim());
  }
  
  /// Check if string is a valid username
  /// Example: "john_doe".isValidUsername → true
  bool get isValidUsername {
    return RegExp(RegexConstants.username).hasMatch(trim());
  }
  
  /// Check if string is a valid phone number
  /// Example: "+1234567890".isValidPhone → true
  bool get isValidPhone {
    final cleaned = replaceAll(RegExp(r'[\s-]'), '');
    return RegExp(RegexConstants.phone).hasMatch(cleaned);
  }
  
  /// Check if string is a valid URL
  /// Example: "https://example.com".isValidUrl → true
  bool get isValidUrl {
    return RegExp(RegexConstants.url).hasMatch(trim());
  }
  
  /// Check if string contains only letters
  /// Example: "Hello".isAlpha → true, "Hello123".isAlpha → false
  bool get isAlpha {
    return RegExp(RegexConstants.lettersOnly).hasMatch(this);
  }
  
  /// Check if string contains only numbers
  /// Example: "12345".isNumeric → true, "123abc".isNumeric → false
  bool get isNumeric {
    return RegExp(RegexConstants.numbersOnly).hasMatch(this);
  }
  
  /// Check if string is alphanumeric
  /// Example: "Hello123".isAlphanumeric → true
  bool get isAlphanumeric {
    return RegExp(RegexConstants.alphanumeric).hasMatch(this);
  }
  
  // ===== Case Transformations =====
  
  /// Capitalize first letter
  /// Example: "hello world".capitalize → "Hello world"
  String get capitalize {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
  
  /// Capitalize each word
  /// Example: "hello world".capitalizeWords → "Hello World"
  String get capitalizeWords {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize).join(' ');
  }
  
  /// Convert to camelCase
  /// Example: "hello world".toCamelCase → "helloWorld"
  String get toCamelCase {
    if (isEmpty) return this;
    final words = trim().split(RegExp(r'[\s_-]+'));
    if (words.isEmpty) return this;
    
    return words.first.toLowerCase() +
        words.skip(1).map((w) => w.capitalize).join();
  }
  
  /// Convert to snake_case
  /// Example: "helloWorld".toSnakeCase → "hello_world"
  String get toSnakeCase {
    return replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => '_${match.group(0)!.toLowerCase()}',
    ).replaceFirst(RegExp(r'^_'), '');
  }
  
  /// Convert to kebab-case
  /// Example: "helloWorld".toKebabCase → "hello-world"
  String get toKebabCase {
    return replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => '-${match.group(0)!.toLowerCase()}',
    ).replaceFirst(RegExp(r'^-'), '');
  }
  
  // ===== Truncation =====
  
  /// Truncate string to max length with ellipsis
  /// Example: "Hello World".truncate(8) → "Hello..."
  String truncate(int maxLength, {String ellipsis = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - ellipsis.length)}$ellipsis';
  }
  
  /// Truncate at word boundary (don't cut words)
  /// Example: "Hello World".truncateWords(8) → "Hello..."
  String truncateWords(int maxLength, {String ellipsis = '...'}) {
    if (length <= maxLength) return this;
    
    final truncated = substring(0, maxLength);
    final lastSpace = truncated.lastIndexOf(' ');
    
    if (lastSpace == -1) {
      return '$truncated$ellipsis';
    }
    
    return '${truncated.substring(0, lastSpace)}$ellipsis';
  }
  
  // ===== Parsing =====
  
  /// Parse to int safely (returns null if invalid)
  /// Example: "123".toIntOrNull → 123, "abc".toIntOrNull → null
  int? get toIntOrNull {
    return int.tryParse(this);
  }
  
  /// Parse to double safely (returns null if invalid)
  /// Example: "12.34".toDoubleOrNull → 12.34, "abc".toDoubleOrNull → null
  double? get toDoubleOrNull {
    return double.tryParse(this);
  }
  
  /// Parse to DateTime safely (returns null if invalid)
  /// Example: "2024-01-15".toDateTimeOrNull → DateTime object
  DateTime? get toDateTimeOrNull {
    return DateTime.tryParse(this);
  }
  
  // ===== Checks =====
  
  /// Check if string is null or empty
  /// Example: "".isNullOrEmpty → true, "hello".isNullOrEmpty → false
  bool get isNullOrEmpty {
    return trim().isEmpty;
  }
  
  /// Check if string is not null and not empty
  /// Example: "hello".isNotNullOrEmpty → true, "".isNotNullOrEmpty → false
  bool get isNotNullOrEmpty {
    return trim().isNotEmpty;
  }
  
  /// Check if string contains only whitespace
  /// Example: "   ".isBlank → true, "hello".isBlank → false
  bool get isBlank {
    return trim().isEmpty;
  }
  
  /// Check if string is not blank
  /// Example: "hello".isNotBlank → true, "   ".isNotBlank → false
  bool get isNotBlank {
    return trim().isNotEmpty;
  }
  
  // ===== Extraction =====
  
  /// Extract all hashtags from string
  /// Example: "Hello #world #flutter".extractHashtags → ["#world", "#flutter"]
  List<String> get extractHashtags {
    final regex = RegExp(RegexConstants.hashtag);
    final matches = regex.allMatches(this);
    return matches.map((m) => m.group(0)!).toList();
  }
  
  /// Extract all mentions from string
  /// Example: "Hello @john @jane".extractMentions → ["john", "jane"]
  List<String> get extractMentions {
    final regex = RegExp(RegexConstants.mention);
    final matches = regex.allMatches(this);
    return matches.map((m) => m.group(0)!.substring(1)).toList(); // Remove @
  }
  
  /// Extract all URLs from string
  /// Example: "Visit https://example.com".extractUrls → ["https://example.com"]
  List<String> get extractUrls {
    final regex = RegExp(RegexConstants.url);
    final matches = regex.allMatches(this);
    return matches.map((m) => m.group(0)!).toList();
  }
  
  // ===== Manipulation =====
  
  /// Remove all whitespace
  /// Example: "hello world".removeWhitespace → "helloworld"
  String get removeWhitespace {
    return replaceAll(RegExp(r'\s+'), '');
  }
  
  /// Remove special characters (keep only alphanumeric and spaces)
  /// Example: "hello@world!".removeSpecialChars → "helloworld"
  String get removeSpecialChars {
    return replaceAll(RegExp(r'[^a-zA-Z0-9\s]'), '');
  }
  
  /// Reverse string
  /// Example: "hello".reverse → "olleh"
  String get reverse {
    return split('').reversed.join('');
  }
  
  /// Remove duplicate consecutive characters
  /// Example: "hellooo".removeDuplicates → "helo"
  String get removeDuplicates {
    if (isEmpty) return this;
    
    final buffer = StringBuffer();
    String? previous;
    
    for (final char in split('')) {
      if (char != previous) {
        buffer.write(char);
        previous = char;
      }
    }
    
    return buffer.toString();
  }
  
  // ===== Username/Handle =====
  
  /// Add @ prefix if not present
  /// Example: "john_doe".withAtSymbol → "@john_doe"
  String get withAtSymbol {
    return startsWith('@') ? this : '@$this';
  }
  
  /// Remove @ prefix if present
  /// Example: "@john_doe".withoutAtSymbol → "john_doe"
  String get withoutAtSymbol {
    return startsWith('@') ? substring(1) : this;
  }
  
  // ===== Hashing =====
  
  /// Get hash code as string
  /// Example: "hello".hashString → "99162322"
  String get hashString {
    return hashCode.toString();
  }
  
  // ===== Counting =====
  
  /// Count words in string
  /// Example: "hello world".wordCount → 2
  int get wordCount {
    if (trim().isEmpty) return 0;
    return trim().split(RegExp(r'\s+')).length;
  }
  
  /// Count occurrences of substring
  /// Example: "hello hello".countOccurrences("hello") → 2
  int countOccurrences(String substring) {
    if (isEmpty || substring.isEmpty) return 0;
    
    int count = 0;
    int index = 0;
    
    while ((index = indexOf(substring, index)) != -1) {
      count++;
      index += substring.length;
    }
    
    return count;
  }
  
  // ===== Comparison =====
  
  /// Case-insensitive equals
  /// Example: "Hello".equalsIgnoreCase("hello") → true
  bool equalsIgnoreCase(String other) {
    return toLowerCase() == other.toLowerCase();
  }
  
  /// Check if string contains substring (case-insensitive)
  /// Example: "Hello World".containsIgnoreCase("hello") → true
  bool containsIgnoreCase(String substring) {
    return toLowerCase().contains(substring.toLowerCase());
  }
  
  // ===== File Operations =====
  
  /// Get file extension
  /// Example: "document.pdf".fileExtension → "pdf"
  String get fileExtension {
    final lastDot = lastIndexOf('.');
    if (lastDot == -1 || lastDot == length - 1) return '';
    return substring(lastDot + 1);
  }
  
  /// Get filename without extension
  /// Example: "document.pdf".fileNameWithoutExtension → "document"
  String get fileNameWithoutExtension {
    final lastDot = lastIndexOf('.');
    if (lastDot == -1) return this;
    return substring(0, lastDot);
  }
  
  // ===== Masking =====
  
  /// Mask email (show first 3 chars and domain)
  /// Example: "john.doe@example.com".maskEmail → "joh***@example.com"
  String get maskEmail {
    if (!isValidEmail) return this;
    
    final parts = split('@');
    final username = parts[0];
    final domain = parts[1];
    
    if (username.length <= 3) {
      return '***@$domain';
    }
    
    return '${username.substring(0, 3)}***@$domain';
  }
  
  /// Mask phone (show last 4 digits)
  /// Example: "+1234567890".maskPhone → "****7890"
  String get maskPhone {
    if (length < 4) return this;
    return '*' * (length - 4) + substring(length - 4);
  }
  
  // ===== Initials =====
  
  /// Get initials from name
  /// Example: "John Doe".initials → "JD"
  String get initials {
    if (isEmpty) return '';
    
    final words = trim().split(' ');
    if (words.length == 1) {
      return words[0][0].toUpperCase();
    }
    
    return '${words[0][0]}${words[words.length - 1][0]}'.toUpperCase();
  }
  
  // ===== Default Value =====
  
  /// Return default value if string is empty
  /// Example: "".orDefault("N/A") → "N/A", "hello".orDefault("N/A") → "hello"
  String orDefault(String defaultValue) {
    return isEmpty ? defaultValue : this;
  }
  
  // ===== Pretty Print =====
  
  /// Convert to readable format (add spaces before capitals)
  /// Example: "HelloWorld".toReadable → "Hello World"
  String get toReadable {
    return replaceAllMapped(
      RegExp(r'([A-Z])'),
      (match) => ' ${match.group(0)}',
    ).trim();
  }
}