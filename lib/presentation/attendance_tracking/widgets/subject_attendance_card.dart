import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SubjectAttendanceCard extends StatefulWidget {
  final Map<String, dynamic> subject;
  final VoidCallback onTap;
  final Function(Map<String, dynamic>) onEditAttendance;

  const SubjectAttendanceCard({
    Key? key,
    required this.subject,
    required this.onTap,
    required this.onEditAttendance,
  }) : super(key: key);

  @override
  State<SubjectAttendanceCard> createState() => _SubjectAttendanceCardState();
}

class _SubjectAttendanceCardState extends State<SubjectAttendanceCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getPercentageColor(double percentage) {
    if (percentage >= 75) {
      return AppTheme.lightTheme.colorScheme.tertiary;
    } else if (percentage >= 65) {
      return const Color(0xFFF59E0B);
    } else {
      return AppTheme.lightTheme.colorScheme.error;
    }
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

  Color _getStatusColor(String status) {
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

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final percentage = widget.subject["percentage"] as double;
    final attendanceDetails = widget.subject["attendanceDetails"] as List;

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppTheme.cardShadow(isLight: true),
      ),
      child: Column(
        children: [
          // Main card content
          InkWell(
            onTap: _toggleExpansion,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Subject header
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.subject["subjectName"] as String,
                              style: AppTheme.lightTheme.textTheme.titleMedium,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              '${widget.subject["subjectCode"]} • ${widget.subject["instructor"]}',
                              style: AppTheme.lightTheme.textTheme.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 2.w),
                      // Percentage circle
                      Container(
                        width: 15.w,
                        height: 15.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _getPercentageColor(percentage)
                              .withValues(alpha: 0.1),
                          border: Border.all(
                            color: _getPercentageColor(percentage),
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '${percentage.toStringAsFixed(1)}%',
                            style: AppTheme.lightTheme.textTheme.labelMedium
                                ?.copyWith(
                              color: _getPercentageColor(percentage),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      AnimatedRotation(
                        turns: _isExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 300),
                        child: CustomIconWidget(
                          iconName: 'keyboard_arrow_down',
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                          size: 24,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 2.h),

                  // Attendance stats
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatItem(
                          'Total Classes',
                          '${widget.subject["totalClasses"]}',
                          AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                      Expanded(
                        child: _buildStatItem(
                          'Attended',
                          '${widget.subject["attendedClasses"]}',
                          Colors.green,
                        ),
                      ),
                      Expanded(
                        child: _buildStatItem(
                          'Missed',
                          '${(widget.subject["totalClasses"] as int) - (widget.subject["attendedClasses"] as int)}',
                          Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Expandable content
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(
                    color: AppTheme.lightTheme.dividerColor,
                    height: 2.h,
                  ),

                  Text(
                    'Recent Attendance',
                    style: AppTheme.lightTheme.textTheme.titleSmall,
                  ),

                  SizedBox(height: 1.h),

                  // Attendance details list
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: attendanceDetails.length > 5
                        ? 5
                        : attendanceDetails.length,
                    separatorBuilder: (context, index) => SizedBox(height: 1.h),
                    itemBuilder: (context, index) {
                      final attendance =
                          attendanceDetails[index] as Map<String, dynamic>;
                      return _buildAttendanceItem(attendance);
                    },
                  ),

                  if (attendanceDetails.length > 5) ...[
                    SizedBox(height: 1.h),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          // Show all attendance details
                        },
                        child: Text(
                          'View All (${attendanceDetails.length})',
                          style: AppTheme.lightTheme.textTheme.labelMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildAttendanceItem(Map<String, dynamic> attendance) {
    final status = attendance["status"] as String;
    final date = attendance["date"] as String;
    final topic = attendance["topic"] as String;
    final classType = attendance["classType"] as String;

    return GestureDetector(
      onLongPress: () => widget.onEditAttendance(attendance),
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppTheme.lightTheme.dividerColor,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Status icon
            Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                color: _getStatusColor(status).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getStatusIcon(status),
                color: _getStatusColor(status),
                size: 4.w,
              ),
            ),

            SizedBox(width: 3.w),

            // Attendance details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        date,
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          classType.toUpperCase(),
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    topic,
                    style: AppTheme.lightTheme.textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Status badge
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: _getStatusColor(status).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                status.toUpperCase(),
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: _getStatusColor(status),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
