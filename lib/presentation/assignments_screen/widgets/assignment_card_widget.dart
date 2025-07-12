import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AssignmentCardWidget extends StatelessWidget {
  final Map<String, dynamic> assignment;
  final VoidCallback onTap;
  final VoidCallback onStartSubmission;
  final VoidCallback onSetReminder;
  final VoidCallback onDownloadResources;
  final VoidCallback onMarkPriority;
  final VoidCallback onAddNote;
  final VoidCallback onShare;

  const AssignmentCardWidget({
    Key? key,
    required this.assignment,
    required this.onTap,
    required this.onStartSubmission,
    required this.onSetReminder,
    required this.onDownloadResources,
    required this.onMarkPriority,
    required this.onAddNote,
    required this.onShare,
  }) : super(key: key);

  Color get _statusColor {
    final status = assignment["status"] as String;
    final isOverdue = assignment["isOverdue"] as bool? ?? false;
    final isDueSoon = assignment["isDueSoon"] as bool? ?? false;

    if (isOverdue) return AppTheme.lightTheme.colorScheme.error;
    if (isDueSoon) return const Color(0xFFD97706); // Warning color
    if (status == "submitted") return AppTheme.lightTheme.colorScheme.tertiary;
    if (status == "graded") return AppTheme.lightTheme.primaryColor;
    return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
  }

  String get _statusText {
    final status = assignment["status"] as String;
    final isOverdue = assignment["isOverdue"] as bool? ?? false;
    final isDueSoon = assignment["isDueSoon"] as bool? ?? false;

    if (isOverdue) return "Overdue";
    if (isDueSoon) return "Due Soon";
    if (status == "submitted") return "Submitted";
    if (status == "graded") return "Graded";
    return "Pending";
  }

  String get _timeRemaining {
    final dueDate = assignment["dueDate"] as DateTime;
    final now = DateTime.now();
    final difference = dueDate.difference(now);

    if (difference.isNegative) {
      final overdue = now.difference(dueDate);
      if (overdue.inDays > 0) {
        return "${overdue.inDays}d overdue";
      } else if (overdue.inHours > 0) {
        return "${overdue.inHours}h overdue";
      } else {
        return "${overdue.inMinutes}m overdue";
      }
    }

    if (difference.inDays > 0) {
      return "${difference.inDays}d remaining";
    } else if (difference.inHours > 0) {
      return "${difference.inHours}h remaining";
    } else {
      return "${difference.inMinutes}m remaining";
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPriority = assignment["isPriority"] as bool? ?? false;
    final hasNote = assignment["hasNote"] as bool? ?? false;
    final attachments = assignment["attachments"] as List? ?? [];
    final grade = assignment["grade"] as int?;

    return Dismissible(
      key: Key(assignment["id"].toString()),
      direction: DismissDirection.startToEnd,
      background: Container(
        margin: EdgeInsets.symmetric(vertical: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.tertiary,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 6.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'play_arrow',
              color: Colors.white,
              size: 24,
            ),
            SizedBox(height: 0.5.h),
            Text(
              'Start',
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      onDismissed: (direction) => onStartSubmission(),
      child: GestureDetector(
        onTap: onTap,
        onLongPress: () => _showContextMenu(context),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 1.h),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: AppTheme.cardShadow(isLight: true),
            border: isPriority
                ? Border.all(
                    color:
                        AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
                    width: 2,
                  )
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with subject and status
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: _statusColor.withValues(alpha: 0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 2.w,
                                  vertical: 0.5.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.lightTheme.primaryColor
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  assignment["subject"] as String,
                                  style: AppTheme
                                      .lightTheme.textTheme.labelSmall
                                      ?.copyWith(
                                    color: AppTheme.lightTheme.primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              if (isPriority) ...[
                                SizedBox(width: 2.w),
                                CustomIconWidget(
                                  iconName: 'priority_high',
                                  color: AppTheme.lightTheme.colorScheme.error,
                                  size: 16,
                                ),
                              ],
                              if (hasNote) ...[
                                SizedBox(width: 2.w),
                                CustomIconWidget(
                                  iconName: 'note',
                                  color: const Color(0xFFD97706),
                                  size: 16,
                                ),
                              ],
                            ],
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            assignment["title"] as String,
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 2.w,
                            vertical: 0.5.h,
                          ),
                          decoration: BoxDecoration(
                            color: _statusColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            _statusText,
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (grade != null) ...[
                          SizedBox(height: 0.5.h),
                          Text(
                            '$grade/${assignment["maxMarks"]}',
                            style: AppTheme.lightTheme.textTheme.labelMedium
                                ?.copyWith(
                              color: AppTheme.lightTheme.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // Content
              Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Description
                    Text(
                      assignment["description"] as String,
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: 2.h),

                    // Due date and time remaining
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'schedule',
                          color: _statusColor,
                          size: 16,
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Due: ${_formatDate(assignment["dueDate"] as DateTime)}',
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                _timeRemaining,
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: _statusColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (attachments.isNotEmpty)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 2.w,
                              vertical: 0.5.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomIconWidget(
                                  iconName: 'attach_file',
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                  size: 14,
                                ),
                                SizedBox(width: 1.w),
                                Text(
                                  '${attachments.length}',
                                  style: AppTheme
                                      .lightTheme.textTheme.labelSmall
                                      ?.copyWith(
                                    color: AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),

                    // Instructor and submission info
                    SizedBox(height: 1.h),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'person',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 16,
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            assignment["instructor"] as String,
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        if (assignment["submittedDate"] != null)
                          Text(
                            'Submitted ${_formatDate(assignment["submittedDate"] as DateTime)}',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.tertiary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ],
                    ),

                    // Feedback for graded assignments
                    if (assignment["feedback"] != null) ...[
                      SizedBox(height: 1.h),
                      Container(
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.primaryColor
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'feedback',
                              color: AppTheme.lightTheme.primaryColor,
                              size: 16,
                            ),
                            SizedBox(width: 2.w),
                            Expanded(
                              child: Text(
                                assignment["feedback"] as String,
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme.lightTheme.primaryColor,
                                  fontStyle: FontStyle.italic,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              assignment["title"] as String,
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 3.h),
            _buildContextMenuItem(
              context,
              icon: 'priority_high',
              title: (assignment["isPriority"] as bool? ?? false)
                  ? 'Remove Priority'
                  : 'Mark Priority',
              onTap: () {
                Navigator.pop(context);
                onMarkPriority();
              },
            ),
            _buildContextMenuItem(
              context,
              icon: 'note_add',
              title: 'Add Note',
              onTap: () {
                Navigator.pop(context);
                onAddNote();
              },
            ),
            _buildContextMenuItem(
              context,
              icon: 'share',
              title: 'Share with Classmates',
              onTap: () {
                Navigator.pop(context);
                onShare();
              },
            ),
            _buildContextMenuItem(
              context,
              icon: 'download',
              title: 'Download Resources',
              onTap: () {
                Navigator.pop(context);
                onDownloadResources();
              },
            ),
            _buildContextMenuItem(
              context,
              icon: 'alarm',
              title: 'Set Reminder',
              onTap: () {
                Navigator.pop(context);
                onSetReminder();
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildContextMenuItem(
    BuildContext context, {
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
            SizedBox(width: 4.w),
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
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
  }
}
