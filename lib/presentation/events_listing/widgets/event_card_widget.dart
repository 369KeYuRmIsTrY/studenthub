import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EventCardWidget extends StatelessWidget {
  final Map<String, dynamic> event;
  final VoidCallback onTap;
  final VoidCallback onAddToCalendar;
  final VoidCallback onShare;
  final VoidCallback onSetReminder;

  const EventCardWidget({
    super.key,
    required this.event,
    required this.onTap,
    required this.onAddToCalendar,
    required this.onShare,
    required this.onSetReminder,
  });

  @override
  Widget build(BuildContext context) {
    final isFeature = event['isFeature'] as bool? ?? false;

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Card(
        elevation: isFeature ? 4 : 2,
        shadowColor: AppTheme.lightTheme.colorScheme.shadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: isFeature
              ? BorderSide(
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
                  width: 1,
                )
              : BorderSide.none,
        ),
        child: InkWell(
          onTap: onTap,
          onLongPress: _showContextMenu,
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Image
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: Stack(
                  children: [
                    CustomImageWidget(
                      imageUrl: event['imageUrl'] as String,
                      width: double.infinity,
                      height: 25.h,
                      fit: BoxFit.cover,
                    ),
                    if (isFeature)
                      Positioned(
                        top: 2.h,
                        right: 4.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 3.w,
                            vertical: 0.5.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.primaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Featured',
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    // Category Badge
                    Positioned(
                      top: 2.h,
                      left: 4.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 3.w,
                          vertical: 0.5.h,
                        ),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(event['category'] as String),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          event['category'] as String,
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Event Content
              Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      event['title'] as String,
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: 1.h),

                    // Description
                    Text(
                      event['description'] as String,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: 2.h),

                    // Event Details Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildDetailItem(
                            icon: 'schedule',
                            text: '${event['date']} • ${event['time']}',
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 1.h),

                    Row(
                      children: [
                        Expanded(
                          child: _buildDetailItem(
                            icon: 'location_on',
                            text: event['location'] as String,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 1.h),

                    Row(
                      children: [
                        Expanded(
                          child: _buildDetailItem(
                            icon: 'people',
                            text: '${event['attendees']} attendees',
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 2.h),

                    // Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'By ${event['organizer']}',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: onAddToCalendar,
                              icon: CustomIconWidget(
                                iconName: 'calendar_today',
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                size: 20,
                              ),
                              tooltip: 'Add to Calendar',
                            ),
                            IconButton(
                              onPressed: onShare,
                              icon: CustomIconWidget(
                                iconName: 'share',
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                size: 20,
                              ),
                              tooltip: 'Share Event',
                            ),
                            IconButton(
                              onPressed: onSetReminder,
                              icon: CustomIconWidget(
                                iconName: 'notifications',
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                size: 20,
                              ),
                              tooltip: 'Set Reminder',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem({
    required String icon,
    required String text,
  }) {
    return Row(
      children: [
        CustomIconWidget(
          iconName: icon,
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          size: 16,
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: Text(
            text,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'academic':
        return AppTheme.lightTheme.primaryColor;
      case 'cultural':
        return const Color(0xFF9C27B0);
      case 'sports':
        return const Color(0xFF4CAF50);
      case 'workshops':
        return const Color(0xFFFF9800);
      case 'seminars':
        return const Color(0xFF2196F3);
      case 'competitions':
        return const Color(0xFFF44336);
      default:
        return AppTheme.lightTheme.colorScheme.secondary;
    }
  }

  void _showContextMenu() {
    // Context menu implementation would go here
    // For now, we'll just show the quick actions
  }
}
