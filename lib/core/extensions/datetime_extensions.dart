import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  
  // ===== Formatting =====
  
  /// Format to readable date
  /// Example: DateTime(2024, 1, 15).toFormattedDate → "Jan 15, 2024"
  String get toFormattedDate {
    return DateFormat('MMM dd, yyyy').format(this);
  }
  
  /// Format to full date
  /// Example: DateTime(2024, 1, 15).toFullDate → "January 15, 2024"
  String get toFullDate {
    return DateFormat('MMMM dd, yyyy').format(this);
  }
  
  /// Format to time only
  /// Example: DateTime(2024, 1, 15, 14, 30).toFormattedTime → "2:30 PM"
  String get toFormattedTime {
    return DateFormat('h:mm a').format(this);
  }
  
  /// Format to date and time
  /// Example: DateTime(2024, 1, 15, 14, 30).toFormattedDateTime → "Jan 15, 2024 at 2:30 PM"
  String get toFormattedDateTime {
    return DateFormat('MMM dd, yyyy \'at\' h:mm a').format(this);
  }
  
  /// Format to 24-hour time
  /// Example: DateTime(2024, 1, 15, 14, 30).to24HourTime → "14:30"
  String get to24HourTime {
    return DateFormat('HH:mm').format(this);
  }
  
  /// Format to ISO8601 string
  /// Example: DateTime(2024, 1, 15).toIso → "2024-01-15T00:00:00.000"
  String get toIso {
    return toIso8601String();
  }
  
  /// Format to custom pattern
  /// Example: DateTime(2024, 1, 15).format('dd/MM/yyyy') → "15/01/2024"
  String format(String pattern) {
    return DateFormat(pattern).format(this);
  }
  
  // ===== Relative Time (Time Ago) =====
  
  /// Get relative time string (like social media)
  /// Examples: "just now", "5m ago", "2h ago", "3d ago", "Jan 15"
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);
    
    if (difference.inSeconds < 5) {
      return 'just now';
    } else if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 365) {
      return DateFormat('MMM dd').format(this);
    } else {
      return DateFormat('MMM dd, yyyy').format(this);
    }
  }
  
  /// Get chat-style time string
  /// Examples: "2:30 PM" (today), "Yesterday", "Mon" (this week), "Jan 15" (older)
  String get chatTime {
    final now = DateTime.now();
    final difference = now.difference(this);
    
    if (isToday) {
      return DateFormat('h:mm a').format(this);
    } else if (isYesterday) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return DateFormat('E').format(this); // Mon, Tue, etc.
    } else {
      return DateFormat('MMM dd').format(this);
    }
  }
  
  // ===== Comparison Helpers =====
  
  /// Check if date is today
  /// Example: DateTime.now().isToday → true
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }
  
  /// Check if date is yesterday
  /// Example: DateTime.now().subtract(Duration(days: 1)).isYesterday → true
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year && 
           month == yesterday.month && 
           day == yesterday.day;
  }
  
  /// Check if date is tomorrow
  /// Example: DateTime.now().add(Duration(days: 1)).isTomorrow → true
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year && 
           month == tomorrow.month && 
           day == tomorrow.day;
  }
  
  /// Check if date is this week
  /// Example: DateTime.now().isThisWeek → true
  bool get isThisWeek {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 7));
    
    return isAfter(startOfWeek) && isBefore(endOfWeek);
  }
  
  /// Check if date is this month
  /// Example: DateTime.now().isThisMonth → true
  bool get isThisMonth {
    final now = DateTime.now();
    return year == now.year && month == now.month;
  }
  
  /// Check if date is this year
  /// Example: DateTime.now().isThisYear → true
  bool get isThisYear {
    final now = DateTime.now();
    return year == now.year;
  }
  
  /// Check if date is in the past
  /// Example: DateTime(2020, 1, 1).isPast → true
  bool get isPast {
    return isBefore(DateTime.now());
  }
  
  /// Check if date is in the future
  /// Example: DateTime(2030, 1, 1).isFuture → true
  bool get isFuture {
    return isAfter(DateTime.now());
  }
  
  /// Check if date is weekend (Saturday or Sunday)
  /// Example: DateTime(2024, 1, 13).isWeekend → true (if Saturday)
  bool get isWeekend {
    return weekday == DateTime.saturday || weekday == DateTime.sunday;
  }
  
  /// Check if date is weekday (Monday to Friday)
  /// Example: DateTime(2024, 1, 15).isWeekday → true (if Monday)
  bool get isWeekday {
    return !isWeekend;
  }
  
  // ===== Date Calculations =====
  
  /// Get start of day (00:00:00)
  /// Example: DateTime(2024, 1, 15, 14, 30).startOfDay → DateTime(2024, 1, 15, 0, 0, 0)
  DateTime get startOfDay {
    return DateTime(year, month, day);
  }
  
  /// Get end of day (23:59:59)
  /// Example: DateTime(2024, 1, 15, 14, 30).endOfDay → DateTime(2024, 1, 15, 23, 59, 59)
  DateTime get endOfDay {
    return DateTime(year, month, day, 23, 59, 59, 999);
  }
  
  /// Get start of week (Monday 00:00:00)
  /// Example: DateTime(2024, 1, 15).startOfWeek → Monday of that week
  DateTime get startOfWeek {
    return subtract(Duration(days: weekday - 1)).startOfDay;
  }
  
  /// Get end of week (Sunday 23:59:59)
  /// Example: DateTime(2024, 1, 15).endOfWeek → Sunday of that week
  DateTime get endOfWeek {
    return add(Duration(days: DateTime.daysPerWeek - weekday)).endOfDay;
  }
  
  /// Get start of month (1st day 00:00:00)
  /// Example: DateTime(2024, 1, 15).startOfMonth → DateTime(2024, 1, 1, 0, 0, 0)
  DateTime get startOfMonth {
    return DateTime(year, month, 1);
  }
  
  /// Get end of month (last day 23:59:59)
  /// Example: DateTime(2024, 1, 15).endOfMonth → DateTime(2024, 1, 31, 23, 59, 59)
  DateTime get endOfMonth {
    return DateTime(year, month + 1, 0, 23, 59, 59, 999);
  }
  
  /// Get start of year (Jan 1st 00:00:00)
  /// Example: DateTime(2024, 6, 15).startOfYear → DateTime(2024, 1, 1, 0, 0, 0)
  DateTime get startOfYear {
    return DateTime(year, 1, 1);
  }
  
  /// Get end of year (Dec 31st 23:59:59)
  /// Example: DateTime(2024, 6, 15).endOfYear → DateTime(2024, 12, 31, 23, 59, 59)
  DateTime get endOfYear {
    return DateTime(year, 12, 31, 23, 59, 59, 999);
  }
  
  /// Add days
  /// Example: DateTime(2024, 1, 15).addDays(5) → DateTime(2024, 1, 20)
  DateTime addDays(int days) {
    return add(Duration(days: days));
  }
  
  /// Subtract days
  /// Example: DateTime(2024, 1, 15).subtractDays(5) → DateTime(2024, 1, 10)
  DateTime subtractDays(int days) {
    return subtract(Duration(days: days));
  }
  
  /// Add months
  /// Example: DateTime(2024, 1, 15).addMonths(2) → DateTime(2024, 3, 15)
  DateTime addMonths(int months) {
    return DateTime(year, month + months, day, hour, minute, second, millisecond, microsecond);
  }
  
  /// Subtract months
  /// Example: DateTime(2024, 3, 15).subtractMonths(2) → DateTime(2024, 1, 15)
  DateTime subtractMonths(int months) {
    return DateTime(year, month - months, day, hour, minute, second, millisecond, microsecond);
  }
  
  /// Add years
  /// Example: DateTime(2024, 1, 15).addYears(5) → DateTime(2029, 1, 15)
  DateTime addYears(int years) {
    return DateTime(year + years, month, day, hour, minute, second, millisecond, microsecond);
  }
  
  /// Subtract years
  /// Example: DateTime(2024, 1, 15).subtractYears(5) → DateTime(2019, 1, 15)
  DateTime subtractYears(int years) {
    return DateTime(year - years, month, day, hour, minute, second, millisecond, microsecond);
  }
  
  // ===== Age Calculation =====
  
  /// Calculate age from birth date
  /// Example: DateTime(1990, 5, 15).age → 33 (if current year is 2024)
  int get age {
    final now = DateTime.now();
    int age = now.year - year;
    
    if (now.month < month || (now.month == month && now.day < day)) {
      age--;
    }
    
    return age;
  }
  
  /// Check if person is adult (18+)
  /// Example: DateTime(2000, 1, 1).isAdult → true
  bool get isAdult {
    return age >= 18;
  }
  
  // ===== Days in Month =====
  
  /// Get number of days in current month
  /// Example: DateTime(2024, 2, 15).daysInMonth → 29 (leap year)
  int get daysInMonth {
    return DateTime(year, month + 1, 0).day;
  }
  
  /// Check if year is leap year
  /// Example: DateTime(2024, 1, 1).isLeapYear → true
  bool get isLeapYear {
    return (year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0));
  }
  
  // ===== Day Names =====
  
  /// Get day name (Monday, Tuesday, etc.)
  /// Example: DateTime(2024, 1, 15).dayName → "Monday"
  String get dayName {
    return DateFormat('EEEE').format(this);
  }
  
  /// Get short day name (Mon, Tue, etc.)
  /// Example: DateTime(2024, 1, 15).shortDayName → "Mon"
  String get shortDayName {
    return DateFormat('E').format(this);
  }
  
  /// Get month name (January, February, etc.)
  /// Example: DateTime(2024, 1, 15).monthName → "January"
  String get monthName {
    return DateFormat('MMMM').format(this);
  }
  
  /// Get short month name (Jan, Feb, etc.)
  /// Example: DateTime(2024, 1, 15).shortMonthName → "Jan"
  String get shortMonthName {
    return DateFormat('MMM').format(this);
  }
  
  // ===== Difference Calculations =====
  
  /// Get difference in days from now
  /// Example: DateTime.now().addDays(5).differenceInDays → 5
  int get differenceInDays {
    return difference(DateTime.now()).inDays.abs();
  }
  
  /// Get difference in hours from now
  /// Example: DateTime.now().add(Duration(hours: 3)).differenceInHours → 3
  int get differenceInHours {
    return difference(DateTime.now()).inHours.abs();
  }
  
  /// Get difference in minutes from now
  /// Example: DateTime.now().add(Duration(minutes: 30)).differenceInMinutes → 30
  int get differenceInMinutes {
    return difference(DateTime.now()).inMinutes.abs();
  }
  
  // ===== Copy With =====
  
  /// Create new DateTime with modified fields
  /// Example: DateTime(2024, 1, 15).copyWith(day: 20) → DateTime(2024, 1, 20)
  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) {
    return DateTime(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? this.hour,
      minute ?? this.minute,
      second ?? this.second,
      millisecond ?? this.millisecond,
      microsecond ?? this.microsecond,
    );
  }
  
  // ===== Between Dates =====
  
  /// Check if date is between two dates
  /// Example: DateTime(2024, 1, 15).isBetween(start, end) → true/false
  bool isBetween(DateTime start, DateTime end) {
    return isAfter(start) && isBefore(end);
  }
  
  /// Check if date is same day as another date
  /// Example: DateTime(2024, 1, 15).isSameDay(other) → true/false
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
  
  // ===== Timestamp =====
  
  /// Get Unix timestamp in seconds
  /// Example: DateTime(2024, 1, 15).toTimestamp → 1705276800
  int get toTimestamp {
    return millisecondsSinceEpoch ~/ 1000;
  }
  
  /// Create DateTime from Unix timestamp
  /// Example: DateTimeExtensions.fromTimestamp(1705276800) → DateTime(2024, 1, 15)
  static DateTime fromTimestamp(int timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  }
}