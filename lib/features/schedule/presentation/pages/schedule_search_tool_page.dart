import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../models/schedule_search_filter.dart';
import '../models/schedule_ui_models.dart';
import 'member_select_page.dart';
import 'program_select_page.dart';

class ScheduleSearchToolPage extends StatefulWidget {
  final ScheduleSearchFilter initial;

  const ScheduleSearchToolPage({
    super.key,
    required this.initial,
  });

  @override
  State<ScheduleSearchToolPage> createState() => _ScheduleSearchToolPageState();
}

class _ScheduleSearchToolPageState extends State<ScheduleSearchToolPage> {
  late Set<String> teacherNames;
  late Set<ScheduleSearchKind> kinds;
  late bool validOnly;
  MemberUi? member;
  ProgramUi? program;
  bool showAllTeachers = false;

  static const teachers = [
    ('박병준', '대표님', Color(0xFF2FBFAE), false),
    ('김형익', '원장님', Color(0xFFD9E7D6), false),
    ('조민석', '센터장님', Color(0xFFB7C7CF), false),
    ('서유나', '언어재활사-QABA(월,수)', Color(0xFF94F4AE), false),
    ('김예림', '언어재활사(월,화,목)', Color(0xFF81D4A3), false),
    ('한가람', '감통치료사(월-금)', Color(0xFFEFA7C6), false),
    ('정선민', '언어재활사(수,금)', Color(0xFF5DBB73), false),
    ('김유진', '작업치료사', Color(0xFF6C99D9), false),
    ('최민정', '상담사', Color(0xFFE5A35D), false),
    ('윤수희', '언어재활사(월-금)', Colors.black, true),
  ];

  @override
  void initState() {
    super.initState();
    teacherNames = {...widget.initial.teacherNames};
    kinds = {...widget.initial.kinds};
    validOnly = widget.initial.validOnly;
    member = widget.initial.member;
    program = widget.initial.program;
  }

  void _apply() {
    Navigator.pop(
      context,
      ScheduleSearchFilter(
        teacherNames: teacherNames,
        member: member,
        program: program,
        kinds: kinds,
        validOnly: validOnly,
      ),
    );
  }

