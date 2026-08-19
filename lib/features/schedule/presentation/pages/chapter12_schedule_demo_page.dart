import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../models/schedule_ui_models.dart';
import '../widgets/schedule_type_sheet.dart';
import '../widgets/schedule_ui_components.dart';
import 'schedule_detail_page.dart';

class Chapter12ScheduleDemoPage extends StatelessWidget {
  const Chapter12ScheduleDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final sample = ScheduleDraft(
      type: ScheduleFormType.treatment,
      teacher: const TeacherUi(
        id: 'T04',
        name: '한가람',
        role: '감통치료사(월-금)',
        color: Color(0xFFEFA7C6),
      ),
      member: const MemberUi(
        id: 'M09',
        name: '박시우',
        gender: '남',
        birthDate: '2019-09-26',
        guardianPhone: '(모) 010-5961-0500',
      ),
      program: const ProgramUi(
        id: 'P02',
        category: '감각통합',
        name: '진행X',
        serviceType: '개인, 기관',
      ),
      start: DateTime(2026, 8, 20, 10, 0),
      end: DateTime(2026, 8, 20, 10, 40),
      repeatText: '목 · 1개월',
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chapter 12 UI',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.border),
            ),
            child: const Text(
              '일정 등록 / 상세 / 수정 UI 테스트 화면입니다.\n'
              '실제 메인 연결 전 각 화면을 빠르게 확인할 수 있습니다.',
              style: TextStyle(
                height: 1.55,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textBody,
              ),
            ),
          ),
          const SizedBox(height: 14),
          SchedulePrimaryButton(
            label: '일정 등록 열기',
            onPressed: () => openScheduleTypeSheet(context),
          ),
          const SizedBox(height: 4),
          OutlinedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ScheduleDetailPage(schedule: sample),
                ),
              );
            },
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              foregroundColor: AppColors.primaryDark,
              side: const BorderSide(color: AppColors.primary200),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              '샘플 치료 상세 열기',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }
}
