import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SignupPromptWidget extends StatelessWidget {
  final VoidCallback? onSignUp;

  const SignupPromptWidget({
    super.key,
    this.onSignUp,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'New to Kerala Heritage? ',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          GestureDetector(
            onTap: onSignUp,
            child: Text(
              'Sign Up',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
                decorationColor: colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
