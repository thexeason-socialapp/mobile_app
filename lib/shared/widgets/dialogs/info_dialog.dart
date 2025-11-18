import 'package:flutter/material.dart';

/// Info Dialog - Displays informational messages
class InfoDialog extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback? onPressed;
  final IconData icon;
  final Color iconColor;

  const InfoDialog({
    super.key,
    required this.title,
    required this.message,
    this.buttonText = 'OK',
    this.onPressed,
    this.icon = Icons.info_outline,
    this.iconColor = const Color(0xFFFFC107),
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(title)),
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
            backgroundColor: const Color(0xFFFFC107),
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

  /// Show info dialog
  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = 'OK',
    IconData icon = Icons.info_outline,
    Color iconColor = const Color(0xFFFFC107),
  }) {
    return showDialog(
      context: context,
      builder: (context) => InfoDialog(
        title: title,
        message: message,
        buttonText: buttonText,
        icon: icon,
        iconColor: iconColor,
      ),
    );
  }
}

/// Success Dialog - Displays success messages
class SuccessDialog extends InfoDialog {
  const SuccessDialog({
    super.key,
    required super.title,
    required super.message,
    super.buttonText = 'Great!',
    super.onPressed,
  }) : super(
          icon: Icons.check_circle_outline,
          iconColor: Colors.green,
        );

  /// Show success dialog
  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = 'Great!',
  }) {
    return showDialog(
      context: context,
      builder: (context) => SuccessDialog(
        title: title,
        message: message,
        buttonText: buttonText,
      ),
    );
  }
}
