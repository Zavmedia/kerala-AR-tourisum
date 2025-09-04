import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MemorySearchWidget extends StatefulWidget {
  final Function(String) onSearchChanged;
  final Function(String) onFilterChanged;
  final VoidCallback? onClearSearch;

  const MemorySearchWidget({
    super.key,
    required this.onSearchChanged,
    required this.onFilterChanged,
    this.onClearSearch,
  });

  @override
  State<MemorySearchWidget> createState() => _MemorySearchWidgetState();
}

class _MemorySearchWidgetState extends State<MemorySearchWidget> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'all';
  bool _isSearchActive = false;

  final List<Map<String, String>> _filters = [
    {'key': 'all', 'label': 'All', 'icon': 'apps'},
    {'key': 'photos', 'label': 'Photos', 'icon': 'photo'},
    {'key': 'videos', 'label': 'Videos', 'icon': 'videocam'},
    {'key': 'ar', 'label': 'AR', 'icon': 'view_in_ar'},
    {'key': 'notes', 'label': 'Notes', 'icon': 'note'},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSearchBar(context),
          SizedBox(height: 2.h),
          _buildFilterChips(context),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isSearchActive
              ? AppTheme.lightTheme.colorScheme.primary
              : AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          width: _isSearchActive ? 2 : 1,
        ),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          widget.onSearchChanged(value);
          setState(() {
            _isSearchActive = value.isNotEmpty;
          });
        },
        onTap: () {
          setState(() {
            _isSearchActive = true;
          });
        },
        onSubmitted: (value) {
          setState(() {
            _isSearchActive = value.isNotEmpty;
          });
        },
        decoration: InputDecoration(
          hintText: 'Search memories by location, date, or themes...',
          hintStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface
                .withValues(alpha: 0.5),
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.all(3.w),
            child: CustomIconWidget(
              iconName: 'search',
              color: _isSearchActive
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.5),
              size: 5.w,
            ),
          ),
          suffixIcon: _isSearchActive
              ? GestureDetector(
                  onTap: () {
                    _searchController.clear();
                    widget.onSearchChanged('');
                    widget.onClearSearch?.call();
                    setState(() {
                      _isSearchActive = false;
                    });
                    FocusScope.of(context).unfocus();
                  },
                  child: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'clear',
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.5),
                      size: 5.w,
                    ),
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.w),
        ),
        style: AppTheme.lightTheme.textTheme.bodyMedium,
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _filters.map((filter) {
          final isSelected = _selectedFilter == filter['key'];
          return Padding(
            padding: EdgeInsets.only(right: 2.w),
            child: FilterChip(
              selected: isSelected,
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: filter['icon']!,
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.onPrimary
                        : AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.7),
                    size: 4.w,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    filter['label']!,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.onPrimary
                          : AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.7),
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = filter['key']!;
                });
                widget.onFilterChanged(filter['key']!);
              },
              backgroundColor: AppTheme.lightTheme.colorScheme.surface,
              selectedColor: AppTheme.lightTheme.colorScheme.primary,
              checkmarkColor: AppTheme.lightTheme.colorScheme.onPrimary,
              side: BorderSide(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                width: 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
