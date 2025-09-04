import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './memory_card_widget.dart';

class MemoryGridWidget extends StatelessWidget {
  final List<Map<String, dynamic>> memories;
  final Function(Map<String, dynamic>) onMemoryTap;
  final Function(Map<String, dynamic>) onMemoryLongPress;
  final ScrollController? scrollController;

  const MemoryGridWidget({
    super.key,
    required this.memories,
    required this.onMemoryTap,
    required this.onMemoryLongPress,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    if (memories.isEmpty) {
      return _buildEmptyState(context);
    }

    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          sliver: SliverMasonryGrid.count(
            crossAxisCount: _getCrossAxisCount(),
            mainAxisSpacing: 2.w,
            crossAxisSpacing: 2.w,
            childCount: memories.length,
            itemBuilder: (context, index) {
              final memory = memories[index];
              return MemoryCardWidget(
                memory: memory,
                onTap: () => onMemoryTap(memory),
                onLongPress: () => onMemoryLongPress(memory),
              );
            },
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(height: 10.h),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'photo_library',
            color: AppTheme.lightTheme.colorScheme.onSurface
                .withValues(alpha: 0.4),
            size: 15.w,
          ),
          SizedBox(height: 3.h),
          Text(
            'No Memories Yet',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.6),
            ),
          ),
          SizedBox(height: 1.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Text(
              'Start capturing your Kerala heritage experiences with photos, videos, and AR content',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.5),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 4.h),
          ElevatedButton.icon(
            onPressed: () =>
                Navigator.pushNamed(context, '/ar-camera-experience'),
            icon: CustomIconWidget(
              iconName: 'camera_alt',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 5.w,
            ),
            label: Text('Start Capturing'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            ),
          ),
        ],
      ),
    );
  }

  int _getCrossAxisCount() {
    final screenWidth = 100.w;
    if (screenWidth > 90.w) return 3;
    if (screenWidth > 60.w) return 2;
    return 2;
  }
}

class SliverMasonryGrid extends StatelessWidget {
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final int childCount;
  final Widget Function(BuildContext, int) itemBuilder;

  const SliverMasonryGrid.count({
    super.key,
    required this.crossAxisCount,
    required this.mainAxisSpacing,
    required this.crossAxisSpacing,
    required this.childCount,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
        childAspectRatio: 0.8,
      ),
      delegate: SliverChildBuilderDelegate(
        itemBuilder,
        childCount: childCount,
      ),
    );
  }
}
