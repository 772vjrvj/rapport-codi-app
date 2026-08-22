import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../core/services/local_notification_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    await LocalNotificationService.requestPermission();
    LocalNotificationService.scheduleLoginTestNotification();

    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.schedule,
      (route) => false,
    );
  }

  void _findPassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('비밀번호 찾기는 추후 연결할 예정입니다.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 12),
                  Image.asset(
                    'assets/images/brand-icon.png',
                    height: 108,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 10),
                  const Center(
                    child: _BrandText(fontSize: 23),
                  ),
                  const SizedBox(height: 42),
                  TextField(
                    controller: usernameController,
                    autofocus: true,
                    textInputAction: TextInputAction.next,
                    decoration: _inputDecoration(
                      hintText: '아이디를 입력하세요',
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _login(),
                    decoration: _inputDecoration(
                      hintText: '비밀번호를 입력하세요',
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 50,
                    child: FilledButton(
                      onPressed: _login,
                      style: FilledButton.styleFrom(
                        elevation: 0,
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        '로그인',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: _findPassword,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.textMuted,
                    ),
                    child: const Text(
                      '비밀번호 찾기',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hintText,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(
        fontSize: 13,
        color: AppColors.textMuted,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 15,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: AppColors.border,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: AppColors.primary,
          width: 1.5,
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
