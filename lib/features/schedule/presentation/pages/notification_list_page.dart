import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../models/schedule_detail_ui.dart';
import 'schedule_case_detail_page.dart';

/// 일정 관련 알림 목록입니다.
/// TODO(API): 추후 서버 알림 API 응답으로 목록을 교체합니다.
class NotificationListPage extends StatelessWidget {
  const NotificationListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = _sampleNotifications;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '알림',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
        ),
      ),
      body: ListView.separated(
        itemCount: notifications.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final item = notifications[index];

          return InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ScheduleCaseDetailPage(data: item.schedule),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 18, 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textStrong,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          item.message,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            height: 1.45,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textBody,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    item.ago,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _NotificationItem {
  final String title;
  final String message;
  final String ago;
  final ScheduleListDetailData schedule;

  const _NotificationItem({
    required this.title,
    required this.message,
    required this.ago,
    required this.schedule,
  });
}

const _sampleNotifications = <_NotificationItem>[
  _NotificationItem(
    title: '[김태양] 일반언어평가',
    message: '최승인님이 [08-10(월) 19:10] 일정의 결과를 등록하였습니다.',
    ago: '3일 전',
    schedule: ScheduleListDetailData(
      kind: ScheduleDetailKind.consultation,
      title: '김태양 · 일반언어평가',
      teacherName: '최승인',
      teacherRole: '언어재활사(월)',
      memberName: '김태양',
      memberInfo: '남 / 2020-04-11 · (모) 010-4571-7822',
      programName: '일반언어평가',
      programInfo: '평가',
      dateText: '2026-08-10 (월)',
      startTime: '19:10',
      endTime: '20:10',
      status: '완료',
      memo: '평가 후 20분 7/27 보강진행',
    ),
  ),
  _NotificationItem(
    title: '[김윤택] 언어치료',
    message: '정선민님이 [08-14(금) 16:40] 일정의 회기기록을 등록하였습니다.',
    ago: '5일 전',
    schedule: ScheduleListDetailData(
      kind: ScheduleDetailKind.treatment,
      title: '김윤택 · 언어치료',
      teacherName: '정선민',
      teacherRole: '언어재활사(수,금)',
      memberName: '김윤택',
      memberInfo: '남 / 2020-08-20',
      programName: '언어 · 언어치료',
      programInfo: '개인',
      dateText: '2026-08-14 (금)',
      startTime: '16:40',
      endTime: '17:20',
      status: '완료',
      memo: '회기기록이 등록되었습니다.',
    ),
  ),
  _NotificationItem(
    title: '[백도현] 초기상담',
    message: '권하영님이 [08-05(수) 11:40] 일정의 결과를 등록하였습니다.',
    ago: '5일 전',
    schedule: ScheduleListDetailData(
      kind: ScheduleDetailKind.consultation,
      title: '백도현 · 초기상담',
      teacherName: '권하영',
      teacherRole: '상담사',
      memberName: '백도현',
      memberInfo: '남 / 2021-03-08',
      programName: '초기상담',
      programInfo: '상담',
      dateText: '2026-08-05 (수)',
      startTime: '11:40',
      endTime: '12:20',
      status: '완료',
      memo: '초기상담 결과가 등록되었습니다.',
    ),
  ),
  _NotificationItem(
    title: '[이서준] 초기상담',
    message: '권하영님이 [03-31(화) 11:30] 일정의 결과를 등록하였습니다.',
    ago: '5일 전',
    schedule: ScheduleListDetailData(
      kind: ScheduleDetailKind.consultation,
      title: '이서준 · 초기상담',
      teacherName: '권하영',
      teacherRole: '상담사',
      memberName: '이서준',
      memberInfo: '남 / 2020-11-12',
      programName: '초기상담',
      programInfo: '상담',
      dateText: '2026-03-31 (화)',
      startTime: '11:30',
      endTime: '12:10',
      status: '완료',
      memo: '초기상담 결과가 등록되었습니다.',
    ),
  ),
  _NotificationItem(
    title: '[김윤택] ♡영유아검진♡',
    message: '권하영님이 [08-20(목) 16:40] 일정을 변경하였습니다.',
    ago: '5일 전',
    schedule: ScheduleListDetailData(
      kind: ScheduleDetailKind.treatment,
      title: '김윤택 · 영유아검진',
      teacherName: '권하영',
      teacherRole: '치료사',
      memberName: '김윤택',
      memberInfo: '남 / 2020-08-20',
      programName: '영유아검진',
      programInfo: '개인',
      dateText: '2026-08-20 (목)',
      startTime: '16:40',
      endTime: '17:20',
      status: '예정',
      memo: '일정이 변경되었습니다.',
    ),
  ),
];
