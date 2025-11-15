import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thexeasonapp/core/extensions/context_extensions.dart';

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
                'We\'ve sent a verification email to your inbox. Please click the link to verify your account and then refresh this page.',
                style: AppTypography.body(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 48),
              
              // Check Verification Status Button
              AuthButton(
                text: 'I\'ve Verified - Continue',
                onPressed: () async {
                  // Force reload user to check verification status
                  await ref.read(authProvider.notifier).reloadUser();
                  
                  // Router will automatically handle navigation based on verification status
                },
              ),
              
              const SizedBox(height: 16),
              
              // Resend Email Button
              OutlinedButton(
                onPressed: () async {
                  final result = await ref.read(authProvider.notifier).verifyEmail();
                  if (context.mounted) {
                    result.fold(
                      (failure) => context.showErrorSnackBar(failure.message),
                      (_) => context.showSuccessSnackBar('Verification email sent!'),
                    );
                  }
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                ),
                child: const Text('Resend Verification Email'),
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