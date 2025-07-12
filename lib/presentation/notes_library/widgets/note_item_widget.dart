import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NoteItemWidget extends StatelessWidget {
  final Map<String, dynamic> note;
  final VoidCallback onDownload;
  final VoidCallback onShare;
  final VoidCallback onToggleFavorite;
  final VoidCallback onView;

  const NoteItemWidget({
    super.key,
    required this.note,
    required this.onDownload,
    required this.onShare,
    required this.onToggleFavorite,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    final title = note['title'] as String;
    final uploadDate = note['uploadDate'] as String;
    final fileSize = note['fileSize'] as String;
    final isDownloaded = note['isDownloaded'] as bool;
    final downloadProgress = note['downloadProgress'] as double;
    final isFavorite = note['isFavorite'] as bool;
    final fileType = note['fileType'] as String;

    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      child: Card(
        elevation: 1,
        shadowColor: AppTheme.lightTheme.colorScheme.shadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: InkWell(
          onTap: onView,
          onLongPress: () => _showContextMenu(context),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: EdgeInsets.all(3.w),
            child: Row(
              children: [
                // File Type Icon
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: _getFileTypeColor(fileType).withAlpha(26),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: CustomIconWidget(
                    iconName: 'picture_as_pdf',
                    color: _getFileTypeColor(fileType),
                    size: 20,
                  ),
                ),

                SizedBox(width: 3.w),

                // Note Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: AppTheme.lightTheme.textTheme.titleSmall
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isFavorite)
                            Padding(
                              padding: EdgeInsets.only(left: 2.w),
                              child: CustomIconWidget(
                                iconName: 'favorite',
                                color: AppTheme.lightTheme.colorScheme.error,
                                size: 16,
                              ),
                            ),
                        ],
                      ),

                      SizedBox(height: 0.5.h),

                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'schedule',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 12,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            uploadDate,
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          SizedBox(width: 3.w),
                          CustomIconWidget(
                            iconName: 'folder',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 12,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            fileSize,
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),

                      // Download Progress (if downloading)
                      if (downloadProgress > 0 && downloadProgress < 1.0) ...[
                        SizedBox(height: 1.h),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Downloading...',
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  '${(downloadProgress * 100).round()}%',
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 0.5.h),
                            LinearProgressIndicator(
                              value: downloadProgress,
                              backgroundColor: AppTheme
                                  .lightTheme.colorScheme.outline
                                  .withAlpha(51),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppTheme.lightTheme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                SizedBox(width: 2.w),

                // Action Buttons
                Column(
                  children: [
                    if (isDownloaded)
                      Container(
                        padding: EdgeInsets.all(1.w),
                        decoration: BoxDecoration(
                          color:
                              AppTheme.lightTheme.colorScheme.tertiaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: CustomIconWidget(
                          iconName: 'check_circle',
                          color: AppTheme.lightTheme.colorScheme.tertiary,
                          size: 16,
                        ),
                      )
                    else if (downloadProgress > 0 && downloadProgress < 1.0)
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          value: downloadProgress,
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.lightTheme.colorScheme.primary,
                          ),
                        ),
                      )
                    else
                      IconButton(
                        onPressed: onDownload,
                        icon: CustomIconWidget(
                          iconName: 'download',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 20,
                        ),
                        tooltip: 'Download',
                        visualDensity: VisualDensity.compact,
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

  Color _getFileTypeColor(String fileType) {
    switch (fileType.toLowerCase()) {
      case 'pdf':
        return const Color(0xFFD32F2F);
      case 'doc':
      case 'docx':
        return const Color(0xFF1976D2);
      case 'ppt':
      case 'pptx':
        return const Color(0xFFD84315);
      case 'xls':
      case 'xlsx':
        return const Color(0xFF388E3C);
      default:
        return AppTheme.lightTheme.colorScheme.secondary;
    }
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.bottomSheetTheme.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              note['title'] as String,
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 3.h),
            _buildMenuOption(
              context: context,
              icon: note['isDownloaded'] as bool ? 'visibility' : 'download',
              title: note['isDownloaded'] as bool ? 'View Note' : 'Download',
              onTap: () {
                Navigator.pop(context);
                if (note['isDownloaded'] as bool) {
                  onView();
                } else {
                  onDownload();
                }
              },
            ),
            _buildMenuOption(
              context: context,
              icon: note['isFavorite'] as bool ? 'favorite' : 'favorite_border',
              title: note['isFavorite'] as bool
                  ? 'Remove from Favorites'
                  : 'Add to Favorites',
              onTap: () {
                Navigator.pop(context);
                onToggleFavorite();
              },
            ),
            _buildMenuOption(
              context: context,
              icon: 'share',
              title: 'Share Note',
              onTap: () {
                Navigator.pop(context);
                onShare();
              },
            ),
            _buildMenuOption(
              context: context,
              icon: 'playlist_add',
              title: 'Add to Reading List',
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Added to reading list')),
                );
              },
            ),
            _buildMenuOption(
              context: context,
              icon: 'report',
              title: 'Report Issue',
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Issue reported')),
                );
              },
              textColor: AppTheme.lightTheme.colorScheme.error,
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuOption({
    required BuildContext context,
    required String icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: icon,
        color: textColor ?? AppTheme.lightTheme.colorScheme.onSurface,
        size: 20,
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
          color: textColor ?? AppTheme.lightTheme.colorScheme.onSurface,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
