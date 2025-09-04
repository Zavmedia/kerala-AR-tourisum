import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MemoryStatsWidget extends StatelessWidget {
  final int sitesVisited;
  final int photosCaptured;
  final int arExperiences;
  final int socialShares;

  const MemoryStatsWidget({
    super.key,
    required this.sitesVisited,
    required this.photosCaptured,
    required this.arExperiences,
    required this.socialShares,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              context,
              'sites_visited',
              sitesVisited.toString(),
              'Sites Visited',
              AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
          Container(
            width: 1,
            height: 8.h,
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          ),
          Expanded(
            child: _buildStatItem(
              context,
              'photo_camera',
              photosCaptured.toString(),
              'Photos',
              AppTheme.lightTheme.colorScheme.secondary,
            ),
          ),
          Container(
            width: 1,
            height: 8.h,
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          ),
          Expanded(
            child: _buildStatItem(
              context,
              'view_in_ar',
              arExperiences.toString(),
              'AR Saved',
              AppTheme.lightTheme.colorScheme.tertiary,
            ),
          ),
          Container(
            width: 1,
            height: 8.h,
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          ),
          Expanded(
            child: _buildStatItem(
              context,
              'share',
              socialShares.toString(),
              'Shares',
              AppTheme.goldLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String iconName,
    String value,
    String label,
    Color color,
  ) {
    return Column(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: color,
          size: 6.w,
        ),
        SizedBox(height: 1.h),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface
                .withValues(alpha: 0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
