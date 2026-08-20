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
