import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/soft_toast.dart';
import 'home_screen.dart';
import 'profile_screen.dart';

/// Hosts the tabs behind the floating bottom nav.
///
/// Only Home and Profile are real screens. Both stay mounted in an
/// [IndexedStack] so their state and scroll positions survive tab switches.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  static const items = [
    BottomNavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: 'Home',
    ),
    BottomNavItem(
      icon: Icons.explore_outlined,
      activeIcon: Icons.explore_rounded,
      label: 'Explore',
    ),
    BottomNavItem(
      icon: Icons.shopping_bag_outlined,
      activeIcon: Icons.shopping_bag_rounded,
      label: 'Cart',
    ),
    BottomNavItem(
      icon: Icons.favorite_border_rounded,
      activeIcon: Icons.favorite_rounded,
      label: 'Favorites',
    ),
    BottomNavItem(
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: 'Profile',
    ),
  ];

  static const _homeIndex = 0;
  static const _profileIndex = 4;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _navIndex = AppShell._homeIndex;
  final _bucket = PageStorageBucket();

  void _onNavTap(int index) {
    if (index == AppShell._homeIndex || index == AppShell._profileIndex) {
      setState(() => _navIndex = index);
    } else {
      showSoftToast(context, '${AppShell.items[index].label} is coming soon');
    }
  }

  @override
  Widget build(BuildContext context) {
    final stackIndex = _navIndex == AppShell._profileIndex ? 1 : 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      body: PageStorage(
        bucket: _bucket,
        child: _FadeIndexedStack(
          index: stackIndex,
          children: const [HomeScreen(), ProfileScreen()],
        ),
      ),
      bottomNavigationBar: BottomNav(
        items: AppShell.items,
        currentIndex: _navIndex,
        onTap: _onNavTap,
      ),
    );
  }
}

/// [IndexedStack] that softly cross-fades the newly selected child in.
class _FadeIndexedStack extends StatefulWidget {
  const _FadeIndexedStack({required this.index, required this.children});

  final int index;
  final List<Widget> children;

  @override
  State<_FadeIndexedStack> createState() => _FadeIndexedStackState();
}

class _FadeIndexedStackState extends State<_FadeIndexedStack>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppMotion.medium,
    value: 1,
  );
  late final Animation<double> _fade = CurvedAnimation(
    parent: _controller,
    curve: AppMotion.standard,
  );

  @override
  void didUpdateWidget(_FadeIndexedStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.index != widget.index) _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: Tween(
          begin: const Offset(0, 0.015),
          end: Offset.zero,
        ).animate(_fade),
        child: IndexedStack(index: widget.index, children: widget.children),
      ),
    );
  }
}
