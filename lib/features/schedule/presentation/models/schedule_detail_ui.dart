enum ScheduleDetailKind {
  treatment,
  consultation,
  other,
  notice,
}

class ScheduleListDetailData {
  final ScheduleDetailKind kind;
  final String title;
  final String teacherName;
  final String teacherRole;
  final String memberName;
  final String memberInfo;
  final String programName;
  final String programInfo;
  final String dateText;
  final String startTime;
  final String endTime;
  final String status;
  final String memo;
  final String repeatText;
  final bool allDay;
  final bool centerShared;
  final bool quickInput;
  final String noticeContent;

  const ScheduleListDetailData({
    required this.kind,
    required this.title,
    required this.teacherName,
    required this.teacherRole,
    required this.dateText,
    required this.startTime,
    required this.endTime,
    this.memberName = '',
    this.memberInfo = '',
    this.programName = '',
    this.programInfo = '',
    this.status = '예정',
    this.memo = '',
    this.repeatText = '반복 없음',
    this.allDay = false,
    this.centerShared = false,
    this.quickInput = false,
    this.noticeContent = '',
  });

  ScheduleListDetailData copyWith({
    String? title,
    String? teacherName,
    String? teacherRole,
    String? memberName,
    String? memberInfo,
    String? programName,
    String? programInfo,
    String? dateText,
    String? startTime,
    String? endTime,
    String? memo,
    String? repeatText,
    bool? allDay,
    bool? centerShared,
    bool? quickInput,
  }) {
    return ScheduleListDetailData(
      kind: kind,
      title: title ?? this.title,
      teacherName: teacherName ?? this.teacherName,
      teacherRole: teacherRole ?? this.teacherRole,
      memberName: memberName ?? this.memberName,
      memberInfo: memberInfo ?? this.memberInfo,
      programName: programName ?? this.programName,
      programInfo: programInfo ?? this.programInfo,
      dateText: dateText ?? this.dateText,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status,
      memo: memo ?? this.memo,
      repeatText: repeatText ?? this.repeatText,
      allDay: allDay ?? this.allDay,
      centerShared: centerShared ?? this.centerShared,
      quickInput: quickInput ?? this.quickInput,
      noticeContent: noticeContent,
    );
  }

}
