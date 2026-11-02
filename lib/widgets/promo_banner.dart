import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'soft_button.dart';

/// Soft gradient promo card with floating "cotton" blobs.
class PromoBanner extends StatelessWidget {
  const PromoBanner({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.promoGradient,
        borderRadius: AppRadii.xlAll,
        boxShadow: AppShadows.soft,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          const Positioned(right: -30, top: -40, child: _Blob(size: 150)),
          const Positioned(right: 40, bottom: -50, child: _Blob(size: 110)),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xxs,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surface.withValues(alpha: 0.7),
                          borderRadius: AppRadii.pillAll,
                        ),
                        child: Text(
                          'Autumn Softness',
                          style: AppText.caption.copyWith(
                            color: AppColors.accentDeep,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      const Text(
                        'Up to 30% off\ncozy essentials',
                        style: AppText.heading,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      SoftButton(
                        label: 'Shop now',
                        height: 40,
                        onPressed: onTap,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    color: AppColors.surface.withValues(alpha: 0.75),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.local_mall_rounded,
                    size: 34,
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.surface.withValues(alpha: 0.35),
      ),
    );
  }
}
