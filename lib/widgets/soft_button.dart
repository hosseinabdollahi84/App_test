import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'pressable.dart';

enum SoftButtonVariant { primary, tinted }

/// Pill-shaped button with a soft gradient (primary) or tinted fill.
class SoftButton extends StatelessWidget {
  const SoftButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.variant = SoftButtonVariant.primary,
    this.expand = false,
    this.height = 56,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final SoftButtonVariant variant;
  final bool expand;
  final double height;

  @override
  Widget build(BuildContext context) {
    final primary = variant == SoftButtonVariant.primary;
    final fg = primary ? Colors.white : AppColors.accentDeep;

    return Pressable(
      onTap: onPressed,
      semanticLabel: label,
      builder: (context, pressed) => AnimatedContainer(
        duration: AppMotion.fast,
        curve: AppMotion.standard,
        height: height,
        width: expand ? double.infinity : null,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        decoration: BoxDecoration(
          borderRadius: AppRadii.pillAll,
          gradient: primary ? AppColors.accentGradient : null,
          color: primary ? null : AppColors.accentSoft,
          boxShadow: primary
              ? (pressed ? AppShadows.pressed : AppShadows.accentGlow)
              : null,
        ),
        child: Row(
          mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: fg, size: 20),
              const SizedBox(width: AppSpacing.xs),
            ],
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.label.copyWith(color: fg, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Small round icon button with a soft white or tinted background.
class SoftIconButton extends StatelessWidget {
  const SoftIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = 44,
    this.iconSize = 20,
    this.background = AppColors.surface,
    this.foreground = AppColors.textPrimary,
    this.shadow = true,
    this.semanticLabel,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final double iconSize;
  final Color background;
  final Color foreground;
  final bool shadow;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onPressed,
      scale: 0.92,
      semanticLabel: semanticLabel,
      builder: (context, pressed) => AnimatedContainer(
        duration: AppMotion.fast,
        curve: AppMotion.standard,
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: background,
          shape: BoxShape.circle,
          boxShadow: shadow
              ? (pressed ? AppShadows.pressed : AppShadows.soft)
              : null,
        ),
        child: Icon(icon, size: iconSize, color: foreground),
      ),
    );
  }
}
