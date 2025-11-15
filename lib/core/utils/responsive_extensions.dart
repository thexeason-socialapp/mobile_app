import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'responsive_utils.dart';

/// 🎨 RESPONSIVE EXTENSIONS
/// Convenient extensions to make existing widgets responsive quickly

/// Extension on Widget to add responsive capabilities
extension ResponsiveWidget on Widget {
  /// Wrap widget with responsive padding
  Widget withResponsivePadding(BuildContext context) {
    return Padding(
      padding: ResponsiveValues.padding(context),
      child: this,
    );
  }

  /// Wrap widget with responsive horizontal padding
  Widget withResponsiveHorizontalPadding(BuildContext context) {
    return Padding(
      padding: ResponsiveValues.horizontalPadding(context),
      child: this,
    );
  }

  /// Center widget on desktop, keep as-is on mobile
  Widget centerOnDesktop(BuildContext context) {
    if (BreakPoints.useDesktopLayout(context)) {
      return Center(child: this);
    }
    return this;
  }

  /// Constrain width on larger screens
  Widget constrainWidth(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxWidth: ResponsiveValues.maxContentWidth(context),
      ),
      child: this,
    );
  }

  /// Add hover effect on desktop
  Widget withHoverEffect(BuildContext context, {SystemMouseCursor? cursor}) {
    if (DeviceUtils.supportsHover(context)) {
      return MouseRegion(
        cursor: cursor ?? SystemMouseCursors.click,
        child: this,
      );
    }
    return this;
  }

  /// Show only on specific screen sizes
  Widget onlyOn({
    bool mobile = true,
    bool tablet = true,
    bool desktop = true,
  }) {
    return Builder(
      builder: (context) {
        if (BreakPoints.isMobile(context) && !mobile) {
          return const SizedBox.shrink();
        }
        if (BreakPoints.isTablet(context) && !tablet) {
          return const SizedBox.shrink();
        }
        if (BreakPoints.isDesktop(context) && !desktop) {
          return const SizedBox.shrink();
        }
        return this;
      },
    );
  }

  /// Hide on specific screen sizes
  Widget hideOn({
    bool mobile = false,
    bool tablet = false,
    bool desktop = false,
  }) {
    return onlyOn(
      mobile: !mobile,
      tablet: !tablet,
      desktop: !desktop,
    );
  }
}

/// Extension on BuildContext for easy responsive queries
extension ResponsiveContext on BuildContext {
  /// Check if current screen is mobile
  bool get isMobile => BreakPoints.isMobile(this);

  /// Check if current screen is tablet
  bool get isTablet => BreakPoints.isTablet(this);

  /// Check if current screen is desktop
  bool get isDesktop => BreakPoints.isDesktop(this);

  /// Check if should use mobile layout
  bool get useMobileLayout => BreakPoints.useMobileLayout(this);

  /// Check if should use desktop layout
  bool get useDesktopLayout => BreakPoints.useDesktopLayout(this);

  /// Check if device supports hover
  bool get supportsHover => DeviceUtils.supportsHover(this);

  /// Get responsive padding
  EdgeInsets get responsivePadding => ResponsiveValues.padding(this);

  /// Get responsive horizontal padding
  EdgeInsets get responsiveHorizontalPadding => ResponsiveValues.horizontalPadding(this);

  /// Get responsive max content width
  double get maxContentWidth => ResponsiveValues.maxContentWidth(this);

  /// Get responsive grid columns
  int get gridColumns => ResponsiveValues.gridColumns(this);

  /// Get responsive font scale
  double get fontScale => ResponsiveValues.fontScale(this);

  /// Get responsive icon size
  double responsiveIconSize({double baseSize = 24.0}) => 
      ResponsiveValues.iconSize(this, baseSize: baseSize);

  /// Get responsive tap target size
  double get tapTargetSize => DeviceUtils.tapTargetSize(this);
}

/// Extension on EdgeInsets for responsive values
extension ResponsiveEdgeInsets on EdgeInsets {
  /// Scale EdgeInsets based on screen size
  EdgeInsets scale(BuildContext context) {
    final scale = ResponsiveValues.fontScale(context);
    return EdgeInsets.fromLTRB(
      left * scale,
      top * scale,
      right * scale,
      bottom * scale,
    );
  }
}

/// Extension on TextStyle for responsive text
extension ResponsiveTextStyle on TextStyle {
  /// Scale font size based on screen size
  TextStyle responsive(BuildContext context) {
    final scale = ResponsiveValues.fontScale(context);
    return copyWith(
      fontSize: fontSize != null ? fontSize! * scale : null,
    );
  }
}

/// 🎛️ RESPONSIVE HELPERS
/// Static helper methods for common responsive operations
class ResponsiveHelpers {
  ResponsiveHelpers._();

