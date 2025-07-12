import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProfilePhotoWidget extends StatelessWidget {
  final String imageUrl;
  final bool isEditing;
  final Function(String) onPhotoChanged;

  const ProfilePhotoWidget({
    super.key,
    required this.imageUrl,
    required this.isEditing,
    required this.onPhotoChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          // Profile Image
          Container(
            width: 35.w,
            height: 35.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.primary,
                width: 3,
              ),
              boxShadow: AppTheme.elevatedShadow(isLight: true),
            ),
            child: ClipOval(
              child: CustomImageWidget(
                imageUrl: imageUrl,
                width: 35.w,
                height: 35.w,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Edit Button (when editing)
          if (isEditing)
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: () => _showPhotoOptions(context),
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.lightTheme.cardColor,
                      width: 2,
                    ),
                    boxShadow: AppTheme.cardShadow(isLight: true),
                  ),
                  child: CustomIconWidget(
                    iconName: 'camera_alt',
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showPhotoOptions(BuildContext context) {
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
              'Change Profile Photo',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            _buildPhotoOption(
              context: context,
              icon: 'camera_alt',
              title: 'Take Photo',
              subtitle: 'Capture a new photo',
              onTap: () {
                Navigator.pop(context);
                _simulatePhotoCapture();
              },
            ),
            _buildPhotoOption(
              context: context,
              icon: 'photo_library',
              title: 'Choose from Gallery',
              subtitle: 'Select from your photos',
              onTap: () {
                Navigator.pop(context);
                _simulateGalleryPick();
              },
            ),
            if (imageUrl.isNotEmpty)
              _buildPhotoOption(
                context: context,
                icon: 'delete',
                title: 'Remove Photo',
                subtitle: 'Use default avatar',
                onTap: () {
                  Navigator.pop(context);
                  onPhotoChanged('');
                },
                textColor: AppTheme.lightTheme.colorScheme.error,
              ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoOption({
    required BuildContext context,
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: (textColor ?? AppTheme.lightTheme.colorScheme.primary)
              .withAlpha(26),
          borderRadius: BorderRadius.circular(8),
        ),
        child: CustomIconWidget(
          iconName: icon,
          color: textColor ?? AppTheme.lightTheme.colorScheme.primary,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
          color: textColor ?? AppTheme.lightTheme.colorScheme.onSurface,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          color: textColor?.withAlpha(179) ??
              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  void _simulatePhotoCapture() {
    // Simulate camera capture with a new image URL
    final newImageUrl =
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?fm=jpg&q=60&w=400&ixlib=rb-4.0.3';
    onPhotoChanged(newImageUrl);
  }

  void _simulateGalleryPick() {
    // Simulate gallery pick with a different image URL
    final newImageUrl =
        'https://images.unsplash.com/photo-1517841905240-472988babdf9?fm=jpg&q=60&w=400&ixlib=rb-4.0.3';
    onPhotoChanged(newImageUrl);
  }
}
