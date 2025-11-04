import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_spacing.dart';
import 'app_shadows.dart';

class AppTheme {
  AppTheme._();
  
  // ============================================
  // LIGHT THEME
  // ============================================
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.backgroundLight,
    
    // ===== Color Scheme =====
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      tertiary: AppColors.accent,
      surface: AppColors.surfaceLight,
      error: AppColors.error,
      onPrimary: AppColors.secondary,
      onSecondary: AppColors.surfaceLight,
      onSurface: AppColors.textPrimaryLight,
      onError: AppColors.surfaceLight,
      outline: AppColors.borderLight,
      shadow: Colors.black12,
    ),
    
    // ===== App Bar Theme =====
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.surfaceLight,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 1,
      centerTitle: false,
      iconTheme: const IconThemeData(
        color: AppColors.textPrimaryLight,
        size: 24,
      ),
      actionsIconTheme: const IconThemeData(
        color: AppColors.textPrimaryLight,
        size: 24,
      ),
      titleTextStyle: AppTypography.title(
        color: AppColors.textPrimaryLight,
        weight: FontWeight.w700,
      ),
      toolbarHeight: 56,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    ),
    
    // ===== Bottom Navigation Bar Theme =====
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.surfaceLight,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textSecondaryLight,
      selectedLabelStyle: AppTypography.caption(
        weight: FontWeight.w600,
      ),
      unselectedLabelStyle: AppTypography.caption(),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      showSelectedLabels: true,
      showUnselectedLabels: true,
    ),
    
    // ===== Navigation Bar Theme (Material 3) =====
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.surfaceLight,
      indicatorColor: AppColors.primary.withOpacity(0.2),
      iconTheme: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return const IconThemeData(
            color: AppColors.primary,
            size: 24,
          );
        }
        return const IconThemeData(
          color: AppColors.textSecondaryLight,
          size: 24,
        );
      }),
      labelTextStyle: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppTypography.caption(
            color: AppColors.primary,
            weight: FontWeight.w600,
          );
        }
        return AppTypography.caption(
          color: AppColors.textSecondaryLight,
        );
      }),
      height: 80,
      elevation: 3,
    ),
    
    // ===== Card Theme =====
    cardTheme: CardTheme(
      color: AppColors.surfaceLight,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(
          color: AppColors.borderLight,
          width: 1,
        ),
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      clipBehavior: Clip.antiAlias,
    ),
    
    // ===== Input Decoration Theme =====
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceLight,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      
      // Default Border
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.borderLight,
          width: 1.5,
        ),
      ),
      
      // Enabled Border
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.borderLight,
          width: 1.5,
        ),
      ),
      
      // Focused Border
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.primary,
          width: 2,
        ),
      ),
      
      // Error Border
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.error,
          width: 1.5,
        ),
      ),
      
      // Focused Error Border
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.error,
          width: 2,
        ),
      ),
      
      // Disabled Border
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: AppColors.borderLight.withOpacity(0.5),
          width: 1.5,
        ),
      ),
      
      // Text Styles
      labelStyle: AppTypography.body(
        color: AppColors.textSecondaryLight,
      ),
      floatingLabelStyle: AppTypography.body(
        color: AppColors.primary,
        weight: FontWeight.w600,
      ),
      hintStyle: AppTypography.body(
        color: AppColors.textSecondaryLight,
      ),
      errorStyle: AppTypography.caption(
        color: AppColors.error,
      ),
      helperStyle: AppTypography.caption(
        color: AppColors.textSecondaryLight,
      ),
      
      // Icon Theme
      prefixIconColor: AppColors.textSecondaryLight,
      suffixIconColor: AppColors.textSecondaryLight,
    ),
    
    // ===== Elevated Button Theme =====
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.secondary,
        disabledBackgroundColor: AppColors.borderLight,
        disabledForegroundColor: AppColors.textSecondaryLight,
        elevation: 0,
        shadowColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        minimumSize: const Size(0, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: AppTypography.bodyLarge(
          weight: FontWeight.w600,
        ),
      ),
    ),
    
    // ===== Text Button Theme =====
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        disabledForegroundColor: AppColors.textSecondaryLight,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        minimumSize: const Size(0, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: AppTypography.body(
          weight: FontWeight.w600,
        ),
      ),
    ),
    
    // ===== Outlined Button Theme =====
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        disabledForegroundColor: AppColors.textSecondaryLight,
        side: const BorderSide(
          color: AppColors.primary,
          width: 1.5,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        minimumSize: const Size(0, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: AppTypography.bodyLarge(
          weight: FontWeight.w600,
        ),
      ),
    ),
    
    // ===== Icon Button Theme =====
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: AppColors.textPrimaryLight,
        disabledForegroundColor: AppColors.textSecondaryLight,
        highlightColor: AppColors.primary.withOpacity(0.1),
        padding: const EdgeInsets.all(AppSpacing.sm),
        minimumSize: const Size(40, 40),
        iconSize: 24,
      ),
    ),
    
    // ===== Floating Action Button Theme =====
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.secondary,
      elevation: 4,
      highlightElevation: 8,
      shape: CircleBorder(),
      iconSize: 24,
    ),
    
    // ===== Chip Theme =====
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surfaceLight,
      deleteIconColor: AppColors.textSecondaryLight,
      disabledColor: AppColors.borderLight,
      selectedColor: AppColors.primary.withOpacity(0.2),
      secondarySelectedColor: AppColors.accent.withOpacity(0.2),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      labelStyle: AppTypography.body(
        color: AppColors.textPrimaryLight,
      ),
      secondaryLabelStyle: AppTypography.body(
        color: AppColors.textPrimaryLight,
      ),
      brightness: Brightness.light,
      elevation: 0,
      pressElevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(
          color: AppColors.borderLight,
          width: 1,
        ),
      ),
    ),
    
    // ===== Dialog Theme =====
    dialogTheme: DialogTheme(
      backgroundColor: AppColors.surfaceLight,
      surfaceTintColor: Colors.transparent,
      elevation: 8,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      titleTextStyle: AppTypography.headline(
        color: AppColors.textPrimaryLight,
      ),
      contentTextStyle: AppTypography.body(
        color: AppColors.textPrimaryLight,
      ),
    ),
    
    // ===== Bottom Sheet Theme =====
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.surfaceLight,
      surfaceTintColor: Colors.transparent,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      showDragHandle: true,
      dragHandleColor: AppColors.borderLight,
      modalBackgroundColor: AppColors.surfaceLight,
      modalElevation: 8,
    ),
    
    // ===== Snack Bar Theme =====
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.secondary,
      contentTextStyle: AppTypography.body(
        color: AppColors.surfaceLight,
      ),
      actionTextColor: AppColors.primary,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
    ),
    
    // ===== Progress Indicator Theme =====
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primary,
      linearTrackColor: AppColors.borderLight,
      circularTrackColor: AppColors.borderLight,
    ),
    
    // ===== Switch Theme =====
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.primary;
        }
        return AppColors.borderLight;
      }),
      trackColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.primary.withOpacity(0.5);
        }
        return AppColors.borderLight.withOpacity(0.5);
      }),
    ),
    
    // ===== Checkbox Theme =====
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.primary;
        }
        return Colors.transparent;
      }),
      checkColor: MaterialStateProperty.all(AppColors.secondary),
      side: const BorderSide(
        color: AppColors.borderLight,
        width: 2,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    ),
    
    // ===== Radio Theme =====
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.primary;
        }
        return AppColors.borderLight;
      }),
    ),
    
    // ===== Slider Theme =====
    sliderTheme: SliderThemeData(
      activeTrackColor: AppColors.primary,
      inactiveTrackColor: AppColors.borderLight,
      thumbColor: AppColors.primary,
      overlayColor: AppColors.primary.withOpacity(0.2),
      valueIndicatorColor: AppColors.primary,
      valueIndicatorTextStyle: AppTypography.caption(
        color: AppColors.secondary,
      ),
    ),
    
    // ===== List Tile Theme =====
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      iconColor: AppColors.textPrimaryLight,
      textColor: AppColors.textPrimaryLight,
      titleTextStyle: AppTypography.bodyLarge(
        color: AppColors.textPrimaryLight,
      ),
      subtitleTextStyle: AppTypography.body(
        color: AppColors.textSecondaryLight,
      ),
      leadingAndTrailingTextStyle: AppTypography.caption(
        color: AppColors.textSecondaryLight,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    
    // ===== Icon Theme =====
    iconTheme: const IconThemeData(
      color: AppColors.textPrimaryLight,
      size: 24,
    ),
    
    // ===== Primary Icon Theme =====
    primaryIconTheme: const IconThemeData(
      color: AppColors.primary,
      size: 24,
    ),
    
    // ===== Divider Theme =====
    dividerTheme: const DividerThemeData(
      color: AppColors.borderLight,
      thickness: 1,
      space: AppSpacing.md,
      indent: 0,
      endIndent: 0,
    ),
    
    // ===== Tab Bar Theme =====
    tabBarTheme: TabBarTheme(
      labelColor: AppColors.primary,
      unselectedLabelColor: AppColors.textSecondaryLight,
      labelStyle: AppTypography.body(
        weight: FontWeight.w600,
      ),
      unselectedLabelStyle: AppTypography.body(),
      indicator: const UnderlineTabIndicator(
        borderSide: BorderSide(
          color: AppColors.primary,
          width: 3,
        ),
      ),
      indicatorSize: TabBarIndicatorSize.tab,
      dividerColor: AppColors.borderLight,
      overlayColor: MaterialStateProperty.all(
        AppColors.primary.withOpacity(0.1),
      ),
    ),
    
    // ===== Text Selection Theme =====
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.primary,
      selectionColor: AppColors.primary.withOpacity(0.3),
      selectionHandleColor: AppColors.primary,
    ),
    
    // ===== Tooltip Theme =====
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: AppColors.secondary.withOpacity(0.9),
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: AppTypography.caption(
        color: AppColors.surfaceLight,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      waitDuration: const Duration(milliseconds: 500),
    ),
    
    // ===== Text Theme =====
    textTheme: TextTheme(
      displayLarge: AppTypography.display(
        color: AppColors.textPrimaryLight,
      ),
      displayMedium: AppTypography.headline(
        color: AppColors.textPrimaryLight,
      ),
      displaySmall: AppTypography.title(
        color: AppColors.textPrimaryLight,
      ),
      headlineLarge: AppTypography.headline(
        color: AppColors.textPrimaryLight,
      ),
      headlineMedium: AppTypography.title(
        color: AppColors.textPrimaryLight,
      ),
      headlineSmall: AppTypography.bodyLarge(
        color: AppColors.textPrimaryLight,
      ),
      titleLarge: AppTypography.title(
        color: AppColors.textPrimaryLight,
      ),
      titleMedium: AppTypography.bodyLarge(
        color: AppColors.textPrimaryLight,
      ),
      titleSmall: AppTypography.body(
        color: AppColors.textPrimaryLight,
      ),
      bodyLarge: AppTypography.bodyLarge(
        color: AppColors.textPrimaryLight,
      ),
      bodyMedium: AppTypography.body(
        color: AppColors.textPrimaryLight,
      ),
      bodySmall: AppTypography.caption(
        color: AppColors.textSecondaryLight,
      ),
      labelLarge: AppTypography.bodyLarge(
        color: AppColors.textPrimaryLight,
        weight: FontWeight.w600,
      ),
      labelMedium: AppTypography.body(
        color: AppColors.textPrimaryLight,
        weight: FontWeight.w600,
      ),
      labelSmall: AppTypography.caption(
        color: AppColors.textSecondaryLight,
      ),
    ),
    
    // ===== Primary Text Theme =====
    primaryTextTheme: TextTheme(
      bodyLarge: AppTypography.bodyLarge(
        color: AppColors.primary,
      ),
      bodyMedium: AppTypography.body(
        color: AppColors.primary,
      ),
    ),
  );
  
  // ============================================
  // DARK THEME
  // ============================================
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    
    // ===== Color Scheme =====
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      tertiary: AppColors.accent,
      surface: AppColors.surfaceDark,
      error: AppColors.error,
      onPrimary: AppColors.secondary,
      onSecondary: AppColors.surfaceLight,
      onSurface: AppColors.textPrimaryDark,
      onError: AppColors.surfaceLight,
      outline: AppColors.borderDark,
      shadow: Colors.black38,
    ),
    
    // ===== App Bar Theme =====
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.surfaceDark,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 1,
      centerTitle: false,
      iconTheme: const IconThemeData(
        color: AppColors.textPrimaryDark,
        size: 24,
      ),
      actionsIconTheme: const IconThemeData(
        color: AppColors.textPrimaryDark,
        size: 24,
      ),
      titleTextStyle: AppTypography.title(
        color: AppColors.textPrimaryDark,
        weight: FontWeight.w700,
      ),
      toolbarHeight: 56,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    ),
    
    // ===== Bottom Navigation Bar Theme =====
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.surfaceDark,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textSecondaryDark,
      selectedLabelStyle: AppTypography.caption(
        weight: FontWeight.w600,
      ),
      unselectedLabelStyle: AppTypography.caption(),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      showSelectedLabels: true,
      showUnselectedLabels: true,
    ),
    
    // ===== Navigation Bar Theme (Material 3) =====
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.surfaceDark,
      indicatorColor: AppColors.primary.withOpacity(0.2),
      iconTheme: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return const IconThemeData(
            color: AppColors.primary,
            size: 24,
          );
        }
        return const IconThemeData(
          color: AppColors.textSecondaryDark,
          size: 24,
        );
      }),
      labelTextStyle: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppTypography.caption(
            color: AppColors.primary,
            weight: FontWeight.w600,
          );
        }
        return AppTypography.caption(
          color: AppColors.textSecondaryDark,
        );
      }),
      height: 80,
      elevation: 3,
    ),
    
    // ===== Card Theme =====
    cardTheme: CardTheme(
      color: AppColors.surfaceDark,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shadowColor: Colors.black38,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(
          color: AppColors.borderDark,
          width: 1,
        ),
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      clipBehavior: Clip.antiAlias,
    ),
    
    // ===== Input Decoration Theme =====
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceDark,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      
      // Default Border
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.borderDark,
          width: 1.5,
        ),
      ),
      
      // Enabled Border
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.borderDark,
          width: 1.5,
        ),
      ),
      
      // Focused Border
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.primary,
          width: 2,
        ),
      ),
      
      // Error Border
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.error,
          width: 1.5,
        ),
      ),
      
      // Focused Error Border
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.error,
          width: 2,
        ),
      ),
      
      // Disabled Border
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: AppColors.borderDark.withOpacity(0.5),
          width: 1.5,
        ),
      ),
      
      // Text Styles
      labelStyle: AppTypography.body(
        color: AppColors.textSecondaryDark,
      ),
      floatingLabelStyle: AppTypography.body(
        color: AppColors.primary,
        weight: FontWeight.w600,
      ),
      hintStyle: AppTypography.body(
        color: AppColors.textSecondaryDark,
      ),
      errorStyle: AppTypography.caption(
        color: AppColors.error,
      ),
      helperStyle: AppTypography.caption(
        color: AppColors.textSecondaryDark,
      ),
      
      // Icon Theme
      prefixIconColor: AppColors.textSecondaryDark,
      suffixIconColor: AppColors.textSecondaryDark,
    ),
    
    // ===== Elevated Button Theme =====
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.secondary,
        disabledBackgroundColor: AppColors.borderDark,
        disabledForegroundColor: AppColors.textSecondaryDark,
        elevation: 0,
        shadowColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        minimumSize: const Size(0, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: AppTypography.bodyLarge(
          weight: FontWeight.w600,
        ),
      ),
    ),
    
    // ===== Text Button Theme =====
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        disabledForegroundColor: AppColors.textSecondaryDark,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        minimumSize: const Size(0, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: AppTypography.body(
          weight: FontWeight.w600,
        ),
      ),
    ),
    
    // ===== Outlined Button Theme =====
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        disabledForegroundColor: AppColors.textSecondaryDark,
        side: const BorderSide(
          color: AppColors.primary,
          width: 1.5,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        minimumSize: const Size(0, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: AppTypography.bodyLarge(
          weight: FontWeight.w600,
        ),
      ),
    ),
    
    // ===== Icon Button Theme =====
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: AppColors.textPrimaryDark,
        disabledForegroundColor: AppColors.textSecondaryDark,
        highlightColor: AppColors.primary.withOpacity(0.1),
        padding: const EdgeInsets.all(AppSpacing.sm),
        minimumSize: const Size(40, 40),
        iconSize: 24,
      ),
    ),
    
    // ===== Floating Action Button Theme =====
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.secondary,
      elevation: 4,
      highlightElevation: 8,
      shape: CircleBorder(),
      iconSize: 24,
    ),
    
    // ===== Chip Theme =====
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surfaceDark,
      deleteIconColor: AppColors.textSecondaryDark,
      disabledColor: AppColors.borderDark,
      selectedColor: AppColors.primary.withOpacity(0.2),
      secondarySelectedColor: AppColors.accent.withOpacity(0.2),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      labelStyle: AppTypography.body(
        color: AppColors.textPrimaryDark,
      ),
      secondaryLabelStyle: AppTypography.body(
        color: AppColors.textPrimaryDark,
      ),
      brightness: Brightness.dark,
      elevation: 0,
      pressElevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(
          color: AppColors.borderDark,
          width: 1,
        ),
      ),
    ),
    
    // ===== Dialog Theme =====
    dialogTheme: DialogTheme(
      backgroundColor: AppColors.surfaceDark,
      surfaceTintColor: Colors.transparent,
      elevation: 8,
      shadowColor: Colors.black54,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      titleTextStyle: AppTypography.headline(
        color: AppColors.textPrimaryDark,
      ),
      contentTextStyle: AppTypography.body(
        color: AppColors.textPrimaryDark,
      ),
    ),
    
    // ===== Bottom Sheet Theme =====
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.surfaceDark,
      surfaceTintColor: Colors.transparent,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      showDragHandle: true,
      dragHandleColor: AppColors.borderDark,
      modalBackgroundColor: AppColors.surfaceDark,
      modalElevation: 8,
    ),
    
    // ===== Snack Bar Theme =====
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.surfaceLight,
      contentTextStyle: AppTypography.body(
        color: AppColors.secondary,
      ),
      actionTextColor: AppColors.primary,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
    ),
    
    // ===== Progress Indicator Theme =====
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primary,
      linearTrackColor: AppColors.borderDark,
      circularTrackColor: AppColors.borderDark,
    ),
    
    // ===== Switch Theme =====
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.primary;
        }
        return AppColors.borderDark;
      }),
      trackColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.primary.withOpacity(0.5);
        }
        return AppColors.borderDark.withOpacity(0.5);
      }),
    ),
    
    // ===== Checkbox Theme =====
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.primary;
        }
        return Colors.transparent;
      }),
      checkColor: MaterialStateProperty.all(AppColors.secondary),
      side: const BorderSide(
        color: AppColors.borderDark,
        width: 2,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    ),
    
    // ===== Radio Theme =====
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.primary;
        }
        return AppColors.borderDark;
      }),
    ),
    
    // ===== Slider Theme =====
    sliderTheme: SliderThemeData(
      activeTrackColor: AppColors.primary,
      inactiveTrackColor: AppColors.borderDark,
      thumbColor: AppColors.primary,
      overlayColor: AppColors.primary.withOpacity(0.2),
      valueIndicatorColor: AppColors.primary,
      valueIndicatorTextStyle: AppTypography.caption(
        color: AppColors.secondary,
      ),
    ),
    
    // ===== List Tile Theme =====
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      iconColor: AppColors.textPrimaryDark,
      textColor: AppColors.textPrimaryDark,
      titleTextStyle: AppTypography.bodyLarge(
        color: AppColors.textPrimaryDark,
      ),
      subtitleTextStyle: AppTypography.body(
        color: AppColors.textSecondaryDark,
      ),
      leadingAndTrailingTextStyle: AppTypography.caption(
        color: AppColors.textSecondaryDark,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    
    // ===== Icon Theme =====
    iconTheme: const IconThemeData(
      color: AppColors.textPrimaryDark,
      size: 24,
    ),
    
    // ===== Primary Icon Theme =====
    primaryIconTheme: const IconThemeData(
      color: AppColors.primary,
      size: 24,
    ),
    
    // ===== Divider Theme =====
    dividerTheme: const DividerThemeData(
      color: AppColors.borderDark,
      thickness: 1,
      space: AppSpacing.md,
      indent: 0,
      endIndent: 0,
    ),
    
    // ===== Tab Bar Theme =====
    tabBarTheme: TabBarTheme(
      labelColor: AppColors.primary,
      unselectedLabelColor: AppColors.textSecondaryDark,
      labelStyle: AppTypography.body(
        weight: FontWeight.w600,
      ),
      unselectedLabelStyle: AppTypography.body(),
      indicator: const UnderlineTabIndicator(
        borderSide: BorderSide(
          color: AppColors.primary,
          width: 3,
        ),
      ),
      indicatorSize: TabBarIndicatorSize.tab,
      dividerColor: AppColors.borderDark,
      overlayColor: MaterialStateProperty.all(
        AppColors.primary.withOpacity(0.1),
      ),
    ),
    
    // ===== Text Selection Theme =====
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.primary,
      selectionColor: AppColors.primary.withOpacity(0.3),
      selectionHandleColor: AppColors.primary,
    ),
    
    // ===== Tooltip Theme =====
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: AppColors.surfaceLight.withOpacity(0.9),
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: AppTypography.caption(
        color: AppColors.secondary,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      waitDuration: const Duration(milliseconds: 500),
    ),
    
    // ===== Text Theme =====
    textTheme: TextTheme(
      displayLarge: AppTypography.display(
        color: AppColors.textPrimaryDark,
      ),
      displayMedium: AppTypography.headline(
        color: AppColors.textPrimaryDark,
      ),
      displaySmall: AppTypography.title(
        color: AppColors.textPrimaryDark,
      ),
      headlineLarge: AppTypography.headline(
        color: AppColors.textPrimaryDark,
      ),
      headlineMedium: AppTypography.title(
        color: AppColors.textPrimaryDark,
      ),
      headlineSmall: AppTypography.bodyLarge(
        color: AppColors.textPrimaryDark,
      ),
      titleLarge: AppTypography.title(
        color: AppColors.textPrimaryDark,
      ),
      titleMedium: AppTypography.bodyLarge(
        color: AppColors.textPrimaryDark,
      ),
      titleSmall: AppTypography.body(
        color: AppColors.textPrimaryDark,
      ),
      bodyLarge: AppTypography.bodyLarge(
        color: AppColors.textPrimaryDark,
      ),
      bodyMedium: AppTypography.body(
        color: AppColors.textPrimaryDark,
      ),
      bodySmall: AppTypography.caption(
        color: AppColors.textSecondaryDark,
      ),
      labelLarge: AppTypography.bodyLarge(
        color: AppColors.textPrimaryDark,
        weight: FontWeight.w600,
      ),
      labelMedium: AppTypography.body(
        color: AppColors.textPrimaryDark,
        weight: FontWeight.w600,
      ),
      labelSmall: AppTypography.caption(
        color: AppColors.textSecondaryDark,
      ),
    ),
    
    // ===== Primary Text Theme =====
    primaryTextTheme: TextTheme(
      bodyLarge: AppTypography.bodyLarge(
        color: AppColors.primary,
      ),
      bodyMedium: AppTypography.body(
        color: AppColors.primary,
      ),
    ),
  );
}