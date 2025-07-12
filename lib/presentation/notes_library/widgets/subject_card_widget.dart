import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SubjectCardWidget extends StatelessWidget {
  final String subjectName;
  final Map<String, dynamic> subjectData;
  final bool isExpanded;
  final VoidCallback onToggleExpansion;

  const SubjectCardWidget({
    super.key,
    required this.subjectName,
    required this.subjectData,
    required this.isExpanded,
    required this.onToggleExpansion,
  });

  @override
  Widget build(BuildContext context) {
    final totalNotes = subjectData['totalNotes'] as int;
    final courseCode = subjectData['courseCode'] as String;
    final lastUpdated = subjectData['lastUpdated'] as String;

    // Calculate downloaded notes count
    final weeks = subjectData['weeks'] as Map<String, dynamic>;
    int downloadedCount = 0;
    for (var notes in weeks.values) {
      for (var note in notes as List) {
        if (note['isDownloaded'] == true) downloadedCount++;
      }
    }

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Card(
        elevation: 2,
        shadowColor: AppTheme.lightTheme.colorScheme.shadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: onToggleExpansion,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Subject Icon
                    Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CustomIconWidget(
                        iconName: _getSubjectIcon(subjectName),
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 20,
                      ),
                    ),

                    SizedBox(width: 3.w),

                    // Subject Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            subjectName,
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            courseCode,
                            style: AppTheme.dataTextStyle(
                              isLight: true,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Expansion Arrow
                    AnimatedRotation(
                      duration: const Duration(milliseconds: 200),
                      turns: isExpanded ? 0.5 : 0,
                      child: CustomIconWidget(
                        iconName: 'expand_more',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 2.h),

                // Stats Row
                Row(
                  children: [
                    Expanded(
                      child: _buildStatItem(
                        icon: 'description',
                        label: 'Total Notes',
                        value: totalNotes.toString(),
                      ),
                    ),
                    Container(
                      height: 4.h,
                      width: 1,
                      color: AppTheme.lightTheme.colorScheme.outline,
                    ),
                    Expanded(
                      child: _buildStatItem(
                        icon: 'download_done',
                        label: 'Downloaded',
                        value: '$downloadedCount/$totalNotes',
                        valueColor: downloadedCount == totalNotes
                            ? AppTheme.lightTheme.colorScheme.tertiary
                            : null,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 2.h),

                // Download Progress Bar
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Download Progress',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          '${(downloadedCount / totalNotes * 100).round()}%',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    LinearProgressIndicator(
                      value: downloadedCount / totalNotes,
                      backgroundColor:
                          AppTheme.lightTheme.colorScheme.outline.withAlpha(51),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        downloadedCount == totalNotes
                            ? AppTheme.lightTheme.colorScheme.tertiary
                            : AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 2.h),

                // Last Updated
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'schedule',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 14,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Last updated: $lastUpdated',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required String icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Column(
      children: [
        CustomIconWidget(
          iconName: icon,
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          size: 20,
        ),
        SizedBox(height: 1.h),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: valueColor ?? AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  String _getSubjectIcon(String subjectName) {
    switch (subjectName.toLowerCase()) {
      case 'computer science':
        return 'computer';
      case 'mathematics':
        return 'calculate';
      case 'physics':
        return 'science';
      case 'chemistry':
        return 'biotech';
      case 'biology':
        return 'eco';
      case 'english':
        return 'book';
      case 'history':
        return 'history_edu';
      case 'geography':
        return 'public';
      default:
        return 'subject';
    }
  }
}
