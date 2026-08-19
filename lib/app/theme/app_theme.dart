import 'package:flutter/material.dart';

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
