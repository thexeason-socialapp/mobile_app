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
class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Initialize auth state
    await ref.read(authProvider.notifier).initializeAuth();
    
    // Add a small delay for smooth UX
    await Future.delayed(const Duration(seconds: 1));
    
    // Navigation will be handled by GoRouter redirect
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.bolt,
                size: 60,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Thexeason',
              style: AppTypography.display(
                color: AppColors.secondary,
                // size: 32,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Connect with the world',
              style: AppTypography.body(
                color: AppColors.secondary.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondary),
            ),
          ],
        ),
      ),
    );
  }
}

// ===== WELCOME PAGE =====
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              const Spacer(flex: 1),
              
              // App logo
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Icon(
                  Icons.bolt,
                  size: 50,
                  color: AppColors.primary,
                ),
              ),
              
              const SizedBox(height: 32),
              
              Text(
                'Welcome to Thexeason',
                style: AppTypography.display(
                  color: AppColors.secondary,
                  // size: 28,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 16),
              
              Text(
                'Connect, share, and discover amazing content from people around the world',
                style: AppTypography.body(
                  color: AppColors.secondary.withOpacity(0.9),
                  // size: 16,
                ),
                textAlign: TextAlign.center,
              ),
              
              const Spacer(flex: 2),
              
              // Sign Up Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => context.go('/signup'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Create Account',
                    style: AppTypography.body(
                      weight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Login Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () => context.go('/login'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.secondary,
                    side: const BorderSide(color: AppColors.secondary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Sign In',
                    style: AppTypography.body(
                      weight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// ===== FORGOT PASSWORD PAGE =====
// class ForgotPasswordPage extends ConsumerStatefulWidget {
//   const ForgotPasswordPage({super.key});

//   @override
//   ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
// }

// class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   bool _emailSent = false;

//   @override
//   void dispose() {
//     _emailController.dispose();
//     super.dispose();
//   }

//   Future<void> _sendResetEmail() async {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }

//     final result = await ref.read(authProvider.notifier).resetPassword(
//       _emailController.text.trim(),
//     );

//     if (mounted) {
//       result.fold(
//         (failure) {
//           // Error is shown by the provider
//         },
//         (success) {
//           setState(() {
//             _emailSent = true;
//           });
//         },
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authState = ref.watch(authProvider);

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Color(0xFF111827)),
//           onPressed: () => context.go('/login'),
//         ),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(AppSpacing.lg),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 const SizedBox(height: 32),
                
//                 // Icon
//                 Container(
//                   height: 80,
//                   width: 80,
//                   decoration: BoxDecoration(
//                     color: AppColors.primary.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(40),
//                   ),
//                   child: Icon(
//                     _emailSent ? Icons.mark_email_read : Icons.lock_reset,
//                     size: 40,
//                     color: AppColors.primary,
//                   ),
//                 ).center(),
                
//                 const SizedBox(height: 32),
                
//                 Text(
//                   _emailSent ? 'Check Your Email' : 'Reset Password',
//                   style: AppTypography.display(
//                     color: const Color(0xFF111827),
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
                
//                 const SizedBox(height: 16),
                
//                 Text(
//                   _emailSent
//                       ? 'We\'ve sent a password reset link to ${_emailController.text}'
//                       : 'Enter your email and we\'ll send you a link to reset your password',
//                   style: AppTypography.body(
//                     color: Colors.grey[600],
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
                
//                 const SizedBox(height: 48),
                
//                 if (!_emailSent) ...[
//                   // Email Field
//                   AuthTextField(
//                     controller: _emailController,
//                     labelText: 'Email',
//                     hintText: 'Enter your email',
//                     keyboardType: TextInputType.emailAddress,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Email is required';
//                       }
//                       if (!value.contains('@')) {
//                         return 'Enter a valid email';
//                       }
//                       return null;
//                     },
//                     prefixIcon: const Icon(Icons.email_outlined),
//                     onSubmitted: (_) => _sendResetEmail(),
//                   ),
                  
//                   const SizedBox(height: 32),
                  
//                   // Error Message
//                   if (authState.error != null) ...[
//                     Container(
//                       padding: const EdgeInsets.all(AppSpacing.md),
//                       decoration: BoxDecoration(
//                         color: Colors.red[50],
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(color: Colors.red[200]!),
//                       ),
//                       child: Text(
//                         authState.error!,
//                         style: AppTypography.body(color: Colors.red[700]),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                   ],
                  
//                   // Send Reset Button
//                   AuthButton(
//                     text: 'Send Reset Link',
//                     onPressed: _sendResetEmail,
//                     isLoading: authState.isLoading,
//                   ),
//                 ] else ...[
//                   // Success state
//                   Container(
//                     padding: const EdgeInsets.all(AppSpacing.lg),
//                     decoration: BoxDecoration(
//                       color: Colors.green[50],
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: Colors.green[200]!),
//                     ),
//                     child: Text(
//                       'If an account with that email exists, you\'ll receive a password reset email shortly.',
//                       style: AppTypography.body(color: Colors.green[700]),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
                  
//                   const SizedBox(height: 32),
                  
//                   // Back to Login Button
//                   AuthButton(
//                     text: 'Back to Login',
//                     onPressed: () => context.go('/login'),
//                   ),
//                 ],
                
//                 const SizedBox(height: 24),
                
//                 // Back to Login Link
//                 if (!_emailSent)
//                   TextButton(
//                     onPressed: () => context.go('/login'),
//                     child: Text(
//                       'Back to Login',
//                       style: AppTypography.body(
//                         color: AppColors.primary,
//                         weight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

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