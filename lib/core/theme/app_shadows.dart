import 'package:flutter/material.dart';

class AppShadows {
  AppShadows._();
  
  // Light Shadow
  static List<BoxShadow> light = [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      offset: const Offset(0, 2),
      blurRadius: 4,
      spreadRadius: 0,
    ),
  ];
  
  // Medium Shadow
  static List<BoxShadow> medium = [
    BoxShadow(
      color: Colors.black.withOpacity(0.12),
      offset: const Offset(0, 4),
      blurRadius: 12,
      spreadRadius: 0,
    ),
  ];
  
  // Heavy Shadow
  static List<BoxShadow> heavy = [
    BoxShadow(
      color: Colors.black.withOpacity(0.16),
      offset: const Offset(0, 8),
      blurRadius: 24,
      spreadRadius: 0,
    ),
  ];
  
  // Card Shadow
  static List<BoxShadow> card = [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      offset: const Offset(0, 2),
      blurRadius: 8,
      spreadRadius: 0,
    ),
  ];
}