import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum CustomAppBarVariant {
  standard,
  transparent,
  search,
  profile,
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final CustomAppBarVariant variant;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final VoidCallback? onSearchTap;
  final VoidCallback? onProfileTap;
  final bool showBackButton;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;

  const CustomAppBar({
    super.key,
    this.title,
    this.variant = CustomAppBarVariant.standard,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.onSearchTap,
    this.onProfileTap,
    this.showBackButton = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      title: _buildTitle(context),
      centerTitle: centerTitle,
      backgroundColor: _getBackgroundColor(colorScheme),
      foregroundColor: _getForegroundColor(colorScheme),
      elevation: elevation,
      leading: _buildLeading(context),
      actions: _buildActions(context),
      automaticallyImplyLeading: showBackButton,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: _getForegroundColor(colorScheme),
      ),
      iconTheme: IconThemeData(
        color: _getForegroundColor(colorScheme),
        size: 24,
      ),
      actionsIconTheme: IconThemeData(
        color: _getForegroundColor(colorScheme),
        size: 24,
      ),
    );
  }

  Widget? _buildTitle(BuildContext context) {
    switch (variant) {
      case CustomAppBarVariant.search:
        return GestureDetector(
          onTap: onSearchTap,
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color:
                  Theme.of(context).colorScheme.surface.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .outline
                    .withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 16),
                Icon(
                  Icons.search,
                  size: 20,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.6),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Search heritage sites...',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      case CustomAppBarVariant.transparent:
      case CustomAppBarVariant.standard:
      case CustomAppBarVariant.profile:
        return title != null ? Text(title!) : null;
    }
  }

  Widget? _buildLeading(BuildContext context) {
    if (leading != null) return leading;

    switch (variant) {
      case CustomAppBarVariant.profile:
        return GestureDetector(
          onTap: onProfileTap ??
              () => Navigator.pushNamed(context, '/authentication-screen'),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  Theme.of(context).colorScheme.surface.withValues(alpha: 0.1),
            ),
            child: Icon(
              Icons.person_outline,
              size: 24,
              color: _getForegroundColor(Theme.of(context).colorScheme),
            ),
          ),
        );
      default:
        return null;
    }
  }

  List<Widget>? _buildActions(BuildContext context) {
    final defaultActions = <Widget>[];

    switch (variant) {
      case CustomAppBarVariant.standard:
        defaultActions.addAll([
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, '/ar-camera-experience'),
            icon: const Icon(Icons.camera_alt_outlined),
            tooltip: 'AR Camera',
          ),
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/memory-wall'),
            icon: const Icon(Icons.photo_library_outlined),
            tooltip: 'Memory Wall',
          ),
        ]);
        break;
      case CustomAppBarVariant.search:
        defaultActions.addAll([
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, '/ar-camera-experience'),
            icon: const Icon(Icons.camera_alt_outlined),
            tooltip: 'AR Camera',
          ),
        ]);
        break;
      case CustomAppBarVariant.transparent:
        defaultActions.addAll([
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withValues(alpha: 0.3),
            ),
            child: IconButton(
              onPressed: () =>
                  Navigator.pushNamed(context, '/heritage-dashboard'),
              icon: const Icon(Icons.close, color: Colors.white),
              tooltip: 'Close',
            ),
          ),
        ]);
        break;
      case CustomAppBarVariant.profile:
        defaultActions.addAll([
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, '/trip-planning-assistant'),
            icon: const Icon(Icons.map_outlined),
            tooltip: 'Trip Planner',
          ),
        ]);
        break;
    }

    if (actions != null) {
      defaultActions.addAll(actions!);
    }

    return defaultActions.isNotEmpty ? defaultActions : null;
  }

  Color _getBackgroundColor(ColorScheme colorScheme) {
    if (backgroundColor != null) return backgroundColor!;

    switch (variant) {
      case CustomAppBarVariant.transparent:
        return Colors.transparent;
      case CustomAppBarVariant.standard:
      case CustomAppBarVariant.search:
      case CustomAppBarVariant.profile:
        return colorScheme.primary;
    }
  }

  Color _getForegroundColor(ColorScheme colorScheme) {
    if (foregroundColor != null) return foregroundColor!;

    switch (variant) {
      case CustomAppBarVariant.transparent:
        return Colors.white;
      case CustomAppBarVariant.standard:
      case CustomAppBarVariant.search:
      case CustomAppBarVariant.profile:
        return colorScheme.onPrimary;
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
