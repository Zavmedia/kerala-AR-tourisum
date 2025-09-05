import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/featured_sites_widget.dart';
import './widgets/heritage_site_card_widget.dart';
import './widgets/location_header_widget.dart';
import './widgets/recommended_itinerary_card_widget.dart';
import './widgets/search_bar_widget.dart';
import './widgets/section_header_widget.dart';

class HeritageDashboard extends StatefulWidget {
  const HeritageDashboard({super.key});

  @override
  State<HeritageDashboard> createState() => _HeritageDashboardState();
}

class _HeritageDashboardState extends State<HeritageDashboard> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  int _currentBottomNavIndex = 0;
  bool _isLoading = false;

  // Mock data for featured heritage sites
  final List<Map<String, dynamic>> _featuredSites = [
    {
      "id": 1,
      "name": "Mattancherry Palace",
      "description":
          "Dutch Palace showcasing Kerala's royal heritage with stunning murals and artifacts",
      "image":
          "https://images.unsplash.com/photo-1582510003544-4d00b7f74220?fm=jpg&q=60&w=3000",
      "distance": "2.5 km",
      "rating": 4.6,
      "hasAR": true,
      "isFavorite": false,
      "category": "Palace"
    },
    {
      "id": 2,
      "name": "Chinese Fishing Nets",
      "description":
          "Iconic fishing nets at Fort Kochi, symbol of Kerala's maritime heritage",
      "image":
          "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?fm=jpg&q=60&w=3000",
      "distance": "1.8 km",
      "rating": 4.4,
      "hasAR": true,
      "isFavorite": true,
      "category": "Heritage Site"
    },
    {
      "id": 3,
      "name": "Padmanabhaswamy Temple",
      "description":
          "Ancient temple dedicated to Lord Vishnu, architectural marvel of Kerala",
      "image":
          "https://images.unsplash.com/photo-1544735716-392fe2489ffa?fm=jpg&q=60&w=3000",
      "distance": "45 km",
      "rating": 4.8,
      "hasAR": false,
      "isFavorite": false,
      "category": "Temple"
    }
  ];

  // Mock data for nearby sites
  final List<Map<String, dynamic>> _nearbySites = [
    {
      "id": 4,
      "name": "St. Francis Church",
      "description":
          "Oldest European church in India, where Vasco da Gama was buried",
      "image":
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?fm=jpg&q=60&w=3000",
      "distance": "0.8 km",
      "rating": 4.3,
      "hasAR": true,
      "isFavorite": false,
      "category": "Church"
    },
    {
      "id": 5,
      "name": "Jew Town Synagogue",
      "description": "Historic synagogue showcasing Kerala's Jewish heritage",
      "image":
          "https://images.unsplash.com/photo-1548013146-72479768bada?fm=jpg&q=60&w=3000",
      "distance": "1.2 km",
      "rating": 4.5,
      "hasAR": false,
      "isFavorite": true,
      "category": "Synagogue"
    }
  ];

  // Mock data for trending experiences
  final List<Map<String, dynamic>> _trendingExperiences = [
    {
      "id": 6,
      "name": "Backwater Heritage Cruise",
      "description":
          "Traditional houseboat experience through Kerala's scenic backwaters",
      "image":
          "https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?fm=jpg&q=60&w=3000",
      "distance": "5.2 km",
      "rating": 4.7,
      "hasAR": false,
      "isFavorite": false,
      "category": "Experience"
    },
    {
      "id": 7,
      "name": "Kathakali Performance",
      "description":
          "Traditional dance drama showcasing Kerala's cultural heritage",
      "image":
          "https://images.unsplash.com/photo-1578662996442-48f60103fc96?fm=jpg&q=60&w=3000",
      "distance": "3.1 km",
      "rating": 4.6,
      "hasAR": true,
      "isFavorite": false,
      "category": "Cultural"
    }
  ];

  // Mock data for saved sites
  final List<Map<String, dynamic>> _savedSites = [
    {
      "id": 8,
      "name": "Hill Palace Museum",
      "description":
          "Archaeological museum in the largest heritage complex in Kerala",
      "image":
          "https://images.unsplash.com/photo-1571115764595-644a1f56a55c?fm=jpg&q=60&w=3000",
      "distance": "12.5 km",
      "rating": 4.4,
      "hasAR": true,
      "isFavorite": true,
      "category": "Museum"
    }
  ];

  // Mock data for recommended itineraries
  final List<Map<String, dynamic>> _recommendedItineraries = [
    {
      "id": 1,
      "title": "Heritage Kochi Explorer",
      "description":
          "Discover the colonial charm and cultural heritage of Fort Kochi in 3 days",
      "duration": 3,
      "price": "₹8,500",
      "rating": 4.7,
      "locations": ["Fort Kochi", "Mattancherry", "Jew Town", "Chinese Nets"],
      "images": [
        "https://images.unsplash.com/photo-1582510003544-4d00b7f74220?fm=jpg&q=60&w=3000",
        "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?fm=jpg&q=60&w=3000",
        "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?fm=jpg&q=60&w=3000"
      ]
    },
    {
      "id": 2,
      "title": "Backwater & Heritage Trail",
      "description":
          "Experience Kerala's backwaters combined with historic temple visits",
      "duration": 5,
      "price": "₹15,200",
      "rating": 4.8,
      "locations": ["Alleppey", "Kumarakom", "Padmanabhaswamy", "Trivandrum"],
      "images": [
        "https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?fm=jpg&q=60&w=3000",
        "https://images.unsplash.com/photo-1544735716-392fe2489ffa?fm=jpg&q=60&w=3000",
        "https://images.unsplash.com/photo-1571115764595-644a1f56a55c?fm=jpg&q=60&w=3000"
      ]
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _handleRefresh,
        color: AppTheme.lightTheme.colorScheme.primary,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: LocationHeaderWidget(
                currentLocation: 'Fort Kochi, Kerala',
                weatherInfo: '28°C',
                onLocationTap: _handleLocationTap,
              ),
            ),
            SliverToBoxAdapter(
              child: SearchBarWidget(
                onTap: _handleSearchTap,
                onVoiceSearch: _handleVoiceSearch,
              ),
            ),
            SliverToBoxAdapter(
              child: FeaturedSitesWidget(
                featuredSites: _featuredSites,
                onSiteTap: _handleSiteTap,
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 2.h)),
            SliverToBoxAdapter(
              child: SectionHeaderWidget(
                title: 'Near You',
                subtitle: 'Heritage sites within 5km radius',
                onViewAllTap: _handleViewAllNearby,
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 42.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  itemCount: _nearbySites.length,
                  itemBuilder: (context, index) {
                    return HeritageSiteCardWidget(
                      site: _nearbySites[index],
                      onTap: () => _handleSiteTap(_nearbySites[index]),
                      onFavoriteTap: () =>
                          _handleFavoriteTap(_nearbySites[index]),
                      onShareTap: () => _handleShareTap(_nearbySites[index]),
                      onDirectionsTap: () =>
                          _handleDirectionsTap(_nearbySites[index]),
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 2.h)),
            SliverToBoxAdapter(
              child: SectionHeaderWidget(
                title: 'Trending Experiences',
                subtitle: 'Popular cultural activities this month',
                onViewAllTap: _handleViewAllTrending,
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 42.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  itemCount: _trendingExperiences.length,
                  itemBuilder: (context, index) {
                    return HeritageSiteCardWidget(
                      site: _trendingExperiences[index],
                      onTap: () => _handleSiteTap(_trendingExperiences[index]),
                      onFavoriteTap: () =>
                          _handleFavoriteTap(_trendingExperiences[index]),
                      onShareTap: () =>
                          _handleShareTap(_trendingExperiences[index]),
                      onDirectionsTap: () =>
                          _handleDirectionsTap(_trendingExperiences[index]),
                    );
                  },
                ),
              ),
            ),
            if (_savedSites.isNotEmpty) ...[
              SliverToBoxAdapter(child: SizedBox(height: 2.h)),
              SliverToBoxAdapter(
                child: SectionHeaderWidget(
                  title: 'Your Saved Sites',
                  subtitle: 'Places you want to visit',
                  onViewAllTap: _handleViewAllSaved,
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 42.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    itemCount: _savedSites.length,
                    itemBuilder: (context, index) {
                      return HeritageSiteCardWidget(
                        site: _savedSites[index],
                        onTap: () => _handleSiteTap(_savedSites[index]),
                        onFavoriteTap: () =>
                            _handleFavoriteTap(_savedSites[index]),
                        onShareTap: () => _handleShareTap(_savedSites[index]),
                        onDirectionsTap: () =>
                            _handleDirectionsTap(_savedSites[index]),
                      );
                    },
                  ),
                ),
              ),
            ],
            SliverToBoxAdapter(child: SizedBox(height: 2.h)),
            SliverToBoxAdapter(
              child: SectionHeaderWidget(
                title: 'Recommended Itineraries',
                subtitle: 'Curated trips based on your preferences',
                onViewAllTap: _handleViewAllItineraries,
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 45.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  itemCount: _recommendedItineraries.length,
                  itemBuilder: (context, index) {
                    return RecommendedItineraryCardWidget(
                      itinerary: _recommendedItineraries[index],
                      onTap: () =>
                          _handleItineraryTap(_recommendedItineraries[index]),
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 10.h)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _handleARCameraTap,
        backgroundColor: AppTheme.accentLight,
        foregroundColor: Colors.white,
        icon: CustomIconWidget(
          iconName: 'camera_alt',
          color: Colors.white,
          size: 24,
        ),
        label: Text(
          'Explore AR',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentBottomNavIndex,
        onTap: _handleBottomNavTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        selectedItemColor: AppTheme.lightTheme.colorScheme.primary,
        unselectedItemColor:
            AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6),
        elevation: 8,
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'explore',
              color: _currentBottomNavIndex == 0
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
              size: 24,
            ),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'camera_alt',
              color: _currentBottomNavIndex == 1
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
              size: 24,
            ),
            label: 'AR Camera',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'map',
              color: _currentBottomNavIndex == 2
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
              size: 24,
            ),
            label: 'Trips',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'person',
              color: _currentBottomNavIndex == 3
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
              size: 24,
            ),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'photo_library',
              color: _currentBottomNavIndex == 4
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
              size: 24,
            ),
            label: 'More',
          ),
        ],
      ),
    );
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });
  }

  void _handleLocationTap() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Select Location',
              style: TextStyle(
                color: AppTheme.lightTheme.colorScheme.onSurface,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'my_location',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Use Current Location'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'location_city',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Fort Kochi, Kerala'),
              trailing: CustomIconWidget(
                iconName: 'check',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'location_city',
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.6),
                size: 24,
              ),
              title: Text('Thiruvananthapuram, Kerala'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'location_city',
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.6),
                size: 24,
              ),
              title: Text('Munnar, Kerala'),
              onTap: () => Navigator.pop(context),
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _handleSearchTap() {
    // Navigate to search screen or show search overlay
    showSearch(
      context: context,
      delegate: _HeritageSearchDelegate(),
    );
  }

  void _handleVoiceSearch() {
    // Implement voice search functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Voice search activated'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _handleSiteTap(Map<String, dynamic> site) {
    // Navigate to site details or AR experience
    if (site['hasAR'] == true) {
      Navigator.pushNamed(context, '/ar-camera-experience');
    } else {
      // Navigate to site details page
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Opening ${site['name']}...'),
          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        ),
      );
    }
  }

  void _handleFavoriteTap(Map<String, dynamic> site) {
    setState(() {
      site['isFavorite'] = !(site['isFavorite'] ?? false);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(site['isFavorite'] == true
            ? 'Added to favorites'
            : 'Removed from favorites'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _handleShareTap(Map<String, dynamic> site) {
    // Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing ${site['name']}...'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _handleDirectionsTap(Map<String, dynamic> site) {
    // Open maps app or navigate to directions
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Getting directions to ${site['name']}...'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _handleItineraryTap(Map<String, dynamic> itinerary) {
    Navigator.pushNamed(context, '/trip-planning-assistant');
  }

  void _handleARCameraTap() {
    Navigator.pushNamed(context, '/ar-camera-experience');
  }

  void _handleViewAllNearby() {
    // Navigate to nearby sites list
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Showing all nearby sites...'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _handleViewAllTrending() {
    // Navigate to trending experiences list
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Showing all trending experiences...'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _handleViewAllSaved() {
    // Navigate to saved sites list
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Showing all saved sites...'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _handleViewAllItineraries() {
    Navigator.pushNamed(context, '/trip-planning-assistant');
  }

  void _handleBottomNavTap(int index) {
    setState(() {
      _currentBottomNavIndex = index;
    });

    switch (index) {
      case 0:
        // Already on dashboard
        break;
      case 1:
        Navigator.pushNamed(context, '/ar-camera-experience');
        break;
      case 2:
        Navigator.pushNamed(context, '/trip-planning-assistant');
        break;
      case 3:
        Navigator.pushNamed(context, '/authentication-screen');
        break;
      case 4:
        BusinessNavigationHelper.showBusinessFeatures(context);
        break;
    }
  }
}

class _HeritageSearchDelegate extends SearchDelegate<String> {
  final List<String> _searchHistory = [
    'Mattancherry Palace',
    'Chinese Fishing Nets',
    'Backwater cruise',
    'Kathakali performance',
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: CustomIconWidget(
          iconName: 'clear',
          color: AppTheme.lightTheme.colorScheme.onSurface,
          size: 24,
        ),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: CustomIconWidget(
        iconName: 'arrow_back',
        color: AppTheme.lightTheme.colorScheme.onSurface,
        size: 24,
      ),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'search',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'Searching for "$query"...',
            style: TextStyle(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = query.isEmpty
        ? _searchHistory
        : _searchHistory
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];
        return ListTile(
          leading: CustomIconWidget(
            iconName: query.isEmpty ? 'history' : 'search',
            color: AppTheme.lightTheme.colorScheme.onSurface
                .withValues(alpha: 0.6),
            size: 20,
          ),
          title: Text(suggestion),
          onTap: () {
            query = suggestion;
            showResults(context);
          },
        );
      },
    );
  }
}
