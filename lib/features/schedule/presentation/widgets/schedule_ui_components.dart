import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/utils/date_time_utils.dart';
import '../../../../core/widgets/app_common_widgets.dart';

class ScheduleSectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const ScheduleSectionCard({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return AppSectionCard(
      title: title,
      children: children,
    );
  }
}

class ScheduleFieldTile extends StatelessWidget {
  final String label;
  final String value;
  final String? helper;
  final String? inlineValue;
  final Widget? leading;
  final Widget? trailing;
  final bool enabled;
  final VoidCallback? onTap;

  const ScheduleFieldTile({
    super.key,
    required this.label,
    required this.value,
    this.helper,
    this.inlineValue,
    this.leading,
    this.trailing,
    this.enabled = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: enabled ? onTap : null,
        child: Container(
          constraints: const BoxConstraints(minHeight: 68),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: AppColors.border),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (leading != null) ...[
                leading!,
                const SizedBox(width: 12),
              ],
              SizedBox(
                width: 92,
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: enabled
                        ? AppColors.textStrong
                        : AppColors.textMuted,
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
                              fontWeight: FontWeight.w800,
                              color: enabled
                                  ? AppColors.textStrong
                                  : AppColors.textMuted,
                            ),
                          ),
                        ),
                        if (inlineValue != null && inlineValue!.isNotEmpty) ...[
                          const SizedBox(width: 10),
                          Text(
                            inlineValue!,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              color: enabled
                                  ? AppColors.primaryDark
                                  : AppColors.textMuted,
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (helper != null) ...[
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
                const SizedBox(width: 9),
                trailing!,
              ] else if (onTap != null) ...[
                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 22,
                  color: enabled ? AppColors.textMuted : AppColors.border,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class SchedulePrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const SchedulePrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppPrimaryButton(
      label: label,
      onPressed: onPressed,
    );
  }
}

class ScheduleChoiceChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const ScheduleChoiceChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 46,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.primary100 : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.border,
              width: selected ? 1.4 : 1,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w900,
              color: selected ? AppColors.primaryDark : AppColors.textBody,
            ),
          ),
        ),
      ),
    );
  }
}

String formatDate(DateTime date) => AppDateTime.date(date);

String formatTime(DateTime date) => AppDateTime.time(date);