  void _reset() {
    setState(() {
      teacherNames.clear();
      member = null;
      program = null;
      kinds = {
        ScheduleSearchKind.treatment,
        ScheduleSearchKind.consultation,
        ScheduleSearchKind.other,
        ScheduleSearchKind.centerShared,
      };
      validOnly = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final visibleTeachers = showAllTeachers ? teachers : teachers.take(4).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('검색 도구'),
        actions: [
          TextButton(onPressed: _reset, child: const Text('초기화')),
          TextButton(
            onPressed: _apply,
            child: const Text(
              '적용',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 30),
        children: [
          _Section(
            title: '선생님',
            child: Column(
              children: [
                ...visibleTeachers.map((teacher) {
                  final selected =
                      teacherNames.isEmpty || teacherNames.contains(teacher.$1);
                  return _CheckRow(
                    dotColor: teacher.$3,
                    title: '${teacher.$1} / ${teacher.$2}',
                    selected: selected,
                    trailingLabel: teacher.$4 ? '퇴사' : null,
                    onTap: () => setState(() {
                      // 빈 Set은 '전체 선택'을 뜻합니다.
                      if (teacherNames.isEmpty) {
                        teacherNames.addAll(teachers.map((item) => item.$1));
                        teacherNames.remove(teacher.$1);
                      } else if (selected) {
                        teacherNames.remove(teacher.$1);
                      } else {
                        teacherNames.add(teacher.$1);
                        if (teacherNames.length == teachers.length) {
                          teacherNames.clear();
                        }
                      }
                    }),
                  );
                }),
                TextButton.icon(
                  onPressed: () => setState(
                    () => showAllTeachers = !showAllTeachers,
                  ),
                  icon: Icon(
                    showAllTeachers
                        ? Icons.expand_less_rounded
                        : Icons.expand_more_rounded,
                  ),
                  label: Text(
                    showAllTeachers ? '선생님 접기' : '선생님 전체 보기',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _Section(
            title: '이용자 / 프로그램',
            child: Column(
              children: [
                _SelectRow(
                  title: member == null
                      ? '이용자를 선택하세요.'
                      : '${member!.name} (${member!.gender}, ${member!.birthDate})',
                  selected: member != null,
                  onTap: _selectMember,
                  onClear: member == null
                      ? null
                      : () => setState(() => member = null),
                ),
                const Divider(height: 1),
                _SelectRow(
                  title: program == null
                      ? '프로그램을 선택하세요.'
                      : program!.displayName,
                  selected: program != null,
                  onTap: _selectProgram,
                  onClear: program == null
                      ? null
                      : () => setState(() => program = null),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _Section(
            title: '일정구분',
            child: Column(
              children: [
                _KindRow(
                  label: '치료',
                  color: const Color(0xFF3D9CC4),
                  kind: ScheduleSearchKind.treatment,
                  kinds: kinds,
                  onChanged: _toggleKind,
                ),
                _KindRow(
                  label: '상담/평가',
                  color: const Color(0xFFFF9800),
                  kind: ScheduleSearchKind.consultation,
                  kinds: kinds,
                  onChanged: _toggleKind,
                ),
                _KindRow(
                  label: '기타',
                  color: const Color(0xFF7CB342),
                  kind: ScheduleSearchKind.other,
                  kinds: kinds,
                  onChanged: _toggleKind,
                ),
                _KindRow(
                  label: '센터공유',
                  color: const Color(0xFF8D756A),
                  kind: ScheduleSearchKind.centerShared,
                  kinds: kinds,
                  onChanged: _toggleKind,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: SwitchListTile(
              title: const Text(
                '유효 일정만 보기',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
              ),
              subtitle: const Text(
                '취소/종결/이월 일정 숨김',
                style: TextStyle(fontSize: 11, color: AppColors.textMuted),
              ),
              value: validOnly,
              activeThumbColor: AppColors.primary,
              onChanged: (value) => setState(() => validOnly = value),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleKind(ScheduleSearchKind kind) {
    setState(() {
      if (kinds.contains(kind)) {
        kinds.remove(kind);
      } else {
        kinds.add(kind);
      }
    });
  }

  Future<void> _selectMember() async {
    final result = await Navigator.push<MemberUi>(
      context,
      MaterialPageRoute(builder: (_) => MemberSelectPage(selected: member)),
    );
    if (result != null && mounted) setState(() => member = result);
  }

  Future<void> _selectProgram() async {
    final result = await Navigator.push<ProgramUi>(
      context,
      MaterialPageRoute(builder: (_) => ProgramSelectPage(selected: program)),
    );
    if (result != null && mounted) setState(() => program = result);
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;

  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 9),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: AppColors.primaryDark,
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _CheckRow extends StatelessWidget {
  final Color dotColor;
  final String title;
  final bool selected;
  final String? trailingLabel;
  final VoidCallback onTap;

  const _CheckRow({
    required this.dotColor,
    required this.title,
    required this.selected,
    required this.onTap,
    this.trailingLabel,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
        child: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            if (trailingLabel != null) ...[
              Text(
                trailingLabel!,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.deepOrange,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 10),
            ],
            Icon(
              selected ? Icons.check_circle_rounded : Icons.circle_outlined,
              color: selected ? AppColors.primary : AppColors.border,
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectRow extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  const _SelectRow({
    required this.title,
    required this.selected,
    required this.onTap,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                  color: selected
                      ? AppColors.textStrong
                      : AppColors.textMuted,
                ),
              ),
            ),
            if (onClear != null)
              IconButton(
                onPressed: onClear,
                icon: const Icon(Icons.close_rounded, size: 18),
              )
            else
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textMuted,
              ),
          ],
        ),
      ),
    );
  }
}

class _KindRow extends StatelessWidget {
  final String label;
  final Color color;
  final ScheduleSearchKind kind;
  final Set<ScheduleSearchKind> kinds;
  final ValueChanged<ScheduleSearchKind> onChanged;

  const _KindRow({
    required this.label,
    required this.color,
    required this.kind,
    required this.kinds,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selected = kinds.contains(kind);
    return InkWell(
      onTap: () => onChanged(kind),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
        child: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Icon(
              selected ? Icons.check_circle_rounded : Icons.circle_outlined,
              color: selected ? AppColors.primary : AppColors.border,
            ),
          ],
        ),
      ),
    );
  }
}
