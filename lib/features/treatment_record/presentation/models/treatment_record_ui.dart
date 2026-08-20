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
