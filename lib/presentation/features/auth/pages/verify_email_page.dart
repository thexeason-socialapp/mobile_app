import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thexeasonapp/core/extensions/context_extensions.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../providers/auth_state_provider.dart';
import '../widgets/auth_button.dart';
class EmailVerificationPage extends ConsumerWidget {
  const EmailVerificationPage({super.key});

  @override

  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    
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
              
              // Check Verification Status Button
              // Check Verification Status Button
// Enhanced "I've Verified" button in your EmailVerificationPage

AuthButton(
  text: 'I\'ve Verified - Check Status',
  onPressed: () async {
    print('🔄 User clicked verification check button');
    
    await ref.read(authProvider.notifier).reloadUser();
    
    // Wait for state to update
    await Future.delayed(const Duration(milliseconds: 500));
    
    final authState = ref.read(authProvider);
    final user = authState.user;
    
    if (context.mounted) {
      if (user != null && user.isEmailVerified) {
        context.showSuccessSnackBar('Email verified! Redirecting...');
        
        // ✅ FORCE NAVIGATION since router isn't detecting the change
        await Future.delayed(const Duration(milliseconds: 500));
        if (context.mounted) {
          context.go('/home');
        }
      } else {
        context.showErrorSnackBar('Email not yet verified. Please check your inbox.');
      }
    }
  },
  isLoading: authState.isLoading,
),
              
              const SizedBox(height: 16),
              
              // Resend Email Button
              OutlinedButton(
                onPressed: authState.isLoading ? null : () async {
                  print('📧 Resending verification email...');
                  final result = await ref.read(authProvider.notifier).verifyEmail();
                  
                  if (context.mounted) {
                    result.fold(
                      (failure) => context.showErrorSnackBar(failure.message),
                      (_) => context.showSuccessSnackBar('Verification email sent! Check your inbox.'),
                    );
                  }
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                ),
                child: const Text('Resend Verification Email'),
              ),
              
              // Show current auth state for debugging
             
              
              const Spacer(),
              
              // Logout Button
              TextButton(
                onPressed: authState.isLoading ? null : () async {
                  await ref.read(authProvider.notifier).logout();
                  context.go('/splash');
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