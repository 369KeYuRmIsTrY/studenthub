import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AttendanceStatsWidget extends StatelessWidget {
  final double overallPercentage;
  final Color attendanceColor;
  final DateTime lastSyncTime;
  final bool isLoading;

  const AttendanceStatsWidget({
    Key? key,
    required this.overallPercentage,
    required this.attendanceColor,
    required this.lastSyncTime,
    required this.isLoading,
  }) : super(key: key);

  String _getAttendanceStatus(double percentage) {
    if (percentage >= 75) {
      return 'Good';
    } else if (percentage >= 65) {
      return 'Warning';
    } else {
      return 'Critical';
    }
  }

  String _getStatusMessage(double percentage) {
    if (percentage >= 75) {
      return 'Keep up the good work!';
    } else if (percentage >= 65) {
      return 'Attendance below recommended level';
    } else {
      return 'Immediate attention required';
    }
  }

  String _formatLastSync(DateTime lastSync) {
    final now = DateTime.now();
    final difference = now.difference(lastSync);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow(isLight: true),
      ),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Overall Attendance',
                style: AppTheme.lightTheme.textTheme.titleLarge,
              ),
              if (isLoading)
                SizedBox(
                  width: 5.w,
                  height: 5.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                )
              else
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: attendanceColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getAttendanceStatus(overallPercentage),
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: attendanceColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),

          SizedBox(height: 3.h),

          // Main percentage display
          Row(
            children: [
              // Circular progress indicator
              SizedBox(
                width: 25.w,
                height: 25.w,
                child: Stack(
                  children: [
                    // Background circle
                    SizedBox(
                      width: 25.w,
                      height: 25.w,
                      child: CircularProgressIndicator(
                        value: 1.0,
                        strokeWidth: 8,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.lightTheme.dividerColor,
                        ),
                      ),
                    ),
                    // Progress circle
                    SizedBox(
                      width: 25.w,
                      height: 25.w,
                      child: CircularProgressIndicator(
                        value: overallPercentage / 100,
                        strokeWidth: 8,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(attendanceColor),
                      ),
                    ),
                    // Percentage text
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${overallPercentage.toStringAsFixed(1)}%',
                            style: AppTheme.lightTheme.textTheme.headlineSmall
                                ?.copyWith(
                              color: attendanceColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'Attendance',
                            style: AppTheme.lightTheme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 6.w),

              // Stats breakdown
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatRow(
                      'Status',
                      _getAttendanceStatus(overallPercentage),
                      attendanceColor,
                    ),
                    SizedBox(height: 1.h),
                    _buildStatRow(
                      'Target',
                      '75%',
                      AppTheme.lightTheme.colorScheme.primary,
                    ),
                    SizedBox(height: 1.h),
                    _buildStatRow(
                      'Difference',
                      '${(overallPercentage - 75).toStringAsFixed(1)}%',
                      overallPercentage >= 75 ? Colors.green : Colors.red,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      _getStatusMessage(overallPercentage),
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: attendanceColor,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Progress bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progress to Target (75%)',
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                  Text(
                    '${(overallPercentage / 75 * 100).clamp(0, 100).toStringAsFixed(0)}%',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              Container(
                width: double.infinity,
                height: 1.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.dividerColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: (overallPercentage / 75).clamp(0, 1),
                  child: Container(
                    decoration: BoxDecoration(
                      color: attendanceColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Last sync info
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'sync',
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.6),
                size: 16,
              ),
              SizedBox(width: 1.w),
              Text(
                'Last synced ${_formatLastSync(lastSyncTime)}',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
