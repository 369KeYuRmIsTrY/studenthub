import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickStatsCardWidget extends StatelessWidget {
  final Map<String, dynamic> quickStats;
  final VoidCallback? onTodayClassesTap;
  final VoidCallback? onAssignmentsTap;
  final VoidCallback? onAttendanceTap;

  const QuickStatsCardWidget({
    super.key,
    required this.quickStats,
    this.onTodayClassesTap,
    this.onAssignmentsTap,
    this.onAttendanceTap,
  });

  @override
  Widget build(BuildContext context) {
    final int todayClasses = quickStats["todayClasses"] as int? ?? 0;
    final int pendingAssignments =
        quickStats["pendingAssignments"] as int? ?? 0;
    final double attendancePercentage =
        quickStats["attendancePercentage"] as double? ?? 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Overview',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),

        SizedBox(height: 1.h),

        Row(
          children: [
            // Today's Classes
            Expanded(
              child: _buildStatCard(
                title: 'Today\'s Classes',
                value: todayClasses.toString(),
                icon: 'schedule',
                color: AppTheme.lightTheme.colorScheme.primary,
                onTap: onTodayClassesTap,
              ),
            ),

            SizedBox(width: 3.w),

            // Pending Assignments
            Expanded(
              child: _buildStatCard(
                title: 'Pending Tasks',
                value: pendingAssignments.toString(),
                icon: 'assignment',
                color: pendingAssignments > 0
                    ? AppTheme.lightTheme.colorScheme.error
                    : AppTheme.lightTheme.colorScheme.tertiary,
                onTap: onAssignmentsTap,
              ),
            ),
          ],
        ),

        SizedBox(height: 2.h),

        // Attendance Card (Full Width)
        GestureDetector(
          onTap: onAttendanceTap,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: AppTheme.cardShadow(isLight: true),
              border: Border.all(
                color: _getAttendanceColor(attendancePercentage)
                    .withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: _getAttendanceColor(attendancePercentage)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: 'pie_chart',
                    color: _getAttendanceColor(attendancePercentage),
                    size: 20,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Overall Attendance',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Row(
                        children: [
                          Text(
                            '${attendancePercentage.toStringAsFixed(1)}%',
                            style: AppTheme.lightTheme.textTheme.titleLarge
                                ?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: _getAttendanceColor(attendancePercentage),
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: LinearProgressIndicator(
                              value: attendancePercentage / 100,
                              backgroundColor: AppTheme
                                  .lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.3),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                _getAttendanceColor(attendancePercentage),
                              ),
                              minHeight: 6,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                CustomIconWidget(
                  iconName: 'chevron_right',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String icon,
    required Color color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: AppTheme.cardShadow(isLight: true),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(1.5.w),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: CustomIconWidget(
                    iconName: icon,
                    color: color,
                    size: 16,
                  ),
                ),
                CustomIconWidget(
                  iconName: 'chevron_right',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 14,
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Text(
              value,
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            SizedBox(height: 0.5.h),
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Color _getAttendanceColor(double percentage) {
    if (percentage >= 85) {
      return AppTheme.lightTheme.colorScheme.tertiary; // Green
    } else if (percentage >= 75) {
      return const Color(0xFFD97706); // Orange/Warning
    } else {
      return AppTheme.lightTheme.colorScheme.error; // Red
    }
  }
}
