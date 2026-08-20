import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/widgets/app_common_widgets.dart';

/// 일정 상세에서 바로 작성하는 치료 기록 화면입니다.
class TreatmentRecordPage extends StatefulWidget {
  final String memberName;
  final String programName;
  final String teacherName;
  final String dateText;
  final String startTime;
  final String endTime;

  const TreatmentRecordPage({
    super.key,
    required this.memberName,
    required this.programName,
    required this.teacherName,
    required this.dateText,
    required this.startTime,
    required this.endTime,
  });

  @override
  State<TreatmentRecordPage> createState() => _TreatmentRecordPageState();
}

class _TreatmentRecordPageState extends State<TreatmentRecordPage> {
  final counselController = TextEditingController();
  final recordController = TextEditingController();
  final specialController = TextEditingController();

  @override
  void dispose() {
    counselController.dispose();
    recordController.dispose();
    specialController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '치료 기록',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
        ),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
          children: [
            _StringDateSummary(
              title: '${widget.memberName} · ${widget.programName}',
              teacher: widget.teacherName,
              dateText: widget.dateText,
              startTime: widget.startTime,
              endTime: widget.endTime,
            ),
            const SizedBox(height: 14),
            AppRecordTextSection(
              title: '상담 내용',
              controller: counselController,
              emptyText: '보호자 상담 내용이나 전달사항을 입력하세요.',
              minLines: 4,
            ),
            const SizedBox(height: 14),
            AppRecordTextSection(
              title: '기록 내용',
              controller: recordController,
              emptyText: '치료 목표, 활동, 반응 등을 기록하세요.',
              minLines: 7,
            ),
            const SizedBox(height: 14),
            AppRecordTextSection(
              title: '특이사항',
              controller: specialController,
              emptyText: '특이사항이 있다면 입력하세요.',
              minLines: 4,
            ),
            const SizedBox(height: 14),
            AppAttachmentCard(
              count: 0,
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('첨부파일은 API 단계에서 연결합니다.')),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppPrimaryButton(
        label: '기록 저장',
        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('치료 기록이 저장되었습니다. (UI 샘플)')),
        ),
      ),
    );
  }
}

class _StringDateSummary extends StatelessWidget {
  final String title;
  final String teacher;
  final String dateText;
  final String startTime;
  final String endTime;

  const _StringDateSummary({
    required this.title,
    required this.teacher,
    required this.dateText,
    required this.startTime,
    required this.endTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary50, Colors.white],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary200),
      ),
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
            teacher,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.textBody,
            ),
          ),
          const SizedBox(height: 11),
          _line('시작', startTime),
          const SizedBox(height: 7),
          _line('종료', endTime),
        ],
      ),
    );
  }

  Widget _line(String label, String time) {
    return Row(
      children: [
        SizedBox(
          width: 38,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: AppColors.textMuted,
            ),
          ),
        ),
        Expanded(
          child: Text(
            dateText,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: AppColors.textStrong,
            ),
          ),
        ),
        Text(
          time,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w900,
            color: AppColors.primaryDark,
          ),
        ),
      ],
    );
  }
}
