import 'package:flutter/material.dart';

/// 앱 전체에서 사용하는 색상입니다.
/// 화면마다 색상 값을 직접 쓰지 않고 여기서 관리합니다.
abstract final class AppColors {
  static const Color primary = Color(0xFF2FBFAE);
  static const Color primaryDark = Color(0xFF1F8F83);
  static const Color primaryDeep = Color(0xFF176B63);
  static const Color primary50 = Color(0xFFF1FBF9);
  static const Color primary100 = Color(0xFFDDF7F2);
  static const Color primary200 = Color(0xFFBCEFE7);

  static const Color background = Color(0xFFF5FAF9);
  static const Color surface = Colors.white;
  static const Color textStrong = Color(0xFF254B45);
  static const Color textBody = Color(0xFF657874);
  static const Color textMuted = Color(0xFF91A29F);
  static const Color border = Color(0xFFDCE9E6);

  static const Color consultation = Color(0xFFE5A35D);
  static const Color consultationSoft = Color(0xFFFFF8ED);
  static const Color consultationBorder = Color(0xFFFFD8A0);
}

abstract final class AppTheme {
  static ThemeData build() {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        surface: AppColors.surface,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textStrong,
        surfaceTintColor: Colors.transparent,
      ),
      dividerColor: AppColors.border,
    );
  }
}
