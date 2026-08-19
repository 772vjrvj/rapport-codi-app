import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../models/schedule_ui_models.dart';

class TeacherSelectPage extends StatefulWidget {
  final TeacherUi? selected;

  const TeacherSelectPage({
    super.key,
    this.selected,
  });

  @override
  State<TeacherSelectPage> createState() => _TeacherSelectPageState();
}

class _TeacherSelectPageState extends State<TeacherSelectPage> {
  final _searchController = TextEditingController();
  String query = '';

  static const teachers = [
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
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = teachers.where((teacher) {
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
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
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
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 18),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 7),
              itemBuilder: (context, index) {
                final teacher = filtered[index];
                final selected = widget.selected?.id == teacher.id;

                return Material(
                  color: Colors.white,
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
                              ? AppColors.primary200
                              : AppColors.border,
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
                              teacher.displayName,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
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
