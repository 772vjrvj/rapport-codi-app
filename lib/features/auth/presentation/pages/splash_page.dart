import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../app/routes/app_routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.92,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _controller.forward();

    Timer(const Duration(milliseconds: 3000), () {
      if (!mounted) return;

      Navigator.of(context).pushReplacementNamed(AppRoutes.login);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/brand-icon.png',
                  width: 164,
                  height: 164,
                ),
                const SizedBox(height: 18),
                const _BrandText(fontSize: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BrandText extends StatelessWidget {
  final double fontSize;

  const _BrandText({
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w300,
          letterSpacing: 0.2,
        ),
        children: const [
          TextSpan(
            text: 'rapport',
            style: TextStyle(
              color: Color(0xFFB9BEC5),
            ),
          ),
          TextSpan(
            text: 'codi',
            style: TextStyle(
              color: Color(0xFF1D78C8),
            ),
          ),
        ],
      ),
    );
  }
}
