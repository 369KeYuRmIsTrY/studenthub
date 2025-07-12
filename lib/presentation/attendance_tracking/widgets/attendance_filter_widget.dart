import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AttendanceFilterWidget extends StatefulWidget {
  final String selectedSubject;
  final DateTime selectedDate;
  final List<String> subjects;
  final Function(String subject, DateTime date) onFilterApplied;

  const AttendanceFilterWidget({
    Key? key,
    required this.selectedSubject,
    required this.selectedDate,
    required this.subjects,
    required this.onFilterApplied,
  }) : super(key: key);

  @override
  State<AttendanceFilterWidget> createState() => _AttendanceFilterWidgetState();
}

class _AttendanceFilterWidgetState extends State<AttendanceFilterWidget> {
  late String _selectedSubject;
  late DateTime _selectedDate;
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    _selectedSubject = widget.selectedSubject;
    _selectedDate = widget.selectedDate;
    _startDate = DateTime.now().subtract(const Duration(days: 30));
    _endDate = DateTime.now();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: AppTheme.lightTheme.colorScheme,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _resetFilters() {
    setState(() {
      _selectedSubject = 'All Subjects';
      _selectedDate = DateTime.now();
      _startDate = DateTime.now().subtract(const Duration(days: 30));
      _endDate = DateTime.now();
    });
  }

  void _applyFilters() {
    widget.onFilterApplied(_selectedSubject, _selectedDate);
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
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
            margin: EdgeInsets.only(top: 2.h),
            width: 10.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter Attendance',
                  style: AppTheme.lightTheme.textTheme.titleLarge,
                ),
                TextButton(
                  onPressed: _resetFilters,
                  child: Text(
                    'Reset',
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Divider(
            color: AppTheme.lightTheme.dividerColor,
            height: 1,
          ),

          // Filter options
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Subject filter
                Text(
                  'Subject',
                  style: AppTheme.lightTheme.textTheme.titleMedium,
                ),
                SizedBox(height: 1.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppTheme.lightTheme.dividerColor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedSubject,
                      isExpanded: true,
                      icon: CustomIconWidget(
                        iconName: 'keyboard_arrow_down',
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                        size: 24,
                      ),
                      items: ['All Subjects', ...widget.subjects]
                          .map((String subject) {
                        return DropdownMenuItem<String>(
                          value: subject,
                          child: Text(
                            subject,
                            style: AppTheme.lightTheme.textTheme.bodyMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedSubject = newValue;
                          });
                        }
                      },
                    ),
                  ),
                ),

                SizedBox(height: 3.h),

                // Date range filter
                Text(
                  'Date Range',
                  style: AppTheme.lightTheme.textTheme.titleMedium,
                ),
                SizedBox(height: 1.h),

                Row(
                  children: [
                    Expanded(
                      child: _buildDateSelector(
                        'From',
                        _startDate,
                        () => _selectDate(context, true),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: _buildDateSelector(
                        'To',
                        _endDate,
                        () => _selectDate(context, false),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 3.h),

                // Quick date filters
                Text(
                  'Quick Filters',
                  style: AppTheme.lightTheme.textTheme.titleMedium,
                ),
                SizedBox(height: 1.h),

                Wrap(
                  spacing: 2.w,
                  runSpacing: 1.h,
                  children: [
                    _buildQuickFilterChip('Last 7 days', () {
                      setState(() {
                        _startDate =
                            DateTime.now().subtract(const Duration(days: 7));
                        _endDate = DateTime.now();
                      });
                    }),
                    _buildQuickFilterChip('Last 30 days', () {
                      setState(() {
                        _startDate =
                            DateTime.now().subtract(const Duration(days: 30));
                        _endDate = DateTime.now();
                      });
                    }),
                    _buildQuickFilterChip('This month', () {
                      final now = DateTime.now();
                      setState(() {
                        _startDate = DateTime(now.year, now.month, 1);
                        _endDate = now;
                      });
                    }),
                    _buildQuickFilterChip('Last month', () {
                      final now = DateTime.now();
                      final lastMonth = DateTime(now.year, now.month - 1, 1);
                      setState(() {
                        _startDate = lastMonth;
                        _endDate = DateTime(now.year, now.month, 0);
                      });
                    }),
                  ],
                ),

                SizedBox(height: 4.h),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _applyFilters,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                        ),
                        child: const Text('Apply Filters'),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector(String label, DateTime date, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        SizedBox(height: 0.5.h),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppTheme.lightTheme.dividerColor,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDate(date),
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                ),
                CustomIconWidget(
                  iconName: 'calendar_today',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickFilterChip(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
