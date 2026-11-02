import 'package:flutter/painting.dart';

/// Plain, immutable view model for a product card / detail screen.
class Product {
  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.description,
    required this.imageUrl,
    required this.backdrop,
    this.sizes = const [],
    this.colors = const [],
  });

  final String id;
  final String name;
  final String category;
  final double price;
  final double rating;
  final int reviewCount;
  final String description;
  final String imageUrl;

  /// Pastel color painted behind the product image.
  final Color backdrop;

  final List<String> sizes;
  final List<Color> colors;

  String get formattedPrice => '\$${price.toStringAsFixed(2)}';

  /// Hero tags shared between the grid card and the detail screen.
  String get heroCardTag => 'product-card-$id';
  String get heroImageTag => 'product-image-$id';
  String get heroTitleTag => 'product-title-$id';
}
