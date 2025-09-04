import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MemoryWallAnimationWidget extends StatefulWidget {
  const MemoryWallAnimationWidget({super.key});

  @override
  State<MemoryWallAnimationWidget> createState() =>
      _MemoryWallAnimationWidgetState();
}

class _MemoryWallAnimationWidgetState extends State<MemoryWallAnimationWidget>
    with TickerProviderStateMixin {
  late AnimationController _gridController;
  late AnimationController _shareController;

  late Animation<double> _gridAnimation;
  late Animation<double> _shareAnimation;

  final List<String> _memoryImages = [
    'https://images.unsplash.com/photo-1578662996442-48f60103fc96?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3',
    'https://images.unsplash.com/photo-1544735716-392fe2489ffa?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3',
    'https://images.unsplash.com/photo-1570168007204-dfb528c6958f?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3',
    'https://images.unsplash.com/photo-1588392382834-a891154bca4d?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3',
    'https://images.unsplash.com/photo-1539650116574-75c0c6d73f6e?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3',
    'https://images.unsplash.com/photo-1605640840605-14ac1855827b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3',
  ];

  @override
  void initState() {
    super.initState();

    _gridController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _shareController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _gridAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _gridController,
      curve: Curves.easeOutCubic,
    ));

    _shareAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _shareController,
      curve: Curves.elasticOut,
    ));

    _startAnimation();
  }

  void _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _gridController.forward();

    await Future.delayed(const Duration(milliseconds: 1500));
    _shareController.forward();
  }

  @override
  void dispose() {
    _gridController.dispose();
    _shareController.dispose();
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
          // Photo Grid
          AnimatedBuilder(
            animation: _gridAnimation,
            builder: (context, child) {
              return Container(
                width: 70.w,
                height: 40.h,
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: _memoryImages.length,
                  itemBuilder: (context, index) {
                    final delay = index * 0.1;

                    final itemAnimation = Tween<double>(
                      begin: 0.0,
                      end: 1.0,
                    ).animate(CurvedAnimation(
                      parent: _gridController,
                      curve: Interval(delay, delay + 0.3,
                          curve: Curves.easeOutBack),
                    ));

                    return Transform.scale(
                      scale: itemAnimation.value,
                      child: Transform.rotate(
                        angle: (1 - itemAnimation.value) * 0.5,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3.w),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(3.w),
                            child: CustomImageWidget(
                              imageUrl: _memoryImages[index],
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),

          // Share Animation Overlay
          AnimatedBuilder(
            animation: _shareAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: _shareAnimation.value,
                child: Stack(
                  children: [
                    // Share Icons
                    Positioned(
                      top: 8.h,
                      right: 5.w,
                      child: Transform.scale(
                        scale: _shareAnimation.value,
                        child: _buildShareIcon(
                            'share', AppTheme.lightTheme.colorScheme.secondary),
                      ),
                    ),

                    Positioned(
                      top: 15.h,
                      right: 15.w,
                      child: Transform.scale(
                        scale: _shareAnimation.value,
                        child: _buildShareIcon('favorite', Color(0xFFE91E63)),
                      ),
                    ),

                    Positioned(
                      top: 22.h,
                      right: 8.w,
                      child: Transform.scale(
                        scale: _shareAnimation.value,
                        child: _buildShareIcon(
                            'comment', AppTheme.lightTheme.colorScheme.primary),
                      ),
                    ),

                    // Social Platform Icons
                    Positioned(
                      bottom: 8.h,
                      left: 5.w,
                      child: Transform.translate(
                        offset: Offset(
                          (1 - _shareAnimation.value) * -50,
                          0,
                        ),
                        child: _buildSocialIcon('facebook', Color(0xFF1877F2)),
                      ),
                    ),

                    Positioned(
                      bottom: 8.h,
                      left: 20.w,
                      child: Transform.translate(
                        offset: Offset(
                          (1 - _shareAnimation.value) * -50,
                          0,
                        ),
                        child:
                            _buildSocialIcon('camera_alt', Color(0xFFE4405F)),
                      ),
                    ),

                    Positioned(
                      bottom: 8.h,
                      left: 35.w,
                      child: Transform.translate(
                        offset: Offset(
                          (1 - _shareAnimation.value) * -50,
                          0,
                        ),
                        child: _buildSocialIcon('send', Color(0xFF1DA1F2)),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // Floating Hearts
          AnimatedBuilder(
            animation: _shareAnimation,
            builder: (context, child) {
              return Stack(
                children: List.generate(5, (index) {
                  final delay = index * 0.2;
                  final heartAnimation = Tween<double>(
                    begin: 0.0,
                    end: 1.0,
                  ).animate(CurvedAnimation(
                    parent: _shareController,
                    curve: Interval(delay, delay + 0.5, curve: Curves.easeOut),
                  ));

                  return Positioned(
                    left: (20 + index * 15).w,
                    top: (25 - heartAnimation.value * 10).h,
                    child: Opacity(
                      opacity: heartAnimation.value *
                          (1 - heartAnimation.value * 0.5),
                      child: Transform.scale(
                        scale: 0.5 + heartAnimation.value * 0.5,
                        child: CustomIconWidget(
                          iconName: 'favorite',
                          color: Color(0xFFE91E63).withValues(alpha: 0.8),
                          size: 4.w,
                        ),
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildShareIcon(String iconName, Color color) {
    return Container(
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
        border: Border.all(
          color: color,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: CustomIconWidget(
        iconName: iconName,
        color: color,
        size: 5.w,
      ),
    );
  }

  Widget _buildSocialIcon(String iconName, Color color) {
    return Container(
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: CustomIconWidget(
        iconName: iconName,
        color: Colors.white,
        size: 4.w,
      ),
    );
  }
}
