import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../models/record_history_ui_models.dart';
import 'treatment_record_history_detail_page.dart';

class TreatmentRecordListPage extends StatefulWidget {
  const TreatmentRecordListPage({super.key});

  @override
  State<TreatmentRecordListPage> createState() =>
      _TreatmentRecordListPageState();
}

class _TreatmentRecordListPageState extends State<TreatmentRecordListPage> {
  final searchController = TextEditingController();
  String query = '';
  String selectedTeacher = '전체 선생님';

  final records = <TreatmentRecordHistoryUi>[
    TreatmentRecordHistoryUi(
      id: 'TR-001',
      startAt: DateTime(2026, 8, 20, 10, 0),
      endAt: DateTime(2026, 8, 20, 10, 40),
      memberName: '박시우',
      programName: '감통치료',
      teacherName: '한가람',
      teacherRole: '감통치료사',
      status: '완료',
      summary: '감각통합 활동 및 대근육 활동을 중심으로 진행했습니다.',
      counselContent: '보호자에게 오늘 진행한 활동과 반응을 안내했습니다.',
      recordContent:
          '전정감각 활동 후 집중 시간이 안정적으로 유지되었습니다.\n'
          '균형보드와 터널 활동을 수행했고 지시 수행이 전 회기보다 좋아졌습니다.',
      specialNote: '새로운 활동 시작 시 잠시 거부가 있었으나 곧 참여했습니다.',
    ),
    TreatmentRecordHistoryUi(
      id: 'TR-002',
      startAt: DateTime(2026, 8, 19, 14, 10),
      endAt: DateTime(2026, 8, 19, 14, 50),
      memberName: '박지현',
      programName: '언어치료',
      teacherName: '서유나',
      teacherRole: '언어재활사',
      status: '완료',
      summary: '문장 확장과 상황 설명을 중심으로 진행했습니다.',
      recordContent: '그림 상황 설명 시 4~5어절 문장을 자발적으로 표현했습니다.',
    ),
    TreatmentRecordHistoryUi(
      id: 'TR-003',
      startAt: DateTime(2026, 8, 18, 16, 0),
      endAt: DateTime(2026, 8, 18, 16, 40),
      memberName: '김루아',
      programName: '언어치료',
      teacherName: '서유나',
      teacherRole: '언어재활사',
      status: '완료',
      summary: '발음 및 표현언어 중심으로 진행했습니다.',
      counselContent: '가정에서 사용할 수 있는 표현 촉진 방법을 안내했습니다.',
    ),
    TreatmentRecordHistoryUi(
      id: 'TR-004',
      startAt: DateTime(2026, 8, 14, 11, 0),
      endAt: DateTime(2026, 8, 14, 11, 50),
      memberName: '박도윤',
      programName: '감각통합',
      teacherName: '김유진',
      teacherRole: '작업치료사',
      status: '작성중',
      summary: '치료 기록을 작성 중입니다.',
    ),
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<TreatmentRecordHistoryUi> get filtered {
    final q = query.trim().toLowerCase();
    return records.where((record) {
      final teacherOk = selectedTeacher == '전체 선생님' ||
          record.teacherName == selectedTeacher;
      if (!teacherOk) return false;
      if (q.isEmpty) return true;
      return record.memberName.toLowerCase().contains(q) ||
          record.programName.toLowerCase().contains(q) ||
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
          '치료 기록',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
        ),
        actions: [
          IconButton(
            tooltip: '검색',
            onPressed: () {},
            icon: const Icon(Icons.search_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          _filterHeader(),
          Expanded(
            child: items.isEmpty
                ? const _EmptyState(
                    icon: Icons.description_outlined,
                    text: '조건에 맞는 치료 기록이 없습니다.',
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
                            _DateHeader(date: current.startAt),
                          _TreatmentRecordTile(
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
              hintText: '이용자, 프로그램, 선생님 검색',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: query.isEmpty
                  ? null
                  : IconButton(
                      onPressed: () {
                        searchController.clear();
                        setState(() => query = '');
                      },
                      icon: const Icon(Icons.close_rounded),
                    ),
              filled: true,
              fillColor: AppColors.primary50.withValues(alpha: 0.45),
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
                  const SizedBox(width: 2),
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
    const teachers = ['전체 선생님', '한가람', '서유나', '김유진'];
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
                title: Text(
                  teacher,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
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

  void _openDetail(TreatmentRecordHistoryUi record) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TreatmentRecordHistoryDetailPage(record: record),
      ),
    );
  }

  bool _sameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _DateHeader extends StatelessWidget {
  final DateTime date;

  const _DateHeader({required this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 12, 4, 7),
      child: Text(
        recordDateLabel(date),
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w900,
          color: AppColors.textBody,
        ),
      ),
    );
  }
}

class _TreatmentRecordTile extends StatelessWidget {
  final TreatmentRecordHistoryUi record;
  final VoidCallback onTap;

  const _TreatmentRecordTile({
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
                  color: AppColors.primary,
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
                            '[${record.memberName}] ${record.programName}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textStrong,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
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
                            color: record.status == '완료'
                                ? const Color(0xFFEAF7F0)
                                : const Color(0xFFFFF4E7),
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: Text(
                            record.status,
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w900,
                              color: record.status == '완료'
                                  ? const Color(0xFF438267)
                                  : const Color(0xFFC47921),
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

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String text;

  const _EmptyState({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 42, color: AppColors.textMuted),
          const SizedBox(height: 10),
          Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
