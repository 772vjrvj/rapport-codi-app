import 'package:flutter/material.dart';

import '../../app/theme/app_theme.dart';
import '../utils/date_time_utils.dart';

/// 공통 카드 틀입니다.
class AppSectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final EdgeInsetsGeometry margin;

  const AppSectionCard({
    super.key,
    required this.title,
    required this.children,
    this.margin = const EdgeInsets.fromLTRB(16, 0, 16, 14),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
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

/// 화면 하단의 공통 저장 버튼입니다.
class AppPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const AppPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: SizedBox(
        height: 52,
        child: FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

/// 시작/종료 날짜와 시간을 한 줄로 보여주는 공통 위젯입니다.
/// 날짜와 시간의 글자 크기를 같게 유지하고, 시간은 오른쪽 끝에 둡니다.
class AppDateTimeLine extends StatelessWidget {
  final String label;
  final DateTime value;
  final Color timeColor;

  const AppDateTimeLine({
    super.key,
    required this.label,
    required this.value,
    this.timeColor = AppColors.primaryDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 38,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: AppColors.textMuted,
            ),
          ),
        ),
        Expanded(
          child: Text(
            AppDateTime.date(value),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: AppColors.textStrong,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          AppDateTime.time(value),
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w900,
            color: timeColor,
          ),
        ),
      ],
    );
  }
}

/// 기록 상세/작성 화면의 텍스트 영역입니다.
class AppRecordTextSection extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final bool editable;
  final String emptyText;
  final int minLines;
  final Color fillColor;
  final Color focusColor;

  const AppRecordTextSection({
    super.key,
    required this.title,
    required this.controller,
    required this.emptyText,
    required this.minLines,
    this.editable = true,
    this.fillColor = AppColors.primary50,
    this.focusColor = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    final isEmpty = controller.text.trim().isEmpty;

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w900,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 11),
          if (editable)
            TextField(
              controller: controller,
              minLines: minLines,
              maxLines: minLines + 6,
              decoration: InputDecoration(
                hintText: emptyText,
                filled: true,
                fillColor: fillColor.withValues(alpha: 0.35),
                border: _border(AppColors.border),
                enabledBorder: _border(AppColors.border),
                focusedBorder: _border(focusColor),
              ),
            )
          else
            Text(
              isEmpty ? emptyText : controller.text,
              style: TextStyle(
                fontSize: 13,
                height: 1.65,
                fontWeight: FontWeight.w600,
                color: isEmpty ? AppColors.textMuted : AppColors.textBody,
              ),
            ),
        ],
      ),
    );
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(13),
      borderSide: BorderSide(color: color),
    );
  }
}

/// 첨부파일 상태를 보여주는 공통 카드입니다.
class AppAttachmentCard extends StatelessWidget {
  final int count;
  final VoidCallback? onTap;

  const AppAttachmentCard({
    super.key,
    required this.count,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.attach_file_rounded,
                color: AppColors.primaryDark,
              ),
              const SizedBox(width: 10),
              Text(
                '첨부 ($count)',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textStrong,
                ),
              ),
              const Spacer(),
              Text(
                count == 0 ? '등록된 첨부파일이 없습니다.' : '$count개 파일',
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
