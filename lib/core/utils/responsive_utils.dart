import 'package:flutter/material.dart';

/// 📱 RESPONSIVE BREAKPOINTS & UTILITIES
/// Provides consistent breakpoints and screen size helpers
/// for responsive design across the Thexeason app

class BreakPoints {
  BreakPoints._();

  // ===== BREAKPOINT VALUES =====
  static const double mobile = 768.0;
  static const double tablet = 1024.0;
  static const double desktop = 1200.0;
  static const double largeDesktop = 1440.0;

  // ===== SCREEN TYPE DETECTION =====
  
  /// Check if current screen is mobile (< 768px)
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobile;
  }

  /// Check if current screen is tablet (768px - 1024px)
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobile && width < desktop;
  }

  /// Check if current screen is desktop (≥ 1024px)
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktop;
  }

  /// Check if current screen is large desktop (≥ 1440px)
  static bool isLargeDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= largeDesktop;
  }

  /// Check if screen is mobile OR tablet (< 1024px)
  static bool isMobileOrTablet(BuildContext context) {
    return MediaQuery.of(context).size.width < desktop;
  }

  /// Check if screen should use mobile layout
  /// (Mobile portrait OR tablet portrait)
  static bool useMobileLayout(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return size.width < mobile || 
           (size.width < desktop && size.height > size.width);
  }

  /// Check if screen should use desktop layout
  /// (Desktop OR tablet landscape)
  static bool useDesktopLayout(BuildContext context) {
    return !useMobileLayout(context);
  }
}

/// 📏 RESPONSIVE VALUES
/// Provides adaptive values based on screen size
class ResponsiveValues {
  ResponsiveValues._();

  /// Get responsive padding
  static EdgeInsets padding(BuildContext context) {
    if (BreakPoints.isMobile(context)) {
      return const EdgeInsets.all(16.0);
    } else if (BreakPoints.isTablet(context)) {
      return const EdgeInsets.all(24.0);
    } else {
      return const EdgeInsets.all(32.0);
    }
  }

  /// Get responsive horizontal padding
  static EdgeInsets horizontalPadding(BuildContext context) {
    if (BreakPoints.isMobile(context)) {
      return const EdgeInsets.symmetric(horizontal: 16.0);
    } else if (BreakPoints.isTablet(context)) {
      return const EdgeInsets.symmetric(horizontal: 24.0);
    } else if (BreakPoints.isDesktop(context)) {
      return const EdgeInsets.symmetric(horizontal: 48.0);
    } else {
      return const EdgeInsets.symmetric(horizontal: 64.0);
    }
  }

  /// Get responsive content width
  /// Ensures content doesn't get too wide on large screens
  static double maxContentWidth(BuildContext context) {
    if (BreakPoints.isMobile(context)) {
      return double.infinity;
    } else if (BreakPoints.isTablet(context)) {
      return 600.0;
    } else {
      return 800.0;
    }
  }

  /// Get responsive grid columns
  static int gridColumns(BuildContext context) {
    if (BreakPoints.isMobile(context)) {
      return 2;
    } else if (BreakPoints.isTablet(context)) {
      return 3;
    } else {
      return 4;
    }
  }

  /// Get responsive font scaling factor
  static double fontScale(BuildContext context) {
    if (BreakPoints.isMobile(context)) {
      return 1.0;
    } else if (BreakPoints.isTablet(context)) {
      return 1.1;
    } else {
      return 1.2;
    }
  }

  /// Get responsive icon size
  static double iconSize(BuildContext context, {double baseSize = 24.0}) {
    final scale = fontScale(context);
    return baseSize * scale;
  }

  /// Get responsive sidebar width for desktop
  static double sidebarWidth(BuildContext context) {
    if (BreakPoints.isLargeDesktop(context)) {
      return 280.0;
    } else if (BreakPoints.isDesktop(context)) {
      return 240.0;
    } else {
      return 200.0;
    }
  }
}

/// 📱 DEVICE TYPE UTILITIES
/// Helps determine device capabilities and layout preferences
class DeviceUtils {
  DeviceUtils._();

  /// Check if device supports hover (has mouse)
  static bool supportsHover(BuildContext context) {
    return !BreakPoints.isMobile(context);
  }

  /// Check if device uses touch input primarily
  static bool isPrimaryTouch(BuildContext context) {
    return BreakPoints.isMobileOrTablet(context);
  }

  /// Get appropriate tap target size
  static double tapTargetSize(BuildContext context) {
    if (BreakPoints.isMobile(context)) {
      return 48.0; // Material Design minimum
    } else {
      return 40.0; // Desktop can be smaller due to mouse precision
    }
  }

  /// Get appropriate spacing between interactive elements
  static double interactiveSpacing(BuildContext context) {
    if (BreakPoints.isMobile(context)) {
      return 16.0;
    } else {
      return 12.0;
    }
  }
}

/// 🎨 RESPONSIVE THEME HELPERS
/// Provides adaptive theme values based on screen size
extension ResponsiveTheme on ThemeData {
  /// Get responsive text theme
  TextTheme get responsiveTextTheme {
    return textTheme;
  }

  /// Get responsive app bar height
  double appBarHeight(BuildContext context) {
    if (BreakPoints.isMobile(context)) {
      return kToolbarHeight;
    } else {
      return 64.0;
    }
  }
}

/// 📐 LAYOUT DIRECTION UTILITIES
/// Helps determine optimal layout based on screen dimensions
class LayoutDirection {
  LayoutDirection._();

  /// Check if screen should use horizontal layout
  /// (Desktop or tablet landscape)
  static bool useHorizontalLayout(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return size.width >= BreakPoints.tablet || 
           (size.width > size.height && size.width >= BreakPoints.mobile);
  }

  /// Check if screen should use vertical layout
  /// (Mobile or tablet portrait)
  static bool useVerticalLayout(BuildContext context) {
    return !useHorizontalLayout(context);
  }

  /// Get optimal number of columns for content
  static int getOptimalColumns(BuildContext context, {double itemWidth = 300.0}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = ResponsiveValues.horizontalPadding(context).horizontal;
    final availableWidth = screenWidth - padding;
    
    final columns = (availableWidth / itemWidth).floor();
    return columns.clamp(1, 4);
  }
}