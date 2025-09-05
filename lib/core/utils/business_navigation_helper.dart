import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../core/models/payment_models.dart';
import '../../core/models/partnership_models.dart';

class BusinessNavigationHelper {
  // Navigate to checkout with payment items
  static void navigateToCheckout(
    BuildContext context, {
    required List<TicketType> tickets,
    required List<MerchandiseItem> merchandise,
    required String heritageSiteId,
  }) {
    Navigator.pushNamed(
      context,
      AppRoutes.checkout,
      arguments: {
        'tickets': tickets,
        'merchandise': merchandise,
        'heritageSiteId': heritageSiteId,
      },
    );
  }

  // Navigate to discover screen
  static void navigateToDiscover(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.discover);
  }

  // Navigate to guide booking
  static void navigateToGuideBooking(BuildContext context, TourGuide guide) {
    Navigator.pushNamed(
      context,
      AppRoutes.guideBooking,
      arguments: {'guide': guide},
    );
  }

  // Navigate to feedback screen
  static void navigateToFeedback(
    BuildContext context, {
    String? heritageSiteId,
    String? heritageSiteName,
  }) {
    Navigator.pushNamed(
      context,
      AppRoutes.feedback,
      arguments: {
        'heritageSiteId': heritageSiteId,
        'heritageSiteName': heritageSiteName,
      },
    );
  }

  // Show business features bottom sheet
  static void showBusinessFeatures(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _BusinessFeaturesBottomSheet(),
    );
  }

  // Show quick checkout for a single item
  static void showQuickCheckout(
    BuildContext context, {
    required String itemName,
    required double price,
    required String heritageSiteId,
  }) {
    final ticket = TicketType(
      id: 'quick_ticket',
      name: itemName,
      price: price,
      description: 'Quick purchase',
      quantity: 1,
      maxQuantity: 10,
      isAvailable: true,
    );

    navigateToCheckout(
      context,
      tickets: [ticket],
      merchandise: [],
      heritageSiteId: heritageSiteId,
    );
  }
}

class _BusinessFeaturesBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A2E),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Business Features',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          // Features grid
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              padding: const EdgeInsets.all(20),
              childAspectRatio: 1.1,
              children: [
                _BusinessFeatureCard(
                  title: 'Discover',
                  description: 'Find local businesses and expert guides',
                  icon: Icons.explore,
                  color: Colors.blue,
                  onTap: () {
                    Navigator.pop(context);
                    BusinessNavigationHelper.navigateToDiscover(context);
                  },
                ),
                _BusinessFeatureCard(
                  title: 'Book Guide',
                  description: 'Schedule personalized tours',
                  icon: Icons.person_search,
                  color: Colors.purple,
                  onTap: () {
                    Navigator.pop(context);
                    BusinessNavigationHelper.navigateToDiscover(context);
                  },
                ),
                _BusinessFeatureCard(
                  title: 'Feedback',
                  description: 'Share your experience',
                  icon: Icons.feedback,
                  color: Colors.green,
                  onTap: () {
                    Navigator.pop(context);
                    BusinessNavigationHelper.navigateToFeedback(context);
                  },
                ),
                _BusinessFeatureCard(
                  title: 'Support',
                  description: 'Get help and assistance',
                  icon: Icons.support_agent,
                  color: Colors.orange,
                  onTap: () {
                    Navigator.pop(context);
                    _showSupportDialog(context);
                  },
                ),
                _BusinessFeatureCard(
                  title: 'Demo',
                  description: 'See all features in action',
                  icon: Icons.play_circle,
                  color: Colors.teal,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/business-demo');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
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
              BusinessNavigationHelper.navigateToFeedback(context);
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

class _BusinessFeatureCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _BusinessFeatureCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

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
