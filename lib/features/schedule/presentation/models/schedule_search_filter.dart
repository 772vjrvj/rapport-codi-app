import 'schedule_ui_models.dart';

enum ScheduleSearchKind {
  treatment,
  consultation,
  other,
  centerShared,
}

class ScheduleSearchFilter {
  final Set<String> teacherNames;
  final MemberUi? member;
  final ProgramUi? program;
  final Set<ScheduleSearchKind> kinds;
  final bool validOnly;

  const ScheduleSearchFilter({
    this.teacherNames = const {},
    this.member,
    this.program,
    this.kinds = const {
      ScheduleSearchKind.treatment,
      ScheduleSearchKind.consultation,
      ScheduleSearchKind.other,
      ScheduleSearchKind.centerShared,
    },
    this.validOnly = false,
  });

  bool get isDefault =>
      teacherNames.isEmpty &&
      member == null &&
      program == null &&
      kinds.length == 4 &&
      !validOnly;
}
