import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ArSidePanel extends StatefulWidget {
  final bool isVisible;
  final Map<String, dynamic>? siteData;
  final VoidCallback? onClose;
  final VoidCallback? onPlayNarration;
  final VoidCallback? onPauseNarration;
  final bool isNarrationPlaying;

  const ArSidePanel({
    super.key,
    this.isVisible = false,
    this.siteData,
    this.onClose,
    this.onPlayNarration,
    this.onPauseNarration,
    this.isNarrationPlaying = false,
  });

  @override
  State<ArSidePanel> createState() => _ArSidePanelState();
}

class _ArSidePanelState extends State<ArSidePanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    if (widget.isVisible) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(ArSidePanel oldWidget) {
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
      top: 0,
      right: 0,
      bottom: 0,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return SlideTransition(
            position: _slideAnimation,
            child: Container(
              width: 85.w,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.9),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4.w),
                  bottomLeft: Radius.circular(4.w),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 20,
                    offset: const Offset(-4, 0),
                  ),
                ],
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    _buildHeader(),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(4.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSiteInfo(),
                            SizedBox(height: 3.h),
                            _buildNarrationControls(),
                            SizedBox(height: 3.h),
                            _buildHistoricalTimeline(),
                          ],
                        ),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Heritage Details',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          GestureDetector(
            onTap: widget.onClose,
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(2.w),
              ),
              child: CustomIconWidget(
                iconName: 'close',
                color: Colors.white,
                size: 5.w,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSiteInfo() {
    final siteData = widget.siteData ?? _getDefaultSiteData();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          siteData['name'] as String,
          style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            CustomIconWidget(
              iconName: 'calendar_today',
              color: AppTheme.lightTheme.colorScheme.tertiary,
              size: 4.w,
            ),
            SizedBox(width: 2.w),
            Text(
              siteData['period'] as String,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.tertiary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Text(
          siteData['description'] as String,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.9),
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildNarrationControls() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color:
              AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'headphones',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 5.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'Audio Narration',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              GestureDetector(
                onTap: widget.isNarrationPlaying
                    ? widget.onPauseNarration
                    : widget.onPlayNarration,
                child: Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  child: CustomIconWidget(
                    iconName:
                        widget.isNarrationPlaying ? 'pause' : 'play_arrow',
                    color: Colors.white,
                    size: 5.w,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.isNarrationPlaying ? 'Playing...' : 'Tap to play',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Malayalam • 3:45 min',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHistoricalTimeline() {
    final timelineEvents = [
      {
        'year': '1550 CE',
        'event': 'Original construction completed',
        'description': 'Built during the reign of local rulers',
      },
      {
        'year': '1663 CE',
        'event': 'Dutch colonial modifications',
        'description': 'Structural changes for defensive purposes',
      },
      {
        'year': '1795 CE',
        'event': 'British period renovations',
        'description': 'Administrative building additions',
      },
      {
        'year': '1947 CE',
        'event': 'Post-independence restoration',
        'description': 'Heritage conservation efforts began',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: 'timeline',
              color: AppTheme.lightTheme.colorScheme.tertiary,
              size: 5.w,
            ),
            SizedBox(width: 3.w),
            Text(
              'Historical Timeline',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        ...timelineEvents.map((event) => _buildTimelineItem(event)).toList(),
      ],
    );
  }

  Widget _buildTimelineItem(Map<String, String> event) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 3.w,
            height: 3.w,
            margin: EdgeInsets.only(top: 1.h, right: 3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.tertiary,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event['year']!,
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  event['event']!,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  event['description']!,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.7),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getDefaultSiteData() {
    return {
      'name': 'Mattancherry Palace',
      'period': '16th Century CE',
      'description':
          'Also known as the Dutch Palace, this magnificent structure showcases traditional Kerala architecture with Portuguese and Dutch influences. The palace features beautiful murals depicting scenes from the Ramayana and Mahabharata, along with portraits of Cochin rulers.',
    };
  }
}
