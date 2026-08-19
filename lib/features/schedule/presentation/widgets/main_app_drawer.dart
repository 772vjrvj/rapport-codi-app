import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';

class MainAppDrawer extends StatelessWidget {
  const MainAppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.82,
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '서울성모의원아동발달클리닉',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textStrong,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Row(
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
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(10),
                children: [
                  _item(context, Icons.calendar_month_outlined, '일정', true),
                  _item(context, Icons.description_outlined, '치료기록 관리', false),
                  _item(context, Icons.chat_bubble_outline, '상담/평가기록 관리', false),
                  _item(context, Icons.child_care_outlined, '이용자 관리', false),
                  _item(context, Icons.campaign_outlined, '공지사항', false),
                  _item(context, Icons.support_agent_outlined, '서비스지원', false),
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 6, 10, 12),
              child: Column(
                children: [
                  _item(context, Icons.account_circle_outlined, '나의 계정', false),
                  _item(context, Icons.settings_outlined, '설정', false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _item(
    BuildContext context,
    IconData icon,
    String label,
    bool selected,
  ) {
    return ListTile(
      selected: selected,
      selectedColor: AppColors.primaryDark,
      selectedTileColor: AppColors.primary50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      leading: Icon(icon),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: selected ? FontWeight.w900 : FontWeight.w700,
        ),
      ),
      onTap: () => Navigator.pop(context),
    );
  }
}
