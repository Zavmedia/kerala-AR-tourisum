import 'package:flutter/material.dart';
import '../presentation/authentication_screen/authentication_screen.dart';
import '../presentation/ar_camera_experience/ar_camera_experience.dart';
import '../presentation/onboarding_flow/onboarding_flow.dart';
import '../presentation/heritage_dashboard/heritage_dashboard.dart';
import '../presentation/trip_planning_assistant/trip_planning_assistant.dart';
import '../presentation/memory_wall/memory_wall.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String authentication = '/authentication-screen';
  static const String arCameraExperience = '/ar-camera-experience';
  static const String onboardingFlow = '/onboarding-flow';
  static const String heritageDashboard = '/heritage-dashboard';
  static const String tripPlanningAssistant = '/trip-planning-assistant';
  static const String memoryWall = '/memory-wall';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const OnboardingFlow(),
    authentication: (context) => const AuthenticationScreen(),
    arCameraExperience: (context) => const ArCameraExperience(),
    onboardingFlow: (context) => const OnboardingFlow(),
    heritageDashboard: (context) => const HeritageDashboard(),
    tripPlanningAssistant: (context) => const TripPlanningAssistant(),
    memoryWall: (context) => const MemoryWall(),
    // TODO: Add your other routes here
  };
}
