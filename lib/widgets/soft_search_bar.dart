import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'soft_button.dart';

/// Rounded search field. Visual only: it doesn't search anything.
class SoftSearchBar extends StatelessWidget {
  const SoftSearchBar({super.key, this.onTap, this.onFilterTap});

  final VoidCallback? onTap;
  final VoidCallback? onFilterTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppRadii.pillAll,
                boxShadow: AppShadows.soft,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.search_rounded,
                    color: AppColors.textTertiary,
                    size: 22,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'Search soft things…',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.body.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        SoftIconButton(
          icon: Icons.tune_rounded,
          size: 52,
          background: AppColors.accentSoft,
          foreground: AppColors.accentDeep,
          shadow: false,
          onPressed: onFilterTap,
          semanticLabel: 'Filters',
        ),
      ],
    );
  }
}
