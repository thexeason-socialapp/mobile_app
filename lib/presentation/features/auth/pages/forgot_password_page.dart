import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thexeasonapp/core/extensions/widget_extensions.dart';

import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/utils/validators.dart';
import '../providers/auth_state_provider.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_button.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    // Clear keyboard
    context.unfocus();
    
    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Call reset password use case through provider
    final result = await ref.read(authProvider.notifier).resetPassword(
      _emailController.text.trim(),
    );

    if (mounted) {
      result.fold(
        (failure) {
          context.showErrorSnackBar(failure.message);
        },
        (success) {
          setState(() {
            _emailSent = true;
          });
          context.showSuccessSnackBar('Password reset link sent to your email');
        },
      );
    }
  }

  void _navigateBack() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _navigateBack,
        ),
        title: Text(
          'Reset Password',
          style: AppTypography.title(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: _emailSent ? _buildSuccessState() : _buildFormState(authState),
        ),
      ),
    );
  }

  Widget _buildFormState(AuthState authState) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpacing.xl),
          
          // Icon
          Icon(
            Icons.lock_reset_outlined,
            size: 80,
            color: context.colorScheme.primary,
          ).center(),
          
          const SizedBox(height: AppSpacing.xl),
          
          // Title
          Text(
            'Forgot Password?',
            style: AppTypography.headline(
              color: context.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: AppSpacing.sm),
          
          // Description
          Text(
            'Enter your email address and we\'ll send you a link to reset your password.',
            style: AppTypography.body(
              color: context.colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: AppSpacing.xxl),
          
          // Email Field
          AuthTextField(
            controller: _emailController,
            labelText: 'Email Address',
            hintText: 'Enter your email',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            validator: Validators.email,
            prefixIcon: const Icon(Icons.email_outlined),
            onSubmitted: (_) => _resetPassword(),
          ),
          
          const SizedBox(height: AppSpacing.xl),
          
          // Reset Button
          AuthButton(
            text: 'Send Reset Link',
            onPressed: _resetPassword,
            isLoading: authState.isLoading,
          ),
          
          const SizedBox(height: AppSpacing.lg),
          
          // Back to Login
          TextButton(
            onPressed: _navigateBack,
            child: Text(
              'Back to Login',
              style: AppTypography.body(
                color: context.colorScheme.primary,
                weight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.xxl),
        
        // Success Icon
        Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(40),
          ),
          child: const Icon(
            Icons.check_circle_outline,
            size: 40,
            color: Colors.green,
          ),
        ).center(),
        
        const SizedBox(height: AppSpacing.xl),
        
        // Success Title
        Text(
          'Check Your Email',
          style: AppTypography.headline(
            color: context.colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: AppSpacing.sm),
        
        // Success Description
        Text(
          'We\'ve sent a password reset link to\n${_emailController.text.trim()}',
          style: AppTypography.body(
            color: context.colorScheme.onSurface.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: AppSpacing.xxl),
        
        // Resend Button
        AuthButton.outline(
          text: 'Resend Email',
          onPressed: () {
            setState(() {
              _emailSent = false;
            });
          },
        ),
        
        const SizedBox(height: AppSpacing.lg),
        
        // Back to Login
        TextButton(
          onPressed: _navigateBack,
          child: Text(
            'Back to Login',
            style: AppTypography.body(
              color: context.colorScheme.primary,
              weight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}