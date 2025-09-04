import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum CustomBottomBarVariant {
  standard,
  floating,
  minimal,
}

class CustomBottomBar extends StatefulWidget {
  final CustomBottomBarVariant variant;
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final double elevation;

  const CustomBottomBar({
    super.key,
    this.variant = CustomBottomBarVariant.standard,
    this.currentIndex = 0,
    this.onTap,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.elevation = 8,
  });

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  final List<_BottomBarItem> _items = [
    _BottomBarItem(
      icon: Icons.explore_outlined,
      activeIcon: Icons.explore,
      label: 'Explore',
      route: '/heritage-dashboard',
    ),
    _BottomBarItem(
      icon: Icons.camera_alt_outlined,
      activeIcon: Icons.camera_alt,
      label: 'AR Camera',
      route: '/ar-camera-experience',
    ),
    _BottomBarItem(
      icon: Icons.map_outlined,
      activeIcon: Icons.map,
      label: 'Trip Plan',
      route: '/trip-planning-assistant',
    ),
    _BottomBarItem(
      icon: Icons.photo_library_outlined,
      activeIcon: Icons.photo_library,
      label: 'Memories',
      route: '/memory-wall',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (widget.variant) {
      case CustomBottomBarVariant.floating:
        return _buildFloatingBottomBar(context, colorScheme);
      case CustomBottomBarVariant.minimal:
        return _buildMinimalBottomBar(context, colorScheme);
      case CustomBottomBarVariant.standard:
      default:
        return _buildStandardBottomBar(context, colorScheme);
    }
  }

  Widget _buildStandardBottomBar(
      BuildContext context, ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: widget.elevation,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 72,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = index == widget.currentIndex;

              return _buildBottomBarItem(
                context,
                colorScheme,
                item,
                isSelected,
                index,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingBottomBar(
      BuildContext context, ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.15),
                blurRadius: widget.elevation * 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: SafeArea(
            child: Container(
              height: 64,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _items.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  final isSelected = index == widget.currentIndex;

                  return _buildFloatingBottomBarItem(
                    context,
                    colorScheme,
                    item,
                    isSelected,
                    index,
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMinimalBottomBar(BuildContext context, ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = index == widget.currentIndex;

              return _buildMinimalBottomBarItem(
                context,
                colorScheme,
                item,
                isSelected,
                index,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBarItem(
    BuildContext context,
    ColorScheme colorScheme,
    _BottomBarItem item,
    bool isSelected,
    int index,
  ) {
    final selectedColor = widget.selectedItemColor ?? colorScheme.primary;
    final unselectedColor = widget.unselectedItemColor ??
        colorScheme.onSurface.withValues(alpha: 0.6);

    return Expanded(
      child: GestureDetector(
        onTap: () => _handleTap(context, index, item.route),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedScale(
                scale: isSelected ? 1.1 : 1.0,
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  isSelected ? item.activeIcon : item.icon,
                  size: 24,
                  color: isSelected ? selectedColor : unselectedColor,
                ),
              ),
              const SizedBox(height: 4),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? selectedColor : unselectedColor,
                ),
                child: Text(item.label),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingBottomBarItem(
    BuildContext context,
    ColorScheme colorScheme,
    _BottomBarItem item,
    bool isSelected,
    int index,
  ) {
    final selectedColor = widget.selectedItemColor ?? colorScheme.primary;
    final unselectedColor = widget.unselectedItemColor ??
        colorScheme.onSurface.withValues(alpha: 0.6);

    return GestureDetector(
      onTap: () => _handleTap(context, index, item.route),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? selectedColor.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? item.activeIcon : item.icon,
              size: 24,
              color: isSelected ? selectedColor : unselectedColor,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: selectedColor,
                ),
                child: Text(item.label),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMinimalBottomBarItem(
    BuildContext context,
    ColorScheme colorScheme,
    _BottomBarItem item,
    bool isSelected,
    int index,
  ) {
    final selectedColor = widget.selectedItemColor ?? colorScheme.primary;
    final unselectedColor = widget.unselectedItemColor ??
        colorScheme.onSurface.withValues(alpha: 0.6);

    return GestureDetector(
      onTap: () => _handleTap(context, index, item.route),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 2,
              decoration: BoxDecoration(
                color: isSelected ? selectedColor : Colors.transparent,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
            const SizedBox(height: 8),
            Icon(
              isSelected ? item.activeIcon : item.icon,
              size: 24,
              color: isSelected ? selectedColor : unselectedColor,
            ),
          ],
        ),
      ),
    );
  }

  void _handleTap(BuildContext context, int index, String route) {
    if (widget.onTap != null) {
      widget.onTap!(index);
    }

    // Trigger animation
    _animationController.forward().then((_) {
      _animationController.reverse();
    });

    // Navigate to route
    Navigator.pushNamed(context, route);
  }
}

class _BottomBarItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;

  const _BottomBarItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.route,
  });
}
