import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../app/widgets/main_app_drawer.dart';

class ParentTogetherPage extends StatefulWidget {
  const ParentTogetherPage({super.key});

  @override
  State<ParentTogetherPage> createState() => _ParentTogetherPageState();
}

class _ParentTogetherPageState extends State<ParentTogetherPage> {
  final List<_ParentDiary> entries = [
    const _ParentDiary(
      date: '2026-08-22',
      title: '책 읽고 이야기 나누기',
      content: '오늘 자기 전에 그림책을 같이 읽고 등장인물이 무엇을 하고 있는지 민준이에게 물어봤어요. 평소보다 문장으로 길게 이야기해 줬어요.',
    ),
    const _ParentDiary(
      date: '2026-08-20',
      title: '놀이터에서 차례 기다리기',
      content: '미끄럼틀에서 친구가 먼저 타도록 기다려봤어요. 처음에는 어려워했지만 두 번째부터는 조금 편하게 기다렸어요.',
    ),
  ];

  Future<void> _showGuide() async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.info_outline_rounded, color: AppColors.primaryDark),
        title: const Text('이렇게 적어보세요', style: TextStyle(fontWeight: FontWeight.w900)),
        content: const Text(
          '부모님과 무엇을 했는지, 아이가 어떤 반응을 보였는지 편하게 기록해 주세요.\n\n'
          '예) 오늘 그림책을 읽으며 “누가 무엇을 하고 있을까?”라고 물어봤어요. 민준이가 처음에는 짧게 대답했지만, 기다려주니 문장으로 이야기해줬어요.',
          style: TextStyle(height: 1.55),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  Future<void> _writeDiary() async {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    final result = await showModalBottomSheet<_ParentDiary>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        final bottom = MediaQuery.of(sheetContext).viewInsets.bottom;
        return Padding(
          padding: EdgeInsets.fromLTRB(18, 18, 18, 18 + bottom),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        '오늘 이야기 쓰기',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.textStrong),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(sheetContext),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: titleController,
                  decoration: _inputDecoration('제목', '오늘 있었던 일을 짧게 적어주세요'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: contentController,
                  minLines: 7,
                  maxLines: 12,
                  decoration: _inputDecoration('내용', '부모님과 무엇을 했는지, 아이의 반응은 어땠는지 적어주세요'),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 50,
                  child: FilledButton(
                    onPressed: () {
                      if (titleController.text.trim().isEmpty || contentController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(sheetContext).showSnackBar(
                          const SnackBar(content: Text('제목과 내용을 모두 입력해주세요.')),
                        );
                        return;
                      }
                      final now = DateTime.now();
                      final date = '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
                      Navigator.pop(
                        sheetContext,
                        _ParentDiary(
                          date: date,
                          title: titleController.text.trim(),
                          content: contentController.text.trim(),
                        ),
                      );
                    },
                    style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
                    child: const Text('저장', style: TextStyle(fontWeight: FontWeight.w900)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    titleController.dispose();
    contentController.dispose();

    if (result != null && mounted) {
      setState(() => entries.insert(0, result));
    }
  }

  InputDecoration _inputDecoration(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: AppColors.primary50.withValues(alpha: 0.35),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MainAppDrawer(selected: AppMenu.parentTogether),
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: const Icon(Icons.menu_rounded),
          ),
        ),
        title: const Text('부모님과 함께', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
        actions: [
          IconButton(
            tooltip: '작성 예시',
            onPressed: _showGuide,
            icon: const Icon(Icons.info_outline_rounded),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final item = entries[index];
          final showDate = index == 0 || entries[index - 1].date != item.date;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showDate) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 8, 4, 9),
                  child: Text(
                    item.date,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: AppColors.textMuted),
                  ),
                ),
              ],
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 11),
                padding: const EdgeInsets.all(17),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.textStrong),
                    ),
                    const SizedBox(height: 9),
                    Text(
                      item.content,
                      style: const TextStyle(fontSize: 13, height: 1.65, fontWeight: FontWeight.w600, color: AppColors.textBody),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _writeDiary,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.edit_outlined),
        label: const Text('글쓰기', style: TextStyle(fontWeight: FontWeight.w900)),
      ),
    );
  }
}

class _ParentDiary {
  final String date;
  final String title;
  final String content;

  const _ParentDiary({required this.date, required this.title, required this.content});
}
