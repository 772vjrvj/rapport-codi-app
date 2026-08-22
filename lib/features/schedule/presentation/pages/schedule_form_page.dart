import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../models/schedule_ui_models.dart';
import '../widgets/schedule_ui_components.dart';
import 'member_select_page.dart';
import 'program_select_page.dart';
import 'repeat_setting_page.dart';
import 'teacher_select_page.dart';

class ScheduleFormPage extends StatefulWidget {
  final ScheduleFormType type;
  final ScheduleFormMode mode;
  final ScheduleDraft? initialData;

  const ScheduleFormPage({
    super.key,
    required this.type,
    this.mode = ScheduleFormMode.create,
    this.initialData,
  });

  @override
  State<ScheduleFormPage> createState() => _ScheduleFormPageState();
}

class _ScheduleFormPageState extends State<ScheduleFormPage> {
  TeacherUi? teacher;
  MemberUi? member;
  ProgramUi? program;

  late DateTime start;
  late DateTime end;

  String repeatText = '반복 없음';
  bool quickInput = true;
  bool centerShared = false;
  bool allDay = false;

  final memoController = TextEditingController();
  final titleController = TextEditingController();
  final reasonController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final initial = widget.initialData;
    final now = DateTime.now();

    teacher = initial?.teacher ??
        const TeacherUi(
          id: 'T01',
          name: '박병준',
          role: '대표님',
          color: AppColors.primary,
        );

    member = initial?.member;
    program = initial?.program;

    start = initial?.start ??
        DateTime(now.year, now.month, now.day, now.hour, 0);

    end = initial?.end ?? start.add(
      Duration(
        minutes: widget.type == ScheduleFormType.treatment ? 40 : 60,
      ),
    );

    repeatText = initial?.repeatText ?? '반복 없음';
    quickInput = initial?.quickInput ?? true;
    centerShared = initial?.centerShared ?? false;
    allDay = initial?.allDay ?? false;

