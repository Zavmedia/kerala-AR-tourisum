import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/app_export.dart';
import '../../core/models/payment_models.dart';
import '../../core/models/partnership_models.dart';

class BusinessDemoScreen extends StatefulWidget {
  const BusinessDemoScreen({Key? key}) : super(key: key);

  @override
  State<BusinessDemoScreen> createState() => _BusinessDemoScreenState();
}

class _BusinessDemoScreenState extends State<BusinessDemoScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Animated background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0A0A0A),
                  Color(0xFF1A1A2E),
                  Color(0xFF16213E),
                ],
              ),
            ),
          ),
          
          // Main content
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 30),
                      _buildFeatureShowcase(),
                      const SizedBox(height: 30),
                      _buildQuickActions(),
                      const SizedBox(height: 30),
                      _buildDemoButtons(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Business Features',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Complete tourism ecosystem',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureShowcase() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '✨ Implemented Features',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildFeatureItem(
            '💳 Payment Integration',
            'Secure checkout with multiple payment methods',
            Colors.blue,
            Icons.payment,
          ),
          _buildFeatureItem(
            '🤝 Partnership System',
            'Local businesses and tour guides',
            Colors.purple,
            Icons.handshake,
          ),
          _buildFeatureItem(
            '⭐ Feedback System',
            'Reviews and app feedback collection',
            Colors.green,
            Icons.feedback,
          ),
          _buildFeatureItem(
            '🔍 Discovery Platform',
            'Find and book local services',
            Colors.orange,
            Icons.explore,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String title, String description, Color color, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
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
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '🚀 Quick Actions',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.2,
          children: [
            _buildQuickActionCard(
              'Discover',
              'Find local businesses and guides',
              Icons.explore,
              Colors.blue,
              () => BusinessNavigationHelper.navigateToDiscover(context),
            ),
            _buildQuickActionCard(
              'Book Guide',
              'Schedule personalized tours',
              Icons.person_search,
              Colors.purple,
              () => _demoGuideBooking(),
            ),
            _buildQuickActionCard(
              'Feedback',
              'Share your experience',
              Icons.feedback,
              Colors.green,
              () => BusinessNavigationHelper.navigateToFeedback(context),
            ),
            _buildQuickActionCard(
              'Support',
              'Get help and assistance',
              Icons.support_agent,
              Colors.orange,
              () => BusinessNavigationHelper.showBusinessFeatures(context),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
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
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDemoButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '🎯 Demo Scenarios',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        _buildDemoButton(
          'Demo Checkout Flow',
          'Experience the complete payment process',
          Icons.shopping_cart,
          Colors.blue,
          _demoCheckout,
        ),
        const SizedBox(height: 15),
        _buildDemoButton(
          'Demo Guide Booking',
          'Book a tour guide with scheduling',
          Icons.calendar_today,
          Colors.purple,
          _demoGuideBooking,
        ),
        const SizedBox(height: 15),
        _buildDemoButton(
          'Demo Feedback System',
          'Leave reviews and app feedback',
          Icons.rate_review,
          Colors.green,
          _demoFeedback,
        ),
      ],
    );
  }

  Widget _buildDemoButton(
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
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
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: color,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _demoCheckout() {
    // Create sample items for checkout demo
    final ticket = TicketType(
      id: 'demo_ticket',
      name: 'Heritage Site Entry Ticket',
      price: 100.0,
      description: 'Entry ticket for heritage site visit',
      quantity: 2,
      maxQuantity: 10,
      isAvailable: true,
    );

    final merchandise = MerchandiseItem(
      id: 'demo_merchandise',
      name: 'Kerala Souvenir T-Shirt',
      price: 299.0,
      description: 'Beautiful Kerala themed t-shirt',
      quantity: 1,
      maxQuantity: 5,
      isAvailable: true,
      imageUrl: 'https://example.com/tshirt.jpg',
    );

    BusinessNavigationHelper.navigateToCheckout(
      context,
      tickets: [ticket],
      merchandise: [merchandise],
      heritageSiteId: 'demo_site',
    );
  }

  void _demoGuideBooking() {
    // Create sample guide for booking demo
    final guide = TourGuide(
      id: 'demo_guide',
      name: 'Rajesh Kumar',
      bio: 'Experienced tour guide with 8 years of expertise in Kerala heritage sites',
      languages: ['English', 'Malayalam', 'Hindi'],
      experienceYears: 8,
      rating: 4.8,
      hourlyRate: 500,
      isAvailable: true,
      specialties: ['Heritage Tours', 'Cultural Experiences', 'Photography Tours'],
      contactInfo: '+91 98765 43210',
      profileImageUrl: 'https://example.com/guide.jpg',
    );

    BusinessNavigationHelper.navigateToGuideBooking(context, guide);
  }

  void _demoFeedback() {
    BusinessNavigationHelper.navigateToFeedback(
      context,
      heritageSiteId: 'demo_site',
      heritageSiteName: 'Mattancherry Palace',
    );
  }
}
