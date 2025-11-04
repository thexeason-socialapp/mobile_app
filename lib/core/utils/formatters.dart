import 'package:intl/intl.dart';

class Formatters {
  Formatters._();
  
  // ===== Number Formatting =====
  
  /// Format number with commas
  /// Example: 1234567 → "1,234,567"
  static String number(int number) {
    final formatter = NumberFormat('#,###');
    return formatter.format(number);
  }
  
  /// Format to compact number (like social media)
  /// Examples: 999 → "999", 1500 → "1.5K", 1200000 → "1.2M"
  static String compactNumber(int number) {
    if (number < 1000) {
      return number.toString();
    } else if (number < 1000000) {
      final k = number / 1000;
      return '${k.toStringAsFixed(k.truncateToDouble() == k ? 0 : 1)}K';
    } else if (number < 1000000000) {
      final m = number / 1000000;
      return '${m.toStringAsFixed(m.truncateToDouble() == m ? 0 : 1)}M';
    } else {
      final b = number / 1000000000;
      return '${b.toStringAsFixed(b.truncateToDouble() == b ? 0 : 1)}B';
    }
  }
  
  /// Format currency (Nigerian Naira)
  /// Example: 1234.56 → "₦1,234.56"
  static String currency(double amount, {String symbol = '₦'}) {
    final formatter = NumberFormat('#,###.00');
    return '$symbol${formatter.format(amount)}';
  }
  
  /// Format currency compact
  /// Example: 1500 → "₦1.5K"
  static String currencyCompact(double amount, {String symbol = '₦'}) {
    return '$symbol${compactNumber(amount.toInt())}';
  }
  
  /// Format percentage
  /// Example: 0.1234 → "12.34%"
  static String percentage(double value, {int decimals = 2}) {
    return '${(value * 100).toStringAsFixed(decimals)}%';
  }
  
  // ===== File Size Formatting =====
  
