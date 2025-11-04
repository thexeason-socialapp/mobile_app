import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  
  // ===== Theme Access =====
  
  /// Get current theme
  /// Example: context.theme
  ThemeData get theme => Theme.of(this);
  
  /// Get text theme
  /// Example: context.textTheme.bodyLarge
  TextTheme get textTheme => Theme.of(this).textTheme;
  
  /// Get color scheme
  /// Example: context.colorScheme.primary
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  
  /// Check if dark mode is enabled
  /// Example: if (context.isDarkMode) { ... }
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
  
  /// Check if light mode is enabled
  /// Example: if (context.isLightMode) { ... }
  bool get isLightMode => Theme.of(this).brightness == Brightness.light;
  
  // ===== Screen Size =====
  
  /// Get screen size
  /// Example: context.screenSize
  Size get screenSize => MediaQuery.of(this).size;
  
  /// Get screen width
  /// Example: context.width
  double get width => MediaQuery.of(this).size.width;
  
  /// Get screen height
  /// Example: context.height
  double get height => MediaQuery.of(this).size.height;
  
  /// Get device pixel ratio
  /// Example: context.devicePixelRatio
  double get devicePixelRatio => MediaQuery.of(this).devicePixelRatio;
  
  // ===== Responsive Breakpoints =====
  
  /// Check if mobile (width < 600)
  /// Example: if (context.isMobile) { ... }
  bool get isMobile => width < 600;
  
  /// Check if tablet (600 <= width < 1024)
  /// Example: if (context.isTablet) { ... }
  bool get isTablet => width >= 600 && width < 1024;
  
  /// Check if desktop (width >= 1024)
  /// Example: if (context.isDesktop) { ... }
  bool get isDesktop => width >= 1024;
  
  /// Check if small screen (width < 360)
  /// Example: if (context.isSmallScreen) { ... }
  bool get isSmallScreen => width < 360;
  
  /// Check if large screen (width >= 1440)
  /// Example: if (context.isLargeScreen) { ... }
  bool get isLargeScreen => width >= 1440;
  
  // ===== Orientation =====
  
  /// Check if portrait orientation
  /// Example: if (context.isPortrait) { ... }
  bool get isPortrait => MediaQuery.of(this).orientation == Orientation.portrait;
  
  /// Check if landscape orientation
  /// Example: if (context.isLandscape) { ... }
  bool get isLandscape => MediaQuery.of(this).orientation == Orientation.landscape;
  
  // ===== Padding & Insets =====
  
  /// Get view padding (safe area insets)
  /// Example: context.viewPadding
  EdgeInsets get viewPadding => MediaQuery.of(this).viewPadding;
  
  /// Get view insets (keyboard height, etc.)
  /// Example: context.viewInsets
  EdgeInsets get viewInsets => MediaQuery.of(this).viewInsets;
  
  /// Get status bar height
  /// Example: context.statusBarHeight
  double get statusBarHeight => MediaQuery.of(this).viewPadding.top;
  
  /// Get bottom navigation bar height
  /// Example: context.bottomBarHeight
  double get bottomBarHeight => MediaQuery.of(this).viewPadding.bottom;
  
  /// Get keyboard height
  /// Example: context.keyboardHeight
  double get keyboardHeight => MediaQuery.of(this).viewInsets.bottom;
  
  /// Check if keyboard is visible
  /// Example: if (context.isKeyboardVisible) { ... }
  bool get isKeyboardVisible => MediaQuery.of(this).viewInsets.bottom > 0;
  
  // ===== Navigation =====
  
  /// Push new route
  /// Example: context.push(MyPage())
  Future<T?> push<T>(Widget page) {
    return Navigator.of(this).push<T>(
      MaterialPageRoute(builder: (_) => page),
    );
  }
  
  /// Push replacement (replace current route)
  /// Example: context.pushReplacement(HomePage())
  Future<T?> pushReplacement<T>(Widget page) {
    return Navigator.of(this).pushReplacement<T, dynamic>(
      MaterialPageRoute(builder: (_) => page),
    );
  }
  
  /// Push and remove all previous routes
  /// Example: context.pushAndRemoveAll(HomePage())
  Future<T?> pushAndRemoveAll<T>(Widget page) {
    return Navigator.of(this).pushAndRemoveUntil<T>(
      MaterialPageRoute(builder: (_) => page),
      (route) => false,
    );
  }
  
  /// Pop current route
  /// Example: context.pop()
  void pop<T>([T? result]) {
    Navigator.of(this).pop(result);
  }
  
  /// Check if can pop
  /// Example: if (context.canPop) { context.pop(); }
  bool get canPop => Navigator.of(this).canPop();
  
  /// Pop until first route
  /// Example: context.popToFirst()
  void popToFirst() {
    Navigator.of(this).popUntil((route) => route.isFirst);
  }
  
  // ===== Dialogs & Bottom Sheets =====
  
  /// Show dialog
  /// Example: context.showDialog(MyDialog())
  Future<T?> showCustomDialog<T>(Widget dialog) {  // ✅ Different name
  return showDialog<T>(  // ✅ Calls Flutter's showDialog
    context: this,
    builder: (_) => dialog,
  );
}
  
  /// Show bottom sheet
  /// Example: context.showBottomSheet(MySheet())
  Future<T?> showBottomSheet<T>(Widget sheet) {
    return showModalBottomSheet<T>(
      context: this,
      builder: (_) => sheet,
    );
  }
  
  // ===== Snackbars =====
  
  /// Show snackbar
  /// Example: context.showSnackBar('Success!')
  void showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        action: action,
      ),
    );
  }
  
  /// Show success snackbar (green)
  /// Example: context.showSuccessSnackBar('Post created!')
  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }
  
  /// Show error snackbar (red)
  /// Example: context.showErrorSnackBar('Failed to load posts')
  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
      ),
    );
  }
  
  /// Show warning snackbar (orange)
  /// Example: context.showWarningSnackBar('Slow connection detected')
  void showWarningSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 3),
      ),
    );
  }
  
  /// Show info snackbar (blue)
  /// Example: context.showInfoSnackBar('New update available')
  void showInfoSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 3),
      ),
    );
  }
  
  // ===== Focus =====
  
  /// Unfocus (hide keyboard)
  /// Example: context.unfocus()
  void unfocus() {
    FocusScope.of(this).unfocus();
  }
  
  /// Request focus
  /// Example: context.requestFocus(myFocusNode)
  void requestFocus(FocusNode focusNode) {
    FocusScope.of(this).requestFocus(focusNode);
  }
  
  // ===== Locale & Language =====
  
  /// Get current locale
  /// Example: context.locale
  Locale get locale => Localizations.localeOf(this);
  
  /// Get language code
  /// Example: context.languageCode → "en"
  String get languageCode => Localizations.localeOf(this).languageCode;
  
  // ===== Platform Checks =====
  
  /// Get platform
  /// Example: context.platform
  TargetPlatform get platform => Theme.of(this).platform;
  
  /// Check if Android
  /// Example: if (context.isAndroid) { ... }
  bool get isAndroid => Theme.of(this).platform == TargetPlatform.android;
  
  /// Check if iOS
  /// Example: if (context.isIOS) { ... }
  bool get isIOS => Theme.of(this).platform == TargetPlatform.iOS;
  
  /// Check if web
  /// Example: if (context.isWeb) { ... }
  bool get isWeb => 
      Theme.of(this).platform == TargetPlatform.linux ||
      Theme.of(this).platform == TargetPlatform.macOS ||
      Theme.of(this).platform == TargetPlatform.windows;
  
  // ===== Responsive Values =====
  
  /// Get responsive value based on screen size
  /// Example: context.responsive(mobile: 16.0, tablet: 20.0, desktop: 24.0)
  T responsive<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop && desktop != null) {
      return desktop;
    } else if (isTablet && tablet != null) {
      return tablet;
    } else {
      return mobile;
    }
  }
  
  /// Get responsive padding
  /// Example: context.responsivePadding
  EdgeInsets get responsivePadding {
    if (isDesktop) {
      return const EdgeInsets.all(24.0);
    } else if (isTablet) {
      return const EdgeInsets.all(20.0);
    } else {
      return const EdgeInsets.all(16.0);
    }
  }
  
  // ===== Screen Percentage =====
  
  /// Get percentage of screen width
  /// Example: context.widthPercent(0.5) → 50% of screen width
  double widthPercent(double percent) {
    return width * percent;
  }
  
  /// Get percentage of screen height
  /// Example: context.heightPercent(0.3) → 30% of screen height
  double heightPercent(double percent) {
    return height * percent;
  }
}