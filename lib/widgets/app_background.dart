import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -80,
          right: -70,
          child: _Bubble(
            size: 200,
            color: const Color(0xFFFFE6A7),
          ),
        ),

        Positioned(
          top: 180,
          left: -100,
          child: _Bubble(
            size: 180,
            color: const Color(0xFFE3DDFF),
          ),
        ),

        Positioned(
          bottom: -80,
          right: -50,
          child: _Bubble(
            size: 190,
            color: const Color(0xFFD7F5E7),
          ),
        ),

        SafeArea(
          child: child,
        ),
      ],
    );
  }
}

class _Bubble extends StatelessWidget {
  final double size;
  final Color color;

  const _Bubble({
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: 0.55),
        ),
      ),
    );
  }
}