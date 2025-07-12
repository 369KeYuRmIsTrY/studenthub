import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AnnouncementsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> announcements;
  final Function(int) onDismiss;

  const AnnouncementsWidget({
    super.key,
    required this.announcements,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: announcements.map((announcement) {
        return _buildAnnouncementCard(announcement);
      }).toList(),
    );
  }

  Widget _buildAnnouncementCard(Map<String, dynamic> announcement) {
    final int id = announcement["id"] as int? ?? 0;
    final String title = announcement["title"] as String? ?? "Announcement";
    final String message = announcement["message"] as String? ?? "";
    final String date = announcement["date"] as String? ?? "";
    final String priority = announcement["priority"] as String? ?? "medium";
    final String type = announcement["type"] as String? ?? "general";

    // Parse date for display
    DateTime? announcementDate;
    try {
      announcementDate = DateTime.parse(date);
    } catch (e) {
      announcementDate = DateTime.now();
    }

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Dismissible(
        key: Key('announcement_$id'),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          onDismiss(id);
        },
        background: Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 4.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.error,
            borderRadius: BorderRadius.circular(12),
          ),
          child: CustomIconWidget(
            iconName: 'delete',
            color: Colors.white,
            size: 24,
          ),
        ),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: AppTheme.cardShadow(isLight: true),
            border: Border.all(
              color: _getPriorityColor(priority).withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  // Priority Indicator
                  Container(
                    padding: EdgeInsets.all(1.w),
                    decoration: BoxDecoration(
                      color: _getPriorityColor(priority).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: CustomIconWidget(
                      iconName: _getPriorityIcon(priority),
                      color: _getPriorityColor(priority),
                      size: 16,
                    ),
                  ),

                  SizedBox(width: 2.w),

                  // Type Badge
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: _getTypeColor(type).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      type.toUpperCase(),
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: _getTypeColor(type),
                        fontWeight: FontWeight.w600,
                        fontSize: 10.sp,
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Date
                  Text(
                    '${announcementDate.day}/${announcementDate.month}/${announcementDate.year}',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),

                  SizedBox(width: 2.w),

                  // Dismiss Icon
                  CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 16,
                  ),
                ],
              ),

              SizedBox(height: 2.h),

              // Title
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: 1.h),

              // Message
              Text(
                message,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: 1.h),

              // Swipe hint
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Swipe left to dismiss',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                          .withValues(alpha: 0.7),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(width: 1.w),
                  CustomIconWidget(
                    iconName: 'swipe_left',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                        .withValues(alpha: 0.7),
                    size: 12,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return AppTheme.lightTheme.colorScheme.error;
      case 'medium':
        return const Color(0xFFD97706);
      case 'low':
        return AppTheme.lightTheme.colorScheme.tertiary;
      default:
        return AppTheme.lightTheme.colorScheme.secondary;
    }
  }

  String _getPriorityIcon(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return 'priority_high';
      case 'medium':
        return 'info';
      case 'low':
        return 'info_outline';
      default:
        return 'info';
    }
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'academic':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'facility':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'event':
        return const Color(0xFFD97706);
      default:
        return AppTheme.lightTheme.colorScheme.secondary;
    }
  }
}
