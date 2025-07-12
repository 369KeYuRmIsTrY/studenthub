import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class MonthlyCalendarWidget extends StatefulWidget {
  final DateTime selectedDate;
  final List<Map<String, dynamic>> attendanceData;
  final Function(DateTime) onDateSelected;
  final Function(Map<String, dynamic>) onAttendanceEdit;

  const MonthlyCalendarWidget({
    Key? key,
    required this.selectedDate,
    required this.attendanceData,
    required this.onDateSelected,
    required this.onAttendanceEdit,
  }) : super(key: key);

  @override
  State<MonthlyCalendarWidget> createState() => _MonthlyCalendarWidgetState();
}

class _MonthlyCalendarWidgetState extends State<MonthlyCalendarWidget> {
  late DateTime _currentMonth;
  final List<String> _weekdays = [
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat'
  ];

  @override
  void initState() {
    super.initState();
    _currentMonth =
        DateTime(widget.selectedDate.year, widget.selectedDate.month, 1);
  }

  @override
  void didUpdateWidget(MonthlyCalendarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate != widget.selectedDate) {
      _currentMonth =
          DateTime(widget.selectedDate.year, widget.selectedDate.month, 1);
    }
  }

  List<DateTime> _getDaysInMonth(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);
    final startDate = firstDay.subtract(Duration(days: firstDay.weekday % 7));

    List<DateTime> days = [];
    for (int i = 0; i < 42; i++) {
      days.add(startDate.add(Duration(days: i)));
    }

    return days;
  }

  Map<String, dynamic>? _getAttendanceForDate(DateTime date) {
    final dateString =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

    for (var subject in widget.attendanceData) {
      final attendanceDetails = subject["attendanceDetails"] as List;
      for (var attendance in attendanceDetails) {
        if (attendance["date"] == dateString) {
          return attendance as Map<String, dynamic>;
        }
      }
    }
    return null;
  }

  Color _getDateColor(DateTime date, Map<String, dynamic>? attendance) {
    if (attendance != null) {
      final status = attendance["status"] as String;
      switch (status.toLowerCase()) {
        case 'present':
          return Colors.green;
        case 'absent':
          return Colors.red;
        case 'late':
          return Colors.orange;
        default:
          return Colors.grey;
      }
    }

    // Check if it's weekend
    if (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday) {
      return Colors.grey.shade300;
    }

    return Colors.transparent;
  }

  bool _isCurrentMonth(DateTime date) {
    return date.month == _currentMonth.month && date.year == _currentMonth.year;
  }

  bool _isToday(DateTime date) {
    final today = DateTime.now();
    return date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
  }

  void _onDateTap(DateTime date, Map<String, dynamic>? attendance) {
    widget.onDateSelected(date);

    if (attendance != null) {
      _showAttendanceDetails(date, attendance);
    }
  }

  void _showAttendanceDetails(DateTime date, Map<String, dynamic> attendance) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 10.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            SizedBox(height: 2.h),

            // Date header
            Text(
              '${date.day}/${date.month}/${date.year}',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),

            SizedBox(height: 2.h),

            // Attendance details
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.dividerColor,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _getStatusIcon(attendance["status"] as String),
                        color: _getDateColor(date, attendance),
                        size: 6.w,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Status: ${(attendance["status"] as String).toUpperCase()}',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: _getDateColor(date, attendance),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Class Type: ${(attendance["classType"] as String).toUpperCase()}',
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    'Topic: ${attendance["topic"]}',
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),

            SizedBox(height: 2.h),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      widget.onAttendanceEdit(attendance);
                    },
                    child: const Text('Edit Status'),
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),

            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'present':
        return Icons.check_circle;
      case 'absent':
        return Icons.cancel;
      case 'late':
        return Icons.access_time;
      default:
        return Icons.help;
    }
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = _getDaysInMonth(_currentMonth);

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppTheme.cardShadow(isLight: true),
      ),
      child: Column(
        children: [
          // Weekday headers
          Container(
            padding: EdgeInsets.symmetric(vertical: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.05),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: _weekdays.map((weekday) {
                return Expanded(
                  child: Center(
                    child: Text(
                      weekday,
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Calendar grid
          Padding(
            padding: EdgeInsets.all(2.w),
            child: Column(
              children: List.generate(6, (weekIndex) {
                return Row(
                  children: List.generate(7, (dayIndex) {
                    final dayIndex2 = weekIndex * 7 + dayIndex;
                    if (dayIndex2 >= daysInMonth.length) {
                      return const Expanded(child: SizedBox());
                    }

                    final date = daysInMonth[dayIndex2];
                    final attendance = _getAttendanceForDate(date);
                    final isCurrentMonth = _isCurrentMonth(date);
                    final isToday = _isToday(date);

                    return Expanded(
                      child: GestureDetector(
                        onTap: () => _onDateTap(date, attendance),
                        child: Container(
                          height: 12.w,
                          margin: EdgeInsets.all(0.5.w),
                          decoration: BoxDecoration(
                            color: attendance != null
                                ? _getDateColor(date, attendance)
                                    .withValues(alpha: 0.1)
                                : Colors.transparent,
                            border: isToday
                                ? Border.all(
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                    width: 2,
                                  )
                                : attendance != null
                                    ? Border.all(
                                        color: _getDateColor(date, attendance),
                                        width: 1,
                                      )
                                    : null,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Stack(
                            children: [
                              Center(
                                child: Text(
                                  '${date.day}',
                                  style: AppTheme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    color: isCurrentMonth
                                        ? (isToday
                                            ? AppTheme
                                                .lightTheme.colorScheme.primary
                                            : AppTheme.lightTheme.colorScheme
                                                .onSurface)
                                        : AppTheme
                                            .lightTheme.colorScheme.onSurface
                                            .withValues(alpha: 0.3),
                                    fontWeight: isToday
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                  ),
                                ),
                              ),

                              // Attendance indicator
                              if (attendance != null)
                                Positioned(
                                  top: 1.w,
                                  right: 1.w,
                                  child: Container(
                                    width: 2.w,
                                    height: 2.w,
                                    decoration: BoxDecoration(
                                      color: _getDateColor(date, attendance),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
