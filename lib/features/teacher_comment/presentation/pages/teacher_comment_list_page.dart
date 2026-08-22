import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../app/widgets/main_app_drawer.dart';
import '../../../../core/widgets/record_list_widgets.dart';
import '../../../schedule/presentation/models/schedule_ui_models.dart';
import '../../../schedule/presentation/pages/member_select_page.dart';
import '../../../schedule/presentation/pages/teacher_select_page.dart';
import 'teacher_comment_page.dart';

class TeacherCommentListPage extends StatefulWidget {
  const TeacherCommentListPage({super.key});

  @override
  State<TeacherCommentListPage> createState() => _TeacherCommentListPageState();
}

class _TeacherCommentListPageState extends State<TeacherCommentListPage> {
  String selectedTeacherName = '박병준';
  String selectedTeacherRole = '대표님';
  String? selectedMemberName;

  final records = <_TeacherCommentUi>[
    _TeacherCommentUi(
      startAt: DateTime(2026, 8, 22, 14, 0),
      endAt: DateTime(2026, 8, 22, 14, 40),
      memberName: '민준',
      programName: '언어치료',
      teacherName: '박병준',
      teacherRole: '대표님',
      comment: '오늘은 그림카드를 보며 문장으로 표현하는 활동을 진행했습니다.',
    ),
    _TeacherCommentUi(
      startAt: DateTime(2026, 8, 20, 16, 0),
      endAt: DateTime(2026, 8, 20, 16, 40),
      memberName: '민준',
      programName: '감각통합',
      teacherName: '김유진',
      teacherRole: '작업치료사',
      comment: '활동 전환이 한결 자연스러웠고 새로운 놀이에도 잘 참여했습니다.',
    ),
    _TeacherCommentUi(
      startAt: DateTime(2026, 8, 17, 14, 0),
      endAt: DateTime(2026, 8, 17, 14, 40),
      memberName: '민준',
      programName: '언어치료',
      teacherName: '박병준',
      teacherRole: '대표님',
      comment: '자발적으로 문장을 이어 말하는 횟수가 늘었습니다.',
    ),
  ];

  List<_TeacherCommentUi> get filteredRecords {
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
      drawer: const MainAppDrawer(selected: AppMenu.teacherComments),
      appBar: AppBar(
        title: const Text(
          '선생님 코멘트',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
        ),
        actions: [
          IconButton(
            tooltip: '이용자 찾기',
            onPressed: _selectMember,
            icon: const Icon(Icons.search_rounded),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
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
                        '조건에 맞는 선생님 코멘트가 없습니다.',
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
                              status: '작성완료',
                              summary: record.comment,
                              accentColor: AppColors.primary,
                              statusBackground: const Color(0xFFEAF7F0),
                              statusColor: const Color(0xFF438267),
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => TeacherCommentPage(
                                    memberName: record.memberName,
                                    programName: record.programName,
                                    teacherName: record.teacherName,
                                    dateText: _dateText(record.startAt),
                                    startTime: _timeText(record.startAt),
                                    endTime: _timeText(record.endAt),
                                  ),
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
      ),
    );
  }

  Future<void> _selectMember() async {
    final result = await Navigator.of(context).push<MemberUi>(
      MaterialPageRoute(builder: (_) => const MemberSelectPage()),
    );

    if (result == null || !mounted) return;
    setState(() => selectedMemberName = result.name);
  }

  Future<void> _selectTeacher() async {
    final result = await Navigator.of(context).push<TeacherUi>(
      MaterialPageRoute(
        builder: (_) => TeacherSelectPage(selectedName: selectedTeacherName),
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

  String _dateText(DateTime value) {
    return '${value.year.toString().padLeft(4, '0')}-'
        '${value.month.toString().padLeft(2, '0')}-'
        '${value.day.toString().padLeft(2, '0')}';
  }

  String _timeText(DateTime value) {
    return '${value.hour.toString().padLeft(2, '0')}:'
        '${value.minute.toString().padLeft(2, '0')}';
  }
}

class _TeacherCommentUi {
  final DateTime startAt;
  final DateTime endAt;
  final String memberName;
  final String programName;
  final String teacherName;
  final String teacherRole;
  final String comment;

  const _TeacherCommentUi({
    required this.startAt,
    required this.endAt,
    required this.memberName,
    required this.programName,
    required this.teacherName,
    required this.teacherRole,
    required this.comment,
  });
}
