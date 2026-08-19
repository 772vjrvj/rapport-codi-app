import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../models/record_history_ui_models.dart';

class TreatmentRecordHistoryDetailPage extends StatefulWidget {
  final TreatmentRecordHistoryUi record;

  const TreatmentRecordHistoryDetailPage({
    super.key,
    required this.record,
  });

  @override
  State<TreatmentRecordHistoryDetailPage> createState() =>
      _TreatmentRecordHistoryDetailPageState();
}

class _TreatmentRecordHistoryDetailPageState
    extends State<TreatmentRecordHistoryDetailPage> {
  bool editMode = false;
  late final TextEditingController counselController;
  late final TextEditingController recordController;
  late final TextEditingController specialController;

  @override
  void initState() {
    super.initState();
    counselController =
        TextEditingController(text: widget.record.counselContent);
    recordController =
        TextEditingController(text: widget.record.recordContent);
    specialController =
        TextEditingController(text: widget.record.specialNote);
  }

  @override
  void dispose() {
    counselController.dispose();
    recordController.dispose();
    specialController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final record = widget.record;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '치료 기록 상세',
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
          _SummaryCard(
            title: '[${record.memberName}] ${record.programName}',
            teacher: '${record.teacherName} / ${record.teacherRole}',
            status: record.status,
            startAt: record.startAt,
            endAt: record.endAt,
          ),
          const SizedBox(height: 14),
          _RecordSection(
            title: '상담 내용',
            controller: counselController,
            editMode: editMode,
            emptyText: '등록된 상담 내용이 없습니다.',
            minLines: 4,
          ),
          const SizedBox(height: 14),
          _RecordSection(
            title: '기록 내용',
            controller: recordController,
            editMode: editMode,
            emptyText: '등록된 기록 내용이 없습니다.',
            minLines: 7,
          ),
          const SizedBox(height: 14),
          _RecordSection(
            title: '특이사항',
            controller: specialController,
            editMode: editMode,
            emptyText: '등록된 특이사항이 없습니다.',
            minLines: 4,
          ),
          const SizedBox(height: 14),
          _AttachmentCard(count: record.attachmentCount),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String teacher;
  final String status;
  final DateTime startAt;
  final DateTime endAt;

  const _SummaryCard({
    required this.title,
    required this.teacher,
    required this.status,
    required this.startAt,
    required this.endAt,
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
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textStrong,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF7F0),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  status,
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF438267),
                  ),
                ),
              ),
            ],
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
          const SizedBox(height: 12),
          _DateTimeRow(label: '시작', value: startAt),
          const SizedBox(height: 7),
          _DateTimeRow(label: '종료', value: endAt),
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
            color: AppColors.primaryDark,
          ),
        ),
      ],
    );
  }
}

class _RecordSection extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final bool editMode;
  final String emptyText;
  final int minLines;

  const _RecordSection({
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
              maxLines: minLines + 5,
              decoration: InputDecoration(
                hintText: emptyText,
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
            )
          else
            Text(
              isEmpty ? emptyText : controller.text,
              style: TextStyle(
                fontSize: 13,
                height: 1.65,
                fontWeight: FontWeight.w600,
                color: isEmpty ? AppColors.textMuted : AppColors.textBody,
              ),
            ),
        ],
      ),
    );
  }
}

class _AttachmentCard extends StatelessWidget {
  final int count;

  const _AttachmentCard({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
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
            '첨부 ($count)',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w900,
              color: AppColors.textStrong,
            ),
          ),
          const Spacer(),
          Text(
            count == 0 ? '등록된 첨부파일이 없습니다.' : '$count개 파일',
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
