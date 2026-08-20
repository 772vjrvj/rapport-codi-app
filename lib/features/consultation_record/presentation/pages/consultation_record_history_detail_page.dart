import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/widgets/app_common_widgets.dart';
import '../models/consultation_record_ui.dart';

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
          AppRecordTextSection(
            title: '상담/평가 내용',
            controller: contentController,
            editable: editMode,
            emptyText: '등록된 상담/평가 내용이 없습니다.',
            minLines: 9,
            fillColor: AppColors.consultationSoft,
            focusColor: AppColors.consultation,
          ),
          const SizedBox(height: 14),
          AppRecordTextSection(
            title: '메모',
            controller: memoController,
            editable: editMode,
            emptyText: '등록된 메모가 없습니다.',
            minLines: 4,
            fillColor: AppColors.consultationSoft,
            focusColor: AppColors.consultation,
          ),
          const SizedBox(height: 14),
          AppAttachmentCard(count: record.attachmentCount),
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
          colors: [AppColors.consultationSoft, Colors.white],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.consultationBorder),
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
          AppDateTimeLine(
            label: '시작',
            value: record.startAt,
            timeColor: AppColors.consultation,
          ),
          const SizedBox(height: 7),
          AppDateTimeLine(
            label: '종료',
            value: record.endAt,
            timeColor: AppColors.consultation,
          ),
        ],
      ),
    );
  }
}
