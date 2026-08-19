import 'package:flutter/material.dart';

enum ScheduleFormType {
  treatment,
  consultation,
  other,
}

enum ScheduleFormMode {
  create,
  edit,
}

class TeacherUi {
  final String id;
  final String name;
  final String role;
  final Color color;
  final bool retired;

  const TeacherUi({
    required this.id,
    required this.name,
    required this.role,
    required this.color,
    this.retired = false,
  });

  String get displayName => '$name / $role';
}

class MemberUi {
  final String id;
  final String name;
  final String gender;
  final String birthDate;
  final String guardianPhone;
  final bool terminated;

  const MemberUi({
    required this.id,
    required this.name,
    required this.gender,
    required this.birthDate,
    required this.guardianPhone,
    this.terminated = false,
  });
}

class ProgramUi {
  final String id;
  final String category;
  final String name;
  final String serviceType;

  const ProgramUi({
    required this.id,
    required this.category,
    required this.name,
    required this.serviceType,
  });

  String get displayName => '$category · $name';
}

class ScheduleDraft {
  final ScheduleFormType type;
  final TeacherUi? teacher;
  final MemberUi? member;
  final ProgramUi? program;
  final DateTime start;
  final DateTime end;
  final String repeatText;
  final String memo;
  final String title;
  final bool centerShared;
  final bool allDay;
  final bool quickInput;
  final String consultationReason;

  const ScheduleDraft({
    required this.type,
    required this.start,
    required this.end,
    this.teacher,
    this.member,
    this.program,
    this.repeatText = '반복 없음',
    this.memo = '',
    this.title = '',
    this.centerShared = false,
    this.allDay = false,
    this.quickInput = true,
    this.consultationReason = '',
  });
}
