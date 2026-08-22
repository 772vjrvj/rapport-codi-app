import 'package:flutter/material.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../core/widgets/kid_loading.dart';
import '../../data/auth_service.dart';

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

  final AuthService _authService = AuthService.instance;

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

    _checkLogin();
  }

  Future<void> _checkLogin() async {
    // 스플래시 로고가 너무 빨리 사라지지 않도록 최소 노출시간을 둔다.
    final results = await Future.wait<dynamic>([
      _authService.tryAutoLogin(),
      Future<void>.delayed(
        const Duration(milliseconds: 1800),
      ),
    ]);

    final loggedIn = results.first as bool;

    if (!mounted) return;

    Navigator.of(context).pushReplacementNamed(
      loggedIn ? AppRoutes.schedule : AppRoutes.login,
    );
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
                const SizedBox(height: 32),
                const KidLoading(
                  compact: true,
                ),
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
