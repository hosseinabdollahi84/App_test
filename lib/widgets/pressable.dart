import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Wraps any child with gentle press feedback: it eases down to ~0.96 scale
/// while pressed and springs softly back on release.
///
/// [builder] receives the pressed state so callers can also swap shadows.
class Pressable extends StatefulWidget {
  const Pressable({
    super.key,
    this.onTap,
    this.child,
    this.builder,
    this.scale = AppMotion.pressScale,
    this.semanticLabel,
  }) : assert(child != null || builder != null);

  final VoidCallback? onTap;
  final Widget? child;
  final Widget Function(BuildContext context, bool pressed)? builder;
  final double scale;
  final String? semanticLabel;

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  bool _pressed = false;

  void _set(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final content = widget.builder?.call(context, _pressed) ?? widget.child!;
    return Semantics(
      button: true,
      label: widget.semanticLabel,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _set(true),
        onTapUp: (_) => _set(false),
        onTapCancel: () => _set(false),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _pressed ? widget.scale : 1,
          duration: _pressed ? AppMotion.fast : AppMotion.slow,
          curve: _pressed ? AppMotion.standard : AppMotion.spring,
          child: content,
        ),
      ),
    );
  }
}
