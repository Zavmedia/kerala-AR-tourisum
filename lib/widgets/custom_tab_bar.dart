import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum CustomTabBarVariant {
  standard,
  pills,
  underline,
  segmented,
}

class CustomTabBar extends StatefulWidget {
  final List<String> tabs;
  final CustomTabBarVariant variant;
  final int initialIndex;
  final ValueChanged<int>? onTap;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? backgroundColor;
  final Color? indicatorColor;
  final EdgeInsetsGeometry? padding;
  final bool isScrollable;

  const CustomTabBar({
    super.key,
    required this.tabs,
    this.variant = CustomTabBarVariant.standard,
    this.initialIndex = 0,
    this.onTap,
    this.selectedColor,
    this.unselectedColor,
    this.backgroundColor,
    this.indicatorColor,
    this.padding,
    this.isScrollable = false,
  });

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.tabs.length,
      vsync: this,
      initialIndex: widget.initialIndex,
    );
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _tabController.addListener(() {
      if (widget.onTap != null && _tabController.indexIsChanging) {
        widget.onTap!(_tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (widget.variant) {
      case CustomTabBarVariant.pills:
        return _buildPillsTabBar(context, colorScheme);
      case CustomTabBarVariant.underline:
        return _buildUnderlineTabBar(context, colorScheme);
      case CustomTabBarVariant.segmented:
        return _buildSegmentedTabBar(context, colorScheme);
      case CustomTabBarVariant.standard:
      default:
        return _buildStandardTabBar(context, colorScheme);
    }
  }

  Widget _buildStandardTabBar(BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: widget.isScrollable,
        labelColor: widget.selectedColor ?? colorScheme.primary,
        unselectedLabelColor: widget.unselectedColor ??
            colorScheme.onSurface.withValues(alpha: 0.6),
        indicatorColor: widget.indicatorColor ?? colorScheme.primary,
        indicatorSize: TabBarIndicatorSize.label,
        indicatorWeight: 2,
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        tabs: widget.tabs.map((tab) => Tab(text: tab)).toList(),
      ),
    );
  }

  Widget _buildPillsTabBar(BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: widget.padding ?? const EdgeInsets.all(16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: widget.tabs.asMap().entries.map((entry) {
            final index = entry.key;
            final tab = entry.value;
            final isSelected = index == _tabController.index;

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () {
                  _tabController.animateTo(index);
                  if (widget.onTap != null) {
                    widget.onTap!(index);
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (widget.selectedColor ?? colorScheme.primary)
                        : (widget.backgroundColor ?? colorScheme.surface),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isSelected
                          ? (widget.selectedColor ?? colorScheme.primary)
                          : colorScheme.outline.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected
                          ? colorScheme.onPrimary
                          : (widget.unselectedColor ??
                              colorScheme.onSurface.withValues(alpha: 0.7)),
                    ),
                    child: Text(tab),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildUnderlineTabBar(BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: widget.tabs.asMap().entries.map((entry) {
              final index = entry.key;
              final tab = entry.value;
              final isSelected = index == _tabController.index;

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    _tabController.animateTo(index);
                    if (widget.onTap != null) {
                      widget.onTap!(index);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 300),
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                          color: isSelected
                              ? (widget.selectedColor ?? colorScheme.primary)
                              : (widget.unselectedColor ??
                                  colorScheme.onSurface.withValues(alpha: 0.6)),
                        ),
                        child: Text(tab),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          Container(
            height: 2,
            child: TabBarView(
              controller: _tabController,
              children: widget.tabs.map((tab) {
                return Container(
                  decoration: BoxDecoration(
                    color: widget.indicatorColor ?? colorScheme.primary,
                    borderRadius: BorderRadius.circular(1),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentedTabBar(BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: widget.padding ?? const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: widget.tabs.asMap().entries.map((entry) {
            final index = entry.key;
            final tab = entry.value;
            final isSelected = index == _tabController.index;
            final isFirst = index == 0;
            final isLast = index == widget.tabs.length - 1;

            return Expanded(
              child: GestureDetector(
                onTap: () {
                  _tabController.animateTo(index);
                  if (widget.onTap != null) {
                    widget.onTap!(index);
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (widget.selectedColor ?? colorScheme.primary)
                        : Colors.transparent,
                    borderRadius: BorderRadius.horizontal(
                      left: isFirst ? const Radius.circular(11) : Radius.zero,
                      right: isLast ? const Radius.circular(11) : Radius.zero,
                    ),
                  ),
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 300),
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected
                            ? colorScheme.onPrimary
                            : (widget.unselectedColor ??
                                colorScheme.onSurface.withValues(alpha: 0.7)),
                      ),
                      child: Text(tab),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
