import 'package:flutter/material.dart';

import '../models/product.dart';
import '../theme/app_theme.dart';
import 'soft_image.dart';

/// Pastel backdrop + product photo. This exact widget is used in the grid
/// card, the detail screen, and in-flight, so the hero morph is seamless.
class ProductImageBlock extends StatelessWidget {
  const ProductImageBlock({
    super.key,
    required this.product,
    required this.borderRadius,
  });

  final Product product;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: SoftImage(url: product.imageUrl, background: product.backdrop),
    );
  }
}

/// Hero for the product image that also morphs the corner radius between
/// the card (all corners rounded) and the detail header (bottom rounded).
class ProductImageHero extends StatelessWidget {
  const ProductImageHero({
    super.key,
    required this.product,
    required this.borderRadius,
  });

  static const cardRadius = AppRadii.mdAll;
  static const detailRadius = BorderRadius.vertical(
    bottom: Radius.circular(AppRadii.xl + 8),
  );

  final Product product;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: product.heroImageTag,
      createRectTween: (begin, end) =>
          MaterialRectArcTween(begin: begin, end: end),
      flightShuttleBuilder: (context, animation, direction, fromCtx, toCtx) {
        // animation.value: 0 = grid card, 1 = detail screen (both ways).
        return AnimatedBuilder(
          animation: animation,
          builder: (context, _) => ProductImageBlock(
            product: product,
            borderRadius: BorderRadius.lerp(
              cardRadius,
              detailRadius,
              animation.value,
            )!,
          ),
        );
      },
      child: ProductImageBlock(product: product, borderRadius: borderRadius),
    );
  }
}

/// Hero for the product title. In flight the text style smoothly grows /
/// shrinks between the card and detail sizes without ever overflowing.
class ProductTitleHero extends StatelessWidget {
  const ProductTitleHero({
    super.key,
    required this.product,
    required this.style,
    this.maxLines = 2,
  });

  static const cardStyle = AppText.label;
  static const detailStyle = AppText.title;

  final Product product;
  final TextStyle style;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: product.heroTitleTag,
      flightShuttleBuilder: (context, animation, direction, fromCtx, toCtx) {
        return AnimatedBuilder(
          animation: animation,
          builder: (context, _) => Material(
            type: MaterialType.transparency,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.topLeft,
              child: Text(
                product.name,
                maxLines: 1,
                style: TextStyle.lerp(cardStyle, detailStyle, animation.value),
              ),
            ),
          ),
        );
      },
      child: Material(
        type: MaterialType.transparency,
        child: Text(
          product.name,
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
          style: style,
        ),
      ),
    );
  }
}
