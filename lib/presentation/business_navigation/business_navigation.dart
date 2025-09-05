import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/app_export.dart';
import '../../core/models/payment_models.dart';
import '../../core/models/partnership_models.dart';
import '../checkout/checkout_screen.dart';
import '../discover/discover_screen.dart';
import '../guide_booking/guide_booking_screen.dart';
import '../feedback/feedback_screen.dart';

class BusinessNavigation {
  static const String checkout = '/checkout';
  static const String discover = '/discover';
  static const String guideBooking = '/guide-booking';
  static const String feedback = '/feedback';

  static List<RouteBase> get routes => [
    GoRoute(
      path: checkout,
      name: 'checkout',
      builder: (context, state) {
        final tickets = state.extra?['tickets'] as List<TicketType>? ?? [];
        final merchandise = state.extra?['merchandise'] as List<MerchandiseItem>? ?? [];
        final heritageSiteId = state.extra?['heritageSiteId'] as String? ?? '';
        
        return CheckoutScreen(
          tickets: tickets,
          merchandise: merchandise,
          heritageSiteId: heritageSiteId,
        );
      },
    ),
    GoRoute(
      path: discover,
      name: 'discover',
      builder: (context, state) => const DiscoverScreen(),
    ),
    GoRoute(
      path: guideBooking,
      name: 'guide-booking',
      builder: (context, state) {
        final guide = state.extra?['guide'] as TourGuide?;
        if (guide == null) {
          return const Scaffold(
            body: Center(
              child: Text('Guide information not found'),
            ),
          );
        }
        return GuideBookingScreen(guide: guide);
      },
    ),
    GoRoute(
      path: feedback,
      name: 'feedback',
      builder: (context, state) {
        final heritageSiteId = state.extra?['heritageSiteId'] as String?;
        final heritageSiteName = state.extra?['heritageSiteName'] as String?;
        
        return FeedbackScreen(
          heritageSiteId: heritageSiteId,
          heritageSiteName: heritageSiteName,
        );
      },
    ),
  ];
}

// Extension methods for easy navigation
extension BusinessNavigationExtension on BuildContext {
  void navigateToCheckout({
    required List<TicketType> tickets,
    required List<MerchandiseItem> merchandise,
    required String heritageSiteId,
  }) {
    go('/checkout', extra: {
      'tickets': tickets,
      'merchandise': merchandise,
      'heritageSiteId': heritageSiteId,
    });
  }

  void navigateToDiscover() {
    go('/discover');
  }

  void navigateToGuideBooking(TourGuide guide) {
    go('/guide-booking', extra: {'guide': guide});
  }

  void navigateToFeedback({
    String? heritageSiteId,
    String? heritageSiteName,
  }) {
    go('/feedback', extra: {
      'heritageSiteId': heritageSiteId,
      'heritageSiteName': heritageSiteName,
    });
  }
}

// Business feature widgets for easy integration
class BusinessFeatureCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const BusinessFeatureCard({
    Key? key,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BusinessFeaturesGrid extends StatelessWidget {
  const BusinessFeaturesGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      childAspectRatio: 1.2,
      children: [
        BusinessFeatureCard(
          title: 'Discover',
          description: 'Find local businesses and expert guides',
          icon: Icons.explore,
          color: Colors.blue,
          onTap: () => context.navigateToDiscover(),
        ),
        BusinessFeatureCard(
          title: 'Book Guide',
          description: 'Schedule personalized tours',
          icon: Icons.person_search,
          color: Colors.purple,
          onTap: () {
            // Show guide selection or navigate to discover
            context.navigateToDiscover();
          },
        ),
        BusinessFeatureCard(
          title: 'Feedback',
          description: 'Share your experience',
          icon: Icons.feedback,
          color: Colors.green,
          onTap: () => context.navigateToFeedback(),
        ),
        BusinessFeatureCard(
          title: 'Support',
          description: 'Get help and assistance',
          icon: Icons.support_agent,
          color: Colors.orange,
          onTap: () {
            // Navigate to support or show help dialog
            _showSupportDialog(context);
          },
        ),
      ],
    );
  }

  void _showSupportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text(
          'Customer Support',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Need help? Contact our support team:\n\n📧 support@zenscape.com\n📞 +91 98765 43210\n💬 Live chat available 24/7',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.navigateToFeedback();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Send Feedback'),
          ),
        ],
      ),
    );
  }
}
