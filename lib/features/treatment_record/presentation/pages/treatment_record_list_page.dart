import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../app/widgets/main_app_drawer.dart';
import '../../../../core/widgets/record_list_widgets.dart';
import '../../../schedule/presentation/models/schedule_ui_models.dart';
import '../../../schedule/presentation/pages/member_select_page.dart';
import '../../../schedule/presentation/pages/teacher_select_page.dart';
import '../models/treatment_record_ui.dart';
import 'treatment_record_history_detail_page.dart';

class TreatmentRecordListPage extends StatefulWidget {
  const TreatmentRecordListPage({super.key});

  @override
  State<TreatmentRecordListPage> createState() => _TreatmentRecordListPageState();
}

class _TreatmentRecordListPageState extends State<TreatmentRecordListPage> {
  // TODO(AUTH): 로그인 API 연결 후 로그인 사용자 정보로 교체합니다.
  String selectedTeacherName = '박병준';
  String selectedTeacherRole = '대표님';
  String? selectedMemberName;

  // TODO(API): 추후 Repository에서 받아오는 데이터로 교체합니다.
  final records = <TreatmentRecordHistoryUi>[
    TreatmentRecordHistoryUi(
      id: 'TR-LOGIN-001',
      startAt: DateTime(2026, 8, 20, 16, 40),
      endAt: DateTime(2026, 8, 20, 17, 20),
      memberName: '김윤택',
      programName: '영유아검진',
      teacherName: '박병준',
      teacherRole: '대표님',
      status: '완료',
      summary: '로그인 사용자 기준 치료기록 샘플입니다.',
      recordContent: '추후 실제 API 응답 데이터로 교체합니다.',
    ),
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


  List<TreatmentRecordHistoryUi> get filteredRecords {
    return records.where((record) {
      final matchesTeacher = selectedTeacherName == '전체' ||
          record.teacherName == selectedTeacherName;
      final matchesMember = selectedMemberName == null ||
          record.memberName == selectedMemberName;
      return matchesTeacher && matchesMember;
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
            selectedTeacher: selectedTeacherName == '전체'
                ? '전체'
                : '$selectedTeacherName / $selectedTeacherRole',
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

  /// 상단 돋보기에서 이용자를 선택하면 해당 이용자의 기록만 보여줍니다.
  Future<void> _selectMember() async {
    final result = await Navigator.of(context).push<MemberUi>(
      MaterialPageRoute(
        builder: (_) => const MemberSelectPage(),
      ),
    );

    if (result == null || !mounted) return;

    setState(() => selectedMemberName = result.name);
  }

  /// 기존 선생님 선택 화면을 그대로 사용합니다.
  Future<void> _selectTeacher() async {
    final result = await Navigator.of(context).push<TeacherUi>(
      MaterialPageRoute(
        builder: (_) => TeacherSelectPage(
          selectedName: selectedTeacherName,
        ),
      ),
    );

    if (result == null || !mounted) return;

    setState(() {
      selectedTeacherName = result.name;
      selectedTeacherRole = result.id == 'ALL' ? '' : result.role;
    });
  }

  bool _sameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