  /// Choose value based on screen size
  static T choose<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
    T? largeDesktop,
  }) {
    if (BreakPoints.isLargeDesktop(context)) {
      return largeDesktop ?? desktop ?? tablet ?? mobile;
    } else if (BreakPoints.isDesktop(context)) {
      return desktop ?? tablet ?? mobile;
    } else if (BreakPoints.isTablet(context)) {
      return tablet ?? mobile;
    } else {
      return mobile;
    }
  }

  /// Get appropriate spacing based on screen size
  static double spacing(BuildContext context, {
    double mobile = 8.0,
    double? tablet,
    double? desktop,
  }) {
    return choose<double>(
      context,
      mobile: mobile,
      tablet: tablet ?? mobile * 1.5,
      desktop: desktop ?? mobile * 2.0,
    );
  }

  /// Get appropriate border radius based on screen size
  static BorderRadius borderRadius(BuildContext context, {
    double mobile = 8.0,
    double? tablet,
    double? desktop,
  }) {
    final radius = choose<double>(
      context,
      mobile: mobile,
      tablet: tablet ?? mobile * 1.5,
      desktop: desktop ?? mobile * 2.0,
    );
    return BorderRadius.circular(radius);
  }

  /// Get appropriate elevation based on screen size
  static double elevation(BuildContext context, {
    double mobile = 2.0,
    double? tablet,
    double? desktop,
  }) {
    return choose<double>(
      context,
      mobile: mobile,
      tablet: tablet ?? mobile * 1.5,
      desktop: desktop ?? mobile * 2.0,
    );
  }

  /// Show different content based on screen size
  static Widget adaptive(
    BuildContext context, {
    required Widget mobile,
    Widget? tablet,
    Widget? desktop,
  }) {
    return choose<Widget>(
      context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }

  /// Create responsive sized box
  static SizedBox sizedBox(
    BuildContext context, {
    double? height,
    double? width,
    double mobileHeight = 0.0,
    double? tabletHeight,
    double? desktopHeight,
    double mobileWidth = 0.0,
    double? tabletWidth,
    double? desktopWidth,
  }) {
    return SizedBox(
      height: height ?? choose<double>(
        context,
        mobile: mobileHeight,
        tablet: tabletHeight ?? mobileHeight * 1.5,
        desktop: desktopHeight ?? mobileHeight * 2.0,
      ),
      width: width ?? choose<double>(
        context,
        mobile: mobileWidth,
        tablet: tabletWidth ?? mobileWidth * 1.5,
        desktop: desktopWidth ?? mobileWidth * 2.0,
      ),
    );
  }
}

/// 📐 RESPONSIVE LAYOUT HELPERS
/// Pre-built common responsive patterns
class ResponsiveLayouts {
  ResponsiveLayouts._();

  /// Create a responsive row/column layout
  /// Mobile: Column, Desktop: Row
  static Widget rowColumn(
    BuildContext context, {
    required List<Widget> children,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    double spacing = 16.0,
  }) {
    if (BreakPoints.useMobileLayout(context)) {
      return Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        mainAxisSize: mainAxisSize,
        children: _addSpacing(children, spacing, isVertical: true),
      );
    } else {
      return Row(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        mainAxisSize: mainAxisSize,
        children: _addSpacing(children, spacing, isVertical: false),
      );
    }
  }

  /// Create a responsive sidebar layout
  /// Mobile: Single column, Desktop: Sidebar + content
  static Widget sidebar(
    BuildContext context, {
    required Widget sidebar,
    required Widget content,
    double sidebarWidth = 250.0,
  }) {
    if (BreakPoints.useMobileLayout(context)) {
      return content;
    } else {
      return Row(
        children: [
          SizedBox(
            width: sidebarWidth,
            child: sidebar,
          ),
          Expanded(child: content),
        ],
      );
    }
  }

  /// Create a responsive card grid
  static Widget cardGrid(
    BuildContext context, {
    required List<Widget> children,
    double spacing = 16.0,
    int? mobileColumns,
    int? tabletColumns,
    int? desktopColumns,
  }) {
    final columns = ResponsiveHelpers.choose<int>(
      context,
      mobile: mobileColumns ?? 1,
      tablet: tabletColumns ?? 2,
      desktop: desktopColumns ?? 3,
    );

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: 1.0,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }

  /// Helper to add spacing between widgets
  static List<Widget> _addSpacing(List<Widget> children, double spacing, {required bool isVertical}) {
    if (children.isEmpty) return children;

    final List<Widget> spacedChildren = [];
    for (int i = 0; i < children.length; i++) {
      spacedChildren.add(children[i]);
      if (i < children.length - 1) {
        spacedChildren.add(
          isVertical 
              ? SizedBox(height: spacing)
              : SizedBox(width: spacing),
        );
      }
    }
    return spacedChildren;
  }
}