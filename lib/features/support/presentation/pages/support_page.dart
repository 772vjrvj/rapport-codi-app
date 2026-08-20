import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../app/widgets/main_app_drawer.dart';
import 'support_document_page.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  static const String _termsBody =
      '제1장 정의\n\n본 서비스의 이용과 관련하여 회사와 회원의 권리, 의무 및 책임사항을 정합니다.\n\n'
      '서비스 이용자는 계정 정보를 안전하게 관리해야 하며, 센터에서 제공하는 일정·이용자·기록 정보를 허가된 범위 안에서 이용해야 합니다.\n\n'
      '서비스의 세부 운영 정책과 유료 서비스, 알림, 데이터 보관 및 회원 탈퇴에 관한 내용은 최신 이용약관을 기준으로 적용됩니다.';

  static const String _privacyBody =
      '개인정보 처리방침\n\n서비스는 회원 가입, 본인 확인, 이용자 관리 및 서비스 제공에 필요한 범위에서 개인정보를 처리합니다.\n\n'
      '수집되는 정보와 보유기간, 제3자 제공 및 처리위탁, 개인정보 열람·정정·삭제 요청 절차 등은 최신 개인정보 처리방침을 기준으로 안내합니다.\n\n'
      '운영 환경에서 사용하는 실제 개인정보 처리방침 원문은 서버에서 최신 버전을 내려받아 표시하도록 연결합니다.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MainAppDrawer(selected: AppMenu.support),
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: const Icon(Icons.menu_rounded),
          ),
        ),
        title: const Text('서비스 지원'),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 30),
          children: [
            _MenuCard(
              icon: Icons.description_outlined,
              title: '이용약관',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SupportDocumentPage(
                    title: '이용약관',
                    heading: 'RapportCodi 서비스 이용약관',
                    body: _termsBody,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            _MenuCard(
              icon: Icons.privacy_tip_outlined,
              title: '개인정보 처리방침',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SupportDocumentPage(
                    title: '개인정보 처리방침',
                    heading: '개인정보 취급방침',
                    body: _privacyBody,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              '도움이 필요하신가요?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: AppColors.textStrong,
              ),
            ),
            const SizedBox(height: 16),
            _ContactCard(
              icon: Icons.headset_mic_outlined,
              title: '전화 문의하기',
              value: '070-8823-7799',
              onTap: () => _copy(context, '070-8823-7799', '전화번호'),
            ),
            const SizedBox(height: 12),
            _ContactCard(
              icon: Icons.forward_to_inbox_outlined,
              title: '이메일 문의하기',
              value: 'rapportcodi@test.com',
              onTap: () => _copy(context, 'rapportcodi@test.com', '이메일'),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoLine('운영시간', '월~금 오전 09:00 ~ 오후 06:00'),
                  SizedBox(height: 10),
                  _InfoLine('점심시간', '오후 12:00 ~ 오후 01:00'),
                  SizedBox(height: 10),
                  _InfoLine('휴무', '공휴일은 휴무입니다.'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> _copy(
    BuildContext context,
    String value,
    String label,
  ) async {
    await Clipboard.setData(ClipboardData(text: value));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label가 복사되었습니다.')),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.primaryDark),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textStrong,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback onTap;

  const _ContactCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          constraints: const BoxConstraints(minHeight: 92),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.primary200),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: const BoxDecoration(
                  color: AppColors.primary50,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 26, color: AppColors.primaryDark),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textStrong,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: AppColors.textBody,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.copy_rounded, size: 18, color: AppColors.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final String label;
  final String value;

  const _InfoLine(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 74,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: AppColors.textStrong,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textBody,
            ),
          ),
        ),
      ],
    );
  }
}
