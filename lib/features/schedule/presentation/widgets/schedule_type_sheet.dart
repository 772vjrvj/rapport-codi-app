import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../models/schedule_ui_models.dart';
import '../pages/schedule_form_page.dart';

Future<void> openScheduleTypeSheet(BuildContext context) async {
  final type = await showModalBottomSheet<ScheduleFormType>(
    context: context,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  '일정 등록',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textStrong,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  '등록할 일정 종류를 선택하세요.',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 18),
                _TypeTile(
                  icon: Icons.medical_services_outlined,
                  title: '치료',
                  subtitle: '이용자와 프로그램을 선택해 치료 일정을 등록합니다.',
                  onTap: () => Navigator.pop(
                    context,
                    ScheduleFormType.treatment,
                  ),
                ),
                const SizedBox(height: 8),
                _TypeTile(
                  icon: Icons.forum_outlined,
                  title: '상담 / 평가',
                  subtitle: '초기상담, 평가 등 상담 일정을 등록합니다.',
                  onTap: () => Navigator.pop(
                    context,
                    ScheduleFormType.consultation,
                  ),
                ),
                const SizedBox(height: 8),
                _TypeTile(
                  icon: Icons.event_note_outlined,
                  title: '기타',
                  subtitle: '회의, 교육, 센터 공용 일정 등을 등록합니다.',
                  onTap: () => Navigator.pop(
                    context,
                    ScheduleFormType.other,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );

  if (type == null || !context.mounted) return;

  await Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => ScheduleFormPage(type: type),
    ),
  );
}

class _TypeTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _TypeTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary50,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 13, 12, 13),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(color: AppColors.primary200),
                ),
                child: Icon(
                  icon,
                  size: 22,
                  color: AppColors.primaryDark,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textStrong,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 11,
                        height: 1.35,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.primaryDark,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
