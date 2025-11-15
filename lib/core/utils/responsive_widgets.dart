import 'package:flutter/material.dart';
import 'responsive_utils.dart';

/// 🎨 RESPONSIVE WIDGET UTILITIES
/// Provides easy-to-use widgets for building responsive layouts
/// Automatically adapts based on screen size and device capabilities

/// 📱💻 RESPONSIVE BUILDER
/// Builds different widgets based on screen size
class ResponsiveBuilder extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  final Widget? largeDesktop;
  
  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.largeDesktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (BreakPoints.isLargeDesktop(context)) {
          return largeDesktop ?? desktop ?? tablet ?? mobile;
        } else if (BreakPoints.isDesktop(context)) {
          return desktop ?? tablet ?? mobile;
        } else if (BreakPoints.isTablet(context)) {
          return tablet ?? mobile;
        } else {
          return mobile;
        }
      },
    );
  }
}

/// 📐 RESPONSIVE CONTAINER
/// Container that adapts its properties based on screen size
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? mobilePadding;
  final EdgeInsets? tabletPadding;
  final EdgeInsets? desktopPadding;
  final Color? backgroundColor;
  final BoxConstraints? constraints;
  final bool centerContent;
  
  const ResponsiveContainer({
    super.key,
    required this.child,
    this.mobilePadding,
    this.tabletPadding,
    this.desktopPadding,
    this.backgroundColor,
    this.constraints,
    this.centerContent = false,
  });

  @override
  Widget build(BuildContext context) {
    EdgeInsets padding;
    
    if (BreakPoints.isMobile(context)) {
      padding = mobilePadding ?? const EdgeInsets.all(16.0);
    } else if (BreakPoints.isTablet(context)) {
      padding = tabletPadding ?? const EdgeInsets.all(24.0);
    } else {
      padding = desktopPadding ?? const EdgeInsets.all(32.0);
    }

    Widget content = Container(
      padding: padding,
      constraints: constraints ?? BoxConstraints(
        maxWidth: ResponsiveValues.maxContentWidth(context),
      ),
      decoration: backgroundColor != null
          ? BoxDecoration(color: backgroundColor)
          : null,
      child: child,
    );

    if (centerContent && !BreakPoints.isMobile(context)) {
      content = Center(child: content);
    }

    return content;
  }
}

