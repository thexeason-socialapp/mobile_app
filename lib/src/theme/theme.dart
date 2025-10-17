import 'package:flutter/material.dart';

// ===============================
// 🎨 THEME CONFIGURATION
// ===============================

class AppColors {
  // Brand Colors
  static const Color primary = Color(0xFFFFC107); // Vibrant Yellow
  static const Color secondary = Color(0xFF111827); // Deep Navy (contrast)
  static const Color accent = Color(0xFF00BFA6); // Teal Green highlight

  // Backgrounds
  static const Color lightBackground = Color(0xFFF9FAFB);
  static const Color darkBackground = Color(0xFF0D1117);

  // Text
  static const Color lightTextPrimary = Color(0xFF1F2937);
  static const Color lightTextSecondary = Color(0xFF6B7280);
  static const Color darkTextPrimary = Color(0xFFF9FAFB);
  static const Color darkTextSecondary = Color(0xFF9CA3AF);

  // Surfaces
  static const Color cardLight = Colors.white;
  static const Color cardDark = Color(0xFF1E293B);

  // Other
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);
}

// ===============================
// 🧩 THEME EXTENSIONS (Optional)
// ===============================
@immutable
class AppShadows extends ThemeExtension<AppShadows> {
  final List<BoxShadow> cardShadow;
  final List<BoxShadow> softShadow;

  const AppShadows({
    required this.cardShadow,
    required this.softShadow,
  });

  @override
  AppShadows copyWith({
    List<BoxShadow>? cardShadow,
    List<BoxShadow>? softShadow,
  }) {
    return AppShadows(
      cardShadow: cardShadow ?? this.cardShadow,
      softShadow: softShadow ?? this.softShadow,
    );
  }

  @override
  AppShadows lerp(ThemeExtension<AppShadows>? other, double t) {
    if (other is! AppShadows) return this;
    return AppShadows(
      cardShadow: BoxShadow.lerpList(cardShadow, other.cardShadow, t) ?? cardShadow,
      softShadow: BoxShadow.lerpList(softShadow, other.softShadow, t) ?? softShadow,
    );
  }

  static const AppShadows light = AppShadows(
    cardShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 10,
        offset: Offset(0, 3),
      ),
    ],
    softShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 5,
        offset: Offset(0, 1),
      ),
    ],
  );

  static const AppShadows dark = AppShadows(
    cardShadow: [
      BoxShadow(
        color: Colors.black54,
        blurRadius: 8,
        offset: Offset(0, 2),
      ),
    ],
    softShadow: [
      BoxShadow(
        color: Colors.black45,
        blurRadius: 3,
        offset: Offset(0, 1),
      ),
    ],
  );
}

// ===============================
// 🧠 TYPOGRAPHY
// ===============================
TextTheme _textTheme(Color textColor) => TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: textColor),
      headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: textColor),
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: textColor),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: textColor),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: textColor),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textColor),
    );

// ===============================
// 🌞 LIGHT THEME
// ===============================
ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  primaryColor: AppColors.primary,
  scaffoldBackgroundColor: AppColors.lightBackground,
  cardColor: AppColors.cardLight,
  textTheme: _textTheme(AppColors.lightTextPrimary),
  colorScheme: const ColorScheme.light(
    primary: AppColors.primary,
    secondary: AppColors.accent,
    background: AppColors.lightBackground,
    surface: AppColors.cardLight,
    error: AppColors.error,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0,
    iconTheme: IconThemeData(color: AppColors.lightTextPrimary),
    titleTextStyle: TextStyle(
      color: AppColors.lightTextPrimary,
      fontWeight: FontWeight.bold,
      fontSize: 18,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      minimumSize: Size(double.infinity, 60),
    
      fixedSize: Size(double.infinity, 60),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    ),
  ),
  extensions: const [AppShadows.light],
);

// ===============================
// 🌚 DARK THEME
// ===============================
ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  primaryColor: AppColors.primary,
  scaffoldBackgroundColor: AppColors.darkBackground,
  cardColor: AppColors.cardDark,
  textTheme: _textTheme(AppColors.darkTextPrimary),
  colorScheme: const ColorScheme.dark(
    primary: AppColors.primary,
    secondary: AppColors.accent,
    background: AppColors.darkBackground,
    surface: AppColors.cardDark,
    error: AppColors.error,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.darkBackground,
    elevation: 0,
    iconTheme: IconThemeData(color: AppColors.darkTextPrimary),
    titleTextStyle: TextStyle(
      color: AppColors.darkTextPrimary,
      fontWeight: FontWeight.bold,
      fontSize: 18,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      fixedSize: Size(double.infinity, 60),
      minimumSize: Size(double.infinity, 60),
    ),
  ),
  extensions: const [AppShadows.dark],
);
