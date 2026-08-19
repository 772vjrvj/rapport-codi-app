import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import 'consultation_record_page.dart';
import 'monthly_treatment_management_page.dart';
import 'treatment_record_page.dart';

enum ScheduleDetailKind {
  treatment,
  consultation,
  other,
  notice,
}

class ScheduleListDetailData {
  final ScheduleDetailKind kind;
  final String title;
  final String teacherName;
  final String teacherRole;
  final String memberName;
  final String memberInfo;
  final String programName;
  final String programInfo;
  final String dateText;
  final String startTime;
  final String endTime;
  final String status;
  final String memo;
  final String repeatText;
  final bool allDay;
  final bool centerShared;
  final bool quickInput;
  final String noticeContent;

  const ScheduleListDetailData({
    required this.kind,
    required this.title,
    required this.teacherName,
    required this.teacherRole,
    required this.dateText,
    required this.startTime,
    required this.endTime,
    this.memberName = '',
    this.memberInfo = '',
    this.programName = '',
    this.programInfo = '',
    this.status = '예정',
    this.memo = '',
    this.repeatText = '반복 없음',
    this.allDay = false,
    this.centerShared = false,
    this.quickInput = false,
    this.noticeContent = '',
  });
}

class ScheduleCaseDetailPage extends StatelessWidget {
  final ScheduleListDetailData data;

  const ScheduleCaseDetailPage({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _pageTitle(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        actions: [
          if (data.kind != ScheduleDetailKind.notice)
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('수정 화면은 Chapter 12 등록/수정 Form과 연결 예정입니다.'),
                  ),
                );
              },
              child: const Text(
                '수정',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: AppColors.primaryDark,
                ),
              ),
            ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete') {
                _showDeleteDialog(context);
              }
            },
            itemBuilder: (_) => [
              if (data.kind != ScheduleDetailKind.notice)
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('삭제'),
                ),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        children: [
          _buildHero(),
          const SizedBox(height: 14),
          ..._buildCaseContent(context),
        ],
      ),
    );
  }

  String _pageTitle() {
    switch (data.kind) {
      case ScheduleDetailKind.treatment:
        return '치료 상세';
      case ScheduleDetailKind.consultation:
        return '상담/평가 상세';
      case ScheduleDetailKind.other:
        return '기타 일정 상세';
      case ScheduleDetailKind.notice:
        return '공지 상세';
    }
  }

  IconData _icon() {
    switch (data.kind) {
      case ScheduleDetailKind.treatment:
        return Icons.medical_services_outlined;
      case ScheduleDetailKind.consultation:
        return Icons.forum_outlined;
      case ScheduleDetailKind.other:
        return Icons.event_note_outlined;
      case ScheduleDetailKind.notice:
        return Icons.campaign_outlined;
    }
  }

  String _kindLabel() {
    switch (data.kind) {
      case ScheduleDetailKind.treatment:
        return '치료';
      case ScheduleDetailKind.consultation:
        return '상담/평가';
      case ScheduleDetailKind.other:
        return '기타';
      case ScheduleDetailKind.notice:
        return '공지';
    }
  }

  Widget _buildHero() {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary50,
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: AppColors.primary200),
            ),
            child: Icon(
              _icon(),
              color: AppColors.primaryDark,
              size: 23,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textStrong,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${data.teacherName} / ${data.teacherRole}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textBody,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    _Pill(label: _kindLabel()),
                    if (data.kind != ScheduleDetailKind.notice)
                      _Pill(
                        label: data.status,
                        emphasized: true,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCaseContent(BuildContext context) {
    switch (data.kind) {
      case ScheduleDetailKind.treatment:
        return _treatmentContent(context);
      case ScheduleDetailKind.consultation:
        return _consultationContent(context);
      case ScheduleDetailKind.other:
        return _otherContent(context);
      case ScheduleDetailKind.notice:
        return _noticeContent();
    }
  }

  List<Widget> _treatmentContent(BuildContext context) {
    return [
      _DetailCard(
        title: '기본 정보',
        children: [
          _DetailRow(
            label: '이용자',
            value: data.memberName,
            helper: data.memberInfo,
          ),
          _DetailRow(
            label: '프로그램',
            value: data.programName,
            helper: data.programInfo,
          ),
          _DetailRow(
            label: '월 치료',
            value: '2026년 08월 · 9회',
            trailing: const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textMuted,
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => MonthlyTreatmentManagementPage(
                    memberName: data.memberName,
                    programName: data.programName,
                    teacherName: data.teacherName,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      const SizedBox(height: 14),
      _scheduleCard(),
      const SizedBox(height: 14),
      _DetailCard(
        title: '메모',
        children: [
          _TextBlock(
            text: data.memo.isEmpty ? '등록된 메모가 없습니다.' : data.memo,
          ),
        ],
      ),
      const SizedBox(height: 14),
      _ActionCard(
        icon: Icons.description_outlined,
        title: '치료 기록',
        subtitle: '상담내용, 기록내용, 특이사항을 확인합니다.',
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => TreatmentRecordPage(
                memberName: data.memberName,
                programName: data.programName,
                teacherName: data.teacherName,
                dateText: data.dateText,
                startTime: data.startTime,
                endTime: data.endTime,
              ),
            ),
          );
        },
      ),
    ];
  }

  List<Widget> _consultationContent(BuildContext context) {
    return [
      if (data.quickInput)
        Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF8ED),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFFFD8A0)),
          ),
          child: const Row(
            children: [
              Icon(
                Icons.bolt_rounded,
                size: 18,
                color: Color(0xFFE08A1E),
              ),
              SizedBox(width: 8),
              Text(
                '빠른 입력으로 등록된 상담/평가 일정',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF9B641D),
                ),
              ),
            ],
          ),
        ),
      _DetailCard(
        title: '기본 정보',
        children: [
          _DetailRow(
            label: '이용자',
            value: data.memberName.isEmpty ? '빠른 입력' : data.memberName,
            helper: data.memberInfo,
          ),
          _DetailRow(
            label: '프로그램',
            value: data.programName.isEmpty ? '제목 없음' : data.programName,
            helper: data.programInfo,
          ),
        ],
      ),
      const SizedBox(height: 14),
      _scheduleCard(),
      const SizedBox(height: 14),
      _DetailCard(
        title: '상담 사유',
        children: [
          _TextBlock(
            text: data.memo.isEmpty ? '등록된 상담 사유가 없습니다.' : data.memo,
          ),
        ],
      ),
      const SizedBox(height: 14),
      _ActionCard(
        icon: Icons.note_alt_outlined,
        title: '상담/평가 기록',
        subtitle: '상담 결과 및 평가 기록을 확인합니다.',
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ConsultationRecordPage(
                memberName: data.memberName,
                programName: data.programName,
                teacherName: data.teacherName,
                dateText: data.dateText,
                startTime: data.startTime,
                endTime: data.endTime,
              ),
            ),
          );
        },
      ),
    ];
  }

  List<Widget> _otherContent(BuildContext context) {
    return [
      _DetailCard(
        title: '기본 정보',
        children: [
          _DetailRow(
            label: '센터 공유',
            value: data.centerShared ? '공유' : '나만 보기',
          ),
          _DetailRow(
            label: '제목',
            value: data.title,
          ),
        ],
      ),
      const SizedBox(height: 14),
      _DetailCard(
        title: '일정',
        children: [
          _DetailRow(
            label: '종일',
            value: data.allDay ? '사용' : '미사용',
          ),
          _DetailRow(
            label: '시작',
            value: data.dateText,
            inlineTime: data.allDay ? null : data.startTime,
          ),
          _DetailRow(
            label: '종료',
            value: data.dateText,
            inlineTime: data.allDay ? null : data.endTime,
          ),
          _DetailRow(
            label: '반복',
            value: data.repeatText,
          ),
        ],
      ),
      if (data.memo.isNotEmpty) ...[
        const SizedBox(height: 14),
        _DetailCard(
          title: '메모',
          children: [
            _TextBlock(text: data.memo),
          ],
        ),
      ],
    ];
  }

  List<Widget> _noticeContent() {
    return [
      _DetailCard(
        title: '공지 정보',
        children: [
          _DetailRow(
            label: '작성자',
            value: '${data.teacherName} / ${data.teacherRole}',
          ),
          _DetailRow(
            label: '등록일',
            value: data.dateText,
            helper: data.startTime,
          ),
        ],
      ),
      const SizedBox(height: 14),
      _DetailCard(
        title: '공지 내용',
        children: [
          _TextBlock(
            text: data.noticeContent.isEmpty
                ? '등록된 공지 내용이 없습니다.'
                : data.noticeContent,
          ),
        ],
      ),
    ];
  }

  Widget _scheduleCard() {
    return _DetailCard(
      title: '일정',
      children: [
        _DetailRow(
          label: '시작',
          value: data.dateText,
          inlineTime: data.startTime,
        ),
        _DetailRow(
          label: '종료',
          value: data.dateText,
          inlineTime: data.endTime,
        ),
        _DetailRow(
          label: '상태',
          value: data.status,
          valueColor: data.status == '완료'
              ? const Color(0xFF438267)
              : AppColors.primaryDark,
        ),
        if (data.repeatText != '반복 없음')
          _DetailRow(
            label: '반복',
            value: data.repeatText,
          ),
      ],
    );
  }

  Future<void> _showDeleteDialog(BuildContext context) async {
    final delete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            '일정 삭제',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          content: const Text('이 일정을 삭제하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('취소'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('삭제'),
            ),
          ],
        );
      },
    );

    if (delete == true && context.mounted) {
      Navigator.pop(context);
    }
  }
}

