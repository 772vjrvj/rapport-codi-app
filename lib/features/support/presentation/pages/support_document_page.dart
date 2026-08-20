import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';

class SupportDocumentPage extends StatelessWidget {
  final String title;
  final String heading;
  final String body;

  const SupportDocumentPage({
    super.key,
    required this.title,
    required this.heading,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 20, 18, 36),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                heading,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textStrong,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                body,
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.8,
                  color: AppColors.textBody,
                ),
              ),
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primary50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '현재는 화면 확인용 샘플 본문입니다. 실제 운영 시 서버에서 관리하는 최신 원문을 표시하도록 연결합니다.',
                  style: TextStyle(
                    fontSize: 11.5,
                    height: 1.5,
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
