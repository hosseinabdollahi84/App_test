import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Network image with a soft pastel placeholder that gently fades the photo
/// in once loaded, and a calm fallback icon if it can't be reached.
class SoftImage extends StatelessWidget {
  const SoftImage({
    super.key,
    required this.url,
    this.background = AppColors.surfaceMuted,
    this.fit = BoxFit.cover,
    this.fallbackIcon = Icons.shopping_bag_outlined,
  });

  final String url;
  final Color background;
  final BoxFit fit;
  final IconData fallbackIcon;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: background,
      child: Image.network(
        url,
        fit: fit,
        width: double.infinity,
        height: double.infinity,
        gaplessPlayback: true,
        frameBuilder: (context, child, frame, wasSyncLoaded) {
          if (wasSyncLoaded) return child;
          return AnimatedOpacity(
            opacity: frame == null ? 0 : 1,
            duration: AppMotion.slow,
            curve: AppMotion.gentle,
            child: child,
          );
        },
        errorBuilder: (context, error, stack) => Center(
          child: Icon(fallbackIcon, size: 40, color: AppColors.textTertiary),
        ),
      ),
    );
  }
}
