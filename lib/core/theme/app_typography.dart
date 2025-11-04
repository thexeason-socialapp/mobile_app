import 'package:flutter/material.dart';

class AppTypography {
  AppTypography._();
  
  static const String fontFamily = 'Inter';
  
  // Display
  static TextStyle display({
    Color? color,
    FontWeight? weight,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 32,
      fontWeight: weight ?? FontWeight.w700,
      color: color,
      height: 1.2,
    );
  }
  
  // Headline
  static TextStyle headline({
    Color? color,
    FontWeight? weight,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 24,
      fontWeight: weight ?? FontWeight.w700,
      color: color,
      height: 1.3,
    );
  }
  
  // Title
  static TextStyle title({
    Color? color,
    FontWeight? weight,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 18,
      fontWeight: weight ?? FontWeight.w600,
      color: color,
      height: 1.4,
    );
  }
  
  // Body Large
  static TextStyle bodyLarge({
    Color? color,
    FontWeight? weight,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 16,
      fontWeight: weight ?? FontWeight.w500,
      color: color,
      height: 1.5,
    );
  }
  
  // Body
  static TextStyle body({
    Color? color,
    FontWeight? weight,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 14,
      fontWeight: weight ?? FontWeight.w400,
      color: color,
      height: 1.5,
    );
  }
  
  // Caption
  static TextStyle caption({
    Color? color,
    FontWeight? weight,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 12,
      fontWeight: weight ?? FontWeight.w400,
      color: color,
      height: 1.4,
    );
  }
  
  // Tiny
  static TextStyle tiny({
    Color? color,
    FontWeight? weight,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 10,
      fontWeight: weight ?? FontWeight.w400,
      color: color,
      height: 1.4,
    );
  }
}