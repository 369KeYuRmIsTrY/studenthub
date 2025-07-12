import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AcademicInfoWidget extends StatelessWidget {
  final Map<String, dynamic> academicData;

  const AcademicInfoWidget({
    super.key,
    required this.academicData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.tertiaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: 'school',
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                  size: 20,
                ),
              ),
              SizedBox(width: 3.w),
              Text(
                'Academic Information',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          _buildAcademicField(
            label: 'Course',
            value: academicData['course'],
            icon: 'menu_book',
          ),

          _buildAcademicField(
            label: 'Department',
            value: academicData['department'],
            icon: 'domain',
          ),

          Row(
            children: [
              Expanded(
                child: _buildAcademicField(
                  label: 'Enrollment Date',
                  value: _formatDate(academicData['enrollmentDate']),
                  icon: 'event',
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildAcademicField(
                  label: 'Expected Graduation',
                  value: _formatDate(academicData['expectedGraduation']),
                  icon: 'emoji_events',
                ),
              ),
            ],
          ),

          // GPA Display
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'grade',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current GPA',
                        style:
                            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        '${academicData['currentGPA']} / 10.0',
                        style: AppTheme.dataTextStyle(
                          isLight: true,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                        ).copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                // GPA Status Indicator
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: _getGPAStatusColor(academicData['currentGPA'])
                        .withAlpha(26),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getGPAStatus(academicData['currentGPA']),
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: _getGPAStatusColor(academicData['currentGPA']),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAcademicField({
    required String label,
    required String value,
    required String icon,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: icon,
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 16,
              ),
              SizedBox(width: 2.w),
              Text(
                label,
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest
                  .withAlpha(128),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline.withAlpha(128),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              value,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  String _getGPAStatus(double gpa) {
    if (gpa >= 9.0) return 'Excellent';
    if (gpa >= 8.0) return 'Very Good';
    if (gpa >= 7.0) return 'Good';
    if (gpa >= 6.0) return 'Average';
    return 'Below Average';
  }

  Color _getGPAStatusColor(double gpa) {
    if (gpa >= 9.0) return const Color(0xFF4CAF50); // Green
    if (gpa >= 8.0) return const Color(0xFF8BC34A); // Light Green
    if (gpa >= 7.0) return const Color(0xFF2196F3); // Blue
    if (gpa >= 6.0) return const Color(0xFFFF9800); // Orange
    return const Color(0xFFF44336); // Red
  }
}
