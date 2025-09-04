import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FeaturedSitesWidget extends StatelessWidget {
  final List<Map<String, dynamic>> featuredSites;
  final Function(Map<String, dynamic>)? onSiteTap;

  const FeaturedSitesWidget({
    super.key,
    required this.featuredSites,
    this.onSiteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Featured Heritage Sites',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'View All',
                  style: TextStyle(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 1.h),
        SizedBox(
          height: 32.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            itemCount: featuredSites.length,
            itemBuilder: (context, index) {
              final site = featuredSites[index];
              return _buildFeaturedSiteCard(context, site);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedSiteCard(
      BuildContext context, Map<String, dynamic> site) {
    return GestureDetector(
      onTap: () => onSiteTap?.call(site),
      child: Container(
        width: 70.w,
        margin: EdgeInsets.only(right: 4.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color:
                  AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              CustomImageWidget(
                imageUrl: site['image'] as String,
                width: 70.w,
                height: 32.h,
                fit: BoxFit.cover,
              ),
              Container(
                width: 70.w,
                height: 32.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.7),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 2.h,
                right: 3.w,
                child: Row(
                  children: [
                    if (site['hasAR'] == true)
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: AppTheme.accentLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomIconWidget(
                              iconName: 'camera_alt',
                              color: Colors.white,
                              size: 12,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              'AR',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    SizedBox(width: 2.w),
                    GestureDetector(
                      onTap: () {},
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
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        site['name'] as String,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 0.5.h),
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'location_on',
                            color: Colors.white.withValues(alpha: 0.8),
                            size: 14,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            '${site['distance']} away',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Spacer(),
                          CustomIconWidget(
                            iconName: 'star',
                            color: AppTheme.goldLight,
                            size: 14,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            '${site['rating']}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