/// 📊 RESPONSIVE GRID
/// Grid that adapts column count based on screen size
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double? spacing;
  final double? runSpacing;
  final int? mobileColumns;
  final int? tabletColumns;
  final int? desktopColumns;
  final double? childAspectRatio;
  
  const ResponsiveGrid({
    super.key,
    required this.children,
    this.spacing = 16.0,
    this.runSpacing = 16.0,
    this.mobileColumns = 2,
    this.tabletColumns = 3,
    this.desktopColumns = 4,
    this.childAspectRatio = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    int columns;
    
    if (BreakPoints.isMobile(context)) {
      columns = mobileColumns ?? 2;
    } else if (BreakPoints.isTablet(context)) {
      columns = tabletColumns ?? 3;
    } else {
      columns = desktopColumns ?? 4;
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: spacing ?? 16.0,
        mainAxisSpacing: runSpacing ?? 16.0,
        childAspectRatio: childAspectRatio ?? 1.0,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
}

/// 🔲 RESPONSIVE CARD
/// Card component that adapts its styling based on screen size
class ResponsiveCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double? elevation;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final bool showHoverEffect;
  
  const ResponsiveCard({
    super.key,
    required this.child,
    this.padding,
    this.elevation,
    this.borderRadius,
    this.backgroundColor,
    this.onTap,
    this.showHoverEffect = true,
  });

  @override
  Widget build(BuildContext context) {
    final cardPadding = padding ?? (BreakPoints.isMobile(context) 
        ? const EdgeInsets.all(16.0)
        : const EdgeInsets.all(20.0));
    
    final cardElevation = elevation ?? (BreakPoints.isMobile(context) ? 2.0 : 4.0);
    
    final cardRadius = borderRadius ?? BorderRadius.circular(
      BreakPoints.isMobile(context) ? 12.0 : 16.0
    );

    Widget card = Card(
      elevation: cardElevation,
      shape: RoundedRectangleBorder(borderRadius: cardRadius),
      color: backgroundColor,
      child: Padding(
        padding: cardPadding,
        child: child,
      ),
    );

    if (onTap != null) {
      card = InkWell(
        onTap: onTap,
        borderRadius: cardRadius,
        child: card,
      );
    }

    // Add hover effect for desktop
    if (showHoverEffect && DeviceUtils.supportsHover(context)) {
      card = MouseRegion(
        cursor: onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
        child: card,
      );
    }

    return card;
  }
}

/// 📝 RESPONSIVE TEXT
/// Text widget that adapts font size based on screen size
class ResponsiveText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final double? mobileSize;
  final double? tabletSize;
  final double? desktopSize;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  
  const ResponsiveText({
    super.key,
    required this.text,
    this.style,
    this.mobileSize,
    this.tabletSize,
    this.desktopSize,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    double fontSize;
    
    if (BreakPoints.isMobile(context)) {
      fontSize = mobileSize ?? 16.0;
    } else if (BreakPoints.isTablet(context)) {
      fontSize = tabletSize ?? mobileSize ?? 18.0;
    } else {
      fontSize = desktopSize ?? tabletSize ?? mobileSize ?? 20.0;
    }

    return Text(
      text,
      style: (style ?? const TextStyle()).copyWith(fontSize: fontSize),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// 🔘 RESPONSIVE BUTTON
/// Button that adapts size and padding based on screen size
class ResponsiveButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final ButtonStyle? style;
  final EdgeInsets? mobilePadding;
  final EdgeInsets? desktopPadding;
  final bool isOutlined;
  final bool isElevated;
  
  const ResponsiveButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.style,
    this.mobilePadding,
    this.desktopPadding,
    this.isOutlined = false,
    this.isElevated = true,
  });

  @override
  Widget build(BuildContext context) {
    final padding = BreakPoints.isMobile(context)
        ? mobilePadding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12)
        : desktopPadding ?? const EdgeInsets.symmetric(horizontal: 32, vertical: 16);

    final buttonStyle = (style ?? (isOutlined 
        ? OutlinedButton.styleFrom() 
        : ElevatedButton.styleFrom()))
        .copyWith(
          padding: MaterialStateProperty.all(padding),
        );

    if (isOutlined) {
      return OutlinedButton(
        onPressed: onPressed,
        style: buttonStyle,
        child: child,
      );
    } else {
      return ElevatedButton(
        onPressed: onPressed,
        style: buttonStyle,
        child: child,
      );
    }
  }
}

/// 📱💻 RESPONSIVE LAYOUT
/// Provides different layouts for mobile vs desktop
class ResponsiveLayout extends StatelessWidget {
  final Widget? mobileBody;
  final Widget? desktopBody;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final Widget? endDrawer;
  
  const ResponsiveLayout({
    super.key,
    this.mobileBody,
    this.desktopBody,
    this.appBar,
    this.bottomNavigationBar,
    this.drawer,
    this.endDrawer,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BreakPoints.isMobile(context) ? appBar : null,
      body: BreakPoints.useMobileLayout(context) 
          ? mobileBody ?? desktopBody
          : desktopBody ?? mobileBody,
      bottomNavigationBar: BreakPoints.useMobileLayout(context) 
          ? bottomNavigationBar 
          : null,
      drawer: BreakPoints.isMobile(context) ? drawer : null,
      endDrawer: BreakPoints.isMobile(context) ? endDrawer : null,
    );
  }
}

/// 🎛️ ADAPTIVE SCAFFOLD
/// Scaffold that automatically adapts to screen size
class AdaptiveScaffold extends StatelessWidget {
  final Widget body;
  final String? title;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final bool showAppBar;
  
  const AdaptiveScaffold({
    super.key,
    required this.body,
    this.title,
    this.actions,
    this.floatingActionButton,
    this.showAppBar = true,
  });

  @override
  Widget build(BuildContext context) {
    if (BreakPoints.useDesktopLayout(context)) {
      // Desktop layout - no app bar, body has full height
      return Scaffold(
        body: body,
        floatingActionButton: floatingActionButton,
      );
    } else {
      // Mobile layout - with app bar
      return Scaffold(
        appBar: showAppBar ? AppBar(
          title: title != null ? Text(title!) : null,
          actions: actions,
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF111827),
          elevation: 1,
        ) : null,
        body: body,
        floatingActionButton: floatingActionButton,
      );
    }
  }
}