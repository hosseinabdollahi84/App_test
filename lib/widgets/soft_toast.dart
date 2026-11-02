import 'dart:async';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

OverlayEntry? _currentToast;

/// Shows a small, rounded toast that drifts up from above the bottom nav,
/// lingers briefly, then fades away. Only one toast is shown at a time.
void showSoftToast(
  BuildContext context,
  String message, {
  IconData icon = Icons.auto_awesome_rounded,
}) {
  final overlay = Overlay.of(context, rootOverlay: true);
  _currentToast?.remove();
  late final OverlayEntry entry;
  entry = OverlayEntry(
    builder: (_) => _SoftToast(
      message: message,
      icon: icon,
      onDone: () {
        if (_currentToast == entry) _currentToast = null;
        if (entry.mounted) entry.remove();
      },
    ),
  );
  _currentToast = entry;
  overlay.insert(entry);
}

class _SoftToast extends StatefulWidget {
  const _SoftToast({
    required this.message,
    required this.icon,
    required this.onDone,
  });

  final String message;
  final IconData icon;
  final VoidCallback onDone;

  @override
  State<_SoftToast> createState() => _SoftToastState();
}

class _SoftToastState extends State<_SoftToast>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppMotion.medium,
    reverseDuration: AppMotion.fast,
  );

  @override
  void initState() {
    super.initState();
    _run();
  }

  late final Animation<double> _curved = CurvedAnimation(
    parent: _controller,
    curve: AppMotion.gentle,
    reverseCurve: AppMotion.standard,
  );
  Timer? _holdTimer;

  Future<void> _run() async {
    await _controller.forward();
    if (!mounted) return;
    _holdTimer = Timer(const Duration(milliseconds: 1600), () async {
      if (!mounted) return;
      await _controller.reverse();
      if (mounted) widget.onDone();
    });
  }

  @override
  void dispose() {
    _holdTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final curved = _curved;

    return Positioned(
      left: AppSpacing.lg,
      right: AppSpacing.lg,
      bottom: bottomInset + 112,
      child: IgnorePointer(
        child: FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween(
              begin: const Offset(0, 0.4),
              end: Offset.zero,
            ).animate(curved),
            child: Center(
              child: Material(
                type: MaterialType.transparency,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md + 2,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.textPrimary.withValues(alpha: 0.88),
                    borderRadius: AppRadii.pillAll,
                    boxShadow: AppShadows.floating,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(widget.icon, size: 16, color: AppColors.accentSoft),
                      const SizedBox(width: AppSpacing.xs),
                      Flexible(
                        child: Text(
                          widget.message,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: AppText.label.copyWith(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
