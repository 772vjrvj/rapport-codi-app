import 'package:flutter/material.dart';

import '../routes/app_routes.dart';
import '../theme/app_theme.dart';

enum AppMenu {
  schedule,
  treatmentRecords,
  teacherComments,
  parentTogether,
  childInfo,
  consultationRecords,
  members,
  notices,
  support,
  account,
}

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

      // Drawer 배경은 휴대폰 최상단 상태바 영역까지 올라감
      child: SafeArea(
        // 내용만 상태바 아래부터 시작
        top: true,
        bottom: true,
        child: Column(
          children: [
            const _UserHeader(),
            const Divider(height: 1),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(10),
                children: [
                  _item(
                    context,
                    AppMenu.schedule,
                    Icons.calendar_month_outlined,
                    '일정',
                  ),
                  _item(
                    context,
                    AppMenu.treatmentRecords,
                    Icons.description_outlined,
                    '치료기록 관리',
                  ),
                  _item(
                    context,
                    AppMenu.teacherComments,
                    Icons.chat_bubble_outline_rounded,
                    '선생님 코멘트',
                  ),
                  _item(
                    context,
                    AppMenu.parentTogether,
                    Icons.family_restroom_rounded,
                    '부모님과 함께',
                  ),
                  _item(
                    context,
                    AppMenu.childInfo,
                    Icons.auto_awesome_outlined,
                    '민준이를 위한 정보',
                  ),
                  _item(
                    context,
                    AppMenu.consultationRecords,
                    Icons.chat_bubble_outline,
                    '상담/평가기록 관리',
                  ),
                  _item(
                    context,
                    AppMenu.members,
                    Icons.account_circle_outlined,
                    '이용자 관리',
                  ),
                  _item(
                    context,
                    AppMenu.notices,
                    Icons.campaign_outlined,
                    '공지사항',
                  ),
                  _item(
                    context,
                    AppMenu.support,
                    Icons.support_agent_outlined,
                    '서비스 지원',
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            Padding(
              padding: const EdgeInsets.fromLTRB(10, 6, 10, 12),
              child: Column(
                children: [
                  _item(
                    context,
                    AppMenu.account,
                    Icons.account_circle_outlined,
                    '나의 계정',
                  ),
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      leading: Icon(icon),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
        ),
      ),
      onTap: () {
        if (isSelected) {
          Navigator.pop(context);
          return;
        }

        final navigator = Navigator.of(context);

        navigator.pop();

        navigator.pushReplacementNamed(
          _routeOf(menu),
        );
      },
    );
  }

  String _routeOf(AppMenu menu) {
    return switch (menu) {
      AppMenu.schedule => AppRoutes.schedule,
      AppMenu.treatmentRecords => AppRoutes.treatmentRecords,
      AppMenu.teacherComments => AppRoutes.teacherComments,
      AppMenu.parentTogether => AppRoutes.parentTogether,
      AppMenu.childInfo => AppRoutes.childInfo,
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