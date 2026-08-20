import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';

class PasswordChangePage extends StatefulWidget {
  const PasswordChangePage({super.key});

  @override
  State<PasswordChangePage> createState() => _PasswordChangePageState();
}

class _PasswordChangePageState extends State<PasswordChangePage> {
  final currentController = TextEditingController();
  final newController = TextEditingController();
  final confirmController = TextEditingController();

  bool obscureCurrent = true;
  bool obscureNew = true;
  bool obscureConfirm = true;

  @override
  void dispose() {
    currentController.dispose();
    newController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  bool _validPassword(String value) {
    if (value.length < 8 || value.length > 20) return false;
    final hasNumber = RegExp(r'[0-9]').hasMatch(value);
    final hasLetter = RegExp(r'[A-Za-z]').hasMatch(value);
    final hasSpecial = RegExp(r'[@#$%^&+=!]').hasMatch(value);
    return hasNumber && hasLetter && hasSpecial;
  }

  void _save() {
    final current = currentController.text;
    final next = newController.text;
    final confirm = confirmController.text;

    String? error;
    if (current.isEmpty) {
      error = '현재 비밀번호를 입력해주세요.';
    } else if (!_validPassword(next)) {
      error = '새 비밀번호는 8~20자이며 숫자, 영문자, 특수기호를 각각 포함해야 합니다.';
    } else if (next != confirm) {
      error = '새 비밀번호 확인이 일치하지 않습니다.';
    }

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('비밀번호 변경 API 연결 전 UI 검증까지 완료되었습니다.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('비밀번호 변경'),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text(
              '저장',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 30),
        children: [
          const Text(
            '8자 이상 20자 이하로 비밀번호를 설정해주세요.\n숫자, 영문자, 특수기호(@#\$%^&+=!)가 각각 1개 이상씩 포함되어야 합니다.',
            style: TextStyle(
              fontSize: 12.5,
              height: 1.6,
              color: AppColors.textBody,
            ),
          ),
          const SizedBox(height: 24),
          _PasswordField(
            label: '현재 비밀번호',
            controller: currentController,
            obscure: obscureCurrent,
            onToggle: () => setState(() => obscureCurrent = !obscureCurrent),
          ),
          const SizedBox(height: 16),
          _PasswordField(
            label: '새 비밀번호',
            controller: newController,
            obscure: obscureNew,
            onToggle: () => setState(() => obscureNew = !obscureNew),
          ),
          const SizedBox(height: 16),
          _PasswordField(
            label: '새 비밀번호 확인',
            controller: confirmController,
            obscure: obscureConfirm,
            onToggle: () => setState(() => obscureConfirm = !obscureConfirm),
          ),
        ],
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool obscure;
  final VoidCallback onToggle;

  const _PasswordField({
    required this.label,
    required this.controller,
    required this.obscure,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: IconButton(
          onPressed: onToggle,
          icon: Icon(
            obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          ),
        ),
      ),
    );
  }
}
