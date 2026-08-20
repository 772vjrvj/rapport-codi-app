import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../app/widgets/main_app_drawer.dart';
import '../../../../core/widgets/record_list_widgets.dart';
import '../../../schedule/presentation/models/schedule_ui_models.dart';
import '../../../schedule/presentation/pages/member_select_page.dart';
import '../../../schedule/presentation/pages/teacher_select_page.dart';
import '../models/consultation_record_ui.dart';
import 'consultation_record_history_detail_page.dart';

class ConsultationRecordListPage extends StatefulWidget {
  const ConsultationRecordListPage({super.key});

  @override
  State<ConsultationRecordListPage> createState() => _ConsultationRecordListPageState();
}

class _ConsultationRecordListPageState extends State<ConsultationRecordListPage> {
  final searchController = TextEditingController();
  String query = '';
  String selectedTeacher = '전체 선생님';

  // TODO(API): 추후 Repository에서 받아오는 데이터로 교체합니다.
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
      content: '언어를 계속할지 고민\n감통은 2월까지만 하려 했었다.\n\n언어평가 예약을 안내하고 보호자가 선택하도록 설명함.',
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
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<ConsultationRecordHistoryUi> get filteredRecords {
    final q = query.trim().toLowerCase();
    return records.where((record) {
      final matchesTeacher = selectedTeacher == '전체 선생님' ||
          record.teacherName == selectedTeacher;
      if (!matchesTeacher) return false;
      if (q.isEmpty) return true;
      return record.memberName.toLowerCase().contains(q) ||
          record.consultationType.toLowerCase().contains(q) ||
          record.teacherName.toLowerCase().contains(q) ||
          record.summary.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final items = filteredRecords;

    return Scaffold(
      drawer: const MainAppDrawer(selected: AppMenu.consultationRecords),
      appBar: AppBar(
        title: const Text(
          '상담/평가기록 관리',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
        ),
        actions: [
          // 기록 관리의 돋보기는 항상 이용자 선택 화면을 엽니다.
          IconButton(
            tooltip: '이용자 찾기',
            onPressed: _selectMember,
            icon: const Icon(Icons.search_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          RecordFilterHeader(
            controller: searchController,
            hintText: '이용자, 상담유형, 내용 검색',
            selectedTeacher: selectedTeacher,
            searchBackground: AppColors.consultationSoft,
            onChanged: (value) => setState(() => query = value),
            onMemberSearchTap: _selectMember,
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
                      '조건에 맞는 상담/평가 기록이 없습니다.',
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
                            title: '[${record.memberName}] ${record.consultationType}',
                            teacher: '${record.teacherName} / ${record.teacherRole}',
                            status: record.status,
                            summary: record.summary,
                            accentColor: AppColors.consultation,
                            statusBackground: const Color(0xFFFFF4E7),
                            statusColor: const Color(0xFFC47921),
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ConsultationRecordHistoryDetailPage(record: record),
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

  /// 이용자 선택 화면에서 선택한 이름으로 기록 목록을 필터링합니다.
  Future<void> _selectMember() async {
    final result = await Navigator.of(context).push<MemberUi>(
      MaterialPageRoute(
        builder: (_) => const MemberSelectPage(),
      ),
    );

    if (result == null || !mounted) return;

    searchController.text = result.name;
    setState(() => query = result.name);
  }

  /// 아래에서 올라오는 BottomSheet 대신 기존 선생님 선택 화면을 사용합니다.
  Future<void> _selectTeacher() async {
    final result = await Navigator.of(context).push<TeacherUi>(
      MaterialPageRoute(
        builder: (_) => TeacherSelectPage(
          selectedName: selectedTeacher == '전체 선생님'
              ? null
              : selectedTeacher,
          allowAll: true,
        ),
      ),
    );

    if (result == null || !mounted) return;

    setState(() {
      selectedTeacher = result.id == '__ALL__'
          ? '전체 선생님'
          : result.name;
    });
  }

  bool _sameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
