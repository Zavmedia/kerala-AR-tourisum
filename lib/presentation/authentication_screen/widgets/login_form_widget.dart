import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class LoginFormWidget extends StatefulWidget {
  final VoidCallback? onLogin;
  final VoidCallback? onForgotPassword;

  const LoginFormWidget({
    super.key,
    this.onLogin,
    this.onForgotPassword,
  });

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  String _selectedCountryCode = '+91';

  final List<Map<String, String>> _countryCodes = [
    {'code': '+91', 'country': 'IN'},
    {'code': '+1', 'country': 'US'},
    {'code': '+44', 'country': 'UK'},
    {'code': '+971', 'country': 'AE'},
  ];

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool get _isFormValid {
    return _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _isValidEmailOrPhone(_emailController.text);
  }

  bool _isValidEmailOrPhone(String input) {
    // Email validation
    if (input.contains('@')) {
      return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(input);
    }
    // Phone validation
    return RegExp(r'^\d{10}$').hasMatch(input);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Email/Phone field
          _buildInputField(
            context: context,
            colorScheme: colorScheme,
            controller: _emailController,
            label: 'Email or Phone',
            hintText: 'Enter your email or phone number',
            keyboardType: TextInputType.emailAddress,
            prefixWidget: _emailController.text.isNotEmpty &&
                    !_emailController.text.contains('@')
                ? _buildCountryCodeSelector(colorScheme)
                : null,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email or phone number';
              }
              if (!_isValidEmailOrPhone(value)) {
                return 'Please enter a valid email or phone number';
              }
              return null;
            },
          ),
          SizedBox(height: 2.h),

          // Password field
          _buildInputField(
            context: context,
            colorScheme: colorScheme,
            controller: _passwordController,
            label: 'Password',
            hintText: 'Enter your password',
            obscureText: !_isPasswordVisible,
            suffixWidget: GestureDetector(
              onTap: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
              child: CustomIconWidget(
                iconName: _isPasswordVisible ? 'visibility_off' : 'visibility',
                color: colorScheme.onSurface.withValues(alpha: 0.6),
                size: 20,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          SizedBox(height: 1.h),

          // Forgot password link
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: widget.onForgotPassword,
              child: Text(
                'Forgot Password?',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          SizedBox(height: 4.h),

          // Login button
          SizedBox(
            width: double.infinity,
            height: 6.h,
            child: ElevatedButton(
              onPressed: _isFormValid && !_isLoading ? _handleLogin : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isFormValid
                    ? colorScheme.primary
                    : colorScheme.outline.withValues(alpha: 0.3),
                foregroundColor: _isFormValid
                    ? colorScheme.onPrimary
                    : colorScheme.onSurface.withValues(alpha: 0.5),
                elevation: _isFormValid ? 2 : 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            colorScheme.onPrimary),
                      ),
                    )
                  : Text(
                      'Login',
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required BuildContext context,
    required ColorScheme colorScheme,
    required TextEditingController controller,
    required String label,
    required String hintText,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? prefixWidget,
    Widget? suffixWidget,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: validator,
          onChanged: (value) {
            setState(() {}); // Rebuild to update button state
          },
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: prefixWidget,
            suffixIcon: suffixWidget != null
                ? Padding(
                    padding: EdgeInsets.all(3.w),
                    child: suffixWidget,
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  BorderSide(color: colorScheme.outline.withValues(alpha: 0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  BorderSide(color: colorScheme.outline.withValues(alpha: 0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.error),
            ),
            filled: true,
            fillColor: colorScheme.surface,
          ),
        ),
      ],
    );
  }

  Widget _buildCountryCodeSelector(ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCountryCode,
          items: _countryCodes.map((country) {
            return DropdownMenuItem<String>(
              value: country['code'],
              child: Text(
                '${country['country']} ${country['code']}',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: colorScheme.onSurface,
                ),
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _selectedCountryCode = value;
              });
            }
          },
          icon: CustomIconWidget(
            iconName: 'keyboard_arrow_down',
            color: colorScheme.onSurface.withValues(alpha: 0.6),
            size: 16,
          ),
        ),
      ),
    );
  }

  void _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      // Simulate authentication process
      await Future.delayed(const Duration(seconds: 2));

      // Mock authentication logic
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      // Mock credentials for demonstration
      final validCredentials = [
        {'email': 'tourist@kerala.com', 'password': 'kerala123'},
        {'email': 'heritage@explorer.com', 'password': 'heritage456'},
        {'email': '9876543210', 'password': 'mobile123'},
      ];

      bool isValidCredential = validCredentials.any((cred) =>
          (cred['email'] == email || cred['email'] == email) &&
          cred['password'] == password);

      setState(() {
        _isLoading = false;
      });

      if (isValidCredential) {
        // Success - trigger haptic feedback and navigate
        if (widget.onLogin != null) {
          widget.onLogin!();
        }
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid credentials. Please try again.'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
