import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ClassDetailsBottomSheet extends StatelessWidget {
  final Map<String, dynamic> classData;

  const ClassDetailsBottomSheet({
    super.key,
    required this.classData,
  });

  @override
  Widget build(BuildContext context) {
    final Color cardColor = Color(classData["color"] as int);
    final int attendancePercentage = classData["attendancePercentage"] as int;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 1.h),
            height: 4,
            width: 12.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(6.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 8.h,
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            classData["subject"] as String,
                            style: AppTheme.lightTheme.textTheme.headlineSmall
                                ?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            classData["subjectCode"] as String,
                            style: AppTheme.lightTheme.textTheme.bodyLarge
                                ?.copyWith(
                              color: cardColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: attendancePercentage >= 85
                            ? AppTheme.lightTheme.colorScheme.tertiary
                                .withValues(alpha: 0.1)
                            : attendancePercentage >= 75
                                ? AppTheme.lightTheme.colorScheme.secondary
                                    .withValues(alpha: 0.1)
                                : AppTheme.lightTheme.colorScheme.error
                                    .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        '$attendancePercentage% Attendance',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: attendancePercentage >= 85
                              ? AppTheme.lightTheme.colorScheme.tertiary
                              : attendancePercentage >= 75
                                  ? AppTheme.lightTheme.colorScheme.secondary
                                  : AppTheme.lightTheme.colorScheme.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 4.h),

                // Details
                _buildDetailRow(
                  'Instructor',
                  classData["instructor"] as String,
                  'person',
                ),
                _buildDetailRow(
                  'Contact',
                  classData["instructorContact"] as String,
                  'email',
                ),
                _buildDetailRow(
                  'Room',
                  classData["room"] as String,
                  'location_on',
                ),
                _buildDetailRow(
                  'Time',
                  '${classData["startTime"]} - ${classData["endTime"]}',
                  'access_time',
                ),
                _buildDetailRow(
                  'Duration',
                  classData["duration"] as String,
                  'schedule',
                ),
                _buildDetailRow(
                  'Department',
                  classData["department"] as String,
                  'school',
                ),

                SizedBox(height: 4.h),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/attendance-tracking');
                        },
                        icon: CustomIconWidget(
                          iconName: 'analytics',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 20,
                        ),
                        label: const Text('View Attendance'),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _showAttendanceDialog(context);
                        },
                        icon: CustomIconWidget(
                          iconName: 'check_circle',
                          color: Colors.white,
                          size: 20,
                        ),
                        label: const Text('Mark Present'),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 2.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, String iconName) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 20,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  value,
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAttendanceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Mark Attendance',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Mark your attendance for ${classData["subject"]}',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      // Handle present marking
                    },
                    icon: CustomIconWidget(
                      iconName: 'check_circle',
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                      size: 20,
                    ),
                    label: const Text('Present'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.lightTheme.colorScheme.tertiary,
                      side: BorderSide(
                        color: AppTheme.lightTheme.colorScheme.tertiary,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      // Handle absent marking
                    },
                    icon: CustomIconWidget(
                      iconName: 'cancel',
                      color: AppTheme.lightTheme.colorScheme.error,
                      size: 20,
                    ),
                    label: const Text('Absent'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.lightTheme.colorScheme.error,
                      side: BorderSide(
                        color: AppTheme.lightTheme.colorScheme.error,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
