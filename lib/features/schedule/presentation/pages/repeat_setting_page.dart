import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../widgets/schedule_ui_components.dart';

class RepeatSettingPage extends StatefulWidget {
  final String initialValue;

  const RepeatSettingPage({
    super.key,
    this.initialValue = '반복 없음',
  });

  @override
  State<RepeatSettingPage> createState() => _RepeatSettingPageState();
}

class _RepeatSettingPageState extends State<RepeatSettingPage> {
  final selectedDays = <int>{};
  bool enabled = false;
  int months = 1;

  static const weekdays = ['월', '화', '수', '목', '금', '토', '일'];

  @override
  void initState() {
    super.initState();
    enabled = widget.initialValue != '반복 없음';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '반복 설정',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 12, bottom: 96),
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.fromLTRB(16, 10, 12, 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '반복 사용',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textStrong,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        '요일과 기간을 선택해 반복 일정을 만듭니다.',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: enabled,
                  activeThumbColor: AppColors.primary,
                  onChanged: (value) => setState(() => enabled = value),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Opacity(
            opacity: enabled ? 1 : 0.42,
            child: IgnorePointer(
              ignoring: !enabled,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '반복 요일',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textStrong,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: List.generate(7, (index) {
                            return [
                              ScheduleChoiceChip(
                                label: weekdays[index],
                                selected: selectedDays.contains(index),
                                onTap: () {
                                  setState(() {
                                    if (selectedDays.contains(index)) {
                                      selectedDays.remove(index);
                                    } else {
                                      selectedDays.add(index);
                                    }
                                  });
                                },
                              ),
                              if (index != 6) const SizedBox(width: 6),
                            ];
                          }).expand((e) => e).toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            '반복 기간',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textStrong,
                            ),
                          ),
                        ),
                        DropdownButton<int>(
                          value: months,
                          underline: const SizedBox.shrink(),
                          items: List.generate(
                            12,
                            (index) => DropdownMenuItem(
                              value: index + 1,
                              child: Text('${index + 1}개월'),
                            ),
                          ),
                          onChanged: (value) {
                            if (value == null) return;
                            setState(() => months = value);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SchedulePrimaryButton(
        label: '적용',
        onPressed: () {
          if (!enabled) {
            Navigator.pop(context, '반복 없음');
            return;
          }

          final selected = selectedDays.toList()..sort();
          final dayText = selected.isEmpty
              ? '요일 미선택'
              : selected.map((i) => weekdays[i]).join(', ');

          Navigator.pop(context, '$dayText · $months개월');
        },
      ),
    );
  }
}
