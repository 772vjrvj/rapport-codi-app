class TreatmentRecordHistoryUi {
  final String id;
  final DateTime startAt;
  final DateTime endAt;
  final String memberName;
  final String programName;
  final String teacherName;
  final String teacherRole;
  final String status;
  final String summary;
  final String counselContent;
  final String recordContent;
  final String specialNote;
  final int attachmentCount;

  const TreatmentRecordHistoryUi({
    required this.id,
    required this.startAt,
    required this.endAt,
    required this.memberName,
    required this.programName,
    required this.teacherName,
    required this.teacherRole,
    required this.status,
    required this.summary,
    this.counselContent = '',
    this.recordContent = '',
    this.specialNote = '',
    this.attachmentCount = 0,
  });
}

class ConsultationRecordHistoryUi {
  final String id;
  final DateTime startAt;
  final DateTime endAt;
  final String memberName;
  final String consultationType;
  final String teacherName;
  final String teacherRole;
  final String status;
  final String summary;
  final String content;
  final String memo;
  final int attachmentCount;

  const ConsultationRecordHistoryUi({
    required this.id,
    required this.startAt,
    required this.endAt,
    required this.memberName,
    required this.consultationType,
    required this.teacherName,
    required this.teacherRole,
    required this.status,
    required this.summary,
    this.content = '',
    this.memo = '',
    this.attachmentCount = 0,
  });
}

String recordDateLabel(DateTime value) {
  const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
  final y = value.year.toString().padLeft(4, '0');
  final m = value.month.toString().padLeft(2, '0');
  final d = value.day.toString().padLeft(2, '0');
  return '$y-$m-$d (${weekdays[value.weekday - 1]})';
}

String recordTimeLabel(DateTime value) {
  final h = value.hour.toString().padLeft(2, '0');
  final m = value.minute.toString().padLeft(2, '0');
  return '$h:$m';
}
