import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/ar_demo_animation_widget.dart';
import './widgets/memory_wall_animation_widget.dart';
import './widgets/onboarding_navigation_widget.dart';
import './widgets/onboarding_page_widget.dart';
import './widgets/trip_planning_animation_widget.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  late PageController _pageController;
  int _currentIndex = 0;
  final int _totalPages = 4;

  final List<Map<String, dynamic>> _onboardingData = [
    {
      'title': 'Discover Heritage\nThrough AR',
      'description':
          'Experience Kerala\'s rich cultural heritage with immersive AR technology. See ancient monuments come alive with 3D models and interactive storytelling.',
      'imagePath':
          'https://images.unsplash.com/photo-1578662996442-48f60103fc96?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3',
      'animation': ArDemoAnimationWidget(),
    },
    {
      'title': 'AI-Powered\nTrip Planning',
      'description':
          'Let our intelligent assistant create personalized itineraries based on your interests, budget, and travel preferences for the perfect Kerala experience.',
      'imagePath':
          'https://images.unsplash.com/photo-1544735716-392fe2489ffa?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3',
      'animation': TripPlanningAnimationWidget(),
    },
    {
      'title': 'Share Your\nMemories',
      'description':
          'Create and share your travel memories with our social memory wall. Upload photos, videos, and connect with fellow travelers exploring Kerala.',
      'imagePath':
          'https://images.unsplash.com/photo-1570168007204-dfb528c6958f?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3',
      'animation': MemoryWallAnimationWidget(),
    },
    {
      'title': 'Ready to\nExplore?',
      'description':
          'Grant essential permissions to unlock the full Zenscape AR experience and start your journey through Kerala\'s cultural treasures.',
      'imagePath':
          'https://images.unsplash.com/photo-1588392382834-a891154bca4d?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3',
      'showPermissions': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentIndex < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      HapticFeedback.lightImpact();
    }
  }

  void _skipOnboarding() {
    Navigator.pushReplacementNamed(context, '/heritage-dashboard');
    HapticFeedback.mediumImpact();
  }

  void _getStarted() {
    Navigator.pushReplacementNamed(context, '/authentication-screen');
    HapticFeedback.mediumImpact();
  }

  void _requestCameraPermission() {
    // Mock permission request - in real app would use permission_handler
    _showPermissionDialog(
      'Camera Permission',
      'Zenscape needs camera access to provide AR heritage experiences. This allows you to see 3D models overlaid on real heritage sites.',
      'camera_alt',
    );
  }

  void _requestLocationPermission() {
    // Mock permission request - in real app would use permission_handler
    _showPermissionDialog(
      'Location Permission',
      'Zenscape uses your location to detect nearby heritage sites and provide contextual AR experiences and navigation.',
      'location_on',
    );
  }

  void _requestNotificationPermission() {
    // Mock permission request - in real app would use permission_handler
    _showPermissionDialog(
      'Notification Permission',
      'Stay updated with trip recommendations, heritage site information, and special cultural events happening near you.',
      'notifications',
    );
  }

  void _showPermissionDialog(
      String title, String description, String iconName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.w),
          ),
          title: Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: CustomIconWidget(
                  iconName: iconName,
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 6.w,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            description,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Not Now',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // In real app, would handle actual permission request here
              },
              child: Text('Allow'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Page View
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
              HapticFeedback.selectionClick();
            },
            itemCount: _totalPages,
            itemBuilder: (context, index) {
              final data = _onboardingData[index];

              return OnboardingPageWidget(
                title: data['title'] as String,
                description: data['description'] as String,
                imagePath: data['imagePath'] as String,
                animationWidget: data['animation'] as Widget?,
                showPermissionButtons: data['showPermissions'] == true,
                onCameraPermission: _requestCameraPermission,
                onLocationPermission: _requestLocationPermission,
                onNotificationPermission: _requestNotificationPermission,
              );
            },
          ),

          // Skip Button (Top Right)
          if (_currentIndex < _totalPages - 1)
            Positioned(
              top: 8.h,
              right: 6.w,
              child: SafeArea(
                child: GestureDetector(
                  onTap: _skipOnboarding,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(6.w),
                    ),
                    child: Text(
                      'Skip',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // Navigation Controls (Bottom)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: OnboardingNavigationWidget(
                currentIndex: _currentIndex,
                totalPages: _totalPages,
                isLastPage: _currentIndex == _totalPages - 1,
                onNext: _nextPage,
                onSkip: _skipOnboarding,
                onGetStarted: _getStarted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
