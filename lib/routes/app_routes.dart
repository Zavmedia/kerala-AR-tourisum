import 'package:flutter/material.dart';
import '../presentation/authentication_screen/authentication_screen.dart';
import '../presentation/ar_camera_experience/ar_camera_experience.dart';
import '../presentation/onboarding_flow/onboarding_flow.dart';
import '../presentation/heritage_dashboard/heritage_dashboard.dart';
import '../presentation/trip_planning_assistant/trip_planning_assistant.dart';
import '../presentation/memory_wall/memory_wall.dart';
import '../presentation/checkout/checkout_screen.dart';
import '../presentation/discover/discover_screen.dart';
import '../presentation/guide_booking/guide_booking_screen.dart';
import '../presentation/feedback/feedback_screen.dart';
import '../presentation/business_demo/business_demo_screen.dart';
import '../core/models/payment_models.dart';
import '../core/models/partnership_models.dart';

class AppRoutes {
  // Core app routes
  static const String initial = '/';
  static const String authentication = '/authentication-screen';
  static const String arCameraExperience = '/ar-camera-experience';
  static const String onboardingFlow = '/onboarding-flow';
  static const String heritageDashboard = '/heritage-dashboard';
  static const String tripPlanningAssistant = '/trip-planning-assistant';
  static const String memoryWall = '/memory-wall';
  
  // Business feature routes
  static const String checkout = '/checkout';
  static const String discover = '/discover';
  static const String guideBooking = '/guide-booking';
  static const String feedback = '/feedback';
  static const String businessDemo = '/business-demo';

  static Map<String, WidgetBuilder> routes = {
    // Core app routes
    initial: (context) => const OnboardingFlow(),
    authentication: (context) => const AuthenticationScreen(),
    arCameraExperience: (context) => const ArCameraExperience(),
    onboardingFlow: (context) => const OnboardingFlow(),
    heritageDashboard: (context) => const HeritageDashboard(),
    tripPlanningAssistant: (context) => const TripPlanningAssistant(),
    memoryWall: (context) => const MemoryWall(),
    
    // Business feature routes
    checkout: (context) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      final tickets = args?['tickets'] as List<TicketType>? ?? [];
      final merchandise = args?['merchandise'] as List<MerchandiseItem>? ?? [];
      final heritageSiteId = args?['heritageSiteId'] as String? ?? '';
      
      return CheckoutScreen(
        tickets: tickets,
        merchandise: merchandise,
        heritageSiteId: heritageSiteId,
      );
    },
    discover: (context) => const DiscoverScreen(),
    guideBooking: (context) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      final guide = args?['guide'] as TourGuide?;
      
      if (guide == null) {
        return const Scaffold(
          body: Center(
            child: Text('Guide information not found'),
          ),
        );
      }
      
      return GuideBookingScreen(guide: guide);
    },
    feedback: (context) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      final heritageSiteId = args?['heritageSiteId'] as String?;
      final heritageSiteName = args?['heritageSiteName'] as String?;
      
      return FeedbackScreen(
        heritageSiteId: heritageSiteId,
        heritageSiteName: heritageSiteName,
      );
    },
    businessDemo: (context) => const BusinessDemoScreen(),
  };
}