    memoController.text = initial?.memo ?? '';
    titleController.text = initial?.title ?? '';
    reasonController.text = initial?.consultationReason ?? '';
  }

  @override
  void dispose() {
    memoController.dispose();
    titleController.dispose();
    reasonController.dispose();
    super.dispose();
  }

  String get pageTitle {
    final suffix = widget.mode == ScheduleFormMode.edit ? '수정' : '추가';
    switch (widget.type) {
      case ScheduleFormType.treatment:
        return '치료 $suffix';
      case ScheduleFormType.consultation:
        return '상담/평가 $suffix';
      case ScheduleFormType.other:
        return '기타 $suffix';
    }
  }

  Future<void> _selectTeacher() async {
    final result = await Navigator.push<TeacherUi>(
      context,
      MaterialPageRoute(
        builder: (_) => TeacherSelectPage(selected: teacher),
      ),
    );

    if (result != null) setState(() => teacher = result);
  }

  Future<void> _selectMember() async {
    final result = await Navigator.push<MemberUi>(
      context,
      MaterialPageRoute(
        builder: (_) => MemberSelectPage(selected: member),
      ),
    );

    if (result != null) setState(() => member = result);
  }

  Future<void> _selectProgram() async {
    final result = await Navigator.push<ProgramUi>(
      context,
      MaterialPageRoute(
        builder: (_) => ProgramSelectPage(selected: program),
      ),
    );

    if (result != null) setState(() => program = result);
  }

  Future<void> _selectDateAndTime({required bool isStart}) async {
    final target = isStart ? start : end;

    final date = await showDatePicker(
      context: context,
      initialDate: target,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      helpText: isStart ? '시작일 선택' : '종료일 선택',
    );

    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(target),
      helpText: isStart ? '시작시간 선택' : '종료시간 선택',
    );

    if (time == null || !mounted) return;

    final selected = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    setState(() {
      if (isStart) {
        start = selected;

        if (end.isBefore(start)) {
          end = start.add(
            Duration(
              minutes: widget.type == ScheduleFormType.treatment ? 40 : 60,
            ),
          );
        }
      } else {
        end = selected;
      }
    });
  }

  Future<void> _selectRepeat() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => RepeatSettingPage(
          initialValue: repeatText,
        ),
      ),
    );

    if (result != null) setState(() => repeatText = result);
  }

  void _save() {
    final draft = ScheduleDraft(
      type: widget.type,
      teacher: teacher,
      member: member,
      program: program,
      start: start,
      end: end,
      repeatText: repeatText,
      memo: widget.type == ScheduleFormType.treatment
          ? ''
          : memoController.text.trim(),
      title: titleController.text.trim(),
      centerShared: centerShared,
      allDay: allDay,
      quickInput: quickInput,
      consultationReason: reasonController.text.trim(),
    );

    Navigator.pop(context, draft);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          pageTitle,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.only(top: 12, bottom: 96),
          children: [
            if (widget.type == ScheduleFormType.consultation)
              _consultationGuide(),
            _buildBasicSection(),
            _buildScheduleSection(),
            if (widget.type != ScheduleFormType.treatment)
              _buildMemoSection(),
          ],
        ),
      ),
      bottomNavigationBar: SchedulePrimaryButton(
        label: widget.mode == ScheduleFormMode.edit ? '수정 완료' : '저장',
        onPressed: _save,
      ),
    );
  }

  Widget _consultationGuide() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8ED),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFFFD8A0)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline_rounded,
            size: 20,
            color: Color(0xFFE08A1E),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              '추후 기록 연동을 위해 등록된 이용자/프로그램 선택을 권장합니다.',
              style: TextStyle(
                fontSize: 11,
                height: 1.4,
                fontWeight: FontWeight.w700,
                color: Color(0xFF9B641D),
              ),
            ),
          ),
          Switch(
            value: quickInput,
            activeThumbColor: AppColors.primary,
            onChanged: (value) => setState(() => quickInput = value),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicSection() {
    switch (widget.type) {
      case ScheduleFormType.treatment:
        return ScheduleSectionCard(
          title: '기본 정보',
          children: [
            ScheduleFieldTile(
              label: '선생님',
              value: teacher?.displayName ?? '선생님을 선택하세요',
              onTap: _selectTeacher,
            ),
            ScheduleFieldTile(
              label: '이용자',
              value: member?.name ?? '이용자를 선택하세요',
              helper: member == null
                  ? null
                  : '${member!.gender} / ${member!.birthDate}',
              onTap: _selectMember,
            ),
            ScheduleFieldTile(
              label: '프로그램',
              value: program?.displayName ?? '프로그램을 선택하세요',
              helper: program?.serviceType,
              onTap: _selectProgram,
            ),
          ],
        );

      case ScheduleFormType.consultation:
        return ScheduleSectionCard(
          title: '기본 정보',
          children: [
            ScheduleFieldTile(
              label: '선생님',
              value: teacher?.displayName ?? '선생님을 선택하세요',
              onTap: _selectTeacher,
            ),
            ScheduleFieldTile(
              label: '이용자',
              value: member?.name ?? (quickInput ? '빠른 입력' : '이용자 선택'),
              onTap: _selectMember,
            ),
            ScheduleFieldTile(
              label: '프로그램',
              value: program?.displayName ?? (quickInput ? '제목 없음' : '프로그램 선택'),
              onTap: _selectProgram,
            ),
          ],
        );

      case ScheduleFormType.other:
        return ScheduleSectionCard(
          title: '기본 정보',
          children: [
            ScheduleFieldTile(
              label: '센터 공유',
              value: centerShared ? '공유' : '나만 보기',
              trailing: Switch(
                value: centerShared,
                activeThumbColor: AppColors.primary,
                onChanged: (value) => setState(() => centerShared = value),
              ),
            ),
            ScheduleFieldTile(
              label: '선생님',
              value: teacher?.displayName ?? '선생님을 선택하세요',
              onTap: _selectTeacher,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 13, 16, 16),
              child: TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: '제목',
                  hintText: '일정 제목을 입력하세요',
                  filled: true,
                  fillColor: AppColors.primary50.withValues(alpha: 0.45),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                ),
              ),
            ),
          ],
        );
    }
  }

  Widget _buildScheduleSection() {
    return ScheduleSectionCard(
      title: '일정',
      children: [
        if (widget.type == ScheduleFormType.other)
          ScheduleFieldTile(
            label: '종일',
            value: allDay ? '사용' : '미사용',
            trailing: Switch(
              value: allDay,
              activeThumbColor: AppColors.primary,
              onChanged: (value) => setState(() => allDay = value),
            ),
          ),
        ScheduleFieldTile(
          label: '시작',
          value: formatDate(start),
          inlineValue: allDay ? null : formatTime(start),
          onTap: () => _selectDateAndTime(isStart: true),
        ),
        ScheduleFieldTile(
          label: '종료',
          value: formatDate(end),
          inlineValue: allDay ? null : formatTime(end),
          onTap: () => _selectDateAndTime(isStart: false),
        ),
        ScheduleFieldTile(
          label: '반복',
          value: repeatText,
          onTap: _selectRepeat,
        ),
      ],
    );
  }

  Widget _buildMemoSection() {
    final isConsultation = widget.type == ScheduleFormType.consultation;

    return ScheduleSectionCard(
      title: isConsultation ? '상담 사유' : '메모',
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
          child: TextField(
            controller: isConsultation ? reasonController : memoController,
            minLines: 4,
            maxLines: 6,
            decoration: InputDecoration(
              hintText: isConsultation
                  ? '상담/평가 사유를 입력하세요'
                  : '메모를 입력하세요',
              filled: true,
              fillColor: AppColors.primary50.withValues(alpha: 0.35),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: const BorderSide(color: AppColors.border),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
