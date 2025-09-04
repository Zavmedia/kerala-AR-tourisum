import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

class EnhancedAuthenticationScreen extends StatefulWidget {
  const EnhancedAuthenticationScreen({super.key});

  @override
  State<EnhancedAuthenticationScreen> createState() => _EnhancedAuthenticationScreenState();
}

class _EnhancedAuthenticationScreenState extends State<EnhancedAuthenticationScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final ScrollController _scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  bool _isKeyboardVisible = false;
  bool _isLoading = false;
  bool _isLoginMode = true;
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _setupKeyboardListener();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    // Start animations
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _slideController.forward();
    });
  }

  void _setupKeyboardListener() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Remove the incorrect MediaQueryData listener approach
      // MediaQuery data is immutable and doesn't have addListener
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scrollController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    // Check keyboard visibility using MediaQuery in build method
    final mediaQuery = MediaQuery.of(context);
    final isKeyboardVisible = mediaQuery.viewInsets.bottom > 0;
    
    // Update keyboard visibility state if changed
    if (_isKeyboardVisible != isKeyboardVisible) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _isKeyboardVisible = isKeyboardVisible;
        });
      });
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: 100.h - MediaQuery.of(context).padding.top,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: _isKeyboardVisible ? 4.h : 8.h),

                            // Logo and header
                            const LogoHeaderWidget(),
                            SizedBox(height: _isKeyboardVisible ? 4.h : 6.h),

                            // Welcome text
                            _buildWelcomeSection(theme, colorScheme),
                            SizedBox(height: 4.h),

                            // Error message
                            if (_errorMessage != null) _buildErrorMessage(),
                            if (_errorMessage != null) SizedBox(height: 2.h),

                            // Login/Register form
                            _buildAuthForm(theme, colorScheme),
                            SizedBox(height: 4.h),

                            // Social login options
                            if (!_isLoading) _buildSocialLoginOptions(),
                            if (!_isLoading) SizedBox(height: 4.h),

                            // Toggle between login and register
                            if (!_isLoading) _buildToggleAuthMode(),
                            SizedBox(height: 2.h),

                            // Additional features info
                            if (!_isKeyboardVisible && !_isLoading)
                              _buildFeaturesInfo(theme, colorScheme),
                            SizedBox(height: 2.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      children: [
        Text(
          _isLoginMode ? 'Welcome Back!' : 'Create Account',
          style: theme.textTheme.headlineMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          _isLoginMode 
            ? 'Sign in to continue your heritage journey'
            : 'Join us to explore Kerala\'s cultural heritage',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'error',
            color: AppTheme.lightTheme.colorScheme.error,
            size: 5.w,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              _errorMessage!,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthForm(ThemeData theme, ColorScheme colorScheme) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Name field (only for registration)
          if (!_isLoginMode) ...[
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                prefixIcon: CustomIconWidget(
                  iconName: 'person',
                  color: colorScheme.primary,
                  size: 5.w,
                ),
              ),
              validator: (value) {
                if (!_isLoginMode && (value == null || value.trim().isEmpty)) {
                  return 'Please enter your full name';
                }
                return null;
              },
            ),
            SizedBox(height: 3.h),
          ],

          // Email field
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email',
              prefixIcon: CustomIconWidget(
                iconName: 'email',
                color: colorScheme.primary,
                size: 5.w,
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          SizedBox(height: 3.h),

          // Password field
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: CustomIconWidget(
                iconName: 'lock',
                color: colorScheme.primary,
                size: 5.w,
              ),
              suffixIcon: IconButton(
                icon: CustomIconWidget(
                  iconName: _obscurePassword ? 'visibility' : 'visibility_off',
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                  size: 5.w,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (!_isLoginMode && value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          SizedBox(height: 3.h),

          // Forgot password (only for login)
          if (_isLoginMode) ...[
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _handleForgotPassword,
                child: Text(
                  'Forgot Password?',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(height: 2.h),
          ],

          // Submit button
          SizedBox(
            width: double.infinity,
            height: 6.h,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                ? SizedBox(
                    width: 5.w,
                    height: 5.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(colorScheme.onPrimary),
                    ),
                  )
                : Text(
                    _isLoginMode ? 'Sign In' : 'Create Account',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialLoginOptions() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'Or continue with',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ),
            Expanded(child: Divider()),
          ],
        ),
        SizedBox(height: 3.h),
        Row(
          children: [
            Expanded(
              child: _buildSocialButton(
                'Google',
                'google',
                AppTheme.lightTheme.colorScheme.error,
                _handleGoogleLogin,
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: _buildSocialButton(
                'OTP',
                'phone',
                AppTheme.lightTheme.colorScheme.secondary,
                _handleOtpLogin,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton(String label, String iconName, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 6.h,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: color,
              size: 5.w,
            ),
            SizedBox(width: 2.w),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleAuthMode() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _isLoginMode ? 'Don\'t have an account? ' : 'Already have an account? ',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        GestureDetector(
          onTap: _toggleAuthMode,
          child: Text(
            _isLoginMode ? 'Sign Up' : 'Sign In',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturesInfo(ThemeData theme, ColorScheme colorScheme) {
    final features = [
      {'icon': 'camera_alt', 'text': 'AR Heritage Walks'},
      {'icon': 'map', 'text': 'AI Trip Planning'},
      {'icon': 'photo_library', 'text': 'Memory Sharing'},
    ];

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: [
          Text(
            'Explore Kerala Like Never Before',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: features.map((feature) {
              return Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: CustomIconWidget(
                      iconName: feature['icon']!,
                      color: colorScheme.primary,
                      size: 6.w,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    feature['text']!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _toggleAuthMode() {
    setState(() {
      _isLoginMode = !_isLoginMode;
      _errorMessage = null;
      _emailController.clear();
      _passwordController.clear();
      _nameController.clear();
    });
  }

  void _setError(String message) {
    setState(() {
      _errorMessage = message;
    });
  }

  void _clearError() {
    setState(() {
      _errorMessage = null;
    });
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    _clearError();
    setState(() {
      _isLoading = true;
    });

    try {
      HapticFeedback.lightImpact();
      
      final authService = ServiceManager.instance.auth;
      AuthResult result;

      if (_isLoginMode) {
        result = await authService.login(
          _emailController.text.trim(),
          _passwordController.text,
        );
      } else {
        result = await authService.register(
          _emailController.text.trim(),
          _passwordController.text,
          _nameController.text.trim(),
        );
      }

      if (result.isSuccess) {
        // Navigate to heritage dashboard
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/heritage-dashboard');
        }
      } else {
        _setError(result.error ?? 'Authentication failed');
      }
    } catch (e) {
      _setError('An unexpected error occurred: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleGoogleLogin() async {
    _clearError();
    setState(() {
      _isLoading = true;
    });

    try {
      HapticFeedback.lightImpact();
      
      final authService = ServiceManager.instance.auth;
      final result = await authService.loginWithGoogle();

      if (result.isSuccess) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/heritage-dashboard');
        }
      } else {
        _setError(result.error ?? 'Google login failed');
      }
    } catch (e) {
      _setError('Google login failed: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleOtpLogin() async {
    _clearError();
    
    // Show OTP input dialog
    final phoneNumber = await _showOtpDialog();
    if (phoneNumber == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      HapticFeedback.lightImpact();
      
      final authService = ServiceManager.instance.auth;
      final result = await authService.loginWithOTP(phoneNumber);

      if (result.isSuccess) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/heritage-dashboard');
        }
      } else {
        _setError(result.error ?? 'OTP login failed');
      }
    } catch (e) {
      _setError('OTP login failed: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<String?> _showOtpDialog() async {
    final phoneController = TextEditingController();
    
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter Phone Number'),
        content: TextFormField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'Phone Number',
            hintText: '+91 9876543210',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, phoneController.text),
            child: const Text('Send OTP'),
          ),
        ],
      ),
    );
  }

  void _handleForgotPassword() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Forgot Password'),
        content: const Text(
            'Password reset functionality will be available soon. Please contact support for assistance.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
