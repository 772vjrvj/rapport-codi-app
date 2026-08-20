import 'package:flutter/material.dart';

import '../routes/app_routes.dart';
import '../theme/app_theme.dart';

enum AppMenu {
  schedule,
  treatmentRecords,
  consultationRecords,
  members,
  notices,
  support,
  account,
}

/// 모든 최상위 화면에서 같이 사용하는 Drawer입니다.
/// 메뉴 이동 로직을 이 파일 하나에서 관리합니다.
class MainAppDrawer extends StatelessWidget {
  final AppMenu selected;

  const MainAppDrawer({
    super.key,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.82,
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            const _UserHeader(),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(10),
                children: [
                  _item(context, AppMenu.schedule, Icons.calendar_month_outlined, '일정'),
                  _item(context, AppMenu.treatmentRecords, Icons.description_outlined, '치료기록 관리'),
                  _item(context, AppMenu.consultationRecords, Icons.chat_bubble_outline, '상담/평가기록 관리'),
                  _item(context, AppMenu.members, Icons.account_circle_outlined, '이용자 관리'),
                  _item(context, AppMenu.notices, Icons.campaign_outlined, '공지사항'),
                  _item(context, AppMenu.support, Icons.support_agent_outlined, '서비스 지원'),
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 6, 10, 12),
              child: Column(
                children: [
                  _item(context, AppMenu.account, Icons.account_circle_outlined, '나의 계정'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _item(
      BuildContext context,
      AppMenu menu,
      IconData icon,
      String label,
      ) {
    final isSelected = selected == menu;

    return ListTile(
      selected: isSelected,
      selectedColor: AppColors.primaryDark,
      selectedTileColor: AppColors.primary50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      leading: Icon(icon),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
        ),
      ),
      onTap: () {
        // 현재 화면을 다시 누르면 Drawer만 닫습니다.
        if (isSelected) {
          Navigator.pop(context);
          return;
        }

        final navigator = Navigator.of(context);
        navigator.pop();
        navigator.pushReplacementNamed(_routeOf(menu));
      },
    );
  }

  String _routeOf(AppMenu menu) {
    return switch (menu) {
      AppMenu.schedule => AppRoutes.schedule,
      AppMenu.treatmentRecords => AppRoutes.treatmentRecords,
      AppMenu.consultationRecords => AppRoutes.consultationRecords,
      AppMenu.members => AppRoutes.members,
      AppMenu.notices => AppRoutes.notices,
      AppMenu.support => AppRoutes.support,
      AppMenu.account => AppRoutes.account,
    };
  }
}

class _UserHeader extends StatelessWidget {
  const _UserHeader();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(20, 22, 20, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '서울성모의원아동발달클리닉',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w900,
              color: AppColors.textStrong,
            ),
          ),
          SizedBox(height: 18),
          Row(
            children: [
              CircleAvatar(
                radius: 27,
                backgroundColor: AppColors.primary50,
                child: Icon(
                  Icons.person_outline,
                  color: AppColors.primaryDark,
                  size: 30,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '박병준 / 대표님',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textStrong,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'rapportTest',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
