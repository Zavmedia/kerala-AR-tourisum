import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ArModelInfoPopup extends StatefulWidget {
  final Map<String, dynamic> modelData;
  final Offset position;
  final bool isVisible;
  final VoidCallback? onClose;

  const ArModelInfoPopup({
    super.key,
    required this.modelData,
    required this.position,
    this.isVisible = false,
    this.onClose,
  });

  @override
  State<ArModelInfoPopup> createState() => _ArModelInfoPopupState();
}

class _ArModelInfoPopupState extends State<ArModelInfoPopup>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    if (widget.isVisible) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(ArModelInfoPopup oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.position.dx - 40.w,
      top: widget.position.dy - 25.h,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                width: 80.w,
                constraints: BoxConstraints(maxHeight: 50.h),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(4.w),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeader(),
                    Flexible(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(4.w),
                        child: _buildContent(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.tertiary,
              borderRadius: BorderRadius.circular(2.w),
            ),
            child: CustomIconWidget(
              iconName: 'view_in_ar',
              color: Colors.white,
              size: 5.w,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              widget.modelData['title'] as String? ?? 'AR Model',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          GestureDetector(
            onTap: widget.onClose,
            child: Container(
              padding: EdgeInsets.all(1.5.w),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(1.5.w),
              ),
              child: CustomIconWidget(
                iconName: 'close',
                color: Colors.white,
                size: 4.w,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.modelData['image'] != null) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(3.w),
            child: CustomImageWidget(
              imageUrl: widget.modelData['image'] as String,
              width: double.infinity,
              height: 20.h,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 2.h),
        ],
        if (widget.modelData['category'] != null) ...[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.tertiary
                  .withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(2.w),
            ),
            child: Text(
              widget.modelData['category'] as String,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.tertiary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 2.h),
        ],
        Text(
          widget.modelData['description'] as String? ??
              'No description available',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.9),
            height: 1.5,
          ),
        ),
        if (widget.modelData['historicalContext'] != null) ...[
          SizedBox(height: 2.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'history_edu',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 4.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Historical Context',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            widget.modelData['historicalContext'] as String,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
              height: 1.4,
            ),
          ),
        ],
        if (widget.modelData['significance'] != null) ...[
          SizedBox(height: 2.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'star',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 4.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Cultural Significance',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            widget.modelData['significance'] as String,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
              height: 1.4,
            ),
          ),
        ],
        SizedBox(height: 2.h),
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              // Handle learn more action
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.tertiary,
                borderRadius: BorderRadius.circular(2.w),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'menu_book',
                    color: Colors.white,
                    size: 4.w,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Learn More',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 3.w),
        GestureDetector(
          onTap: () {
            // Handle share action
          },
          child: Container(
            padding: EdgeInsets.all(2.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(2.w),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: CustomIconWidget(
              iconName: 'share',
              color: Colors.white,
              size: 4.w,
            ),
          ),
        ),
      ],
    );
  }
}
