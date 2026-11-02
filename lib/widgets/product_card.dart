import 'package:flutter/material.dart';

import '../models/product.dart';
import '../theme/app_theme.dart';
import 'pressable.dart';
import 'product_hero.dart';

/// Grid card: soft white tile with the product photo, name, price,
/// a favorite toggle and a small "add" button.
class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteTap,
    required this.onAddTap,
  });

  final Product product;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;
  final VoidCallback onAddTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      semanticLabel: product.name,
      builder: (context, pressed) => AnimatedContainer(
        duration: AppMotion.fast,
        curve: AppMotion.standard,
        padding: const EdgeInsets.all(AppSpacing.xs),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadii.lgAll,
          boxShadow: pressed ? AppShadows.pressed : AppShadows.soft,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ProductImageHero(
                      product: product,
                      borderRadius: ProductImageHero.cardRadius,
                    ),
                  ),
                  Positioned(
                    top: AppSpacing.xs,
                    right: AppSpacing.xs,
                    child: _FavoriteBubble(
                      active: isFavorite,
                      onTap: onFavoriteTap,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xxs + 2,
                AppSpacing.sm,
                AppSpacing.xxs,
                AppSpacing.xxs,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProductTitleHero(
                    product: product,
                    style: ProductTitleHero.cardStyle,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.category,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.caption,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          product.formattedPrice,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.price,
                        ),
                      ),
                      _AddBubble(onTap: onAddTap),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FavoriteBubble extends StatelessWidget {
  const _FavoriteBubble({required this.active, required this.onTap});

  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      scale: 0.88,
      semanticLabel: active ? 'Remove from favorites' : 'Add to favorites',
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.85),
          shape: BoxShape.circle,
        ),
        child: AnimatedSwitcher(
          duration: AppMotion.medium,
          switchInCurve: AppMotion.spring,
          switchOutCurve: AppMotion.standard,
          transitionBuilder: (child, anim) =>
              ScaleTransition(scale: anim, child: child),
          child: Icon(
            active ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            key: ValueKey(active),
            size: 18,
            color: active ? AppColors.heart : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _AddBubble extends StatelessWidget {
  const _AddBubble({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      scale: 0.88,
      semanticLabel: 'Add to cart',
      child: Container(
        width: 32,
        height: 32,
        decoration: const BoxDecoration(
          gradient: AppColors.accentGradient,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.add_rounded, size: 18, color: Colors.white),
      ),
    );
  }
}
