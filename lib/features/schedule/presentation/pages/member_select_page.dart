import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../models/schedule_ui_models.dart';

class MemberSelectPage extends StatefulWidget {
  final MemberUi? selected;

  const MemberSelectPage({
    super.key,
    this.selected,
  });

  @override
  State<MemberSelectPage> createState() => _MemberSelectPageState();
}

class _MemberSelectPageState extends State<MemberSelectPage> {
  final _searchController = TextEditingController();
  String query = '';

  static const members = [
    MemberUi(
      id: 'M01',
      name: '강도현',
      gender: '남',
      birthDate: '2022-07-20',
      guardianPhone: '(모) 010-5788-8545',
    ),
    MemberUi(
      id: 'M02',
      name: '강시후',
      gender: '남',
      birthDate: '2020-09-29',
      guardianPhone: '(모) 010-8316-8606',
    ),
    MemberUi(
      id: 'M03',
      name: '강지민',
      gender: '남',
      birthDate: '2021-08-17',
      guardianPhone: '(모) 010-9487-1386',
    ),
    MemberUi(
      id: 'M04',
      name: '공도현',
      gender: '남',
      birthDate: '2020-08-12',
      guardianPhone: '(모) 010-5746-8784',
    ),
    MemberUi(
      id: 'M05',
      name: '공미소',
      gender: '여',
      birthDate: '2019-01-11',
      guardianPhone: '(모) 010-5746-8784',
      terminated: true,
    ),
    MemberUi(
      id: 'M06',
      name: '곽로빈',
      gender: '남',
      birthDate: '2020-10-08',
      guardianPhone: '(모) 010-3040-1288',
    ),
    MemberUi(
      id: 'M07',
      name: '구서하',
      gender: '여',
      birthDate: '2024-08-13',
      guardianPhone: '(모) 010-2672-0133',
    ),
    MemberUi(
      id: 'M08',
      name: '권구성',
      gender: '남',
      birthDate: '2019-03-31',
      guardianPhone: '(모) 010-3247-3937',
    ),

    // 기록 관리 화면의 샘플 데이터와 연결 확인용 이용자입니다.
    // TODO(API): 실제 API 연결 후 서버 응답으로 교체합니다.
    MemberUi(
      id: 'M09',
      name: '박시우',
      gender: '남',
      birthDate: '2019-09-26',
      guardianPhone: '(모) 010-5961-0500',
    ),
    MemberUi(
      id: 'M10',
      name: '박지현',
      gender: '여',
      birthDate: '2020-04-15',
      guardianPhone: '(모) 010-1234-5678',
    ),
    MemberUi(
      id: 'M11',
      name: '박도윤',
      gender: '남',
      birthDate: '2019-09-26',
      guardianPhone: '(모) 010-5961-0500',
    ),
    MemberUi(
      id: 'M12',
      name: '서울',
      gender: '남',
      birthDate: '2020-01-01',
      guardianPhone: '(모) 010-0000-0000',
    ),
    MemberUi(
      id: 'M13',
      name: '김채은',
      gender: '여',
      birthDate: '2020-05-10',
      guardianPhone: '(모) 010-0000-0000',
    ),
    MemberUi(
      id: 'M14',
      name: '김단우',
      gender: '남',
      birthDate: '2020-11-12',
      guardianPhone: '(모) 010-0000-0000',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final q = query.trim().toLowerCase();
    final filtered = members.where((member) {
      if (q.isEmpty) return true;
      return member.name.toLowerCase().contains(q) ||
          member.birthDate.contains(q) ||
          member.guardianPhone.contains(q);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '이용자 선택',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              child: TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => query = value),
                decoration: InputDecoration(
                  hintText: '이름, 생년월일 또는 전화번호 검색',
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
                  final member = filtered[index];
                  final selected = widget.selected?.id == member.id;
  
                  return Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () => Navigator.pop(context, member),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(15, 13, 13, 13),
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
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      if (member.terminated) ...[
                                        const Text(
                                          '종결',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.deepOrange,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                      ],
                                      Text(
                                        member.name,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w900,
                                          color: AppColors.textStrong,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    '${member.gender} / ${member.birthDate}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textBody,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    member.guardianPhone,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                ],
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
      ),
    );
  }
}