  /// Format bytes to human-readable size
  /// Examples: 1024 → "1 KB", 1048576 → "1 MB"
  static String fileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      final kb = bytes / 1024;
      return '${kb.toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      final mb = bytes / (1024 * 1024);
      return '${mb.toStringAsFixed(1)} MB';
    } else {
      final gb = bytes / (1024 * 1024 * 1024);
      return '${gb.toStringAsFixed(1)} GB';
    }
  }
  
  // ===== Duration Formatting =====
  
  /// Format duration to readable string
  /// Example: Duration(seconds: 125) → "2:05"
  static String duration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes}:${seconds.toString().padLeft(2, '0')}';
  }
  
  /// Format duration to hours, minutes, seconds
  /// Example: Duration(seconds: 3665) → "1h 1m 5s"
  static String durationFull(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }
  
  // ===== Phone Number Formatting =====
  
  /// Format phone number with spaces
  /// Example: "+1234567890" → "+1 234 567 890"
  static String phone(String phone) {
    // Remove existing spaces/hyphens
    final cleaned = phone.replaceAll(RegExp(r'[\s-]'), '');
    
    if (cleaned.startsWith('+')) {
      // International format
      if (cleaned.length <= 4) return cleaned;
      final countryCode = cleaned.substring(0, cleaned.length - 10);
      final rest = cleaned.substring(cleaned.length - 10);
      return '$countryCode ${rest.substring(0, 3)} ${rest.substring(3, 6)} ${rest.substring(6)}';
    } else {
      // Local format
      if (cleaned.length != 10) return cleaned;
      return '${cleaned.substring(0, 3)} ${cleaned.substring(3, 6)} ${cleaned.substring(6)}';
    }
  }
  
  // ===== Text Truncation =====
  
  /// Truncate text to max length with ellipsis
  /// Example: truncate("Hello World", 8) → "Hello..."
  static String truncate(String text, int maxLength, {String ellipsis = '...'}) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength - ellipsis.length)}$ellipsis';
  }
  
  /// Truncate to word boundary (don't cut words)
  /// Example: truncateWords("Hello World", 8) → "Hello..."
  static String truncateWords(String text, int maxLength, {String ellipsis = '...'}) {
    if (text.length <= maxLength) return text;
    
    final truncated = text.substring(0, maxLength);
    final lastSpace = truncated.lastIndexOf(' ');
    
    if (lastSpace == -1) {
      return '${truncated}$ellipsis';
    }
    
    return '${truncated.substring(0, lastSpace)}$ellipsis';
  }
  
  // ===== Username/Handle Formatting =====
  
  /// Add @ prefix to username if not present
  /// Example: "john_doe" → "@john_doe"
  static String username(String username) {
    return username.startsWith('@') ? username : '@$username';
  }
  
  /// Remove @ prefix from username
  /// Example: "@john_doe" → "john_doe"
  static String usernameWithoutAt(String username) {
    return username.startsWith('@') ? username.substring(1) : username;
  }
  
  // ===== Capitalize Text =====
  
  /// Capitalize first letter
  /// Example: "hello world" → "Hello world"
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
  
  /// Capitalize each word
  /// Example: "hello world" → "Hello World"
  static String capitalizeWords(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((word) => capitalize(word)).join(' ');
  }
  
  // ===== List Formatting =====
  
  /// Format list of names
  /// Examples:
  /// ["John"] → "John"
  /// ["John", "Jane"] → "John and Jane"
  /// ["John", "Jane", "Bob"] → "John, Jane and Bob"
  /// ["John", "Jane", "Bob", "Alice"] → "John, Jane and 2 others"
  static String nameList(List<String> names, {int maxShow = 3}) {
    if (names.isEmpty) return '';
    if (names.length == 1) return names[0];
    if (names.length == 2) return '${names[0]} and ${names[1]}';
    
    if (names.length <= maxShow) {
      final lastIndex = names.length - 1;
      final others = names.sublist(0, lastIndex).join(', ');
      return '$others and ${names[lastIndex]}';
    } else {
      final shown = names.sublist(0, maxShow - 1).join(', ');
      final remaining = names.length - (maxShow - 1);
      return '$shown and $remaining others';
    }
  }
  
  // ===== Initials =====
  
  /// Get initials from name
  /// Example: "John Doe" → "JD"
  static String initials(String name) {
    if (name.isEmpty) return '';
    
    final words = name.trim().split(' ');
    if (words.length == 1) {
      return words[0][0].toUpperCase();
    }
    
    return '${words[0][0]}${words[words.length - 1][0]}'.toUpperCase();
  }
  
  // ===== Credit Card =====
  
  /// Format credit card number
  /// Example: "1234567890123456" → "1234 5678 9012 3456"
  static String creditCard(String cardNumber) {
    final cleaned = cardNumber.replaceAll(RegExp(r'\s'), '');
    final buffer = StringBuffer();
    
    for (var i = 0; i < cleaned.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(cleaned[i]);
    }
    
    return buffer.toString();
  }
  
  /// Mask credit card (show last 4 digits)
  /// Example: "1234567890123456" → "**** **** **** 3456"
  static String maskCreditCard(String cardNumber) {
    final cleaned = cardNumber.replaceAll(RegExp(r'\s'), '');
    if (cleaned.length < 4) return cardNumber;
    
    final last4 = cleaned.substring(cleaned.length - 4);
    return '**** **** **** $last4';
  }
  
  // ===== Ordinal Numbers =====
  
  /// Convert number to ordinal
  /// Examples: 1 → "1st", 2 → "2nd", 3 → "3rd", 4 → "4th"
  static String ordinal(int number) {
    if (number % 100 >= 11 && number % 100 <= 13) {
      return '${number}th';
    }
    
    switch (number % 10) {
      case 1:
        return '${number}st';
      case 2:
        return '${number}nd';
      case 3:
        return '${number}rd';
      default:
        return '${number}th';
    }
  }
}