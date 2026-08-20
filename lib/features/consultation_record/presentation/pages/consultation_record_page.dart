import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/widgets/app_common_widgets.dart';

/// 일정 상세에서 바로 작성하는 상담/평가 기록 화면입니다.
class ConsultationRecordPage extends StatefulWidget {
  final String memberName;
  final String programName;
  final String teacherName;
  final String dateText;
  final String startTime;
  final String endTime;

  const ConsultationRecordPage({
    super.key,
    required this.memberName,
    required this.programName,
    required this.teacherName,
    required this.dateText,
    required this.startTime,
    required this.endTime,
  });

  @override
  State<ConsultationRecordPage> createState() => _ConsultationRecordPageState();
}

class _ConsultationRecordPageState extends State<ConsultationRecordPage> {
  final contentController = TextEditingController();
  final memoController = TextEditingController();

  @override
  void dispose() {
    contentController.dispose();
    memoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '상담/평가 기록',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
        ),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
          children: [
            _Summary(
              title: widget.memberName.isEmpty
                  ? '상담/평가'
                  : '${widget.memberName} · ${widget.programName}',
              teacher: widget.teacherName,
              dateText: widget.dateText,
              startTime: widget.startTime,
              endTime: widget.endTime,
            ),
            const SizedBox(height: 14),
            AppRecordTextSection(
              title: '상담/평가 내용',
              controller: contentController,
              emptyText: '상담 내용, 평가 결과, 보호자 전달사항 등을 입력하세요.',
              minLines: 8,
              fillColor: AppColors.consultationSoft,
              focusColor: AppColors.consultation,
            ),
            const SizedBox(height: 14),
            AppRecordTextSection(
              title: '메모',
              controller: memoController,
              emptyText: '추가 메모가 있다면 입력하세요.',
              minLines: 4,
              fillColor: AppColors.consultationSoft,
              focusColor: AppColors.consultation,
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppPrimaryButton(
        label: '기록 저장',
        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('상담/평가 기록이 저장되었습니다. (UI 샘플)')),
        ),
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  final String title;
  final String teacher;
  final String dateText;
  final String startTime;
  final String endTime;

  const _Summary({
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
          colors: [AppColors.consultationSoft, Colors.white],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.consultationBorder),
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
            color: AppColors.consultation,
          ),
        ),
      ],
    );
  }
}
