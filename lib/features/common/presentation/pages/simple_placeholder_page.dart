import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../app/widgets/main_app_drawer.dart';

/// 아직 상세 기능을 만들지 않은 최상위 메뉴의 공통 임시 화면입니다.
/// Drawer 메뉴는 모두 실제로 반응하도록 연결해 두었습니다.
class SimplePlaceholderPage extends StatelessWidget {
  final String title;
  final String message;
  final AppMenu menu;
  final IconData icon;

  const SimplePlaceholderPage({
    super.key,
    required this.title,
    required this.message,
    required this.menu,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainAppDrawer(selected: menu),
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 52, color: AppColors.primaryDark),
                const SizedBox(height: 14),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.6,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textBody,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
