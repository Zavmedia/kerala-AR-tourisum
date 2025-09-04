import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TripPlanningAnimationWidget extends StatefulWidget {
  const TripPlanningAnimationWidget({super.key});

  @override
  State<TripPlanningAnimationWidget> createState() =>
      _TripPlanningAnimationWidgetState();
}

class _TripPlanningAnimationWidgetState
    extends State<TripPlanningAnimationWidget> with TickerProviderStateMixin {
  late AnimationController _cardController;
  late AnimationController _aiController;

  late Animation<double> _cardSlideAnimation;
  late Animation<double> _aiPulseAnimation;

  final List<Map<String, dynamic>> _tripCards = [
    {
      'title': 'Backwater Cruise',
      'location': 'Alleppey',
      'time': '9:00 AM',
      'icon': 'directions_boat',
      'color': Color(0xFF2E8B57),
    },
    {
      'title': 'Spice Garden Tour',
      'location': 'Munnar',
      'time': '2:00 PM',
      'icon': 'local_florist',
      'color': Color(0xFF20B2AA),
    },
    {
      'title': 'Heritage Walk',
      'location': 'Fort Kochi',
      'time': '5:00 PM',
      'icon': 'account_balance',
      'color': Color(0xFF1B4B73),
    },
  ];

  @override
  void initState() {
    super.initState();

    _cardController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    _aiController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _cardSlideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _cardController,
      curve: Curves.easeOutCubic,
    ));

    _aiPulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _aiController,
      curve: Curves.easeInOut,
    ));

    _startAnimation();
  }

  void _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _cardController.forward();
    _aiController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _cardController.dispose();
    _aiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 85.w,
      height: 50.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // AI Brain Icon
          Positioned(
            top: 5.h,
            child: AnimatedBuilder(
              animation: _aiPulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _aiPulseAnimation.value,
                  child: Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.secondary
                          .withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.secondary,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.lightTheme.colorScheme.secondary
                              .withValues(alpha: 0.3),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: CustomIconWidget(
                      iconName: 'psychology',
                      color: AppTheme.lightTheme.colorScheme.secondary,
                      size: 8.w,
                    ),
                  ),
                );
              },
            ),
          ),

          // Trip Cards
          Positioned(
            bottom: 8.h,
            child: AnimatedBuilder(
              animation: _cardSlideAnimation,
              builder: (context, child) {
                return Column(
                  children: _tripCards.asMap().entries.map((entry) {
                    final index = entry.key;
                    final card = entry.value;
                    final delay = index * 0.3;

                    final cardAnimation = Tween<double>(
                      begin: 0.0,
                      end: 1.0,
                    ).animate(CurvedAnimation(
                      parent: _cardController,
                      curve: Interval(delay, delay + 0.4,
                          curve: Curves.easeOutBack),
                    ));

                    return Transform.translate(
                      offset: Offset(
                        (1 - cardAnimation.value) * 100,
                        0,
                      ),
                      child: Opacity(
                        opacity: cardAnimation.value,
                        child: Container(
                          width: 75.w,
                          margin: EdgeInsets.only(bottom: 2.h),
                          padding: EdgeInsets.all(4.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(4.w),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(3.w),
                                decoration: BoxDecoration(
                                  color: (card['color'] as Color)
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(3.w),
                                ),
                                child: CustomIconWidget(
                                  iconName: card['icon'] as String,
                                  color: card['color'] as Color,
                                  size: 6.w,
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      card['title'] as String,
                                      style: AppTheme
                                          .lightTheme.textTheme.titleSmall
                                          ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme
                                            .lightTheme.colorScheme.onSurface,
                                      ),
                                    ),
                                    SizedBox(height: 0.5.h),
                                    Row(
                                      children: [
                                        CustomIconWidget(
                                          iconName: 'location_on',
                                          color: AppTheme
                                              .lightTheme.colorScheme.onSurface
                                              .withValues(alpha: 0.6),
                                          size: 3.w,
                                        ),
                                        SizedBox(width: 1.w),
                                        Text(
                                          card['location'] as String,
                                          style: AppTheme
                                              .lightTheme.textTheme.bodySmall
                                              ?.copyWith(
                                            color: AppTheme.lightTheme
                                                .colorScheme.onSurface
                                                .withValues(alpha: 0.6),
                                          ),
                                        ),
                                        Spacer(),
                                        Text(
                                          card['time'] as String,
                                          style: AppTheme
                                              .lightTheme.textTheme.bodySmall
                                              ?.copyWith(
                                            color: card['color'] as Color,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),

          // Connecting Lines
          AnimatedBuilder(
            animation: _cardSlideAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: _cardSlideAnimation.value,
                child: CustomPaint(
                  size: Size(75.w, 35.h),
                  painter: _ConnectionLinesPainter(
                    progress: _cardSlideAnimation.value,
                    color: AppTheme.lightTheme.colorScheme.secondary
                        .withValues(alpha: 0.3),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ConnectionLinesPainter extends CustomPainter {
  final double progress;
  final Color color;

  _ConnectionLinesPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();

    // Draw curved lines connecting AI brain to cards
    final startPoint = Offset(size.width / 2, size.height * 0.2);
    final endPoints = [
      Offset(size.width * 0.1, size.height * 0.6),
      Offset(size.width * 0.1, size.height * 0.75),
      Offset(size.width * 0.1, size.height * 0.9),
    ];

    for (int i = 0; i < endPoints.length; i++) {
      final endPoint = endPoints[i];
      final controlPoint = Offset(
        startPoint.dx - (size.width * 0.2),
        startPoint.dy + (endPoint.dy - startPoint.dy) * 0.5,
      );

      path.moveTo(startPoint.dx, startPoint.dy);
      path.quadraticBezierTo(
        controlPoint.dx,
        controlPoint.dy,
        endPoint.dx,
        endPoint.dy,
      );
    }

    // Create path effect for animated drawing
    final pathMetrics = path.computeMetrics();
    final animatedPath = Path();

    for (final pathMetric in pathMetrics) {
      final extractPath = pathMetric.extractPath(
        0.0,
        pathMetric.length * progress,
      );
      animatedPath.addPath(extractPath, Offset.zero);
    }

    canvas.drawPath(animatedPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
