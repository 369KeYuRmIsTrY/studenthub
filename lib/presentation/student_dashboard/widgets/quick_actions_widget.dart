import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickActionsWidget extends StatelessWidget {
  final VoidCallback? onTimetableTap;
  final VoidCallback? onAssignmentUploadTap;
  final VoidCallback? onAttendanceCheckTap;

  const QuickActionsWidget({
    super.key,
    this.onTimetableTap,
    this.onAssignmentUploadTap,
    this.onAttendanceCheckTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            // Today's Timetable
            Expanded(
              child: _buildActionButton(
                title: 'Today\'s\nTimetable',
                icon: 'schedule',
                color: AppTheme.lightTheme.colorScheme.primary,
                onTap: onTimetableTap,
              ),
            ),

            SizedBox(width: 3.w),

            // Upload Assignment
            Expanded(
              child: _buildActionButton(
                title: 'Upload\nAssignment',
                icon: 'upload_file',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                onTap: onAssignmentUploadTap,
              ),
            ),

            SizedBox(width: 3.w),

            // Check Attendance
            Expanded(
              child: _buildActionButton(
                title: 'Check\nAttendance',
                icon: 'fact_check',
                color: const Color(0xFFD97706),
                onTap: onAttendanceCheckTap,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String title,
    required String icon,
    required Color color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 2.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: AppTheme.cardShadow(isLight: true),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: icon,
                color: color,
                size: 24,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
