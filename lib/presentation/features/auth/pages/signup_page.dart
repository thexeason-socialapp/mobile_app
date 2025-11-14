import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/utils/validators.dart';
// import '../../providers/auth_provider.dart';
import '../providers/auth_state_provider.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_button.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _displayNameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    // Clear keyboard
    context.unfocus();
    
    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Check terms acceptance
    if (!_acceptTerms) {
      context.showErrorSnackBar('Please accept the Terms of Service');
      return;
    }

    // Call sign up use case through provider
    final result = await ref.read(authProvider.notifier).signUp(
      email: _emailController.text.trim(),
      username: _usernameController.text.trim(),
      displayName: _displayNameController.text.trim(),
      password: _passwordController.text,
    );

    if (mounted) {
      result.fold(
        (failure) {
          context.showErrorSnackBar(failure.message);
        },
        (user) {
          context.showSuccessSnackBar('Account created! Please verify your email.');
          // Navigation will be handled by app router based on auth state
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
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Text(
                  'Create Account',
                  style: AppTypography.display(
                    color: context.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: AppSpacing.sm),
                
                Text(
                  'Join the conversation',
                  style: AppTypography.body(
                    color: context.colorScheme.onSurface.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: AppSpacing.xl),
                
                // Display Name Field
                AuthTextField(
                  controller: _displayNameController,
                  labelText: 'Full Name',
                  hintText: 'Enter your full name',
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  validator: Validators.displayName,
                  prefixIcon: const Icon(Icons.person_outline),
                ),
                
                const SizedBox(height: AppSpacing.md),
                
                // Username Field
                AuthTextField(
                  controller: _usernameController,
                  labelText: 'Username',
                  hintText: 'Choose a username',
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  validator: Validators.username,
                  prefixIcon: const Icon(Icons.alternate_email),
                ),
                
                const SizedBox(height: AppSpacing.md),
                
                // Email Field
                AuthTextField(
                  controller: _emailController,
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: Validators.email,
                  prefixIcon: const Icon(Icons.email_outlined),
                ),
                
                const SizedBox(height: AppSpacing.md),
                
                // Password Field
                AuthTextField(
                  controller: _passwordController,
                  labelText: 'Password',
                  hintText: 'Create a password',
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.next,
                  validator: Validators.password,
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                
                const SizedBox(height: AppSpacing.md),
                
                // Confirm Password Field
                AuthTextField(
                  controller: _confirmPasswordController,
                  labelText: 'Confirm Password',
                  hintText: 'Confirm your password',
                  obscureText: _obscureConfirmPassword,
                  textInputAction: TextInputAction.done,
                  validator: (value) => Validators.confirmPassword(value, _passwordController.text),
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                  onSubmitted: (_) => _signUp(),
                ),
                
                const SizedBox(height: AppSpacing.lg),
                
                // Terms and Conditions
                Row(
                  children: [
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: Checkbox(
                        value: _acceptTerms,
                        onChanged: (value) {
                          setState(() {
                            _acceptTerms = value ?? false;
                          });
                        },
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: context.colorScheme.onSurface.withOpacity(0.8),
                          ),
                          children: [
                            const TextSpan(text: 'I agree to the '),
                            TextSpan(
                              text: 'Terms of Service',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: AppSpacing.xl),
                
                // Sign Up Button
                AuthButton(
                  text: 'Create Account',
                  onPressed: _signUp,
                  isLoading: authState.isLoading,
                ),
                
                const SizedBox(height: AppSpacing.lg),
                
                // Divider
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: context.colorScheme.outline.withOpacity(0.5),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      child: Text(
                        'OR',
                        style: AppTypography.caption(
                          color: context.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: context.colorScheme.outline.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: AppSpacing.lg),
                
                // Social Sign Up Buttons (placeholder)
                OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Implement Google sign up
                    context.showInfoSnackBar('Google sign-up coming soon!');
                  },
                  icon: const Icon(Icons.g_mobiledata, size: 24),
                  label: const Text('Sign up with Google'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  ),
                ),
                
                const SizedBox(height: AppSpacing.xl),
                
                // Sign In Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: AppTypography.body(
                        color: context.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    TextButton(
                      onPressed: _navigateBack,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                      ),
                      child: Text(
                        'Sign in',
                        style: AppTypography.body(
                          color: AppColors.primary,
                          weight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}