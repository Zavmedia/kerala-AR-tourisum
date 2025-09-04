import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

enum MemoryType { photo, video, ar, note }

class MemoryCardWidget extends StatelessWidget {
  final Map<String, dynamic> memory;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const MemoryCardWidget({
    super.key,
    required this.memory,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final memoryType = _getMemoryType(memory['type'] as String);
    final aspectRatio = _getAspectRatio(memory);

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: EdgeInsets.all(1.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color:
                  AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AspectRatio(
            aspectRatio: aspectRatio,
            child: Stack(
              fit: StackFit.expand,
              children: [
                _buildMemoryContent(context, memoryType),
                _buildOverlay(context),
                _buildTypeIndicator(context, memoryType),
                _buildEngagementMetrics(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  MemoryType _getMemoryType(String type) {
    switch (type.toLowerCase()) {
      case 'video':
        return MemoryType.video;
      case 'ar':
        return MemoryType.ar;
      case 'note':
        return MemoryType.note;
      default:
        return MemoryType.photo;
    }
  }

  double _getAspectRatio(Map<String, dynamic> memory) {
    final height = (memory['height'] as num?)?.toDouble() ?? 1.0;
    final width = (memory['width'] as num?)?.toDouble() ?? 1.0;
    return width / height;
  }

  Widget _buildMemoryContent(BuildContext context, MemoryType type) {
    switch (type) {
      case MemoryType.video:
        return Stack(
          fit: StackFit.expand,
          children: [
            CustomImageWidget(
              imageUrl: memory['thumbnail'] as String,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
            Center(
              child: Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: 'play_arrow',
                  color: Colors.white,
                  size: 6.w,
                ),
              ),
            ),
          ],
        );
      case MemoryType.ar:
        return Stack(
          fit: StackFit.expand,
          children: [
            CustomImageWidget(
              imageUrl: memory['imageUrl'] as String,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.3),
                  ],
                ),
              ),
            ),
          ],
        );
      case MemoryType.note:
        return Container(
          color: AppTheme.goldLight.withValues(alpha: 0.9),
          padding: EdgeInsets.all(3.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomIconWidget(
                iconName: 'note',
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.7),
                size: 5.w,
              ),
              SizedBox(height: 2.h),
              Expanded(
                child: Text(
                  memory['content'] as String? ?? '',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                  maxLines: 8,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      default:
        return CustomImageWidget(
          imageUrl: memory['imageUrl'] as String,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        );
    }
  }

  Widget _buildOverlay(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withValues(alpha: 0.7),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'location_on',
                  color: Colors.white,
                  size: 3.w,
                ),
                SizedBox(width: 1.w),
                Expanded(
                  child: Text(
                    memory['location'] as String? ?? 'Unknown Location',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 0.5.h),
            Text(
              memory['date'] as String? ?? '',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeIndicator(BuildContext context, MemoryType type) {
    if (type == MemoryType.photo) return const SizedBox.shrink();

    return Positioned(
      top: 2.w,
      right: 2.w,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
        decoration: BoxDecoration(
          color: _getTypeColor(type).withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: _getTypeIcon(type),
              color: Colors.white,
              size: 3.w,
            ),
            SizedBox(width: 1.w),
            Text(
              _getTypeLabel(type),
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 10.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEngagementMetrics(BuildContext context) {
    final likes = memory['likes'] as int? ?? 0;
    final comments = memory['comments'] as int? ?? 0;

    if (likes == 0 && comments == 0) return const SizedBox.shrink();

    return Positioned(
      top: 2.w,
      left: 2.w,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (likes > 0) ...[
              CustomIconWidget(
                iconName: 'favorite',
                color: Colors.red,
                size: 3.w,
              ),
              SizedBox(width: 1.w),
              Text(
                likes.toString(),
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontSize: 10.sp,
                ),
              ),
            ],
            if (likes > 0 && comments > 0) SizedBox(width: 2.w),
            if (comments > 0) ...[
              CustomIconWidget(
                iconName: 'comment',
                color: Colors.white,
                size: 3.w,
              ),
              SizedBox(width: 1.w),
              Text(
                comments.toString(),
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontSize: 10.sp,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getTypeColor(MemoryType type) {
    switch (type) {
      case MemoryType.video:
        return Colors.red;
      case MemoryType.ar:
        return AppTheme.lightTheme.colorScheme.primary;
      case MemoryType.note:
        return AppTheme.goldLight;
      default:
        return AppTheme.lightTheme.colorScheme.secondary;
    }
  }

  String _getTypeIcon(MemoryType type) {
    switch (type) {
      case MemoryType.video:
        return 'videocam';
      case MemoryType.ar:
        return 'view_in_ar';
      case MemoryType.note:
        return 'note';
      default:
        return 'photo';
    }
  }

  String _getTypeLabel(MemoryType type) {
    switch (type) {
      case MemoryType.video:
        return 'Video';
      case MemoryType.ar:
        return 'AR';
      case MemoryType.note:
        return 'Note';
      default:
        return 'Photo';
    }
  }
}
