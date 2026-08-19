import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../models/record_history_ui_models.dart';
import 'consultation_record_history_detail_page.dart';

class ConsultationRecordListPage extends StatefulWidget {
  const ConsultationRecordListPage({super.key});

  @override
  State<ConsultationRecordListPage> createState() =>
      _ConsultationRecordListPageState();
}

class _ConsultationRecordListPageState
    extends State<ConsultationRecordListPage> {
  final searchController = TextEditingController();
  String query = '';
  String selectedTeacher = '전체 선생님';

  final records = <ConsultationRecordHistoryUi>[
    ConsultationRecordHistoryUi(
      id: 'CR-001',
      startAt: DateTime(2026, 1, 28, 18, 20),
      endAt: DateTime(2026, 1, 28, 19, 0),
      memberName: '서울',
      consultationType: '일반상담',
      teacherName: '박병준',
      teacherRole: '대표님',
      status: '완료',
      summary: '언어를 계속할지 고민, 감통은 2월까지만 하려 했었다.',
      content:
          '언어를 계속할지 고민\n'
          '감통은 2월까지만 하려 했었다.\n\n'
          '언어평가 이야기가 나와서 고민중이었는데 현재 선생님과 아이가 잘 맞는듯해서 '
          '언어평가 예약을 안내함.\n\n'
          '보험실비상 6개월마다 왜 해야하는지에 대한 당위성을 설명하고 보호자가 선택하도록 안내함.\n\n'
          '앞서 감통 언어 종결 얘기는 기억에서 지워달라고 하심.',
    ),
    ConsultationRecordHistoryUi(
      id: 'CR-002',
      startAt: DateTime(2026, 1, 28, 10, 0),
      endAt: DateTime(2026, 1, 28, 10, 40),
      memberName: '김채은',
      consultationType: '일반상담',
      teacherName: '박병준',
      teacherRole: '대표님',
      status: '완료',
      summary: '치아관련 및 추후 치료 계획 상담',
    ),
    ConsultationRecordHistoryUi(
      id: 'CR-003',
      startAt: DateTime(2025, 11, 12, 15, 50),
      endAt: DateTime(2025, 11, 12, 16, 30),
      memberName: '김단우',
      consultationType: '일반상담',
      teacherName: '박병준',
      teacherRole: '대표님',
      status: '완료',
      summary: '내년부터 종일통합반으로 올라간다고 함.',
    ),
    ConsultationRecordHistoryUi(
      id: 'CR-004',
      startAt: DateTime(2025, 9, 11, 15, 50),
      endAt: DateTime(2025, 9, 11, 16, 30),
      memberName: '박이수',
      consultationType: '초기상담',
      teacherName: '박병준',
      teacherRole: '대표님',
      status: '완료',
      summary: '5;2 남아, 어린이집 다니고 있는 보호자와 초기상담 진행.',
    ),
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<ConsultationRecordHistoryUi> get filtered {
    final q = query.trim().toLowerCase();
    return records.where((record) {
      final teacherOk = selectedTeacher == '전체 선생님' ||
          record.teacherName == selectedTeacher;
      if (!teacherOk) return false;
      if (q.isEmpty) return true;
      return record.memberName.toLowerCase().contains(q) ||
          record.consultationType.toLowerCase().contains(q) ||
          record.teacherName.toLowerCase().contains(q) ||
          record.summary.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final items = filtered;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '상담/평가 기록',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
        ),
      ),
      body: Column(
        children: [
          _filterHeader(),
          Expanded(
            child: items.isEmpty
                ? const Center(
                    child: Text(
                      '조건에 맞는 상담/평가 기록이 없습니다.',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textMuted,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 22),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final current = items[index];
                      final showDate = index == 0 ||
                          !_sameDate(
                            items[index - 1].startAt,
                            current.startAt,
                          );

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (showDate)
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(4, 12, 4, 7),
                              child: Text(
                                recordDateLabel(current.startAt),
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.textBody,
                                ),
                              ),
                            ),
                          _ConsultationTile(
                            record: current,
                            onTap: () => _openDetail(current),
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _filterHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 11),
      child: Column(
        children: [
          TextField(
            controller: searchController,
            onChanged: (value) => setState(() => query = value),
            decoration: InputDecoration(
              hintText: '이용자, 상담유형, 내용 검색',
              prefixIcon: const Icon(Icons.search_rounded),
              filled: true,
              fillColor: const Color(0xFFFFF8ED),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 9),
          InkWell(
            onTap: _selectTeacher,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 43,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.person_outline_rounded,
                    size: 19,
                    color: AppColors.primaryDark,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      selectedTeacher,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textStrong,
                      ),
                    ),
                  ),
                  const Text(
                    '선생님 변경',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: AppColors.textMuted,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectTeacher() async {
    const teachers = ['전체 선생님', '박병준', '최민정'];
    final result = await showModalBottomSheet<String>(
      context: context,
      useSafeArea: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(
              title: Text(
                '선생님 선택',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
              ),
            ),
            ...teachers.map(
              (teacher) => ListTile(
                title: Text(teacher),
                trailing: teacher == selectedTeacher
                    ? const Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.primary,
                      )
                    : null,
                onTap: () => Navigator.pop(context, teacher),
              ),
            ),
          ],
        ),
      ),
    );

    if (result != null && mounted) {
      setState(() => selectedTeacher = result);
    }
  }

  void _openDetail(ConsultationRecordHistoryUi record) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ConsultationRecordHistoryDetailPage(record: record),
      ),
    );
  }

  bool _sameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _ConsultationTile extends StatelessWidget {
  final ConsultationRecordHistoryUi record;
  final VoidCallback onTap;

  const _ConsultationTile({
    required this.record,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.fromLTRB(13, 13, 12, 13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 54,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recordTimeLabel(record.startAt),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textStrong,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      recordTimeLabel(record.endAt),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 4,
                height: 54,
                margin: const EdgeInsets.only(right: 11),
                decoration: BoxDecoration(
                  color: const Color(0xFFE5A35D),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '[${record.memberName}] ${record.consultationType}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textStrong,
                            ),
                          ),
                        ),
                        Text(
                          '${record.teacherName} / ${record.teacherRole}',
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 7),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF4E7),
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: const Text(
                            '완료',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFC47921),
                            ),
                          ),
                        ),
                        const SizedBox(width: 7),
                        Expanded(
                          child: Text(
                            record.summary,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textBody,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right_rounded,
                          size: 18,
                          color: AppColors.textMuted,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
