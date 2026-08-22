import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/widgets/app_common_widgets.dart';

/// 치료 일정 1건과 1:1로 연결되는 부모 공개용 선생님 코멘트 화면입니다.
class TeacherCommentPage extends StatefulWidget {
  final String memberName;
  final String programName;
  final String teacherName;
  final String dateText;
  final String startTime;
  final String endTime;

  const TeacherCommentPage({
    super.key,
    required this.memberName,
    required this.programName,
    required this.teacherName,
    required this.dateText,
    required this.startTime,
    required this.endTime,
  });

  @override
  State<TeacherCommentPage> createState() => _TeacherCommentPageState();
}

class _TeacherCommentPageState extends State<TeacherCommentPage> {
  final commentController = TextEditingController(
    text: '오늘은 그림카드를 보며 문장으로 표현하는 활동을 진행했습니다. '
        '처음에는 짧게 대답했지만 후반에는 스스로 문장을 이어 말하는 모습이 좋았습니다.',
  );

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '선생님 코멘트',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
        ),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
          children: [
            _CommentSummary(
              title: '${widget.memberName} · ${widget.programName}',
              teacher: widget.teacherName,
              dateText: widget.dateText,
              startTime: widget.startTime,
              endTime: widget.endTime,
            ),
            const SizedBox(height: 14),
            AppRecordTextSection(
              title: '코멘트',
              controller: commentController,
              emptyText: '부모님께 전달할 내용을 입력하세요.',
              minLines: 9,
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppPrimaryButton(
        label: '코멘트 저장',
        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('선생님 코멘트가 저장되었습니다. (UI 샘플)')),
        ),
      ),
    );
  }
}

class _CommentSummary extends StatelessWidget {
  final String title;
  final String teacher;
  final String dateText;
  final String startTime;
  final String endTime;

  const _CommentSummary({
    required this.title,
    required this.teacher,
    required this.dateText,
    required this.startTime,
    required this.endTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: AppColors.textStrong,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            teacher,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.textBody,
            ),
          ),
          const SizedBox(height: 11),
          _line('시작', startTime),
          const SizedBox(height: 7),
          _line('종료', endTime),
        ],
      ),
    );
  }

  Widget _line(String label, String time) {
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
            dateText,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: AppColors.textStrong,
            ),
          ),
        ),
        Text(
          time,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w900,
            color: AppColors.primaryDark,
          ),
        ),
      ],
    );
  }
}
