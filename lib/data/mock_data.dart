import 'package:flutter/material.dart';

import '../models/product.dart';
import '../theme/app_theme.dart';

/// Static, in-memory mock data. Nothing here is fetched or persisted.

String _img(String id) =>
    'https://images.unsplash.com/photo-$id?w=800&q=80&auto=format&fit=crop';

const List<String> kCategories = [
  'All',
  'Shoes',
  'Audio',
  'Accessories',
  'Apparel',
  'Home',
];

const _cloudColors = [
  Color(0xFFF3EFEA),
  Color(0xFFCFC6F5),
  Color(0xFFF6C9D6),
  Color(0xFFBFE3D6),
];

const _shoeSizes = ['38', '39', '40', '41', '42', '43'];
const _apparelSizes = ['XS', 'S', 'M', 'L', 'XL'];

final List<Product> kProducts = [
  Product(
    id: 'p1',
    name: 'Cloud Runner Sneakers',
    category: 'Shoes',
    price: 129.00,
    rating: 4.8,
    reviewCount: 214,
    description:
        'Featherlight runners with a pillowy foam sole and a breathable knit '
        'upper. Made for long walks, lazy Sundays and everything in between.',
    imageUrl: _img('1542291026-7eec264c27ff'),
    backdrop: AppColors.peach,
    sizes: _shoeSizes,
    colors: _cloudColors,
  ),
  Product(
    id: 'p2',
    name: 'Hush Wireless Headphones',
    category: 'Audio',
    price: 189.00,
    rating: 4.7,
    reviewCount: 532,
    description:
        'Over-ear headphones with soft memory-foam cushions, gentle noise '
        'cancelling and a 40-hour battery that keeps up with your day.',
    imageUrl: _img('1505740420928-5e560c06d30e'),
    backdrop: AppColors.butter,
    colors: [Color(0xFFF3EFEA), Color(0xFF3B3A4A), Color(0xFFCFC6F5)],
  ),
  Product(
    id: 'p3',
    name: 'Minimal Leather Watch',
    category: 'Accessories',
    price: 149.00,
    rating: 4.6,
    reviewCount: 98,
    description:
        'A calm, clean dial on a supple leather strap. Quietly elegant and '
        'light enough to forget you are wearing it.',
    imageUrl: _img('1523275335684-37898b6baf30'),
    backdrop: AppColors.sky,
    sizes: ['38mm', '42mm'],
    colors: [Color(0xFFF3EFEA), Color(0xFFD9B99B), Color(0xFF3B3A4A)],
  ),
  Product(
    id: 'p4',
    name: 'Instant Film Camera',
    category: 'Accessories',
    price: 99.00,
    rating: 4.5,
    reviewCount: 176,
    description:
        'Point, shoot and hold the moment in your hand seconds later. A '
        'friendly little camera for soft, dreamy snapshots.',
    imageUrl: _img('1526170375885-4d8ecf77b99f'),
    backdrop: AppColors.mint,
    colors: [Color(0xFFBFE3D6), Color(0xFFF6C9D6), Color(0xFFF3EFEA)],
  ),
  Product(
    id: 'p5',
    name: 'Pastel Sunglasses',
    category: 'Accessories',
    price: 59.00,
    rating: 4.4,
    reviewCount: 61,
    description:
        'Softly tinted lenses with full UV protection in a lightweight frame '
        'that rests comfortably all afternoon.',
    imageUrl: _img('1572635196237-14b3f281503f'),
    backdrop: AppColors.blush,
    colors: [Color(0xFFF6C9D6), Color(0xFF3B3A4A)],
  ),
  Product(
    id: 'p6',
    name: 'Everyday Canvas Backpack',
    category: 'Accessories',
    price: 79.00,
    rating: 4.7,
    reviewCount: 143,
    description:
        'Roomy, padded and water-resistant, with a cushioned laptop sleeve and '
        'plenty of little pockets for the little things.',
    imageUrl: _img('1553062407-98eeb64c6a62'),
    backdrop: AppColors.lilac,
    colors: [Color(0xFFCFC6F5), Color(0xFFF3EFEA), Color(0xFF8C8A9C)],
  ),
  Product(
    id: 'p7',
    name: 'Cotton Soft Hoodie',
    category: 'Apparel',
    price: 69.00,
    rating: 4.9,
    reviewCount: 389,
    description:
        'Brushed-cotton fleece that feels like a hug. Relaxed fit, dropped '
        'shoulders and a hood made for cozy evenings.',
    imageUrl: _img('1556821840-3a63f95609a7'),
    backdrop: AppColors.butter,
    sizes: _apparelSizes,
    colors: [Color(0xFFF3EFEA), Color(0xFFCFC6F5), Color(0xFFBFE3D6)],
  ),
  Product(
    id: 'p8',
    name: 'Organic Basic Tee',
    category: 'Apparel',
    price: 29.00,
    rating: 4.6,
    reviewCount: 257,
    description:
        'A breathable organic-cotton tee with a soft hand feel and a '
        'perfectly easy shape. The one you will reach for first.',
    imageUrl: _img('1521572163474-6864f9cf17ab'),
    backdrop: AppColors.sky,
    sizes: _apparelSizes,
    colors: [Color(0xFFF3EFEA), Color(0xFFF6C9D6), Color(0xFF3B3A4A)],
  ),
  Product(
    id: 'p9',
    name: 'Daydream Sneakers',
    category: 'Shoes',
    price: 115.00,
    rating: 4.5,
    reviewCount: 120,
    description:
        'Low-profile sneakers with a soft suede finish and a cushioned '
        'insole. Easy to style, easier to wear.',
    imageUrl: _img('1491553895911-0055eca6402d'),
    backdrop: AppColors.mint,
    sizes: _shoeSizes,
    colors: _cloudColors,
  ),
  Product(
    id: 'p10',
    name: 'Mini Bluetooth Speaker',
    category: 'Audio',
    price: 49.00,
    rating: 4.3,
    reviewCount: 88,
    description:
        'Pocket-sized speaker with surprisingly warm sound and a soft-touch '
        'finish. Ten hours of music on a single charge.',
    imageUrl: _img('1608043152269-423dbba4e7e1'),
    backdrop: AppColors.peach,
    colors: [Color(0xFF3B3A4A), Color(0xFFCFC6F5), Color(0xFFBFE3D6)],
  ),
  Product(
    id: 'p11',
    name: 'Bloom Eau de Parfum',
    category: 'Home',
    price: 84.00,
    rating: 4.8,
    reviewCount: 201,
    description:
        'A light floral scent with notes of peony, white musk and a hint of '
        'pear. Soft, fresh and quietly memorable.',
    imageUrl: _img('1585386959984-a4155224a1ad'),
    backdrop: AppColors.blush,
    sizes: ['30ml', '50ml', '100ml'],
  ),
  Product(
    id: 'p12',
    name: 'Soft Tote Bag',
    category: 'Accessories',
    price: 119.00,
    rating: 4.6,
    reviewCount: 74,
    description:
        'A slouchy tote in buttery vegan leather with an inner zip pocket. '
        'Big enough for the day, light enough for the evening.',
    imageUrl: _img('1584917865442-de89df76afd3'),
    backdrop: AppColors.lilac,
    colors: [Color(0xFFF3EFEA), Color(0xFFD9B99B), Color(0xFFF6C9D6)],
  ),
];

class MockUser {
  const MockUser._();

  static const name = 'Ava Thompson';
  static const firstName = 'Ava';
  static const username = '@ava.soft';
  static const email = 'ava.thompson@example.com';
  static const avatarUrl =
      'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400&q=80&auto=format&fit=crop&crop=faces';

  static const orders = 12;
  static const wishlist = 28;
  static const reviews = 7;
}
