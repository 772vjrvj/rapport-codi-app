import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../models/record_history_ui_models.dart';

class ConsultationRecordHistoryDetailPage extends StatefulWidget {
  final ConsultationRecordHistoryUi record;

  const ConsultationRecordHistoryDetailPage({
    super.key,
    required this.record,
  });

  @override
  State<ConsultationRecordHistoryDetailPage> createState() =>
      _ConsultationRecordHistoryDetailPageState();
}

class _ConsultationRecordHistoryDetailPageState
    extends State<ConsultationRecordHistoryDetailPage> {
  bool editMode = false;
  late final TextEditingController contentController;
  late final TextEditingController memoController;

  @override
  void initState() {
    super.initState();
    contentController = TextEditingController(text: widget.record.content);
    memoController = TextEditingController(text: widget.record.memo);
  }

  @override
  void dispose() {
    contentController.dispose();
    memoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final record = widget.record;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '상담/평가 기록 상세',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (editMode) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('수정되었습니다. (UI 샘플)')),
                );
              }
              setState(() => editMode = !editMode);
            },
            child: Text(
              editMode ? '완료' : '수정',
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                color: AppColors.primaryDark,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        children: [
          _SummaryCard(record: record),
          const SizedBox(height: 14),
          _Section(
            title: '상담/평가 내용',
            controller: contentController,
            editMode: editMode,
            emptyText: '등록된 상담/평가 내용이 없습니다.',
            minLines: 9,
          ),
          const SizedBox(height: 14),
          _Section(
            title: '메모',
            controller: memoController,
            editMode: editMode,
            emptyText: '등록된 메모가 없습니다.',
            minLines: 4,
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.attach_file_rounded,
                  color: AppColors.primaryDark,
                ),
                const SizedBox(width: 10),
                Text(
                  '첨부 (${record.attachmentCount})',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textStrong,
                  ),
                ),
                const Spacer(),
                Text(
                  record.attachmentCount == 0
                      ? '등록된 첨부파일이 없습니다.'
                      : '${record.attachmentCount}개 파일',
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final ConsultationRecordHistoryUi record;

  const _SummaryCard({required this.record});

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
            '[${record.memberName}] ${record.consultationType}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: AppColors.textStrong,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '${record.teacherName} / ${record.teacherRole}',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.textBody,
            ),
          ),
          const SizedBox(height: 12),
          _DateTimeRow(label: '시작', value: record.startAt),
          const SizedBox(height: 7),
          _DateTimeRow(label: '종료', value: record.endAt),
        ],
      ),
    );
  }
}

class _DateTimeRow extends StatelessWidget {
  final String label;
  final DateTime value;

  const _DateTimeRow({
    required this.label,
    required this.value,
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
            recordDateLabel(value),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: AppColors.textStrong,
            ),
          ),
        ),
        Text(
          recordTimeLabel(value),
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w900,
            color: Color(0xFFE08A1E),
          ),
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final bool editMode;
  final String emptyText;
  final int minLines;

  const _Section({
    required this.title,
    required this.controller,
    required this.editMode,
    required this.emptyText,
    required this.minLines,
  });

  @override
  Widget build(BuildContext context) {
    final isEmpty = controller.text.trim().isEmpty;

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
          const SizedBox(height: 11),
          if (editMode)
            TextField(
              controller: controller,
              minLines: minLines,
              maxLines: minLines + 6,
              decoration: InputDecoration(
                hintText: emptyText,
                filled: true,
                fillColor: const Color(0xFFFFFAF3),
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
                  borderSide: const BorderSide(color: Color(0xFFE5A35D)),
                ),
              ),
            )
          else
            Text(
              isEmpty ? emptyText : controller.text,
              style: TextStyle(
                fontSize: 13,
                height: 1.7,
                fontWeight: FontWeight.w600,
                color: isEmpty ? AppColors.textMuted : AppColors.textBody,
              ),
            ),
        ],
      ),
    );
  }
}
