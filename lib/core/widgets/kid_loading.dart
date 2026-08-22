import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme/app_theme.dart';

class KidLoading extends StatefulWidget {
  final String message;
  final bool compact;

  const KidLoading({
    super.key,
    this.message = '잠시만 기다려주세요',
    this.compact = false,
  });

  @override
  State<KidLoading> createState() => _KidLoadingState();
}

class _KidLoadingState extends State<KidLoading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _bouncingIcon(
                  phase: 0.0,
                  icon: Icons.star_rounded,
                  color: const Color(0xFFFFC857),
                ),
                const SizedBox(width: 8),
                _bouncingIcon(
                  phase: 2.1,
                  icon: Icons.favorite_rounded,
                  color: const Color(0xFFFF8FA3),
                ),
                const SizedBox(width: 8),
                _bouncingIcon(
                  phase: 4.2,
                  icon: Icons.star_rounded,
                  color: AppColors.primary,
                ),
              ],
            );
          },
        ),
        if (!widget.compact) ...[
          const SizedBox(height: 12),
          Text(
            widget.message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ],
    );

    if (widget.compact) {
      return content;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: content,
    );
  }

  Widget _bouncingIcon({
    required double phase,
    required IconData icon,
    required Color color,
  }) {
    final value = _controller.value * math.pi * 2;
    final bounce = math.sin(value + phase);
    final offsetY = -6.0 * math.max(0, bounce);

    return Transform.translate(
      offset: Offset(0, offsetY),
      child: Icon(
        icon,
        size: 26,
        color: color,
      ),
    );
  }
}

class KidLoadingOverlay extends StatelessWidget {
  final String message;

  const KidLoadingOverlay({
    super.key,
    this.message = '잠시만 기다려주세요',
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ColoredBox(
        color: Colors.white.withValues(alpha: 0.72),
        child: Center(
          child: KidLoading(
            message: message,
          ),
        ),
      ),
    );
  }
}
