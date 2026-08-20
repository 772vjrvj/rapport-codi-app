import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../app/widgets/main_app_drawer.dart';
import '../models/member_ui.dart';
import 'member_detail_page.dart';
import 'member_form_page.dart';

class MemberListPage extends StatefulWidget {
  const MemberListPage({super.key});

  @override
  State<MemberListPage> createState() => _MemberListPageState();
}

class _MemberListPageState extends State<MemberListPage> {
  final TextEditingController _searchController = TextEditingController();
  late final List<MemberUi> _members;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _members = List<MemberUi>.from(sampleMembers);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _members.where((member) {
      final q = _query.trim().toLowerCase();
      if (q.isEmpty) return true;
      return member.name.toLowerCase().contains(q) ||
          member.motherPhone.replaceAll('-', '').contains(q.replaceAll('-', '')) ||
          _date(member.birthDate).contains(q);
    }).toList();

    return Scaffold(
      drawer: const MainAppDrawer(selected: AppMenu.members),
      appBar: AppBar(
        title: const Text('이용자 관리'),
        actions: [
          IconButton(
            tooltip: '이용자 등록',
            onPressed: _createMember,
            icon: const Icon(Icons.add_rounded),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          _searchBox(),
          _summary(filtered.length),
          Expanded(
            child: filtered.isEmpty
                ? const _EmptyMembers()
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 9),
                    itemBuilder: (context, index) => _memberCard(filtered[index]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _searchBox() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) => setState(() => _query = value),
        decoration: InputDecoration(
          hintText: '이름, 생년월일 또는 전화번호 검색',
          hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textMuted),
          suffixIcon: _query.isEmpty
              ? null
              : IconButton(
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _query = '');
                  },
                  icon: const Icon(Icons.close_rounded),
                ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  Widget _summary(int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
      child: Row(
        children: [
          Text(
            '전체 ${_members.length}명',
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w800,
              color: AppColors.textMuted,
            ),
          ),
          if (_query.isNotEmpty) ...[
            const SizedBox(width: 6),
            Text(
              '· 검색 $count명',
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w900,
                color: AppColors.primaryDark,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _memberCard(MemberUi member) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        onTap: () => _openDetail(member),
        borderRadius: BorderRadius.circular(17),
        child: Container(
          padding: const EdgeInsets.fromLTRB(15, 14, 14, 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 23,
                backgroundColor: member.status == '종결'
                    ? const Color(0xFFFFF2ED)
                    : AppColors.primary50,
                child: Icon(
                  member.gender == '여' ? Icons.girl_rounded : Icons.boy_rounded,
                  color: member.status == '종결'
                      ? const Color(0xFFC96B45)
                      : AppColors.primaryDark,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            member.name,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textStrong,
                            ),
                          ),
                        ),
                        _statusChip(member.status),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${member.gender} · ${_date(member.birthDate)} · ${_ageText(member.birthDate)}',
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textBody,
                      ),
                    ),
                    if (member.motherPhone.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        '(모) ${member.motherPhone}',
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                    if (member.mobileAppEnabled) ...[
                      const SizedBox(height: 7),
                      const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.smartphone_rounded, size: 14, color: AppColors.primaryDark),
                          SizedBox(width: 4),
                          Text(
                            '모바일앱 사용중',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 6),
              const Padding(
                padding: EdgeInsets.only(top: 29),
                child: Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusChip(String status) {
    final color = switch (status) {
      '등록' => AppColors.primaryDark,
      '종결' => const Color(0xFFC96B45),
      _ => const Color(0xFF71807C),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status,
        style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900, color: color),
      ),
    );
  }

  Future<void> _createMember() async {
    final result = await Navigator.push<MemberUi>(
      context,
      MaterialPageRoute(builder: (_) => const MemberFormPage()),
    );

    if (result != null && mounted) {
      setState(() => _members.insert(0, result));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이용자가 등록되었습니다.')),
      );
    }
  }

  Future<void> _openDetail(MemberUi member) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MemberDetailPage(member: member)),
    );
  }

  String _date(DateTime value) {
    final m = value.month.toString().padLeft(2, '0');
    final d = value.day.toString().padLeft(2, '0');
    return '${value.year}-$m-$d';
  }

  String _ageText(DateTime birth) {
    final now = DateTime.now();
    var months = (now.year - birth.year) * 12 + now.month - birth.month;
    if (now.day < birth.day) months--;
    if (months < 0) months = 0;
    final years = months ~/ 12;
    final remain = months % 12;
    return years > 0 ? '$years세 $remain개월' : '$months개월';
  }
}

class _EmptyMembers extends StatelessWidget {
  const _EmptyMembers();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off_rounded, size: 42, color: AppColors.textMuted),
          SizedBox(height: 10),
          Text(
            '조건에 맞는 이용자가 없습니다.',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
