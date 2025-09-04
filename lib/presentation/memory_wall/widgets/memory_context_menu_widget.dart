import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MemoryContextMenuWidget extends StatelessWidget {
  final Map<String, dynamic> memory;
  final VoidCallback onEdit;
  final VoidCallback onShare;
  final VoidCallback onAddToStory;
  final VoidCallback onDelete;
  final VoidCallback onClose;

  const MemoryContextMenuWidget({
    super.key,
    required this.memory,
    required this.onEdit,
    required this.onShare,
    required this.onAddToStory,
    required this.onDelete,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: onClose,
        child: Container(
          color: Colors.black.withValues(alpha: 0.5),
          child: Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.w),
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.lightTheme.colorScheme.shadow
                        .withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeader(context),
                  SizedBox(height: 3.h),
                  _buildMenuItems(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CustomImageWidget(
            imageUrl: memory['imageUrl'] as String? ??
                memory['thumbnail'] as String? ??
                '',
            width: 12.w,
            height: 12.w,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                memory['location'] as String? ?? 'Unknown Location',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 0.5.h),
              Text(
                memory['date'] as String? ?? '',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: onClose,
          child: Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: 'close',
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.7),
              size: 5.w,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    final menuItems = [
      {
        'icon': 'edit',
        'label': 'Edit Memory',
        'color': AppTheme.lightTheme.colorScheme.primary,
        'onTap': onEdit,
      },
      {
        'icon': 'share',
        'label': 'Share',
        'color': AppTheme.lightTheme.colorScheme.secondary,
        'onTap': onShare,
      },
      {
        'icon': 'auto_stories',
        'label': 'Add to Story',
        'color': AppTheme.lightTheme.colorScheme.tertiary,
        'onTap': onAddToStory,
      },
      {
        'icon': 'delete',
        'label': 'Delete',
        'color': AppTheme.lightTheme.colorScheme.error,
        'onTap': () => _showDeleteConfirmation(context),
      },
    ];

    return Column(
      children: menuItems.map((item) {
        return Padding(
          padding: EdgeInsets.only(bottom: 1.h),
          child: ListTile(
            leading: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: (item['color'] as Color).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: item['icon'] as String,
                color: item['color'] as Color,
                size: 5.w,
              ),
            ),
            title: Text(
              item['label'] as String,
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              onClose();
              (item['onTap'] as VoidCallback)();
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
          ),
        );
      }).toList(),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Memory',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          'Are you sure you want to delete this memory? This action cannot be undone.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.7),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onClose();
              onDelete();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
              foregroundColor: AppTheme.lightTheme.colorScheme.onError,
            ),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}
