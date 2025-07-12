import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import './class_card_widget.dart';

class TimeSlotWidget extends StatelessWidget {
  final String timeSlot;
  final Map<String, dynamic>? classData;
  final VoidCallback? onClassTap;

  const TimeSlotWidget({
    super.key,
    required this.timeSlot,
    this.classData,
    this.onClassTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time column
          Container(
            width: 20.w,
            padding: EdgeInsets.only(top: 1.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  timeSlot,
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 0.5.h),
                  height: 1,
                  width: 15.w,
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                ),
              ],
            ),
          ),

          SizedBox(width: 4.w),

          // Class content
          Expanded(
            child: classData != null
                ? ClassCardWidget(
                    classData: classData!,
                    onTap: onClassTap,
                  )
                : Container(
                    height: 8.h,
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Free Period',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
