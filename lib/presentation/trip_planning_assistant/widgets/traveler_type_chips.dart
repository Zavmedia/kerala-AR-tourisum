import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TravelerTypeChips extends StatefulWidget {
  final String selectedType;
  final ValueChanged<String> onTypeChanged;

  const TravelerTypeChips({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
  });

  @override
  State<TravelerTypeChips> createState() => _TravelerTypeChipsState();
}

class _TravelerTypeChipsState extends State<TravelerTypeChips> {
  final List<Map<String, dynamic>> travelerTypes = [
    {'type': 'Solo', 'icon': 'person'},
    {'type': 'Family', 'icon': 'family_restroom'},
    {'type': 'Cultural Enthusiast', 'icon': 'museum'},
    {'type': 'Photography', 'icon': 'camera_alt'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8.h,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: travelerTypes.length,
        itemBuilder: (context, index) {
          final travelerType = travelerTypes[index];
          final isSelected = travelerType['type'] == widget.selectedType;

          return Padding(
            padding: EdgeInsets.only(right: 3.w),
            child: GestureDetector(
              onTap: () => widget.onTypeChanged(travelerType['type']),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.secondary
                      : AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.secondary
                        : AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: travelerType['icon'],
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.onSecondary
                          : AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.7),
                      size: 18,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      travelerType['type'],
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.onSecondary
                            : AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.7),
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
