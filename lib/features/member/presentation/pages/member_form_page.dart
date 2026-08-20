import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/widgets/app_common_widgets.dart';
import '../models/member_ui.dart';
import 'member_option_select_page.dart';

class MemberFormPage extends StatefulWidget {
  final MemberUi? initial;

  const MemberFormPage({super.key, this.initial});

  bool get isEdit => initial != null;

  @override
  State<MemberFormPage> createState() => _MemberFormPageState();
}

class _MemberFormPageState extends State<MemberFormPage> {
  static const _disabilityOptions = [
    '미응답',
    '지체장애',
    '뇌병변장애',
    '시각장애',
    '청각장애',
    '언어장애',
    '지적장애',
    '자폐성장애',
    '정신장애',
    '신장장애',
    '심장장애',
    '호흡기장애',
  ];

  static const _referralOptions = [
    '미선택',
    '인터넷 검색',
    '지인 소개',
    '홍보물',
    '기타',
  ];

  late final TextEditingController _name;
  late final TextEditingController _phone;
  late final TextEditingController _address;
  late final TextEditingController _email;
  late final TextEditingController _school;
  late final TextEditingController _memo;

  late String _gender;
  late DateTime _birthDate;
  late String _status;
  late DateTime _statusDate;
  late String _disabilityType;
  late String _referralSource;
  late bool _mobileAppEnabled;

  @override
  void initState() {
    super.initState();
    final member = widget.initial;

    _name = TextEditingController(text: member?.name ?? '');
    _phone = TextEditingController(text: member?.motherPhone ?? '');
    _address = TextEditingController(text: member?.address ?? '');
    _email = TextEditingController(text: member?.email ?? '');
    _school = TextEditingController(text: member?.school ?? '');
    _memo = TextEditingController(text: member?.memo ?? '');

    _gender = member?.gender ?? '남';
    _birthDate = member?.birthDate ?? DateTime(2020, 1, 1);
    _status = member?.status ?? '대기';
    _statusDate = member?.statusDate ?? DateTime.now();
    _disabilityType = member?.disabilityType ?? '미응답';
    _referralSource = member?.referralSource ?? '미선택';
    _mobileAppEnabled = member?.mobileAppEnabled ?? false;
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _address.dispose();
    _email.dispose();
    _school.dispose();
    _memo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? '이용자 수정' : '이용자 등록'),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.only(top: 16, bottom: 12),
          children: [
            AppSectionCard(
              title: '기본 정보',
              children: [
                _textField('이름', _name, isRequired: true),
                _choiceRow(
                  label: '성별',
                  value: _gender,
                  onTap: _selectGender,
                ),
                _choiceRow(
                  label: '생년월일',
                  value: _date(_birthDate),
                  onTap: _selectBirthDate,
                ),
              ],
            ),
            AppSectionCard(
              title: '상태',
              children: [
                _choiceRow(
                  label: '현재 상태',
                  value: _status,
                  onTap: _selectStatus,
                ),
                _choiceRow(
                  label: '상태 적용일',
                  value: _date(_statusDate),
                  onTap: _selectStatusDate,
                ),
              ],
            ),
            AppSectionCard(
              title: '연락처',
              children: [
                _textField(
                  '전화번호 (모)',
                  _phone,
                  keyboardType: TextInputType.phone,
                ),
                SwitchListTile.adaptive(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  value: _mobileAppEnabled,
                  activeColor: AppColors.primary,
                  title: const Text(
                    '모바일앱 사용',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textStrong,
                    ),
                  ),
                  onChanged: (value) => setState(() => _mobileAppEnabled = value),
                ),
              ],
            ),
            AppSectionCard(
              title: '추가 정보',
              children: [
                _textField('주소', _address),
                _textField('이메일', _email, keyboardType: TextInputType.emailAddress),
                _textField('학교', _school),
                _choiceRow(
                  label: '장애유형',
                  value: _disabilityType,
                  onTap: _selectDisability,
                ),
                _choiceRow(
                  label: '유입경로',
                  value: _referralSource,
                  onTap: _selectReferral,
                ),
                _textField('메모', _memo, minLines: 3),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppPrimaryButton(
        label: widget.isEdit ? '수정 저장' : '이용자 등록',
        onPressed: _save,
      ),
    );
  }

