import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';

class MonthlyTreatmentManagementPage extends StatefulWidget {
  final String memberName;
  final String programName;
  final String teacherName;

  const MonthlyTreatmentManagementPage({
    super.key,
    required this.memberName,
    required this.programName,
    required this.teacherName,
  });

  @override
  State<MonthlyTreatmentManagementPage> createState() =>
      _MonthlyTreatmentManagementPageState();
}

class _MonthlyTreatmentManagementPageState
    extends State<MonthlyTreatmentManagementPage> {
  int treatmentCount = 9;
  int durationMinutes = 40;
  int price = 50000;
  bool voucher = false;
  String repeatText = '매주 수요일';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '월 치료관리',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
        ),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
          children: [
            Container(
              padding: const EdgeInsets.all(17),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary50, Colors.white],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primary200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.memberName} · ${widget.programName}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textStrong,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.teacherName,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textBody,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            _Card(
              title: '2026년 08월',
              children: [
                _CounterRow(
                  label: '총 치료 회기',
                  value: '$treatmentCount회',
                  onMinus: treatmentCount > 1
                      ? () => setState(() => treatmentCount--)
                      : null,
                  onPlus: () => setState(() => treatmentCount++),
                ),
                _ValueRow(
                  label: '치료 반복',
                  value: repeatText,
                  onTap: _changeRepeat,
                ),
                _SwitchRow(
                  label: '바우처',
                  value: voucher,
                  onChanged: (v) => setState(() => voucher = v),
                ),
                _CounterRow(
                  label: '1회 치료시간',
                  value: '$durationMinutes분',
                  onMinus: durationMinutes > 10
                      ? () => setState(() => durationMinutes -= 10)
                      : null,
                  onPlus: () => setState(() => durationMinutes += 10),
                ),
                _ValueRow(
                  label: '1회 치료비',
                  value: '${_money(price)}원',
                  onTap: _editPrice,
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: AppColors.primary50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primary200),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      '예상 월 서비스 금액',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textStrong,
                      ),
                    ),
                  ),
                  Text(
                    '${_money(treatmentCount * price)}원',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: SizedBox(
          height: 52,
          child: FilledButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('저장되었습니다. (UI 샘플)')),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              '저장',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
            ),
          ),
        ),
      ),
    );
  }

  String _money(int value) {
    final s = value.toString();
    return s.replaceAllMapped(
      RegExp(r'(?<=\d)(?=(\d{3})+(?!\d))'),
      (_) => ',',
    );
  }

  Future<void> _editPrice() async {
    final c = TextEditingController(text: price.toString());
    final value = await showDialog<int>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('1회 치료비'),
        content: TextField(
          controller: c,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(suffixText: '원'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(
              ctx,
              int.tryParse(c.text.trim()),
            ),
            child: const Text('적용'),
          ),
        ],
      ),
    );
    c.dispose();
    if (value != null && mounted) setState(() => price = value);
  }

  Future<void> _changeRepeat() async {
    const options = [
      '반복 없음',
      '매주 월요일',
      '매주 화요일',
      '매주 수요일',
      '매주 목요일',
      '매주 금요일',
    ];
    final value = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            const ListTile(
              title: Text(
                '치료 반복',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
            ...options.map(
              (e) => ListTile(
                title: Text(e),
                trailing: e == repeatText
                    ? const Icon(
                        Icons.check_circle,
                        color: AppColors.primary,
                      )
                    : null,
                onTap: () => Navigator.pop(ctx, e),
              ),
            ),
          ],
        ),
      ),
    );
    if (value != null && mounted) setState(() => repeatText = value);
  }
}

class _Card extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _Card({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 15, 16, 11),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primaryDark,
                ),
              ),
            ),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _ValueRow extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const _ValueRow({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: const Border(
        top: BorderSide(color: AppColors.border),
      ),
      title: Text(
        label,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: AppColors.textStrong,
            ),
          ),
          const SizedBox(width: 6),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textMuted,
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}

class _SwitchRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SwitchListTile(
        title: Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
        ),
        value: value,
        activeThumbColor: AppColors.primary,
        onChanged: onChanged,
      ),
    );
  }
}

class _CounterRow extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback? onMinus;
  final VoidCallback onPlus;

  const _CounterRow({
    required this.label,
    required this.value,
    required this.onMinus,
    required this.onPlus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 64,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          IconButton(
            onPressed: onMinus,
            icon: const Icon(Icons.remove_rounded),
          ),
          SizedBox(
            width: 64,
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: AppColors.primaryDark,
              ),
            ),
          ),
          IconButton(
            onPressed: onPlus,
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
    );
  }
}
