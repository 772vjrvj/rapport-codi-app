import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';

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
  final counsel = TextEditingController();
  final record = TextEditingController();
  final special = TextEditingController();

  @override
  void dispose() {
    counsel.dispose();
    record.dispose();
    special.dispose();
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
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
        children: [
          _Summary(
            title: '${widget.memberName} · ${widget.programName}',
            teacher: widget.teacherName,
            dateText: widget.dateText,
            startTime: widget.startTime,
            endTime: widget.endTime,
          ),
          const SizedBox(height: 14),
          _InputCard(
            title: '상담 내용',
            hint: '보호자 상담 내용이나 전달사항을 입력하세요.',
            controller: counsel,
            lines: 4,
          ),
          const SizedBox(height: 14),
          _InputCard(
            title: '기록 내용',
            hint: '치료 목표, 활동, 반응 등을 기록하세요.',
            controller: record,
            lines: 7,
          ),
          const SizedBox(height: 14),
          _InputCard(
            title: '특이사항',
            hint: '특이사항이 있다면 입력하세요.',
            controller: special,
            lines: 4,
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('첨부파일은 API 단계에서 연결합니다.')),
              );
            },
            icon: const Icon(Icons.attach_file_rounded),
            label: const Text('첨부파일'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              foregroundColor: AppColors.primaryDark,
              side: const BorderSide(color: AppColors.primary200),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _SaveBar(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('치료 기록이 저장되었습니다. (UI 샘플)')),
          );
        },
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
          _DateTimeLine(
            label: '시작',
            dateText: dateText,
            timeText: startTime,
          ),
          const SizedBox(height: 7),
          _DateTimeLine(
            label: '종료',
            dateText: dateText,
            timeText: endTime,
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
            maxLines: lines + 3,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: AppColors.primary50.withValues(alpha: 0.35),
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

class _SaveBar extends StatelessWidget {
  final VoidCallback onPressed;

  const _SaveBar({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: SizedBox(
        height: 52,
        child: FilledButton(
          onPressed: onPressed,
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
    );
  }
}
