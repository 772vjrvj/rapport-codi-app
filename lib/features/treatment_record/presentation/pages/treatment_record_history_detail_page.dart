import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/widgets/app_common_widgets.dart';
import '../models/treatment_record_ui.dart';

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
    counselController = TextEditingController(text: widget.record.counselContent);
    recordController = TextEditingController(text: widget.record.recordContent);
    specialController = TextEditingController(text: widget.record.specialNote);
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
          _SummaryCard(record: record),
          const SizedBox(height: 14),
          AppRecordTextSection(
            title: '상담 내용',
            controller: counselController,
            editable: editMode,
            emptyText: '등록된 상담 내용이 없습니다.',
            minLines: 4,
          ),
          const SizedBox(height: 14),
          AppRecordTextSection(
            title: '기록 내용',
            controller: recordController,
            editable: editMode,
            emptyText: '등록된 기록 내용이 없습니다.',
            minLines: 7,
          ),
          const SizedBox(height: 14),
          AppRecordTextSection(
            title: '특이사항',
            controller: specialController,
            editable: editMode,
            emptyText: '등록된 특이사항이 없습니다.',
            minLines: 4,
          ),
          const SizedBox(height: 14),
          AppAttachmentCard(count: record.attachmentCount),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final TreatmentRecordHistoryUi record;

  const _SummaryCard({required this.record});

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
                  '[${record.memberName}] ${record.programName}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textStrong,
                  ),
                ),
              ),
              _StatusPill(status: record.status),
            ],
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
          AppDateTimeLine(label: '시작', value: record.startAt),
          const SizedBox(height: 7),
          AppDateTimeLine(label: '종료', value: record.endAt),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String status;

  const _StatusPill({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
    );
  }
}
