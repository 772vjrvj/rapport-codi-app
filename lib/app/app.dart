import 'package:flutter/material.dart';

import '../features/account/presentation/pages/account_page.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/splash_page.dart';
import '../features/consultation_record/presentation/pages/consultation_record_list_page.dart';
import '../features/member/presentation/pages/member_list_page.dart';
import '../features/notice/presentation/pages/notice_list_page.dart';
import '../features/schedule/presentation/pages/main_schedule_page.dart';
import '../features/support/presentation/pages/support_page.dart';
import '../features/treatment_record/presentation/pages/treatment_record_list_page.dart';
import '../features/teacher_comment/presentation/pages/teacher_comment_list_page.dart';
import '../features/parent_together/presentation/pages/parent_together_page.dart';
import '../features/child_info/presentation/pages/child_info_feed_page.dart';
import '../core/services/local_notification_service.dart';
import 'routes/app_routes.dart';
import 'theme/app_theme.dart';

class RapportCodiApp extends StatelessWidget {
  const RapportCodiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: LocalNotificationService.navigatorKey,
      title: 'Rapport Codi',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.build(),
      home: const SplashPage(),
      routes: {
        AppRoutes.login: (_) => const LoginPage(),
        AppRoutes.schedule: (_) => const MainSchedulePage(),
        AppRoutes.treatmentRecords: (_) => const TreatmentRecordListPage(),
        AppRoutes.teacherComments: (_) => const TeacherCommentListPage(),
        AppRoutes.parentTogether: (_) => const ParentTogetherPage(),
        AppRoutes.childInfo: (_) => const ChildInfoFeedPage(),
        AppRoutes.consultationRecords: (_) => const ConsultationRecordListPage(),
        AppRoutes.members: (_) => const MemberListPage(),
        AppRoutes.notices: (_) => const NoticeListPage(),
        AppRoutes.support: (_) => const SupportPage(),
        AppRoutes.account: (_) => const AccountPage(),
      },
    );
  }
}