class _DetailCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _DetailCard({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
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

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final String? helper;
  final String? inlineTime;
  final Widget? trailing;
  final Color? valueColor;
  final VoidCallback? onTap;

  const _DetailRow({
    required this.label,
    required this.value,
    this.helper,
    this.inlineTime,
    this.trailing,
    this.valueColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 66),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: AppColors.border)),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 88,
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textStrong,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Text(
                            value,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              color: valueColor ?? AppColors.textStrong,
                            ),
                          ),
                        ),
                        if (inlineTime != null && inlineTime!.isNotEmpty) ...[
                          const SizedBox(width: 10),
                          Text(
                            inlineTime!,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (helper != null && helper!.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        helper!,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 8),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _TextBlock extends StatelessWidget {
  final String text;

  const _TextBlock({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.border),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          height: 1.6,
          fontWeight: FontWeight.w600,
          color: AppColors.textBody,
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
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
            border: Border.all(color: AppColors.primary200),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primary50,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primaryDark,
                  size: 21,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textStrong,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 11,
                        height: 1.35,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
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

class _Pill extends StatelessWidget {
  final String label;
  final bool emphasized;

  const _Pill({
    required this.label,
    this.emphasized = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: emphasized ? AppColors.primary100 : Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: emphasized ? AppColors.primary200 : AppColors.border,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w900,
          color: emphasized ? AppColors.primaryDark : AppColors.textBody,
        ),
      ),
    );
  }
}
