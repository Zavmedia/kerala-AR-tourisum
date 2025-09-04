import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/login_form_widget.dart';
import './widgets/logo_header_widget.dart';
import './widgets/signup_prompt_widget.dart';
import './widgets/social_login_widget.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final ScrollController _scrollController = ScrollController();
  bool _isKeyboardVisible = false;

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

                            // Login form
                            LoginFormWidget(
                              onLogin: _handleLogin,
                              onForgotPassword: _handleForgotPassword,
                            ),
                            SizedBox(height: 4.h),

                            // Social login options
                            SocialLoginWidget(
                              onGoogleLogin: _handleGoogleLogin,
                              onOtpLogin: _handleOtpLogin,
                            ),
                            SizedBox(height: 4.h),

                            // Sign up prompt
                            SignupPromptWidget(
                              onSignUp: _handleSignUp,
                            ),
                            SizedBox(height: 2.h),

                            // Additional features info
                            if (!_isKeyboardVisible)
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
          'Welcome Back!',
          style: theme.textTheme.headlineMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Sign in to continue your heritage journey',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.7),
          ),
          textAlign: TextAlign.center,
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

  void _handleLogin() {
    // Trigger haptic feedback
    HapticFeedback.lightImpact();

    // Navigate to heritage dashboard
    Navigator.pushReplacementNamed(context, '/heritage-dashboard');
  }

  void _handleForgotPassword() {
    // Show forgot password dialog or navigate to forgot password screen
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

  void _handleGoogleLogin() {
    // Show loading and simulate Google OAuth
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // Close loading dialog
      HapticFeedback.lightImpact();
      Navigator.pushReplacementNamed(context, '/heritage-dashboard');
    });
  }

  void _handleOtpLogin() {
    // Navigate to OTP verification screen or show OTP dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('OTP Login'),
        content: const Text(
            'OTP-based authentication will be available soon. Please use email/password login for now.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _handleSignUp() {
    // Navigate to sign up screen or show sign up dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Up'),
        content: const Text(
            'Registration functionality will be available soon. Please use the demo credentials to explore the app.'),
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