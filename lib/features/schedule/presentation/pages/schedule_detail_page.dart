import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../models/schedule_ui_models.dart';
import '../widgets/schedule_ui_components.dart';
import 'schedule_form_page.dart';

class ScheduleDetailPage extends StatefulWidget {
  final ScheduleDraft schedule;

  const ScheduleDetailPage({
    super.key,
    required this.schedule,
  });

  @override
  State<ScheduleDetailPage> createState() => _ScheduleDetailPageState();
}

class _ScheduleDetailPageState extends State<ScheduleDetailPage> {
  late ScheduleDraft schedule;

  @override
  void initState() {
    super.initState();
    schedule = widget.schedule;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _title(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
        ),
        actions: [
          TextButton(
            onPressed: _edit,
            child: const Text(
              '수정',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete') {
                Navigator.pop(context);
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'delete',
                child: Text('삭제'),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 12, bottom: 24),
        children: [
          _heroCard(),
          ScheduleSectionCard(
            title: '일정',
            children: [
              ScheduleFieldTile(
                label: '시작',
                value: formatDate(schedule.start),
                helper: schedule.allDay ? '종일' : formatTime(schedule.start),
              ),
              ScheduleFieldTile(
                label: '종료',
                value: schedule.type == ScheduleFormType.other
                    ? formatDate(schedule.end)
                    : formatTime(schedule.end),
                helper: schedule.type == ScheduleFormType.other &&
                        !schedule.allDay
                    ? formatTime(schedule.end)
                    : null,
              ),
              ScheduleFieldTile(
                label: '반복',
                value: schedule.repeatText,
              ),
              const ScheduleFieldTile(
                label: '상태',
                value: '예정',
              ),
            ],
          ),
          ScheduleSectionCard(
            title: schedule.type == ScheduleFormType.consultation
                ? '상담 사유'
                : '메모',
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  schedule.type == ScheduleFormType.consultation
                      ? (schedule.consultationReason.isEmpty
                          ? '등록된 내용이 없습니다.'
                          : schedule.consultationReason)
                      : (schedule.memo.isEmpty
                          ? '등록된 내용이 없습니다.'
                          : schedule.memo),
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.55,
                    color: AppColors.textBody,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          if (schedule.type == ScheduleFormType.treatment)
            Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('치료 기록 화면은 다음 Chapter에서 연결합니다.'),
                    ),
                  );
                },
                icon: const Icon(Icons.description_outlined),
                label: const Text(
                  '치료 기록',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  foregroundColor: AppColors.primaryDark,
                  side: const BorderSide(color: AppColors.primary200),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _title() {
    switch (schedule.type) {
      case ScheduleFormType.treatment:
        return '치료 상세';
      case ScheduleFormType.consultation:
        return '상담/평가 상세';
      case ScheduleFormType.other:
        return '기타 상세';
    }
  }

  Widget _heroCard() {
    final icon = switch (schedule.type) {
      ScheduleFormType.treatment => Icons.medical_services_outlined,
      ScheduleFormType.consultation => Icons.forum_outlined,
      ScheduleFormType.other => Icons.event_note_outlined,
    };

    final title = switch (schedule.type) {
      ScheduleFormType.treatment =>
        '${schedule.member?.name ?? '이용자 미선택'} · ${schedule.program?.name ?? '프로그램 미선택'}',
      ScheduleFormType.consultation =>
        '${schedule.member?.name ?? '빠른 입력'} · 상담/평가',
      ScheduleFormType.other =>
        schedule.title.isEmpty ? '기타 일정' : schedule.title,
    };

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary50,
            Colors.white,
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primary200),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: AppColors.primary200),
            ),
            child: Icon(icon, color: AppColors.primaryDark),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textStrong,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  schedule.teacher?.displayName ?? '선생님 미선택',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textBody,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.primary100,
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Text(
              '예정',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                color: AppColors.primaryDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _edit() async {
    final result = await Navigator.push<ScheduleDraft>(
      context,
      MaterialPageRoute(
        builder: (_) => ScheduleFormPage(
          type: schedule.type,
          mode: ScheduleFormMode.edit,
          initialData: schedule,
        ),
      ),
    );

    if (result != null) {
      setState(() => schedule = result);
    }
  }
}
