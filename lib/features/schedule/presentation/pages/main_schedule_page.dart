import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../widgets/main_app_drawer.dart';
import '../widgets/schedule_type_sheet.dart';
import 'schedule_case_detail_page.dart';

class MainSchedulePage extends StatefulWidget {
  const MainSchedulePage({super.key});

  @override
  State<MainSchedulePage> createState() => _MainSchedulePageState();
}

class _MainSchedulePageState extends State<MainSchedulePage>
    with TickerProviderStateMixin {
  bool calendarExpanded = true;

  int year = 2026;
  int month = 8;
  int selectedDay = 19;

  static const List<String> days = [
    '', '', '', '', '', '', '1',
    '2', '3', '4', '5', '6', '7', '8',
    '9', '10', '11', '12', '13', '14', '15',
    '16', '17', '18', '19', '20', '21', '22',
    '23', '24', '25', '26', '27', '28', '29',
    '30', '31', '', '', '', '', '',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MainAppDrawer(),
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: const Icon(Icons.menu_rounded),
          ),
        ),
        title: InkWell(
          onTap: _openYearMonthPicker,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$year년 $month월',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textStrong,
                  ),
                ),
                const SizedBox(width: 2),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 20,
                  color: AppColors.textBody,
                ),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Badge(
              smallSize: 7,
              backgroundColor: Color(0xFFE96A77),
              child: Icon(Icons.notifications_none_rounded),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search_rounded),
          ),
          const SizedBox(width: 2),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            AnimatedSize(
              duration: const Duration(milliseconds: 320),
              curve: Curves.easeInOutCubic,
              alignment: Alignment.topCenter,
              child: calendarExpanded
                  ? _calendar()
                  : const SizedBox(width: double.infinity),
            ),
            _summary(),
            Expanded(child: _scheduleList()),
            _bottomBar(),
            _sampleAd(),
          ],
        ),
      ),
    );
  }

  Widget _calendar() {
    const scheduleDays = <int>{
      3, 5, 7, 11, 12, 17, 18, 19, 20, 21, 25, 27, 29
    };

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 7),
      child: Column(
        children: [
          const Row(
            children: [
              _Weekday('일', Color(0xFFE16B75)),
              _Weekday('월', AppColors.textMuted),
              _Weekday('화', AppColors.textMuted),
              _Weekday('수', AppColors.textMuted),
              _Weekday('목', AppColors.textMuted),
              _Weekday('금', AppColors.textMuted),
              _Weekday('토', AppColors.primaryDark),
            ],
          ),
          const SizedBox(height: 5),
          SizedBox(
            height: 218,
            child: GridView.builder(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: days.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1.23,
              ),
              itemBuilder: (context, index) {
                final value = days[index];
                if (value.isEmpty) {
                  return const SizedBox.shrink();
                }

                final day = int.parse(value);
                final selected = day == selectedDay;

                Color textColor = AppColors.textBody;
                if (index % 7 == 0) {
                  textColor = const Color(0xFFE16B75);
                } else if (index % 7 == 6) {
                  textColor = AppColors.primaryDark;
                }

                return InkWell(
                  borderRadius: BorderRadius.circular(99),
                  onTap: () => setState(() => selectedDay = day),
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        if (selected)
                          const SizedBox(
                            width: 33,
                            height: 33,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        Text(
                          value,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight:
                                selected ? FontWeight.w900 : FontWeight.w700,
                            color: selected ? Colors.white : textColor,
                          ),
                        ),
                        if (scheduleDays.contains(day) && !selected)
                          const Positioned(
                            bottom: -6,
                            child: SizedBox(
                              width: 4,
                              height: 4,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _summary() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeInOutCubic,
      margin: const EdgeInsets.fromLTRB(10, 7, 10, 7),
      height: 48,
      padding: const EdgeInsets.only(left: 12, right: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.primary200.withValues(alpha: 0.85),
        ),
      ),
      child: Row(
        children: [
          Text(
            '$year-${month.toString().padLeft(2, '0')}-${selectedDay.toString().padLeft(2, '0')} (수)',
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w900,
              color: AppColors.textStrong,
            ),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              child: Row(
                children: [
                  _StatBadge(
                    label: '치료',
                    count: 30,
                    background: Color(0xFFE8F8F4),
                    foreground: Color(0xFF168777),
                    border: Color(0xFFBCE9DF),
                  ),
                  SizedBox(width: 5),
                  _StatBadge(
                    label: '상담/평가',
                    count: 4,
                    background: Color(0xFFEEF3FF),
                    foreground: Color(0xFF5577C8),
                    border: Color(0xFFD7E1FA),
                  ),
                  SizedBox(width: 5),
                  _StatBadge(
                    label: '기타',
                    count: 14,
                    background: Color(0xFFFFF4E8),
                    foreground: Color(0xFFC07B32),
                    border: Color(0xFFF3DFC7),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 3),
          SizedBox(
            width: 36,
            height: 36,
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                setState(() {
                  calendarExpanded = !calendarExpanded;
                });
              },
              style: IconButton.styleFrom(
                backgroundColor: AppColors.primary50,
                foregroundColor: AppColors.primaryDark,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
              icon: AnimatedRotation(
                turns: calendarExpanded ? 0 : 0.5,
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeInOut,
                child: const Icon(
                  Icons.keyboard_arrow_up_rounded,
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _scheduleList() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 1, 12, 14),
      physics: const BouncingScrollPhysics(),
      children: [
        _ScheduleItem(
          '10:00',
          '10:40',
          '김루아',
          '언어치료',
          '서유나',
          '언어재활사',
          '완료',
          const Color(0xFF55BFAE),
          onTap: () => _openScheduleDetail(
            const ScheduleListDetailData(
              kind: ScheduleDetailKind.treatment,
              title: '김루아 · 언어치료',
              teacherName: '서유나',
              teacherRole: '언어재활사',
              memberName: '김루아',
              memberInfo: '여 / 2020-04-15 · (모) 010-1234-5678',
              programName: '언어 · 언어치료',
              programInfo: '개인, 기관',
              dateText: '2026-08-19 (수)',
              startTime: '10:00',
              endTime: '10:40',
              status: '완료',
              repeatText: '수 · 1개월',
              memo: '발음 및 표현언어 중심으로 진행했습니다.',
            ),
          ),
        ),
        _ScheduleItem(
          '11:00',
          '11:50',
          '박도윤',
          '감각통합',
          '김유진',
          '작업치료사',
          '예정',
          const Color(0xFF6C99D9),
          onTap: () => _openScheduleDetail(
            const ScheduleListDetailData(
              kind: ScheduleDetailKind.treatment,
              title: '박도윤 · 감각통합',
              teacherName: '김유진',
              teacherRole: '작업치료사',
              memberName: '박도윤',
              memberInfo: '남 / 2019-09-26 · (모) 010-5961-0500',
              programName: '감각통합 · 감각통합',
              programInfo: '개인',
              dateText: '2026-08-19 (수)',
              startTime: '11:00',
              endTime: '11:50',
              status: '예정',
              repeatText: '반복 없음',
            ),
          ),
        ),
        _ScheduleItem(
          '13:30',
          '14:10',
          '이서아',
          '상담/평가',
          '최민정',
          '상담사',
          '예정',
          const Color(0xFFE5A35D),
          onTap: () => _openScheduleDetail(
            const ScheduleListDetailData(
              kind: ScheduleDetailKind.consultation,
              title: '이서아 · 초기상담',
              teacherName: '최민정',
              teacherRole: '상담사',
              memberName: '이서아',
              memberInfo: '여 / 2021-02-11',
              programName: '초기상담',
              programInfo: '상담',
              dateText: '2026-08-19 (수)',
              startTime: '13:30',
              endTime: '14:10',
              status: '예정',
              quickInput: false,
              memo: '보호자 초기 상담 및 발달 이력 확인 예정',
            ),
          ),
        ),
        _ScheduleItem(
          '15:00',
          '15:40',
          '센터회의',
          '기타',
          '박병준',
          '대표님',
          '예정',
          const Color(0xFF9B83D7),
          onTap: () => _openScheduleDetail(
            const ScheduleListDetailData(
              kind: ScheduleDetailKind.other,
              title: '센터회의',
              teacherName: '박병준',
              teacherRole: '대표님',
              dateText: '2026-08-19 (수)',
              startTime: '15:00',
              endTime: '15:40',
              status: '예정',
              repeatText: '반복 없음',
              centerShared: true,
              memo: '주간 센터 운영 회의',
            ),
          ),
        ),
        _ScheduleItem(
          '16:30',
          '16:30',
          '8월 센터 안내',
          '공지',
          '박병준',
          '대표님',
          '공지',
          const Color(0xFFE96A77),
          onTap: () => _openScheduleDetail(
            const ScheduleListDetailData(
              kind: ScheduleDetailKind.notice,
              title: '8월 센터 운영 안내',
              teacherName: '박병준',
              teacherRole: '대표님',
              dateText: '2026-08-19 (수)',
              startTime: '16:30',
              endTime: '16:30',
              noticeContent:
                  '8월 센터 운영 및 일정 관련 안내입니다.\n세부 내용은 추후 공지 API와 연결합니다.',
            ),
          ),
        ),
      ],
    );
  }

  void _openScheduleDetail(ScheduleListDetailData data) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ScheduleCaseDetailPage(data: data),
      ),
    );
  }

  Widget _bottomBar() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppColors.border),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 44),
          const Spacer(),
          TextButton.icon(
            onPressed: () {},
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primaryDark,
            ),
            icon: const Icon(Icons.today_outlined, size: 19),
            label: const Text(
              '오늘',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const Spacer(),
          SizedBox(
            width: 44,
            height: 44,
            child: FilledButton(
              onPressed: () => openScheduleTypeSheet(context),
              style: FilledButton.styleFrom(
                padding: EdgeInsets.zero,
                elevation: 0,
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
              child: const Icon(Icons.add_rounded),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sampleAd() {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: const BoxDecoration(
        color: Color(0xFFF0F5F4),
        border: Border(
          top: BorderSide(color: AppColors.border),
        ),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.favorite_outline,
            color: AppColors.primaryDark,
            size: 20,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              '우리 아이의 오늘을 함께 기록하세요   ·   광고',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.textStrong,
              ),
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textMuted,
          ),
        ],
      ),
    );
  }

  Future<void> _openYearMonthPicker() async {
    int tempYear = year;
    int tempMonth = month;

    final years = List<int>.generate(41, (index) => 2006 + index);
    final initialYearIndex = years.indexOf(year).clamp(0, years.length - 1);
    final initialMonthIndex = (month - 1).clamp(0, 11);

    final yearController = FixedExtentScrollController(
      initialItem: initialYearIndex,
    );
    final monthController = FixedExtentScrollController(
      initialItem: initialMonthIndex,
    );

    final result = await showDialog<List<int>>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.34),
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 34),
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 360),
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Center(
                  child: Text(
                    '연 / 월 선택',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textStrong,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  height: 220,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        left: 8,
                        right: 8,
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppColors.primary200,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ListWheelScrollView.useDelegate(
                              controller: yearController,
                              itemExtent: 44,
                              diameterRatio: 1.8,
                              perspective: 0.002,
                              physics: const FixedExtentScrollPhysics(),
                              onSelectedItemChanged: (index) {
                                tempYear = years[index];
                              },
                              childDelegate: ListWheelChildBuilderDelegate(
                                childCount: years.length,
                                builder: (context, index) {
                                  if (index == null) return null;
                                  return Center(
                                    child: Text(
                                      '${years[index]}년',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.textStrong,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 150,
                            color: AppColors.border,
                          ),
                          Expanded(
                            child: ListWheelScrollView.useDelegate(
                              controller: monthController,
                              itemExtent: 44,
                              diameterRatio: 1.8,
                              perspective: 0.002,
                              physics: const FixedExtentScrollPhysics(),
                              onSelectedItemChanged: (index) {
                                tempMonth = index + 1;
                              },
                              childDelegate: ListWheelChildBuilderDelegate(
                                childCount: 12,
                                builder: (context, index) {
                                  if (index == null) return null;
                                  return Center(
                                    child: Text(
                                      '${index + 1}월',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.textStrong,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.pop(
                        dialogContext,
                        <int>[tempYear, tempMonth],
                      );
                    },
                    style: FilledButton.styleFrom(
                      elevation: 0,
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11),
                      ),
                    ),
                    child: const Text(
                      '선택',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    yearController.dispose();
    monthController.dispose();

    if (result != null) {
      setState(() {
        year = result[0];
        month = result[1];
      });
    }
  }
}

class _Weekday extends StatelessWidget {
  final String text;
  final Color color;

  const _Weekday(this.text, this.color);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String label;
  final int count;
  final Color background;
  final Color foreground;
  final Color border;

  const _StatBadge({
    required this.label,
    required this.count,
    required this.background,
    required this.foreground,
    required this.border,
  });

  @override
  Widget build(BuildContext context) {
    if (count <= 0) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: border),
      ),
      child: Text(
        '$label $count',
        maxLines: 1,
        style: TextStyle(
          fontSize: 10,
          height: 1,
          fontWeight: FontWeight.w900,
          color: foreground,
        ),
      ),
    );
  }
}

class _ScheduleItem extends StatelessWidget {
  final String startTime;
  final String endTime;
  final String memberName;
  final String programName;
  final String teacherName;
  final String teacherRole;
  final String status;
  final Color teacherColor;
  final VoidCallback? onTap;

  const _ScheduleItem(
    this.startTime,
    this.endTime,
    this.memberName,
    this.programName,
    this.teacherName,
    this.teacherRole,
    this.status,
    this.teacherColor, {
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: Container(
          height: 69,
          margin: const EdgeInsets.only(bottom: 7),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 48,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      startTime,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textStrong,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      endTime,
                      style: const TextStyle(
                        fontSize: 10.5,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 4,
                height: 43,
                margin: const EdgeInsets.only(right: 11),
                decoration: BoxDecoration(
                  color: teacherColor,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$memberName  $programName',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textStrong,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '$teacherName / $teacherRole',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textBody,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: status == '완료'
                                ? const Color(0xFFEAF7F0)
                                : status == '공지'
                                    ? const Color(0xFFFFEFF1)
                                    : AppColors.primary50,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              color: status == '완료'
                                  ? const Color(0xFF438267)
                                  : status == '공지'
                                      ? const Color(0xFFC84D5D)
                                      : AppColors.primaryDark,
                            ),
                          ),
                        ),
                        if (onTap != null) ...[
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.chevron_right_rounded,
                            size: 18,
                            color: AppColors.textMuted,
                          ),
                        ],
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
