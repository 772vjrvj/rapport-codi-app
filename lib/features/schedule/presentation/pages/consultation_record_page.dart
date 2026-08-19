import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';

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
  State<ConsultationRecordPage> createState() =>
      _ConsultationRecordPageState();
}

class _ConsultationRecordPageState extends State<ConsultationRecordPage> {
  final content = TextEditingController();
  final memo = TextEditingController();

  @override
  void dispose() {
    content.dispose();
    memo.dispose();
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
      body: ListView(
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
          _InputCard(
            title: '상담/평가 내용',
            hint: '상담 내용, 평가 결과, 보호자 전달사항 등을 입력하세요.',
            controller: content,
            lines: 8,
          ),
          const SizedBox(height: 14),
          _InputCard(
            title: '메모',
            hint: '추가 메모가 있다면 입력하세요.',
            controller: memo,
            lines: 4,
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: SizedBox(
          height: 52,
          child: FilledButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('상담/평가 기록이 저장되었습니다. (UI 샘플)'),
                ),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              '기록 저장',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
            ),
          ),
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
          colors: [Color(0xFFFFF8ED), Colors.white],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFD8A0)),
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
          _DateTimeLine(
            label: '시작',
            dateText: dateText,
            timeText: startTime,
            timeColor: Color(0xFFE08A1E),
          ),
          const SizedBox(height: 7),
          _DateTimeLine(
            label: '종료',
            dateText: dateText,
            timeText: endTime,
            timeColor: Color(0xFFE08A1E),
          ),
        ],
      ),
    );
  }
}

class _DateTimeLine extends StatelessWidget {
  final String label;
  final String dateText;
  final String timeText;
  final Color timeColor;

  const _DateTimeLine({
    required this.label,
    required this.dateText,
    required this.timeText,
    this.timeColor = AppColors.primaryDark,
  });

  @override
  Widget build(BuildContext context) {
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
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: AppColors.textStrong,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          timeText,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w900,
            color: timeColor,
          ),
        ),
      ],
    );
  }
}

class _InputCard extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController controller;
  final int lines;

  const _InputCard({
    required this.title,
    required this.hint,
    required this.controller,
    required this.lines,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w900,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: controller,
            minLines: lines,
            maxLines: lines + 4,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: AppColors.primary50.withValues(alpha: 0.30),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
