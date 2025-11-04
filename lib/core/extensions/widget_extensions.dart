import 'package:flutter/material.dart';

extension WidgetExtensions on Widget {
  
  // ===== Padding =====
  
  /// Add padding on all sides
  /// Example: Text('Hello').padding(16)
  Widget padding(double value) {
    return Padding(
      padding: EdgeInsets.all(value),
      child: this,
    );
  }
  
  /// Add symmetric padding
  /// Example: Text('Hello').paddingSymmetric(horizontal: 16, vertical: 8)
  Widget paddingSymmetric({double horizontal = 0, double vertical = 0}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
      child: this,
    );
  }
  
  /// Add padding only on specific sides
  /// Example: Text('Hello').paddingOnly(left: 16, top: 8)
  Widget paddingOnly({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        left: left,
        top: top,
        right: right,
        bottom: bottom,
      ),
      child: this,
    );
  }
  
  /// Add horizontal padding
  /// Example: Text('Hello').paddingHorizontal(16)
  Widget paddingHorizontal(double value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: value),
      child: this,
    );
  }
  
  /// Add vertical padding
  /// Example: Text('Hello').paddingVertical(16)
  Widget paddingVertical(double value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: value),
      child: this,
    );
  }
  
  // ===== Margin (via Container) =====
  
  /// Add margin on all sides
  /// Example: Text('Hello').margin(16)
  Widget margin(double value) {
    return Container(
      margin: EdgeInsets.all(value),
      child: this,
    );
  }
  
  /// Add symmetric margin
  /// Example: Text('Hello').marginSymmetric(horizontal: 16, vertical: 8)
  Widget marginSymmetric({double horizontal = 0, double vertical = 0}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
      child: this,
    );
  }
  
  /// Add margin only on specific sides
  /// Example: Text('Hello').marginOnly(left: 16, top: 8)
  Widget marginOnly({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) {
    return Container(
      margin: EdgeInsets.only(
        left: left,
        top: top,
        right: right,
        bottom: bottom,
      ),
      child: this,
    );
  }
  
  // ===== Alignment =====
  
  /// Center widget
  /// Example: Text('Hello').center()
  Widget center() {
    return Center(child: this);
  }
  
  /// Align widget
  /// Example: Text('Hello').align(Alignment.topRight)
  Widget align(Alignment alignment) {
    return Align(alignment: alignment, child: this);
  }
  
  /// Align to top left
  /// Example: Text('Hello').alignTopLeft()
  Widget alignTopLeft() {
    return Align(alignment: Alignment.topLeft, child: this);
  }
  
  /// Align to top center
  /// Example: Text('Hello').alignTopCenter()
  Widget alignTopCenter() {
    return Align(alignment: Alignment.topCenter, child: this);
  }
  
  /// Align to top right
  /// Example: Text('Hello').alignTopRight()
  Widget alignTopRight() {
    return Align(alignment: Alignment.topRight, child: this);
  }
  
  /// Align to center left
  /// Example: Text('Hello').alignCenterLeft()
  Widget alignCenterLeft() {
    return Align(alignment: Alignment.centerLeft, child: this);
  }
  
  /// Align to center right
  /// Example: Text('Hello').alignCenterRight()
  Widget alignCenterRight() {
    return Align(alignment: Alignment.centerRight, child: this);
  }
  
  /// Align to bottom left
  /// Example: Text('Hello').alignBottomLeft()
  Widget alignBottomLeft() {
    return Align(alignment: Alignment.bottomLeft, child: this);
  }
  
  /// Align to bottom center
  /// Example: Text('Hello').alignBottomCenter()
  Widget alignBottomCenter() {
    return Align(alignment: Alignment.bottomCenter, child: this);
  }
  
  /// Align to bottom right
  /// Example: Text('Hello').alignBottomRight()
  Widget alignBottomRight() {
    return Align(alignment: Alignment.bottomRight, child: this);
  }
  
  // ===== Expanded & Flexible =====
  
  /// Make widget expanded
  /// Example: Text('Hello').expanded()
  Widget expanded({int flex = 1}) {
    return Expanded(flex: flex, child: this);
  }
  
  /// Make widget flexible
  /// Example: Text('Hello').flexible()
  Widget flexible({int flex = 1, FlexFit fit = FlexFit.loose}) {
    return Flexible(flex: flex, fit: fit, child: this);
  }
  
  // ===== SizedBox =====
  
  /// Add fixed width
  /// Example: Text('Hello').width(100)
  Widget width(double width) {
    return SizedBox(width: width, child: this);
  }
  
  /// Add fixed height
  /// Example: Text('Hello').height(50)
  Widget height(double height) {
    return SizedBox(height: height, child: this);
  }
  
  /// Add fixed width and height
  /// Example: Text('Hello').size(100, 50)
  Widget size(double width, double height) {
    return SizedBox(width: width, height: height, child: this);
  }
  
  /// Make widget square
  /// Example: Image.network('...').square(100)
  Widget square(double size) {
    return SizedBox(width: size, height: size, child: this);
  }
  
  // ===== Visibility =====
  
  /// Show widget conditionally
  /// Example: Text('Hello').visible(isLoggedIn)
  Widget visible(bool visible, {Widget? replacement}) {
    return visible ? this : (replacement ?? const SizedBox.shrink());
  }
  
  /// Hide widget conditionally
  /// Example: Text('Hello').hidden(isLoading)
  Widget hidden(bool hidden) {
    return hidden ? const SizedBox.shrink() : this;
  }
  
  // ===== Gestures =====
  
  /// Add tap gesture
  /// Example: Text('Hello').onTap(() => print('Tapped'))
  Widget onTap(VoidCallback onTap, {bool opaque = true}) {
    return GestureDetector(
      onTap: onTap,
      behavior: opaque ? HitTestBehavior.opaque : HitTestBehavior.deferToChild,
      child: this,
    );
  }
  
  /// Add long press gesture
  /// Example: Text('Hello').onLongPress(() => print('Long pressed'))
  Widget onLongPress(VoidCallback onLongPress) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: this,
    );
  }
  
  /// Add double tap gesture
  /// Example: Text('Hello').onDoubleTap(() => print('Double tapped'))
  Widget onDoubleTap(VoidCallback onDoubleTap) {
    return GestureDetector(
      onDoubleTap: onDoubleTap,
      child: this,
    );
  }
  
  // ===== InkWell (Material ripple effect) =====
  
  /// Add ink well with ripple effect
  /// Example: Text('Hello').inkWell(() => print('Tapped'))
  Widget inkWell(VoidCallback onTap, {BorderRadius? borderRadius}) {
    return InkWell(
      onTap: onTap,
      borderRadius: borderRadius,
      child: this,
    );
  }
  
  // ===== Opacity =====
  
  /// Add opacity
  /// Example: Text('Hello').opacity(0.5)
  Widget opacity(double opacity) {
    return Opacity(opacity: opacity, child: this);
  }
  
  // ===== Clip =====
  
  /// Clip with border radius
  /// Example: Image.network('...').clipRRect(12)
  Widget clipRRect(double radius) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: this,
    );
  }
  
  /// Clip as circle
  /// Example: Image.network('...').clipOval()
  Widget clipOval() {
    return ClipOval(child: this);
  }
  
  // ===== Card =====
  
  /// Wrap in card
  /// Example: Text('Hello').card()
  Widget card({
    double elevation = 1,
    Color? color,
    ShapeBorder? shape,
    EdgeInsetsGeometry? margin,
  }) {
    return Card(
      elevation: elevation,
      color: color,
      shape: shape,
      margin: margin,
      child: this,
    );
  }
  
  // ===== Container =====
  
  /// Wrap in container with decoration
  /// Example: Text('Hello').container(color: Colors.blue, padding: 16)
  Widget container({
    Color? color,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Decoration? decoration,
    AlignmentGeometry? alignment,
  }) {
    return Container(
      width: width,
      height: height,
      padding: padding != null ? EdgeInsets.all(padding as double) : null,
      margin: margin != null ? EdgeInsets.all(margin as double) : null,
      decoration: decoration ?? (color != null ? BoxDecoration(color: color) : null),
      alignment: alignment,
      child: this,
    );
  }
  
  // ===== Decorated Box =====
  
  /// Add background color
  /// Example: Text('Hello').backgroundColor(Colors.blue)
  Widget backgroundColor(Color color) {
    return DecoratedBox(
      decoration: BoxDecoration(color: color),
      child: this,
    );
  }
  
  /// Add border
  /// Example: Text('Hello').border(color: Colors.blue, width: 2)
  Widget border({
    Color color = Colors.black,
    double width = 1,
    BorderRadius? borderRadius,
  }) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: color, width: width),
        borderRadius: borderRadius,
      ),
      child: this,
    );
  }
  
  /// Add rounded border
  /// Example: Text('Hello').roundedBorder(radius: 12, color: Colors.blue)
  Widget roundedBorder({
    required double radius,
    Color color = Colors.black,
    double width = 1,
  }) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: color, width: width),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: this,
    );
  }
  
  // ===== Rotate =====
  
  /// Rotate widget
  /// Example: Icon(Icons.arrow_forward).rotate(90) // 90 degrees
  Widget rotate(double angleInDegrees) {
    return Transform.rotate(
      angle: angleInDegrees * (3.14159 / 180), // Convert to radians
      child: this,
    );
  }
  
  // ===== Scale =====
  
  /// Scale widget
  /// Example: Icon(Icons.star).scale(1.5)
  Widget scale(double scale) {
    return Transform.scale(
      scale: scale,
      child: this,
    );
  }
  
  // ===== Hero =====
  
  /// Wrap in Hero widget for transitions
  /// Example: Image.network('...').hero('imageHero')
  Widget hero(String tag) {
    return Hero(
      tag: tag,
      child: this,
    );
  }
  
  // ===== Tooltip =====
  
  /// Add tooltip
  /// Example: IconButton(...).tooltip('Delete')
  Widget tooltip(String message) {
    return Tooltip(
      message: message,
      child: this,
    );
  }
  
  // ===== SafeArea =====
  
  /// Wrap in SafeArea
  /// Example: Column(...).safeArea()
  Widget safeArea({
    bool top = true,
    bool bottom = true,
    bool left = true,
    bool right = true,
  }) {
    return SafeArea(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: this,
    );
  }
  
  // ===== Shimmer (Loading State) =====
  
  /// Add shimmer effect (placeholder for shimmer package)
  /// Example: Container().shimmer()
  Widget shimmer() {
    // Note: Requires shimmer package
    // This is a placeholder - actual implementation when we add shimmer package
    return this;
  }
  
  // ===== Scrollable =====
  
  /// Make widget scrollable (SingleChildScrollView)
  /// Example: Column(...).scrollable()
  Widget scrollable({
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    EdgeInsetsGeometry? padding,
  }) {
    return SingleChildScrollView(
      scrollDirection: scrollDirection,
      reverse: reverse,
      padding: padding,
      child: this,
    );
  }
  
  // ===== FittedBox =====
  
  /// Fit widget within bounds
  /// Example: Text('Long text').fitted()
  Widget fitted({BoxFit fit = BoxFit.contain}) {
    return FittedBox(
      fit: fit,
      child: this,
    );
  }
  
  // ===== AspectRatio =====
  
  /// Set aspect ratio
  /// Example: Image.network('...').aspectRatio(16 / 9)
  Widget aspectRatio(double aspectRatio) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: this,
    );
  }
  
  // ===== FractionallySizedBox =====
  
  /// Size relative to parent
  /// Example: Container().fractionalSize(widthFactor: 0.5)
  Widget fractionalSize({
    double? widthFactor,
    double? heightFactor,
  }) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      heightFactor: heightFactor,
      child: this,
    );
  }
  
  // ===== ConstrainedBox =====
  
  /// Add constraints
  /// Example: Text('Hello').constrained(maxWidth: 200)
  Widget constrained({
    double? minWidth,
    double? maxWidth,
    double? minHeight,
    double? maxHeight,
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: minWidth ?? 0,
        maxWidth: maxWidth ?? double.infinity,
        minHeight: minHeight ?? 0,
        maxHeight: maxHeight ?? double.infinity,
      ),
      child: this,
    );
  }
  
  // ===== Baseline =====
  
  /// Align text baseline
  /// Example: Text('Hello').baseline(TextBaseline.alphabetic)
  Widget baseline(TextBaseline baseline, double baselineOffset) {
    return Baseline(
      baseline: baselineOffset,
      baselineType: baseline,
      child: this,
    );
  }
  
  // ===== IgnorePointer =====
  
  /// Ignore pointer events
  /// Example: Button().ignorePointer(isLoading)
  Widget ignorePointer(bool ignoring) {
    return IgnorePointer(
      ignoring: ignoring,
      child: this,
    );
  }
  
  // ===== AbsorbPointer =====
  
  /// Absorb pointer events
  /// Example: Container().absorbPointer(true)
  Widget absorbPointer(bool absorbing) {
    return AbsorbPointer(
      absorbing: absorbing,
      child: this,
    );
  }
}