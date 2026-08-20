import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../models/schedule_ui_models.dart';

class TeacherSelectPage extends StatefulWidget {
  final TeacherUi? selected;
  final String? selectedName;

  const TeacherSelectPage({
    super.key,
    this.selected,
    this.selectedName,
  });

  @override
  State<TeacherSelectPage> createState() => _TeacherSelectPageState();
}

class _TeacherSelectPageState extends State<TeacherSelectPage> {
  final _searchController = TextEditingController();
  String query = '';

  // 기본은 퇴사자를 숨깁니다.
  bool hideRetired = true;

  // TODO(API): 추후 서버에서 받은 선생님 목록으로 교체합니다.
  static const teachers = [
    TeacherUi(
      id: 'ALL',
      name: '전체',
      role: '',
      color: Color(0xFFB7C7CF),
    ),
    TeacherUi(
      id: 'T01',
      name: '박병준',
      role: '대표님',
      color: Color(0xFF2FBFAE),
    ),
    TeacherUi(
      id: 'T02',
      name: '김예림',
      role: '언어재활사(월,화,목)',
      color: Color(0xFF81D4A3),
    ),
    TeacherUi(
      id: 'T03',
      name: '김형익',
      role: '원장님',
      color: Color(0xFFD9E7D6),
    ),
    TeacherUi(
      id: 'T04',
      name: '박은지',
      role: '감통치료사(월)',
      color: Color(0xFFF7CDE4),
      retired: true,
    ),
    TeacherUi(
      id: 'T05',
      name: '서유나',
      role: '언어재활사-QABA(월,수)',
      color: Color(0xFF94F4AE),
    ),
    TeacherUi(
      id: 'T06',
      name: '용소연',
      role: '놀이치료사(화,수,목,금)',
      color: Color(0xFFF6DF79),
    ),
    TeacherUi(
      id: 'T07',
      name: '이예진',
      role: '감통치료사(월,수,금)',
      color: Color(0xFFED80AB),
    ),
    TeacherUi(
      id: 'T08',
      name: '정선민',
      role: '언어재활사(수,금)',
      color: Color(0xFF5DBB73),
    ),
    TeacherUi(
      id: 'T09',
      name: '조민석',
      role: '센터장님',
      color: Color(0xFFB7C7CF),
    ),
    TeacherUi(
      id: 'T10',
      name: '한가람',
      role: '감통치료사',
      color: Color(0xFFEFA7C6),
    ),
    TeacherUi(
      id: 'T11',
      name: '김유진',
      role: '작업치료사',
      color: Color(0xFF6C99D9),
    ),
    TeacherUi(
      id: 'T12',
      name: '최민정',
      role: '상담사',
      color: Color(0xFFE5A35D),
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedName = widget.selected?.name ??
        widget.selectedName ??
        '박병준'; // TODO(AUTH): 로그인 사용자 이름으로 교체

    final filtered = teachers.where((teacher) {
      if (hideRetired && teacher.retired) return false;

      final q = query.trim().toLowerCase();
      if (q.isEmpty) return true;

      return teacher.name.toLowerCase().contains(q) ||
          teacher.role.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '선생님 선택',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => query = value),
              decoration: InputDecoration(
                hintText: '이름 또는 직함을 검색하세요',
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
              ),
            ),
          ),

          // As-Is 화면에 있던 퇴사자 감추기 옵션입니다.
          Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            padding: const EdgeInsets.only(left: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                '퇴사자 감추기',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textStrong,
                ),
              ),
              value: hideRetired,
              activeThumbColor: AppColors.primary,
              onChanged: (value) => setState(() => hideRetired = value),
            ),
          ),

          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 18),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 7),
              itemBuilder: (context, index) {
                final teacher = filtered[index];
                final selected = teacher.name == selectedName;

                return Material(
                  color: selected ? AppColors.primary50 : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => Navigator.pop(context, teacher),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 15,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: selected
                              ? AppColors.primary
                              : AppColors.border,
                          width: selected ? 1.4 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: teacher.color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              teacher.id == 'ALL' ? '전체' : teacher.displayName,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: selected
                                    ? FontWeight.w900
                                    : FontWeight.w800,
                                color: AppColors.textStrong,
                              ),
                            ),
                          ),
                          if (teacher.retired)
                            const Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: Text(
                                '퇴사',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.deepOrange,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          Icon(
                            selected
                                ? Icons.check_circle_rounded
                                : Icons.chevron_right_rounded,
                            color: selected
                                ? AppColors.primary
                                : AppColors.textMuted,
                          ),
                        ],
                      ),
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
}
