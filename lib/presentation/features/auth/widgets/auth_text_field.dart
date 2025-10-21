import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField({super.key, required this.controller, required this.title, required this.type});
  final TextEditingController controller;
  final String title;
  final TextInputType type;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration:InputDecoration(),
      keyboardType: type,
      
    );
  }
}