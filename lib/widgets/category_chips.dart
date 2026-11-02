import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'pressable.dart';

/// Horizontally scrolling, selectable pill chips.
class CategoryChips extends StatelessWidget {
  const CategoryChips({
    super.key,
    required this.categories,
    required this.selected,
    required this.onSelected,
  });

  final List<String> categories;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
        clipBehavior: Clip.none,
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.xs + 2),
        itemBuilder: (context, i) {
          final category = categories[i];
          final isSelected = category == selected;
          return Pressable(
            onTap: () => onSelected(category),
            semanticLabel: category,
            child: AnimatedContainer(
              duration: AppMotion.medium,
              curve: AppMotion.standard,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md + 2,
              ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: AppRadii.pillAll,
                gradient: isSelected ? AppColors.accentGradient : null,
                color: isSelected ? null : AppColors.surface,
                boxShadow: isSelected ? AppShadows.accentGlow : AppShadows.soft,
              ),
              child: AnimatedDefaultTextStyle(
                duration: AppMotion.medium,
                curve: AppMotion.standard,
                style: AppText.label.copyWith(
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
                child: Text(category),
              ),
            ),
          );
        },
      ),
    );
  }
}
