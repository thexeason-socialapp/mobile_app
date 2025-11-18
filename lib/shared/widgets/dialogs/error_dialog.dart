import 'package:flutter/material.dart';

/// Error Dialog - Displays error messages
class ErrorDialog extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback? onPressed;

  const ErrorDialog({
    super.key,
    this.title = 'Error',
    required this.message,
    this.buttonText = 'OK',
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 28,
          ),
          const SizedBox(width: 12),
          Text(title),
        ],
      ),
      content: Text(message),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            onPressed?.call();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(buttonText),
        ),
      ],
    );
  }

  /// Show error dialog
  static Future<void> show(
    BuildContext context, {
    String title = 'Error',
    required String message,
    String buttonText = 'OK',
  }) {
    return showDialog(
      context: context,
      builder: (context) => ErrorDialog(
        title: title,
        message: message,
        buttonText: buttonText,
      ),
    );
  }
}
