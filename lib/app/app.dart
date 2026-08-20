import 'package:flutter/material.dart';

import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/splash_page.dart';
import '../features/common/presentation/pages/simple_placeholder_page.dart';
import '../features/consultation_record/presentation/pages/consultation_record_list_page.dart';
import '../features/schedule/presentation/pages/main_schedule_page.dart';
import '../features/treatment_record/presentation/pages/treatment_record_list_page.dart';
import 'routes/app_routes.dart';
import 'theme/app_theme.dart';
import 'widgets/main_app_drawer.dart';

class RapportCodiApp extends StatelessWidget {
  const RapportCodiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rapport Codi',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.build(),
      home: const SplashPage(),
      routes: {
        AppRoutes.login: (_) => const LoginPage(),
        AppRoutes.schedule: (_) => const MainSchedulePage(),
        AppRoutes.treatmentRecords: (_) => const TreatmentRecordListPage(),
        AppRoutes.consultationRecords: (_) => const ConsultationRecordListPage(),
        AppRoutes.members: (_) => const SimplePlaceholderPage(
              title: '이용자 관리',
              message: '이용자 관리 화면은 다음 작업에서 실제 기능을 연결합니다.',
              menu: AppMenu.members,
              icon: Icons.child_care_outlined,
            ),
        AppRoutes.notices: (_) => const SimplePlaceholderPage(
              title: '공지사항',
              message: '공지사항 목록/상세 API 연결 전 임시 화면입니다.',
              menu: AppMenu.notices,
              icon: Icons.campaign_outlined,
            ),
        AppRoutes.support: (_) => const SimplePlaceholderPage(
              title: '서비스지원',
              message: '서비스지원 화면은 추후 연결합니다.',
              menu: AppMenu.support,
              icon: Icons.support_agent_outlined,
            ),
        AppRoutes.account: (_) => const SimplePlaceholderPage(
              title: '나의 계정',
              message: '나의 계정 화면은 추후 연결합니다.',
              menu: AppMenu.account,
              icon: Icons.account_circle_outlined,
            ),
        AppRoutes.settings: (_) => const SimplePlaceholderPage(
              title: '설정',
              message: '설정 화면은 추후 연결합니다.',
              menu: AppMenu.settings,
              icon: Icons.settings_outlined,
            ),
      },
    );
  }
}
