import 'package:flutter/material.dart';

import '../models/product.dart';
import '../theme/app_theme.dart';
import '../widgets/pressable.dart';
import '../widgets/product_hero.dart';
import '../widgets/quantity_stepper.dart';
import '../widgets/soft_button.dart';
import '../widgets/soft_toast.dart';

/// Product detail. The image and title arrive via hero from the grid card;
/// everything else drifts in gently once the hero has mostly landed.
class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({
    super.key,
    required this.product,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  final Product product;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  static Route<void> route({
    required Product product,
    required bool isFavorite,
    required VoidCallback onFavoriteToggle,
  }) {
    return PageRouteBuilder<void>(
      transitionDuration: AppMotion.slow,
      reverseTransitionDuration:
          AppMotion.medium + const Duration(milliseconds: 50),
      pageBuilder: (context, animation, secondaryAnimation) =>
          ProductDetailScreen(
            product: product,
            isFavorite: isFavorite,
            onFavoriteToggle: onFavoriteToggle,
          ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Only the backdrop fades; the hero carries the visual continuity.
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: AppMotion.standard,
          ),
          child: child,
        );
      },
    );
  }

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late bool _favorite = widget.isFavorite;
  int _quantity = 1;
  int _sizeIndex = 1;
  int _colorIndex = 0;

  Product get product => widget.product;

  @override
  void initState() {
    super.initState();
    if (_sizeIndex >= product.sizes.length) _sizeIndex = 0;
  }

  void _toggleFavorite() {
    setState(() => _favorite = !_favorite);
    widget.onFavoriteToggle();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final topInset = MediaQuery.paddingOf(context).top;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final imageHeight = (size.height * 0.46).clamp(280.0, 460.0);
    final routeAnimation =
        ModalRoute.of(context)?.animation ?? kAlwaysCompleteAnimation;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(
                  height: imageHeight,
                  child: ProductImageHero(
                    product: product,
                    borderRadius: ProductImageHero.detailRadius,
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.page + 4,
                  AppSpacing.lg,
                  AppSpacing.page + 4,
                  120 + bottomInset,
                ),
                sliver: SliverList.list(
                  children: [
                    ProductTitleHero(
                      product: product,
                      style: ProductTitleHero.detailStyle,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    _Reveal(
                      animation: routeAnimation,
                      order: 0,
                      child: _PriceRatingRow(product: product),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _Reveal(
                      animation: routeAnimation,
                      order: 1,
                      child: Text(product.description, style: AppText.body),
                    ),
                    if (product.sizes.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.lg),
                      _Reveal(
                        animation: routeAnimation,
                        order: 2,
                        child: _SizeSelector(
                          sizes: product.sizes,
                          selected: _sizeIndex,
                          onSelected: (i) => setState(() => _sizeIndex = i),
                        ),
                      ),
                    ],
                    if (product.colors.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.lg),
                      _Reveal(
                        animation: routeAnimation,
                        order: 3,
                        child: _ColorSelector(
                          colors: product.colors,
                          selected: _colorIndex,
                          onSelected: (i) => setState(() => _colorIndex = i),
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.lg),
                    _Reveal(
                      animation: routeAnimation,
                      order: 4,
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text('Quantity', style: AppText.heading),
                          ),
                          QuantityStepper(
                            value: _quantity,
                            onChanged: (q) => setState(() => _quantity = q),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Floating top controls.
          Positioned(
            top: topInset + AppSpacing.xs,
            left: AppSpacing.page,
            right: AppSpacing.page,
            child: _Reveal(
              animation: routeAnimation,
              order: 0,
              slide: false,
              child: Row(
                children: [
                  SoftIconButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    iconSize: 18,
                    onPressed: () => Navigator.of(context).maybePop(),
                    semanticLabel: 'Back',
                  ),
                  const Spacer(),
                  SoftIconButton(
                    icon: _favorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    foreground: _favorite
                        ? AppColors.heart
                        : AppColors.textPrimary,
                    onPressed: _toggleFavorite,
                    semanticLabel: 'Favorite',
                  ),
                ],
              ),
            ),
          ),
          // Fixed bottom "Add to Cart" bar.
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _Reveal(
              animation: routeAnimation,
              order: 2,
              offset: 0.6,
              child: _AddToCartBar(
                total: product.price * _quantity,
                bottomInset: bottomInset,
                onAdd: () => showSoftToast(
                  context,
                  'Added $_quantity × ${product.name}',
                  icon: Icons.check_circle_rounded,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Fades and slides content in after the hero transition, staggered by
/// [order]. On the way back it fades out first so the hero flies cleanly.
class _Reveal extends StatelessWidget {
  const _Reveal({
    required this.animation,
    required this.order,
    required this.child,
    this.slide = true,
    this.offset = 0.15,
  });

  final Animation<double> animation;
  final int order;
  final Widget child;
  final bool slide;
  final double offset;

  @override
  Widget build(BuildContext context) {
    final start = (0.45 + order * 0.08).clamp(0.0, 0.85);
    final curved = CurvedAnimation(
      parent: animation,
      curve: Interval(start, 1, curve: AppMotion.gentle),
      reverseCurve: const Interval(0.6, 1, curve: Curves.easeIn),
    );
    Widget result = FadeTransition(opacity: curved, child: child);
    if (slide) {
      result = SlideTransition(
        position: Tween(
          begin: Offset(0, offset),
          end: Offset.zero,
        ).animate(curved),
        child: result,
      );
    }
    return result;
  }
}

class _PriceRatingRow extends StatelessWidget {
  const _PriceRatingRow({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            product.formattedPrice,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.price.copyWith(fontSize: 22),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xxs + 2,
          ),
          decoration: const BoxDecoration(
            color: AppColors.butter,
            borderRadius: AppRadii.pillAll,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star_rounded, size: 18, color: AppColors.star),
              const SizedBox(width: AppSpacing.xxs),
              Text(product.rating.toStringAsFixed(1), style: AppText.label),
              const SizedBox(width: AppSpacing.xxs),
              Text('(${product.reviewCount})', style: AppText.caption),
            ],
          ),
        ),
      ],
    );
  }
}

class _SizeSelector extends StatelessWidget {
  const _SizeSelector({
    required this.sizes,
    required this.selected,
    required this.onSelected,
  });

  final List<String> sizes;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Size', style: AppText.heading),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.xs + 2,
          runSpacing: AppSpacing.xs + 2,
          children: [
            for (var i = 0; i < sizes.length; i++)
              Pressable(
                onTap: () => onSelected(i),
                semanticLabel: 'Size ${sizes[i]}',
                child: AnimatedContainer(
                  duration: AppMotion.medium,
                  curve: AppMotion.standard,
                  constraints: const BoxConstraints(minWidth: 52),
                  height: 44,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),

                  decoration: BoxDecoration(
                    color: i == selected ? AppColors.accent : AppColors.surface,
                    borderRadius: AppRadii.smAll,
                    boxShadow: i == selected
                        ? AppShadows.accentGlow
                        : AppShadows.soft,
                  ),
                  child: AnimatedDefaultTextStyle(
                    duration: AppMotion.medium,
                    style: AppText.label.copyWith(
                      color: i == selected
                          ? Colors.white
                          : AppColors.textSecondary,
                    ),
                    child: Align(widthFactor: 1, child: Text(sizes[i])),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _ColorSelector extends StatelessWidget {
  const _ColorSelector({
    required this.colors,
    required this.selected,
    required this.onSelected,
  });

  final List<Color> colors;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Color', style: AppText.heading),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (var i = 0; i < colors.length; i++)
              Pressable(
                onTap: () => onSelected(i),
                scale: 0.9,
                semanticLabel: 'Color ${i + 1}',
                child: AnimatedContainer(
                  duration: AppMotion.medium,
                  curve: AppMotion.standard,
                  width: 40,
                  height: 40,
                  padding: EdgeInsets.all(i == selected ? 4 : 0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: i == selected
                        ? AppColors.accentSoft
                        : Colors.transparent,
                  ),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: colors[i],
                      shape: BoxShape.circle,
                      boxShadow: AppShadows.soft,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _AddToCartBar extends StatelessWidget {
  const _AddToCartBar({
    required this.total,
    required this.bottomInset,
    required this.onAdd,
  });

  final double total;
  final double bottomInset;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.page + 4,
        AppSpacing.md,
        AppSpacing.page,
        bottomInset > 0 ? bottomInset : AppSpacing.md,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.xl)),
        boxShadow: AppShadows.floating,
      ),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Total', style: AppText.caption),
              const SizedBox(height: 2),
              AnimatedSwitcher(
                duration: AppMotion.fast,
                child: Text(
                  '\$${total.toStringAsFixed(2)}',
                  key: ValueKey(total),
                  style: AppText.heading,
                ),
              ),
            ],
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: SoftButton(
              label: 'Add to Cart',
              icon: Icons.shopping_bag_outlined,
              expand: true,
              onPressed: onAdd,
            ),
          ),
        ],
      ),
    );
  }
}
