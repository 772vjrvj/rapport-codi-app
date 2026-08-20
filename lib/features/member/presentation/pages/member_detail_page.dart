import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../models/member_ui.dart';
import 'member_form_page.dart';
import 'member_treatment_status_page.dart';

class MemberDetailPage extends StatefulWidget {
  final MemberUi member;

  const MemberDetailPage({super.key, required this.member});

  @override
  State<MemberDetailPage> createState() => _MemberDetailPageState();
}

class _MemberDetailPageState extends State<MemberDetailPage> {
  late MemberUi _member;

  @override
  void initState() {
    super.initState();
    _member = widget.member;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('이용자 · ${_member.name}'),
        actions: [
          TextButton(
            onPressed: _edit,
            child: const Text(
              '수정',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
        children: [
          _headerCard(),
          const SizedBox(height: 14),
          _section(
            title: '이용자 정보',
            children: [
              _row('상태', _member.status, badge: true),
              _row('전화번호 (모)', _empty(_member.motherPhone)),
              if (_member.mobileAppEnabled)
                _row('모바일앱', '사용중', valueColor: AppColors.primaryDark),
              _row('주소', _empty(_member.address)),
              _row('이메일', _empty(_member.email)),
              _row('학교', _empty(_member.school)),
              _row('장애유형', _member.disabilityType),
              _row(
                '초기상담일시',
                _member.firstConsultationAt == null
                    ? '등록된 정보가 없습니다.'
                    : _dateTime(_member.firstConsultationAt!),
              ),
              _row('유입경로', _empty(_member.referralSource)),
              _row('메모', _empty(_member.memo), multiline: true),
            ],
          ),
          const SizedBox(height: 14),
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            child: InkWell(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => MemberTreatmentStatusPage(member: _member),
                ),
              ),
              borderRadius: BorderRadius.circular(18),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.monitor_heart_outlined, color: AppColors.primaryDark),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '치료현황 보기',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textStrong,
                        ),
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerCard() {
    final ageText = _ageText(_member.birthDate);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary50, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 31,
            backgroundColor: AppColors.primary100,
            child: Icon(
              Icons.person_outline_rounded,
              color: AppColors.primaryDark,
              size: 34,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _member.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textStrong,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${_member.gender} · ${_date(_member.birthDate)} · $ageText',
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textBody,
                  ),
                ),
                const SizedBox(height: 9),
                Text(
                  '최종수정 ${_dateTime(_member.lastModifiedAt)}, ${_member.lastModifiedBy}',
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _section({required String title, required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primaryDark,
                  ),
                ),
              ),
            ),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _row(
    String label,
    String value, {
    bool badge = false,
    bool multiline = false,
    Color? valueColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 13, 16, 14),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 6),
          if (badge)
            _statusChip(value)
          else
            Text(
              value,
              maxLines: multiline ? null : 2,
              overflow: multiline ? null : TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13.5,
                height: 1.5,
                fontWeight: FontWeight.w700,
                color: valueColor ?? (value.startsWith('등록된') ? AppColors.textMuted : AppColors.textBody),
              ),
            ),
        ],
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status,
        style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w900, color: color),
      ),
    );
  }

  Future<void> _edit() async {
    final result = await Navigator.push<MemberUi>(
      context,
      MaterialPageRoute(builder: (_) => MemberFormPage(initial: _member)),
    );

    if (result != null && mounted) {
      setState(() => _member = result);
    }
  }

  String _empty(String value) => value.trim().isEmpty ? '등록된 정보가 없습니다.' : value;

  String _date(DateTime value) {
    final m = value.month.toString().padLeft(2, '0');
    final d = value.day.toString().padLeft(2, '0');
    return '${value.year}-$m-$d';
  }

  String _dateTime(DateTime value) {
    final h = value.hour.toString().padLeft(2, '0');
    final m = value.minute.toString().padLeft(2, '0');
    return '${_date(value)} $h:$m';
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
