import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OnboardingPageWidget extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final Widget? animationWidget;
  final bool showPermissionButtons;
  final VoidCallback? onCameraPermission;
  final VoidCallback? onLocationPermission;
  final VoidCallback? onNotificationPermission;

  const OnboardingPageWidget({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
    this.animationWidget,
    this.showPermissionButtons = false,
    this.onCameraPermission,
    this.onLocationPermission,
    this.onNotificationPermission,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: CustomImageWidget(
              imageUrl: imagePath,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          // Gradient Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.3),
                    Colors.black.withValues(alpha: 0.7),
                  ],
                ),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: animationWidget ?? Container(),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Title
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: AppTheme.lightTheme.textTheme.headlineMedium
                              ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                          ),
                        ),

                        SizedBox(height: 3.h),

                        // Description
                        Text(
                          description,
                          textAlign: TextAlign.center,
                          style:
                              AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                            height: 1.5,
                          ),
                        ),

                        if (showPermissionButtons) ...[
                          SizedBox(height: 4.h),
                          _buildPermissionButtons(context),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionButtons(BuildContext context) {
    return Column(
      children: [
        // Camera Permission
        _buildPermissionButton(
          context: context,
          icon: 'camera_alt',
          title: 'Camera Access',
          description: 'For AR heritage experiences',
          onTap: onCameraPermission,
        ),

        SizedBox(height: 2.h),

        // Location Permission
        _buildPermissionButton(
          context: context,
          icon: 'location_on',
          title: 'Location Access',
          description: 'For site detection & navigation',
          onTap: onLocationPermission,
        ),

        SizedBox(height: 2.h),

        // Notification Permission
        _buildPermissionButton(
          context: context,
          icon: 'notifications',
          title: 'Notifications',
          description: 'For trip updates & recommendations',
          onTap: onNotificationPermission,
        ),
      ],
    );
  }

  Widget _buildPermissionButton({
    required BuildContext context,
    required String icon,
    required String title,
    required String description,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: CustomIconWidget(
                iconName: icon,
                color: Colors.white,
                size: 6.w,
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    description,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'arrow_forward_ios',
              color: Colors.white.withValues(alpha: 0.7),
              size: 4.w,
            ),
          ],
        ),
      ),
    );
  }
}
