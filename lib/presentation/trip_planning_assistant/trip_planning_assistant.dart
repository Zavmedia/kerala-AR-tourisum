import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/calendar_integration_widget.dart';
import './widgets/itinerary_day_card.dart';
import './widgets/traveler_type_chips.dart';
import './widgets/trip_duration_selector.dart';
import './widgets/trip_summary_bottom_sheet.dart';

class TripPlanningAssistant extends StatefulWidget {
  const TripPlanningAssistant({super.key});

  @override
  State<TripPlanningAssistant> createState() => _TripPlanningAssistantState();
}

class _TripPlanningAssistantState extends State<TripPlanningAssistant>
    with TickerProviderStateMixin {
  int _selectedDuration = 3;
  String _selectedTravelerType = 'Cultural Enthusiast';
  bool _isEditMode = false;
  bool _isGeneratingItinerary = false;
  bool _showCalendar = false;
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  late AnimationController _fabAnimationController;
  late Animation<double> _fabScaleAnimation;

  final PageController _pageController = PageController();
  int _currentPageIndex = 0;

  // Mock data for AI-generated itinerary
  final List<Map<String, dynamic>> _mockItinerary = [
    {
      "day": 1,
      "title": "Kochi Heritage Discovery",
      "duration": "8 hours",
      "totalCost": "₹2,500",
      "travelTime": "30 mins",
      "activities": [
        {
          "name": "Fort Kochi Chinese Fishing Nets",
          "time": "9:00 AM - 10:30 AM",
          "image":
              "https://images.unsplash.com/photo-1578662996442-48f60103fc96?fm=jpg&q=60&w=3000",
          "arAvailable": true,
          "bookingStatus": "available"
        },
        {
          "name": "Mattancherry Palace",
          "time": "11:00 AM - 12:30 PM",
          "image":
              "https://images.unsplash.com/photo-1544735716-392fe2489ffa?fm=jpg&q=60&w=3000",
          "arAvailable": true,
          "bookingStatus": "booked"
        },
        {
          "name": "Jewish Synagogue",
          "time": "2:00 PM - 3:30 PM",
          "image":
              "https://images.unsplash.com/photo-1609137144813-7d9921338f24?fm=jpg&q=60&w=3000",
          "arAvailable": false,
          "bookingStatus": "available"
        }
      ]
    },
    {
      "day": 2,
      "title": "Backwater Heritage Trail",
      "duration": "9 hours",
      "totalCost": "₹3,200",
      "travelTime": "1 hour",
      "activities": [
        {
          "name": "Alleppey Backwater Cruise",
          "time": "8:00 AM - 12:00 PM",
          "image":
              "https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?fm=jpg&q=60&w=3000",
          "arAvailable": true,
          "bookingStatus": "available"
        },
        {
          "name": "Traditional Houseboat Experience",
          "time": "1:00 PM - 4:00 PM",
          "image":
              "https://images.unsplash.com/photo-1544735716-392fe2489ffa?fm=jpg&q=60&w=3000",
          "arAvailable": false,
          "bookingStatus": "available"
        },
        {
          "name": "Kumrakom Bird Sanctuary",
          "time": "4:30 PM - 6:00 PM",
          "image":
              "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?fm=jpg&q=60&w=3000",
          "arAvailable": true,
          "bookingStatus": "available"
        }
      ]
    },
    {
      "day": 3,
      "title": "Munnar Hill Station Heritage",
      "duration": "10 hours",
      "totalCost": "₹2,800",
      "travelTime": "2 hours",
      "activities": [
        {
          "name": "Tea Museum & Plantation",
          "time": "9:00 AM - 11:00 AM",
          "image":
              "https://images.unsplash.com/photo-1597318181409-cf64e4940c4b?fm=jpg&q=60&w=3000",
          "arAvailable": true,
          "bookingStatus": "available"
        },
        {
          "name": "Eravikulam National Park",
          "time": "11:30 AM - 2:00 PM",
          "image":
              "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?fm=jpg&q=60&w=3000",
          "arAvailable": false,
          "bookingStatus": "available"
        },
        {
          "name": "Mattupetty Dam & Echo Point",
          "time": "3:00 PM - 5:00 PM",
          "image":
              "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?fm=jpg&q=60&w=3000",
          "arAvailable": true,
          "bookingStatus": "available"
        }
      ]
    }
  ];

  final Map<String, dynamic> _mockTripSummary = {
    "duration": 3,
    "totalCost": "₹8,500",
    "totalDistance": "245 km",
    "totalSites": 12,
    "arExperiences": 8,
    "totalActivities": 15,
    "culturalHighlights": [
      "Traditional Kathakali Performance",
      "Backwater Heritage Cruise",
      "Spice Plantation Tour",
      "Ancient Temple Architecture"
    ]
  };

  final List<DateTime> _festivalDates = [
    DateTime.now().add(const Duration(days: 15)),
    DateTime.now().add(const Duration(days: 32)),
    DateTime.now().add(const Duration(days: 45)),
  ];

  final List<DateTime> _optimalDates = [
    DateTime.now().add(const Duration(days: 10)),
    DateTime.now().add(const Duration(days: 11)),
    DateTime.now().add(const Duration(days: 12)),
    DateTime.now().add(const Duration(days: 25)),
    DateTime.now().add(const Duration(days: 26)),
    DateTime.now().add(const Duration(days: 27)),
  ];

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: _showCalendar ? _buildCalendarView() : _buildMainContent(),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          size: 24,
        ),
      ),
      title: Text(
        'Trip Planning Assistant',
        style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      actions: [
        if (!_showCalendar)
          IconButton(
            onPressed: () {
              setState(() {
                _showCalendar = true;
              });
            },
            icon: CustomIconWidget(
              iconName: 'calendar_today',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 24,
            ),
            tooltip: 'Select Dates',
          ),
        if (_showCalendar)
          IconButton(
            onPressed: () {
              setState(() {
                _showCalendar = false;
              });
            },
            icon: CustomIconWidget(
              iconName: 'close',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 24,
            ),
            tooltip: 'Close Calendar',
          ),
        IconButton(
          onPressed: () {
            setState(() {
              _isEditMode = !_isEditMode;
            });
          },
          icon: CustomIconWidget(
            iconName: _isEditMode ? 'check' : 'edit',
            color: AppTheme.lightTheme.colorScheme.onPrimary,
            size: 24,
          ),
          tooltip: _isEditMode ? 'Save Changes' : 'Edit Itinerary',
        ),
      ],
    );
  }

  Widget _buildCalendarView() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: CalendarIntegrationWidget(
        selectedStartDate: _selectedStartDate,
        selectedEndDate: _selectedEndDate,
        onDateRangeSelected: (start, end) {
          setState(() {
            _selectedStartDate = start;
            _selectedEndDate = end;
          });
        },
        festivalDates: _festivalDates,
        optimalDates: _optimalDates,
      ),
    );
  }

  Widget _buildMainContent() {
    return Column(
      children: [
        _buildPreferencesSection(),
        if (_isGeneratingItinerary) _buildGeneratingIndicator(),
        if (!_isGeneratingItinerary) _buildItinerarySection(),
      ],
    );
  }

  Widget _buildPreferencesSection() {
    return Container(
      color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(4.w, 2.h, 4.w, 1.h),
            child: Text(
              'Trip Duration',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TripDurationSelector(
            selectedDuration: _selectedDuration,
            onDurationChanged: (duration) {
              setState(() {
                _selectedDuration = duration;
                _generateNewItinerary();
              });
            },
          ),
          SizedBox(height: 2.h),
          Padding(
            padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 1.h),
            child: Text(
              'Traveler Type',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TravelerTypeChips(
            selectedType: _selectedTravelerType,
            onTypeChanged: (type) {
              setState(() {
                _selectedTravelerType = type;
                _generateNewItinerary();
              });
            },
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildGeneratingIndicator() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 20.w,
              height: 10.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'AI is crafting your perfect Kerala heritage experience...',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              'Analyzing cultural sites, weather patterns, and local events',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItinerarySection() {
    return Expanded(
      child: Column(
        children: [
          _buildItineraryHeader(),
          _buildItineraryList(),
        ],
      ),
    );
  }

  Widget _buildItineraryHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.secondary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: CustomIconWidget(
              iconName: 'route',
              color: AppTheme.lightTheme.colorScheme.secondary,
              size: 24,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your AI-Generated Itinerary',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '$_selectedDuration days • $_selectedTravelerType',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: _showTripSummary,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.tertiary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.tertiary
                      .withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'summarize',
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    size: 16,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    'Summary',
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItineraryList() {
    final itineraryToShow = _mockItinerary.take(_selectedDuration).toList();

    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.only(bottom: 10.h),
        itemCount: itineraryToShow.length,
        itemBuilder: (context, index) {
          return ItineraryDayCard(
            dayData: itineraryToShow[index],
            isEditMode: _isEditMode,
            onEdit: () => _editDayItinerary(index),
            onAlternatives: () => _showAlternatives(index),
          );
        },
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return AnimatedBuilder(
      animation: _fabScaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _fabScaleAnimation.value,
          child: FloatingActionButton.extended(
            onPressed: () {
              _fabAnimationController.forward().then((_) {
                _fabAnimationController.reverse();
              });
              _showTripSummary();
            },
            backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
            foregroundColor: AppTheme.lightTheme.colorScheme.onSecondary,
            icon: CustomIconWidget(
              iconName: 'save',
              color: AppTheme.lightTheme.colorScheme.onSecondary,
              size: 20,
            ),
            label: const Text('Save & Share Trip'),
            elevation: 8,
          ),
        );
      },
    );
  }

  void _generateNewItinerary() {
    setState(() {
      _isGeneratingItinerary = true;
    });

    // Simulate AI generation delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isGeneratingItinerary = false;
        });
      }
    });
  }

  void _editDayItinerary(int dayIndex) {
    // Show edit options for the day
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 60.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 2.h, bottom: 1.h),
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Text(
                'Edit Day ${dayIndex + 1} Itinerary',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Drag and drop activities to reorder\nTap sites to view alternatives',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAlternatives(int dayIndex) {
    // Show alternative suggestions for the day
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 70.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 2.h, bottom: 1.h),
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Text(
                'Alternative Suggestions',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'swap_horiz',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 48,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'AI-powered alternatives coming soon!',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Get personalized site recommendations\nbased on your preferences',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.6),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTripSummary() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TripSummaryBottomSheet(
        tripData: _mockTripSummary,
        onSaveTrip: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Trip saved to your favorites!'),
              backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        onShareTrip: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Trip shared successfully!'),
              backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        onBookAll: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Booking complete trip...'),
              backgroundColor: AppTheme.lightTheme.colorScheme.primary,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }
}