  Widget _textField(
    String label,
    TextEditingController controller, {
    bool isRequired = false,
    TextInputType? keyboardType,
    int minLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 14),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        minLines: minLines,
        maxLines: minLines == 1 ? 1 : 5,
        decoration: InputDecoration(
          labelText: isRequired ? '$label *' : label,
          filled: true,
          fillColor: AppColors.background,
          border: _inputBorder(AppColors.border),
          enabledBorder: _inputBorder(AppColors.border),
          focusedBorder: _inputBorder(AppColors.primary),
        ),
      ),
    );
  }

  Widget _choiceRow({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textStrong,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
            ],
          ),
        ),
      ),
    );
  }

  OutlineInputBorder _inputBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(13),
      borderSide: BorderSide(color: color),
    );
  }

  Future<void> _selectBirthDate() async {
    final value = await showDatePicker(
      context: context,
      initialDate: _birthDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (value != null && mounted) setState(() => _birthDate = value);
  }

  Future<void> _selectStatusDate() async {
    final value = await showDatePicker(
      context: context,
      initialDate: _statusDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (value != null && mounted) setState(() => _statusDate = value);
  }

  Future<void> _selectGender() async {
    final value = await _simpleSheet('성별', ['남', '여'], _gender);
    if (value != null && mounted) setState(() => _gender = value);
  }

  Future<void> _selectStatus() async {
    final value = await _simpleSheet('이용자 상태', ['대기', '등록', '종결'], _status);
    if (value != null && mounted) setState(() => _status = value);
  }

  Future<String?> _simpleSheet(String title, List<String> options, String selected) {
    return showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textStrong,
                ),
              ),
              const SizedBox(height: 12),
              ...options.map(
                (option) => ListTile(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  tileColor: option == selected ? AppColors.primary50 : null,
                  title: Text(option),
                  trailing: option == selected
                      ? const Icon(Icons.check_circle_rounded, color: AppColors.primary)
                      : null,
                  onTap: () => Navigator.pop(context, option),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDisability() async {
    final value = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => MemberOptionSelectPage(
          title: '장애유형 선택',
          options: _disabilityOptions,
          selected: _disabilityType,
        ),
      ),
    );
    if (value != null && mounted) setState(() => _disabilityType = value);
  }

  Future<void> _selectReferral() async {
    final value = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => MemberOptionSelectPage(
          title: '유입경로 선택',
          options: _referralOptions,
          selected: _referralSource,
        ),
      ),
    );
    if (value != null && mounted) setState(() => _referralSource = value);
  }

  void _save() {
    final name = _name.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이름을 입력해주세요.')),
      );
      return;
    }

    final base = widget.initial;
    final result = MemberUi(
      id: base?.id ?? 'M${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      gender: _gender,
      birthDate: _birthDate,
      status: _status,
      statusDate: _statusDate,
      motherPhone: _phone.text.trim(),
      mobileAppEnabled: _mobileAppEnabled,
      address: _address.text.trim(),
      email: _email.text.trim(),
      school: _school.text.trim(),
      disabilityType: _disabilityType,
      firstConsultationAt: base?.firstConsultationAt,
      referralSource: _referralSource == '미선택' ? '' : _referralSource,
      memo: _memo.text.trim(),
      lastModifiedBy: '박병준 / 대표님',
      lastModifiedAt: DateTime.now(),
    );

    Navigator.pop(context, result);
  }

  String _date(DateTime value) {
    final m = value.month.toString().padLeft(2, '0');
    final d = value.day.toString().padLeft(2, '0');
    return '${value.year}-$m-$d';
  }
}
