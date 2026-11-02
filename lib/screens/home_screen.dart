import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/category_chips.dart';
import '../widgets/product_card.dart';
import '../widgets/promo_banner.dart';
import '../widgets/soft_search_bar.dart';
import '../widgets/soft_toast.dart';
import 'product_detail_screen.dart';

/// Store front: greeting, search, categories, promo and the product grid.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _category = kCategories.first;
  final Set<String> _favorites = {'p2', 'p7'};

  List<Product> get _visibleProducts => _category == 'All'
      ? kProducts
      : kProducts.where((p) => p.category == _category).toList();

  void _toggleFavorite(Product product) {
    setState(() {
      if (!_favorites.remove(product.id)) _favorites.add(product.id);
    });
  }

  void _openProduct(Product product) {
    Navigator.of(context).push(
      ProductDetailScreen.route(
        product: product,
        isFavorite: _favorites.contains(product.id),
        onFavoriteToggle: () => _toggleFavorite(product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final products = _visibleProducts;
    final width = MediaQuery.sizeOf(context).width;
    final textScale = MediaQuery.textScalerOf(context).scale(1).clamp(1.0, 1.6);
    const gap = AppSpacing.md;
    final tileWidth = (width - AppSpacing.page * 2 - gap) / 2;
    // Image area is roughly square; the text block scales with font size.
    final tileHeight = tileWidth * 0.95 + 96 * textScale;

    return CustomScrollView(
      key: const PageStorageKey('home-scroll'),
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        SliverSafeArea(
          bottom: false,
          sliver: SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.page,
              AppSpacing.md,
              AppSpacing.page,
              0,
            ),
            sliver: SliverList.list(
              children: [
                const _GreetingHeader(),
                const SizedBox(height: AppSpacing.lg),
                SoftSearchBar(
                  onTap: () => showSoftToast(context, 'Search is coming soon'),
                  onFilterTap: () =>
                      showSoftToast(context, 'Filters are coming soon'),
                ),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
        SliverToBoxAdapter(
          child: CategoryChips(
            categories: kCategories,
            selected: _category,
            onSelected: (c) => setState(() => _category = c),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.page,
            AppSpacing.lg,
            AppSpacing.page,
            0,
          ),
          sliver: SliverList.list(
            children: [
              PromoBanner(
                onTap: () => showSoftToast(context, 'Offers are coming soon'),
              ),
              const SizedBox(height: AppSpacing.lg),
              _SectionHeader(
                title: _category == 'All' ? 'Popular picks' : _category,
                count: products.length,
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.page,
            0,
            AppSpacing.page,
            BottomNav.occupiedHeight(context) + AppSpacing.xs,
          ),
          sliver: SliverGrid.builder(
            itemCount: products.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: gap,
              crossAxisSpacing: gap,
              mainAxisExtent: tileHeight,
            ),
            itemBuilder: (context, i) {
              final product = products[i];
              return _GentleEntrance(
                // New key per category so cards softly re-enter on filter.
                key: ValueKey('$_category-${product.id}'),
                index: i,
                child: ProductCard(
                  product: product,
                  isFavorite: _favorites.contains(product.id),
                  onTap: () => _openProduct(product),
                  onFavoriteTap: () => _toggleFavorite(product),
                  onAddTap: () => showSoftToast(
                    context,
                    '${product.name} added to cart',
                    icon: Icons.check_circle_rounded,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _GreetingHeader extends StatelessWidget {
  const _GreetingHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, ${MockUser.firstName}',
                style: AppText.body.copyWith(fontSize: 14),
              ),
              const SizedBox(height: 2),
              const Text(
                'Find something soft',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.display,
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(3),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColors.accentGradient,
            boxShadow: AppShadows.soft,
          ),
          child: const CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.accentSoft,
            foregroundImage: NetworkImage(MockUser.avatarUrl),
            onForegroundImageError: _ignoreImageError,
            child: Icon(Icons.person_rounded, color: AppColors.accent),
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.count});

  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AnimatedSwitcher(
            duration: AppMotion.medium,
            layoutBuilder: (current, previous) => Stack(
              alignment: Alignment.centerLeft,
              children: [...previous, ?current],
            ),
            child: Text(title, key: ValueKey(title), style: AppText.heading),
          ),
        ),
        Text('$count items', style: AppText.caption),
      ],
    );
  }
}

/// Fades and lifts a grid card in, slightly staggered by position.
class _GentleEntrance extends StatelessWidget {
  const _GentleEntrance({super.key, required this.index, required this.child});

  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final delay = (index * 0.08).clamp(0.0, 0.5);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: AppMotion.slow * 1.6,
      curve: Interval(delay, 1, curve: AppMotion.gentle),
      child: child,
      builder: (context, t, child) => Opacity(
        opacity: t,
        child: Transform.translate(
          offset: Offset(0, (1 - t) * 16),
          child: child,
        ),
      ),
    );
  }
}

// Falls back to the icon child when offline.
void _ignoreImageError(Object error, StackTrace? stackTrace) {}
