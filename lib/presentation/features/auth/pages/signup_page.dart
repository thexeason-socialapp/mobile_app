import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../../../shared/widgets/buttons/secondary_button.dart';
import '../../../../shared/widgets/inputs/text_field_custom.dart';
// import '../../../../shared/widgets/loaders/loading_spinner.dart';
import '../../../../shared/widgets/animations/fade_in_animation.dart';
import '../providers/auth_state_provider.dart';

/// Multi-step signup flow with animations and validation
class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage>
    with TickerProviderStateMixin {
  // Controllers
  final PageController _pageController = PageController();
  final _displayNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Form keys for each step
  final _step1FormKey = GlobalKey<FormState>();
  final _step2FormKey = GlobalKey<FormState>();
  final _step3FormKey = GlobalKey<FormState>();

  // Animation controllers
  late AnimationController _stepAnimationController;
  late AnimationController _usernameCheckController;
  late Animation<double> _stepAnimation;
  late Animation<double> _usernameCheckAnimation;

  // State variables
  int _currentStep = 0;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;
  bool _isCheckingUsername = false;
  bool _isUsernameAvailable = false;
  String? _usernameCheckMessage;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _stepAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _usernameCheckController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _stepAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _stepAnimationController, curve: Curves.easeInOut),
    );

    _usernameCheckAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _usernameCheckController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _displayNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _stepAnimationController.dispose();
    _usernameCheckController.dispose();
    super.dispose();
  }

  /// Username availability check with animation
  Future<void> _checkUsernameAvailability() async {
    final username = _usernameController.text.trim();
    
    if (username.length < 3) {
      setState(() {
        _usernameCheckMessage = null;
        _isUsernameAvailable = false;
      });
      return;
    }

    setState(() {
      _isCheckingUsername = true;
      _usernameCheckMessage = null;
    });

    _usernameCheckController.forward();

    try {
      final result = await ref.read(authProvider.notifier).checkUsernameAvailable(username);
      
      await _usernameCheckController.reverse();
      
      if (mounted) {
        result.fold(
          (failure) {
            setState(() {
              _isCheckingUsername = false;
              _isUsernameAvailable = false;
              _usernameCheckMessage = failure.message;
            });
          },
          (isAvailable) {
            setState(() {
              _isCheckingUsername = false;
              _isUsernameAvailable = isAvailable;
              _usernameCheckMessage = isAvailable 
                  ? 'Username is available!' 
                  : 'Username is already taken';
            });
          },
        );
      }
    } catch (e) {
      if (mounted) {
        await _usernameCheckController.reverse();
        setState(() {
          _isCheckingUsername = false;
          _isUsernameAvailable = false;
          _usernameCheckMessage = 'Error checking username';
        });
      }
    }
  }

  /// Navigate to next step with animation
  Future<void> _nextStep() async {
    switch (_currentStep) {
      case 0:
        if (_step1FormKey.currentState!.validate()) {
          await _animateToStep(1);
        }
        break;
      case 1:
        if (_step2FormKey.currentState!.validate() && _isUsernameAvailable) {
          await _animateToStep(2);
        } else if (!_isUsernameAvailable) {
          context.showErrorSnackBar('Please choose an available username');
        }
        break;
      case 2:
        if (_step3FormKey.currentState!.validate() && _acceptTerms) {
          await _performSignUp();
        } else if (!_acceptTerms) {
          context.showErrorSnackBar('Please accept the Terms of Service');
        }
        break;
    }
  }

  /// Navigate to previous step
  Future<void> _previousStep() async {
    if (_currentStep > 0) {
      await _animateToStep(_currentStep - 1);
    }
  }

  /// Animate to specific step
  Future<void> _animateToStep(int step) async {
    await _stepAnimationController.reverse();
    setState(() {
      _currentStep = step;
    });
    await _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    _stepAnimationController.forward();
  }

  /// Perform the actual signup
  Future<void> _performSignUp() async {
  context.unfocus();

  // ✅ PRODUCTION FIX: Clear any existing auth state before signup
  ref.read(authProvider.notifier).clearAuthState();
  
  // Small delay to ensure state is properly cleared
  await Future.delayed(const Duration(milliseconds: 100));

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
        // Router will handle navigation directly to /verify-email
      },
    );
  }
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
          onPressed: () => _currentStep > 0 ? _previousStep() : GoRouterHelper(context).pop(),
        ),
        title: Text(
          'Create Account',
          style: AppTypography.title(color: context.colorScheme.onSurface),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress Indicator
            _buildProgressIndicator(),
            
            const SizedBox(height: AppSpacing.xl),
            
            // Page View
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildStep1(), // Personal Info
                  _buildStep2(), // Username & Email
                  _buildStep3(), // Password & Terms
                ],
              ),
            ),
            
            // Navigation Buttons
            _buildNavigationButtons(authState),
          ],
        ),
      ),
    );
  }

  /// Progress indicator widget
  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Row(
        children: List.generate(3, (index) {
          final isActive = index <= _currentStep;
          final isCompleted = index < _currentStep;
          
          return Expanded(
            child: Container(
              height: 4,
              margin: EdgeInsets.only(
                right: index < 2 ? AppSpacing.sm : 0,
              ),
              decoration: BoxDecoration(
                color: isCompleted 
                    ? AppColors.primary
                    : isActive 
                        ? AppColors.primary.withOpacity(0.5)
                        : Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  /// Step 1: Personal Information
  Widget _buildStep1() {
    return FadeInAnimation(
      duration: const Duration(milliseconds: 300),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Form(
          key: _step1FormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Let\'s get started',
                style: AppTypography.display(
                  color: context.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: AppSpacing.sm),
              
              Text(
                'Tell us about yourself',
                style: AppTypography.body(
                  color: context.colorScheme.onSurface.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: AppSpacing.xxl),
              
              TextFieldCustom(
                controller: _displayNameController,
                labelText: 'Full Name',
                hintText: 'Enter your full name',
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                validator: Validators.displayName,
                prefixIcon: const Icon(Icons.person_outline),
              ),
              
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  /// Step 2: Username & Email
  Widget _buildStep2() {
    return FadeInAnimation(
      duration: const Duration(milliseconds: 300),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Form(
          key: _step2FormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Choose your identity',
                style: AppTypography.display(
                  color: context.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: AppSpacing.sm),
              
              Text(
                'Pick a unique username and email',
                style: AppTypography.body(
                  color: context.colorScheme.onSurface.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: AppSpacing.xxl),
              
              // Username field with validation animation
              TextFieldCustom(
                controller: _usernameController,
                labelText: 'Username',
                hintText: 'Choose a username',
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                validator: Validators.username,
                prefixIcon: const Icon(Icons.alternate_email),
                suffixIcon: _buildUsernameValidationIcon(),
                onChanged: (value) {
                  // Debounce username checking
                  Future.delayed(const Duration(milliseconds: 500), () {
                    if (value == _usernameController.text && value.length >= 3) {
                      _checkUsernameAvailability();
                    }
                  });
                },
              ),
              
              // Username validation message
              if (_usernameCheckMessage != null) ...[
                const SizedBox(height: AppSpacing.xs),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: _isUsernameAvailable 
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _isUsernameAvailable ? Colors.green : Colors.red,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _isUsernameAvailable ? Icons.check_circle : Icons.error,
                        color: _isUsernameAvailable ? Colors.green : Colors.red,
                        size: 16,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        _usernameCheckMessage!,
                        style: AppTypography.caption(
                          color: _isUsernameAvailable ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              
              const SizedBox(height: AppSpacing.lg),
              
              TextFieldCustom(
                controller: _emailController,
                labelText: 'Email',
                hintText: 'Enter your email',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: Validators.email,
                prefixIcon: const Icon(Icons.email_outlined),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Step 3: Password & Terms
  Widget _buildStep3() {
    return FadeInAnimation(
      duration: const Duration(milliseconds: 300),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Form(
          key: _step3FormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Secure your account',
                style: AppTypography.display(
                  color: context.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: AppSpacing.sm),
              
              Text(
                'Create a strong password',
                style: AppTypography.body(
                  color: context.colorScheme.onSurface.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: AppSpacing.xxl),
              
              TextFieldCustom(
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
              
              const SizedBox(height: AppSpacing.lg),
              
              TextFieldCustom(
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
              ),
              
              const SizedBox(height: AppSpacing.xl),
              
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
            ],
          ),
        ),
      ),
    );
  }

  /// Username validation icon with animation
  Widget _buildUsernameValidationIcon() {
    if (_isCheckingUsername) {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
      );
    }

    if (_usernameCheckMessage != null) {
      return Icon(
        _isUsernameAvailable ? Icons.check_circle : Icons.error,
        color: _isUsernameAvailable ? Colors.green : Colors.red,
      );
    }

    return const SizedBox.shrink();
  }

  /// Navigation buttons
  Widget _buildNavigationButtons(AuthState authState) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        children: [
          PrimaryButton(
            text: _currentStep == 2 ? 'Create Account' : 'Continue',
            onPressed: _nextStep,
            isLoading: authState.isLoading,
            icon: _currentStep == 2 ? Icons.check : Icons.arrow_forward,
          ),
          
          if (_currentStep > 0) ...[
            const SizedBox(height: AppSpacing.md),
            SecondaryButton(
              text: 'Back',
              onPressed: _previousStep,
              icon: Icons.arrow_back,
            ),
          ],
          
          const SizedBox(height: AppSpacing.lg),
          
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
                onPressed: () => GoRouterHelper(context).pop(),
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
        ],
      ),
    );
  }
}