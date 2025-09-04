import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ArDemoAnimationWidget extends StatefulWidget {
  const ArDemoAnimationWidget({super.key});

  @override
  State<ArDemoAnimationWidget> createState() => _ArDemoAnimationWidgetState();
}

class _ArDemoAnimationWidgetState extends State<ArDemoAnimationWidget>
    with TickerProviderStateMixin {
  late AnimationController _phoneController;
  late AnimationController _modelController;
  late AnimationController _pulseController;

  late Animation<double> _phoneAnimation;
  late Animation<double> _modelScaleAnimation;
  late Animation<double> _modelOpacityAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _phoneController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _modelController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _phoneAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _phoneController,
      curve: Curves.easeOutBack,
    ));

    _modelScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _modelController,
      curve: const Interval(0.3, 1.0, curve: Curves.elasticOut),
    ));

    _modelOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _modelController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeIn),
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _startAnimation();
  }

  void _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _phoneController.forward();

    await Future.delayed(const Duration(milliseconds: 800));
    _modelController.forward();

    await Future.delayed(const Duration(milliseconds: 1000));
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _modelController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.w,
      height: 50.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Phone mockup
          AnimatedBuilder(
            animation: _phoneAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _phoneAnimation.value,
                child: Transform.rotate(
                  angle: (1 - _phoneAnimation.value) * 0.3,
                  child: Container(
                    width: 45.w,
                    height: 35.h,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8.w),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Container(
                      margin: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(6.w),
                        image: const DecorationImage(
                          image: NetworkImage(
                            'https://images.unsplash.com/photo-1578662996442-48f60103fc96?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // 3D Heritage Model
          AnimatedBuilder(
            animation: Listenable.merge([_modelController, _pulseController]),
            builder: (context, child) {
              return Transform.scale(
                scale: _modelScaleAnimation.value * _pulseAnimation.value,
                child: Opacity(
                  opacity: _modelOpacityAnimation.value,
                  child: Container(
                    width: 25.w,
                    height: 25.w,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4.w),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.3),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'account_balance',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 8.w,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          '3D Model',
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          // AR Indicators
          AnimatedBuilder(
            animation: _modelController,
            builder: (context, child) {
              return Opacity(
                opacity: _modelOpacityAnimation.value,
                child: Stack(
                  children: [
                    // Corner indicators
                    Positioned(
                      top: 15.h,
                      left: 25.w,
                      child: _buildArIndicator(),
                    ),
                    Positioned(
                      top: 15.h,
                      right: 25.w,
                      child: _buildArIndicator(),
                    ),
                    Positioned(
                      bottom: 15.h,
                      left: 25.w,
                      child: _buildArIndicator(),
                    ),
                    Positioned(
                      bottom: 15.h,
                      right: 25.w,
                      child: _buildArIndicator(),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildArIndicator() {
    return Container(
      width: 4.w,
      height: 4.w,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.secondary,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.secondary
                .withValues(alpha: 0.5),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
}
