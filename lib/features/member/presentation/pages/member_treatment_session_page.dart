import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../treatment_record/presentation/models/treatment_record_ui.dart';
import '../../../treatment_record/presentation/pages/treatment_record_history_detail_page.dart';
import '../models/member_ui.dart';

/// 선택한 치료 프로그램의 회기 목록입니다.
/// TODO(API): 실제 일정/회기 API 응답으로 교체합니다.
class MemberTreatmentSessionPage extends StatelessWidget {
  final MemberUi member;
  final String programName;
  final String teacherName;
  final String period;

  const MemberTreatmentSessionPage({
    super.key,
    required this.member,
    required this.programName,
    required this.teacherName,
    required this.period,
  });

  @override
  Widget build(BuildContext context) {
    final records = _records();

    return Scaffold(
      appBar: AppBar(title: const Text('치료 현황')),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 17),
              decoration: const BoxDecoration(
                color: AppColors.primary50,
                border: Border(bottom: BorderSide(color: AppColors.primary200)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${member.name} (${member.gender})',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textStrong,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    programName,
                    style: const TextStyle(fontSize: 12.5, color: AppColors.textBody),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '기간 · $period',
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 28),
                itemCount: records.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final record = records[index];
                  return Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => TreatmentRecordHistoryDetailPage(record: record),
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '${_date(record.startAt)}  ${_time(record.startAt)} ~ ${_time(record.endAt)}',
                                    style: const TextStyle(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.textStrong,
                                    ),
                                  ),
                                ),
                                Text(
                                  record.status,
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w900,
                                    color: record.status == '취소'
                                        ? const Color(0xFFC47921)
                                        : AppColors.primaryDark,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 7),
                            Text(
                              teacherName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 11.5, color: AppColors.textBody),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              record.summary.isEmpty ? '등록된 기록 내용이 없습니다.' : record.summary,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 11.5, height: 1.45, color: AppColors.textMuted),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<TreatmentRecordHistoryUi> _records() => [
        TreatmentRecordHistoryUi(
          id: 'MTR-001',
          startAt: DateTime(2025, 5, 19, 15, 0),
          endAt: DateTime(2025, 5, 19, 15, 40),
          memberName: member.name,
          programName: programName,
          teacherName: _teacherNameOnly(),
          teacherRole: _teacherRoleOnly(),
          status: '취소',
          summary: '등록된 기록 내용이 없습니다.',
        ),
        TreatmentRecordHistoryUi(
          id: 'MTR-002',
          startAt: DateTime(2025, 5, 26, 15, 0),
          endAt: DateTime(2025, 5, 26, 15, 40),
          memberName: member.name,
          programName: programName,
          teacherName: _teacherNameOnly(),
          teacherRole: _teacherRoleOnly(),
          status: '완료',
          summary: '놀이를 통해 라포를 형성하고 기본 감정어휘를 연습했습니다.',
          recordContent: '아동은 치료자와 첫 만남에서 놀이를 통해 라포를 형성하였으며, 갈등상황에서 사용할 수 있는 기본 감정어휘(속상해요, 화나요)를 도입하였다. 동생이 장난감을 가져갔을 때 “내가 하고 있었어”라고 말로 표현하는 연습을 진행하며 요구를 문장으로 말하도록 촉진하였다.',
        ),
        TreatmentRecordHistoryUi(
          id: 'MTR-003',
          startAt: DateTime(2025, 6, 2, 15, 0),
          endAt: DateTime(2025, 6, 2, 15, 40),
          memberName: member.name,
          programName: programName,
          teacherName: _teacherNameOnly(),
          teacherRole: _teacherRoleOnly(),
          status: '완료',
          summary: '상황을 말로 설명하는 연습과 어휘증진 활동을 진행했습니다.',
          recordContent: '또래가 먼저 놀이에 끼어들었을 때 울거나 손으로 막는 대신 지금 내가 하고 있어라고 말로 상황을 설명하는 연습 후, 어휘증진 활동을 진행하였다.',
        ),
        TreatmentRecordHistoryUi(
          id: 'MTR-004',
          startAt: DateTime(2025, 6, 16, 15, 0),
          endAt: DateTime(2025, 6, 16, 15, 40),
          memberName: member.name,
          programName: programName,
          teacherName: _teacherNameOnly(),
          teacherRole: _teacherRoleOnly(),
          status: '완료',
          summary: '갈등 상황에서 행동 대신 말로 표현해보기 연습을 진행했습니다.',
          recordContent: '놀이 중 블록이 무너지며 갈등이 발생했을 때 행동 대신 말로 표현해보기 연습 후, 그림과 어울리는 어휘 고르기 및 이야기 확장하기 활동하였다.',
        ),
      ];

  String _teacherNameOnly() => teacherName.split('/').first.trim();
  String _teacherRoleOnly() => teacherName.contains('/') ? teacherName.split('/').skip(1).join('/').trim() : '';

  static String _date(DateTime value) {
    final m = value.month.toString().padLeft(2, '0');
    final d = value.day.toString().padLeft(2, '0');
    const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    return '${value.year}-$m-$d (${weekdays[value.weekday - 1]})';
  }

  static String _time(DateTime value) {
    final h = value.hour.toString().padLeft(2, '0');
    final m = value.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
