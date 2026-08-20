import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../app/widgets/main_app_drawer.dart';
import '../../../../core/widgets/record_list_widgets.dart';
import '../models/treatment_record_ui.dart';
import 'treatment_record_history_detail_page.dart';

class TreatmentRecordListPage extends StatefulWidget {
  const TreatmentRecordListPage({super.key});

  @override
  State<TreatmentRecordListPage> createState() => _TreatmentRecordListPageState();
}

class _TreatmentRecordListPageState extends State<TreatmentRecordListPage> {
  final searchController = TextEditingController();
  String query = '';
  String selectedTeacher = '전체 선생님';

  // TODO(API): 추후 Repository에서 받아오는 데이터로 교체합니다.
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
      recordContent: '전정감각 활동 후 집중 시간이 안정적으로 유지되었습니다.\n균형보드와 터널 활동을 수행했습니다.',
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

  List<TreatmentRecordHistoryUi> get filteredRecords {
    final q = query.trim().toLowerCase();
    return records.where((record) {
      final matchesTeacher = selectedTeacher == '전체 선생님' ||
          record.teacherName == selectedTeacher;
      if (!matchesTeacher) return false;
      if (q.isEmpty) return true;
      return record.memberName.toLowerCase().contains(q) ||
          record.programName.toLowerCase().contains(q) ||
          record.teacherName.toLowerCase().contains(q) ||
          record.summary.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final items = filteredRecords;

    return Scaffold(
      drawer: const MainAppDrawer(selected: AppMenu.treatmentRecords),
      appBar: AppBar(
        title: const Text(
          '치료기록 관리',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
        ),
      ),
      body: Column(
        children: [
          RecordFilterHeader(
            controller: searchController,
            hintText: '이용자, 프로그램, 선생님 검색',
            selectedTeacher: selectedTeacher,
            onChanged: (value) => setState(() => query = value),
            onClear: () {
              searchController.clear();
              setState(() => query = '');
            },
            onTeacherTap: _selectTeacher,
          ),
          Expanded(
            child: items.isEmpty
                ? const Center(
                    child: Text(
                      '조건에 맞는 치료 기록이 없습니다.',
                      style: TextStyle(color: AppColors.textMuted),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 22),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final record = items[index];
                      final showDate = index == 0 ||
                          !_sameDate(items[index - 1].startAt, record.startAt);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (showDate) RecordDateHeader(date: record.startAt),
                          RecordListTile(
                            startAt: record.startAt,
                            endAt: record.endAt,
                            title: '[${record.memberName}] ${record.programName}',
                            teacher: '${record.teacherName} / ${record.teacherRole}',
                            status: record.status,
                            summary: record.summary,
                            accentColor: AppColors.primary,
                            statusBackground: record.status == '완료'
                                ? const Color(0xFFEAF7F0)
                                : const Color(0xFFFFF4E7),
                            statusColor: record.status == '완료'
                                ? const Color(0xFF438267)
                                : const Color(0xFFC47921),
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => TreatmentRecordHistoryDetailPage(record: record),
                              ),
                            ),
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

  Future<void> _selectTeacher() async {
    final result = await showTeacherFilterSheet(
      context,
      selectedTeacher: selectedTeacher,
      teachers: const ['전체 선생님', '한가람', '서유나', '김유진'],
    );
    if (result != null && mounted) {
      setState(() => selectedTeacher = result);
    }
  }

  bool _sameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
