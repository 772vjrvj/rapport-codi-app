import 'package:flutter/material.dart';

import '../../app/theme/app_theme.dart';
import '../utils/date_time_utils.dart';

/// 치료기록/상담기록 목록이 공통으로 사용하는 검색 + 선생님 필터 영역입니다.
class RecordFilterHeader extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String selectedTeacher;
  final ValueChanged<String> onChanged;
  final VoidCallback onTeacherTap;
  final VoidCallback onClear;
  final Color searchBackground;

  const RecordFilterHeader({
    super.key,
    required this.controller,
    required this.hintText,
    required this.selectedTeacher,
    required this.onChanged,
    required this.onTeacherTap,
    required this.onClear,
    this.searchBackground = AppColors.primary50,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 11),
      child: Column(
        children: [
          TextField(
            controller: controller,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: hintText,
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: controller.text.isEmpty
                  ? null
                  : IconButton(
                      onPressed: onClear,
                      icon: const Icon(Icons.close_rounded),
                    ),
              filled: true,
              fillColor: searchBackground.withValues(alpha: 0.55),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 9),
          InkWell(
            onTap: onTeacherTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 43,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.person_outline_rounded,
                    size: 19,
                    color: AppColors.primaryDark,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      selectedTeacher,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textStrong,
                      ),
                    ),
                  ),
                  const Text(
                    '선생님 변경',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: AppColors.textMuted,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RecordDateHeader extends StatelessWidget {
  final DateTime date;

  const RecordDateHeader({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 12, 4, 7),
      child: Text(
        AppDateTime.date(date),
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w900,
          color: AppColors.textBody,
        ),
      ),
    );
  }
}

/// 기록 목록의 한 행입니다.
/// 치료/상담 목록은 색상과 텍스트만 바꾸고 같은 UI를 재사용합니다.
class RecordListTile extends StatelessWidget {
  final DateTime startAt;
  final DateTime endAt;
  final String title;
  final String teacher;
  final String status;
  final String summary;
  final Color accentColor;
  final Color statusBackground;
  final Color statusColor;
  final VoidCallback onTap;

  const RecordListTile({
    super.key,
    required this.startAt,
    required this.endAt,
    required this.title,
    required this.teacher,
    required this.status,
    required this.summary,
    required this.accentColor,
    required this.statusBackground,
    required this.statusColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.fromLTRB(13, 13, 12, 13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 54,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppDateTime.time(startAt),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textStrong,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppDateTime.time(endAt),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 4,
                height: 54,
                margin: const EdgeInsets.only(right: 11),
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textStrong,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          teacher,
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 7),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: statusBackground,
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w900,
                              color: statusColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 7),
                        Expanded(
                          child: Text(
                            summary,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textBody,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right_rounded,
                          size: 18,
                          color: AppColors.textMuted,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<String?> showTeacherFilterSheet(
  BuildContext context, {
  required String selectedTeacher,
  required List<String> teachers,
}) {
  return showModalBottomSheet<String>(
    context: context,
    useSafeArea: true,
    builder: (context) => Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 18),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ListTile(
            title: Text(
              '선생님 선택',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
            ),
          ),
          ...teachers.map(
            (teacher) => ListTile(
              title: Text(
                teacher,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              trailing: teacher == selectedTeacher
                  ? const Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.primary,
                    )
                  : null,
              onTap: () => Navigator.pop(context, teacher),
            ),
          ),
        ],
      ),
    ),
  );
}
