import 'package:flutter/material.dart';
import 'package:thexeasonapp/demo.dart';
import 'package:thexeasonapp/src/onboarding/onboarding.dart';
import './src/theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Xeason App',
      themeMode: ThemeMode.light,
      darkTheme: darkTheme,
      theme: lightTheme,
      home: const Onboarding(),
    );
  }
}

