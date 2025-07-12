import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class AssignmentFilterWidget extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterChanged;
  final List<Map<String, dynamic>> assignments;

  const AssignmentFilterWidget({
    Key? key,
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.assignments,
  }) : super(key: key);

  List<String> get _subjects {
    final subjects = <String>{'All'};
    for (final assignment in assignments) {
      subjects.add(assignment["subject"] as String);
    }
    return subjects.toList();
  }

  @override
  Widget build(BuildContext context) {
    final subjects = _subjects;

    return Container(
      height: 6.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          final subject = subjects[index];
          final isSelected = selectedFilter == subject;

          return GestureDetector(
            onTap: () => onFilterChanged(subject),
            child: Container(
              margin: EdgeInsets.only(right: 2.w),
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.lightTheme.primaryColor
                    : AppTheme.lightTheme.cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? AppTheme.lightTheme.primaryColor
                      : AppTheme.lightTheme.colorScheme.outline,
                  width: 1,
                ),
                boxShadow:
                    isSelected ? AppTheme.cardShadow(isLight: true) : null,
              ),
              child: Center(
                child: Text(
                  subject,
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: isSelected
                        ? Colors.white
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
