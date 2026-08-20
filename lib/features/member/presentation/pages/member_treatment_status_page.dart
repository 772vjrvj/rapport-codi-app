import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../models/member_ui.dart';
import 'member_treatment_session_page.dart';

/// 이용자 상세에서 진입하는 치료/상담 이력 요약 화면입니다.
/// TODO(API): 서버 연결 후 이용자 ID로 실제 이력을 조회합니다.
class MemberTreatmentStatusPage extends StatelessWidget {
  final MemberUi member;

  const MemberTreatmentStatusPage({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    final items = _sampleItems();

    return Scaffold(
      appBar: AppBar(title: const Text('치료 현황')),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _MemberHeader(member: member),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 26),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        if (!item.treatment) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('상담/평가 이력입니다.')),
                          );
                          return;
                        }
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => MemberTreatmentSessionPage(
                              member: member,
                              programName: item.title,
                              teacherName: item.teacher,
                              period: item.dateText,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.dateText,
                                    style: const TextStyle(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.primaryDark,
                                    ),
                                  ),
                                  const SizedBox(height: 7),
                                  Text(
                                    item.title,
                                    style: const TextStyle(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textStrong,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    item.teacher,
                                    style: const TextStyle(
                                      fontSize: 11.5,
                                      color: AppColors.textBody,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<_TreatmentStatusItem> _sampleItems() => const [
        _TreatmentStatusItem(
          dateText: '2025-12-05',
          title: '해석상담',
          teacher: '조민석 / 센터장님',
        ),
        _TreatmentStatusItem(
          dateText: '2025-11-10',
          title: '감각통합평가',
          teacher: '이예진 / 감통치료사',
        ),
        _TreatmentStatusItem(
          dateText: '2025-07-18',
          title: '일반상담',
          teacher: '박병준 / 대표님',
        ),
        _TreatmentStatusItem(
          dateText: '2025-05-19 ~ 2025-12-26',
          title: '언어 · 언어치료 (개인 / 기관)',
          teacher: '윤수희 / 언어재활사(월-금)',
          treatment: true,
        ),
        _TreatmentStatusItem(
          dateText: '2025-05-19 ~ 2026-02-06',
          title: '감각통합 · 감각통합치료 (개인 / 기관)',
          teacher: '이예진 / 감통치료사(월,수,금)',
          treatment: true,
        ),
      ];
}

class _MemberHeader extends StatelessWidget {
  final MemberUi member;

  const _MemberHeader({required this.member});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: AppColors.primary50,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primary200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${member.name} (${member.gender}, ${_date(member.birthDate)})',
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w900,
              color: AppColors.textStrong,
            ),
          ),
          if (member.motherPhone.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              '(모) ${member.motherPhone}',
              style: const TextStyle(fontSize: 12, color: AppColors.textBody),
            ),
          ],
        ],
      ),
    );
  }

  static String _date(DateTime value) {
    final m = value.month.toString().padLeft(2, '0');
    final d = value.day.toString().padLeft(2, '0');
    return '${value.year}-$m-$d';
  }
}

class _TreatmentStatusItem {
  final String dateText;
  final String title;
  final String teacher;
  final bool treatment;

  const _TreatmentStatusItem({
    required this.dateText,
    required this.title,
    required this.teacher,
    this.treatment = false,
  });
}
