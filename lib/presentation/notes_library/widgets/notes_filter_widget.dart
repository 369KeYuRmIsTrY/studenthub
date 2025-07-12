import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NotesFilterWidget extends StatelessWidget {
  final List<String> selectedSubjects;
  final List<String> selectedWeeks;
  final VoidCallback onClearFilters;

  const NotesFilterWidget({
    super.key,
    required this.selectedSubjects,
    required this.selectedWeeks,
    required this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    final allFilters = [...selectedSubjects, ...selectedWeeks];

    if (allFilters.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Active Filters',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
              TextButton(
                onPressed: onClearFilters,
                child: Text(
                  'Clear All',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: allFilters.map((filter) {
              final isSubject = selectedSubjects.contains(filter);
              return Chip(
                label: Text(
                  filter,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                avatar: CustomIconWidget(
                  iconName: isSubject ? 'subject' : 'schedule',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 16,
                ),
                backgroundColor: AppTheme.lightTheme.cardColor,
                side: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  width: 1,
                ),
                deleteIcon: CustomIconWidget(
                  iconName: 'close',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 16,
                ),
                onDeleted: () {
                  // Remove individual filter - this would need to be handled by parent
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
