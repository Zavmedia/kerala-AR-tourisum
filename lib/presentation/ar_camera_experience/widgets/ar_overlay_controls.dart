import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ArOverlayControls extends StatelessWidget {
  final VoidCallback? onCapturePhoto;
  final VoidCallback? onCaptureVideo;
  final VoidCallback? onGalleryAccess;
  final VoidCallback? onSettingsMenu;
  final bool isRecording;

  const ArOverlayControls({
    super.key,
    this.onCapturePhoto,
    this.onCaptureVideo,
    this.onGalleryAccess,
    this.onSettingsMenu,
    this.isRecording = false,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 4.h,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Gallery Access Button
            GestureDetector(
              onTap: onGalleryAccess,
              child: Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(2.w),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: CustomIconWidget(
                  iconName: 'photo_library',
                  color: Colors.white,
                  size: 6.w,
                ),
              ),
            ),

            // Capture Controls
            Row(
              children: [
                // Video Record Button
                GestureDetector(
                  onTap: onCaptureVideo,
                  child: Container(
                    width: 14.w,
                    height: 14.w,
                    margin: EdgeInsets.only(right: 4.w),
                    decoration: BoxDecoration(
                      color: isRecording
                          ? AppTheme.lightTheme.colorScheme.error
                          : Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(7.w),
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: CustomIconWidget(
                      iconName: isRecording ? 'stop' : 'videocam',
                      color: Colors.white,
                      size: 7.w,
                    ),
                  ),
                ),

                // Photo Capture Button
                GestureDetector(
                  onTap: onCapturePhoto,
                  child: Container(
                    width: 18.w,
                    height: 18.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(9.w),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: CustomIconWidget(
                      iconName: 'camera_alt',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 8.w,
                    ),
                  ),
                ),
              ],
            ),

            // Settings Menu Button
            GestureDetector(
              onTap: onSettingsMenu,
              child: Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(2.w),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: CustomIconWidget(
                  iconName: 'settings',
                  color: Colors.white,
                  size: 6.w,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
