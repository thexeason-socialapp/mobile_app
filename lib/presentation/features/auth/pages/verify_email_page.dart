import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../providers/auth_state_provider.dart';
import '../widgets/auth_button.dart';
// import '../widgets/auth_text_field.dart';

// ===== SPLASH PAGE =====


// ===== EMAIL VERIFICATION PAGE =====
class EmailVerificationPage extends ConsumerWidget {
  const EmailVerificationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              const Spacer(),
              
              // Icon
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(
                  Icons.mark_email_unread,
                  size: 50,
                  color: AppColors.primary,
                ),
              ),
              
              const SizedBox(height: 32),
              
              Text(
                'Verify Your Email',
                style: AppTypography.display(
                  color: const Color(0xFF111827),
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 16),
              
              Text(
                'We\'ve sent a verification email to your inbox. Please click the link to verify your account.',
                style: AppTypography.body(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 48),
              
              // Resend Email Button
              AuthButton(
                text: 'Resend Verification Email',
                onPressed: () async {
                  await ref.read(authProvider.notifier).verifyEmail();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Verification email sent!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
              ),
              
              const SizedBox(height: 16),
              
              // Continue Button
              OutlinedButton(
                onPressed: () => context.go('/home'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                ),
                child: const Text('Continue to App'),
              ),
              
              const Spacer(),
              
              // Logout Button
              TextButton(
                onPressed: () async {
                  await ref.read(authProvider.notifier).logout();
                },
                child: Text(
                  'Sign out',
                  style: AppTypography.body(
                    color: Colors.red[600],
                    weight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Extension for centering widgets
extension WidgetExtensions on Widget {
  Widget center() => Center(child: this);
}