import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final mobileController = TextEditingController(text: '010-3093-1959');
  final officeController = TextEditingController();
  final emailController = TextEditingController(text: 'libre@kakao.com');
  final addressController = TextEditingController();
  DateTime birthDate = DateTime(2026, 8, 20);

  @override
  void dispose() {
    mobileController.dispose();
    officeController.dispose();
    emailController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Future<void> _pickBirthDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: birthDate,
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
    );
    if (date != null) setState(() => birthDate = date);
  }

  void _save() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('프로필 저장 API 연결 전 UI 상태입니다.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateText =
        '${birthDate.year}-${birthDate.month.toString().padLeft(2, '0')}-${birthDate.day.toString().padLeft(2, '0')}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필 변경'),
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
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 30),
          children: [
            const Text(
              '박병준 / 대표님',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: AppColors.textStrong,
              ),
            ),
            const SizedBox(height: 20),
            _Field(
              icon: Icons.phone_outlined,
              label: '휴대전화',
              controller: mobileController,
            ),
            const SizedBox(height: 12),
            _Field(
              icon: Icons.apartment_outlined,
              label: '기관전화번호',
              controller: officeController,
            ),
            const SizedBox(height: 12),
            Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                onTap: _pickBirthDate,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.cake_outlined,
                        color: AppColors.primaryDark,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        '생년월일',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        dateText,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textBody,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            _Field(
              icon: Icons.mail_outline_rounded,
              label: '이메일',
              controller: emailController,
            ),
            const SizedBox(height: 12),
            _Field(
              icon: Icons.location_on_outlined,
              label: '주소',
              controller: addressController,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final IconData icon;
  final String label;
  final TextEditingController controller;
  final int maxLines;

  const _Field({
    required this.icon,
    required this.label,
    required this.controller,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
    );
  }
}
