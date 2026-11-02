import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'soft_button.dart';

/// Pill-shaped − / value / + stepper.
class QuantityStepper extends StatelessWidget {
  const QuantityStepper({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 1,
    this.max = 9,
  });

  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxs),
      decoration: const BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: AppRadii.pillAll,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SoftIconButton(
            icon: Icons.remove_rounded,
            size: 36,
            iconSize: 18,
            foreground: value > min
                ? AppColors.textPrimary
                : AppColors.textTertiary,
            onPressed: value > min ? () => onChanged(value - 1) : null,
            semanticLabel: 'Decrease quantity',
          ),
          SizedBox(
            width: 40,
            child: AnimatedSwitcher(
              duration: AppMotion.fast,
              transitionBuilder: (child, anim) => FadeTransition(
                opacity: anim,
                child: ScaleTransition(scale: anim, child: child),
              ),
              child: Text(
                '$value',
                key: ValueKey(value),
                textAlign: TextAlign.center,
                style: AppText.heading,
              ),
            ),
          ),
          SoftIconButton(
            icon: Icons.add_rounded,
            size: 36,
            iconSize: 18,
            background: AppColors.accent,
            foreground: Colors.white,
            onPressed: value < max ? () => onChanged(value + 1) : null,
            semanticLabel: 'Increase quantity',
          ),
        ],
      ),
    );
  }
}
