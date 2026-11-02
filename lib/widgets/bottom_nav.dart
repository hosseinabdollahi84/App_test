import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'pressable.dart';

class BottomNavItem {
  const BottomNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
}

/// Floating, rounded bottom navigation bar with a soft pill indicator that
/// glides between items on a spring-like curve.
class BottomNav extends StatelessWidget {
  const BottomNav({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  final List<BottomNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  static const double barHeight = 72;
  static const double _indicatorInset = 6;

  /// Total vertical space the bar occupies, used to pad scrollable content.
  static double occupiedHeight(BuildContext context) =>
      barHeight + MediaQuery.paddingOf(context).bottom + AppSpacing.md * 2;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.page,
        0,
        AppSpacing.page,
        bottomInset > 0 ? bottomInset : AppSpacing.md,
      ),
      child: Container(
        height: barHeight,
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadii.xlAll,
          boxShadow: AppShadows.floating,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final slot = constraints.maxWidth / items.length;
            return Stack(
              children: [
                AnimatedPositioned(
                  duration: AppMotion.slow,
                  curve: AppMotion.spring,
                  left: slot * currentIndex + _indicatorInset,
                  top: _indicatorInset + 4,
                  bottom: _indicatorInset + 4,
                  width: slot - _indicatorInset * 2,
                  child: const DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.accentSoft,
                      borderRadius: AppRadii.mdAll,
                    ),
                  ),
                ),
                Row(
                  children: [
                    for (var i = 0; i < items.length; i++)
                      Expanded(
                        child: _NavButton(
                          item: items[i],
                          selected: i == currentIndex,
                          onTap: () => onTap(i),
                        ),
                      ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final BottomNavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.accentDeep : AppColors.textTertiary;

    return Pressable(
      onTap: onTap,
      scale: 0.9,
      semanticLabel: item.label,
      child: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: AppMotion.fast,
              child: Icon(
                selected ? item.activeIcon : item.icon,
                key: ValueKey(selected),
                color: color,
                size: 24,
              ),
            ),
            // Label fades + expands in only for the selected item.
            AnimatedSize(
              duration: AppMotion.medium,
              curve: AppMotion.standard,
              child: AnimatedOpacity(
                duration: AppMotion.medium,
                curve: AppMotion.standard,
                opacity: selected ? 1 : 0,
                child: selected
                    ? Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          item.label,
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          style: AppText.caption.copyWith(
                            color: color,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : const SizedBox(width: 0, height: 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
