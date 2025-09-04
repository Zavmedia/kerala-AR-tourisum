import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class SocialLoginWidget extends StatelessWidget {
  final VoidCallback? onGoogleLogin;
  final VoidCallback? onOtpLogin;

  const SocialLoginWidget({
    super.key,
    this.onGoogleLogin,
    this.onOtpLogin,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        // Divider with text
        Row(
          children: [
            Expanded(
              child: Container(
                height: 1,
                color: colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'Or continue with',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 1,
                color: colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
          ],
        ),
        SizedBox(height: 3.h),

        // Social login buttons
        Row(
          children: [
            // Google Login
            Expanded(
              child: _buildSocialButton(
                context: context,
                colorScheme: colorScheme,
                iconName: 'g_translate',
                label: 'Google',
                onTap: onGoogleLogin,
              ),
            ),
            SizedBox(width: 4.w),

            // OTP Login
            Expanded(
              child: _buildSocialButton(
                context: context,
                colorScheme: colorScheme,
                iconName: 'sms',
                label: 'OTP',
                onTap: onOtpLogin,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required BuildContext context,
    required ColorScheme colorScheme,
    required String iconName,
    required String label,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 6.h,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: colorScheme.onSurface,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
