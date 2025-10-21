import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({super.key, required this.action, required this.title});
  final VoidCallback action;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: action,
      style: Theme.of(context).elevatedButtonTheme.style,
      child: Text(title),

    );
  }
}