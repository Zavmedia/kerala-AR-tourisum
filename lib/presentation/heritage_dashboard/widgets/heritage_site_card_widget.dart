import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class HeritageSiteCardWidget extends StatelessWidget {
  final Map<String, dynamic> site;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onShareTap;
  final VoidCallback? onDirectionsTap;

  const HeritageSiteCardWidget({
    super.key,
    required this.site,
    this.onTap,
    this.onFavoriteTap,
    this.onShareTap,
    this.onDirectionsTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: () => _showQuickActions(context),
      child: Container(
        width: 60.w,
        margin: EdgeInsets.only(right: 4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color:
                  AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: Stack(
                children: [
                  CustomImageWidget(
                    imageUrl: site['image'] as String,
                    width: 60.w,
                    height: 20.h,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 1.h,
                    right: 2.w,
                    child: Row(
                      children: [
                        if (site['hasAR'] == true)
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color: AppTheme.accentLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'AR',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        SizedBox(width: 1.w),
                        GestureDetector(
                          onTap: onFavoriteTap,
                          child: Container(
                            padding: EdgeInsets.all(1.w),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.3),
                              shape: BoxShape.circle,
                            ),
                            child: CustomIconWidget(
                              iconName: site['isFavorite'] == true
                                  ? 'favorite'
                                  : 'favorite_border',
                              color: site['isFavorite'] == true
                                  ? Colors.red
                                  : Colors.white,
                              size: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(3.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    site['name'] as String,
                    style: TextStyle(
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    site['description'] as String,
                    style: TextStyle(
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.7),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'location_on',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 12,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        '${site['distance']} away',
                        style: TextStyle(
                          color: AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Spacer(),
                      CustomIconWidget(
                        iconName: 'star',
                        color: AppTheme.goldLight,
                        size: 12,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        '${site['rating']}',
                        style: TextStyle(
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pushNamed(
                              context, '/ar-camera-experience'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                AppTheme.lightTheme.colorScheme.primary,
                            foregroundColor:
                                AppTheme.lightTheme.colorScheme.onPrimary,
                            padding: EdgeInsets.symmetric(vertical: 1.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            site['hasAR'] == true ? 'AR Preview' : 'Explore',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      OutlinedButton(
                        onPressed: () => Navigator.pushNamed(
                            context, '/trip-planning-assistant'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor:
                              AppTheme.lightTheme.colorScheme.primary,
                          side: BorderSide(
                              color: AppTheme.lightTheme.colorScheme.primary),
                          padding: EdgeInsets.symmetric(
                              horizontal: 3.w, vertical: 1.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: CustomIconWidget(
                          iconName: 'add',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuickActions(BuildContext context) {
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
              site['name'] as String,
              style: TextStyle(
                color: AppTheme.lightTheme.colorScheme.onSurface,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildQuickActionButton(
                  context,
                  'favorite',
                  'Save to Favorites',
                  onFavoriteTap,
                ),
                _buildQuickActionButton(
                  context,
                  'share',
                  'Share',
                  onShareTap,
                ),
                _buildQuickActionButton(
                  context,
                  'directions',
                  'Get Directions',
                  onDirectionsTap,
                ),
              ],
            ),
            SizedBox(height: 2.h),
            // Business features row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildQuickActionButton(
                  context,
                  'confirmation_number',
                  'Book Tickets',
                  () => _bookTickets(context),
                ),
                _buildQuickActionButton(
                  context,
                  'feedback',
                  'Leave Feedback',
                  () => _leaveFeedback(context),
                ),
                _buildQuickActionButton(
                  context,
                  'explore',
                  'Discover More',
                  () => _discoverMore(context),
                ),
              ],
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context,
    String iconName,
    String label,
    VoidCallback? onTap,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        onTap?.call();
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: iconName,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            label,
            style: TextStyle(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _bookTickets(BuildContext context) {
    Navigator.pop(context);
    
    // Create sample ticket for quick checkout
    final ticket = TicketType(
      id: '${site['id']}_ticket',
      name: '${site['name']} Entry Ticket',
      price: 50.0, // Sample price
      description: 'Entry ticket for ${site['name']}',
      quantity: 1,
      maxQuantity: 10,
      isAvailable: true,
    );

    BusinessNavigationHelper.navigateToCheckout(
      context,
      tickets: [ticket],
      merchandise: [],
      heritageSiteId: site['id'].toString(),
    );
  }

  void _leaveFeedback(BuildContext context) {
    Navigator.pop(context);
    
    BusinessNavigationHelper.navigateToFeedback(
      context,
      heritageSiteId: site['id'].toString(),
      heritageSiteName: site['name'] as String,
    );
  }

  void _discoverMore(BuildContext context) {
    Navigator.pop(context);
    
    BusinessNavigationHelper.navigateToDiscover(context);
  }
}
