import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProfileSettingsWidget extends StatelessWidget {
  final Map<String, dynamic> settingsData;
  final Function(String, dynamic) onSettingChanged;
  final VoidCallback onLogout;

  const ProfileSettingsWidget({
    super.key,
    required this.settingsData,
    required this.onSettingChanged,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppTheme.cardShadow(isLight: true),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: 'settings',
                  color: AppTheme.lightTheme.colorScheme.secondary,
                  size: 20,
                ),
              ),
              SizedBox(width: 3.w),
              Text(
                'Settings & Privacy',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Notifications Section
          _buildSectionHeader('Notifications'),

          _buildSwitchTile(
            title: 'Push Notifications',
            subtitle: 'Receive notifications on this device',
            icon: 'notifications',
            value: settingsData['notificationsEnabled'],
            onChanged: (value) =>
                onSettingChanged('notificationsEnabled', value),
          ),

          _buildSwitchTile(
            title: 'Email Notifications',
            subtitle: 'Receive updates via email',
            icon: 'email',
            value: settingsData['emailNotifications'],
            onChanged: (value) => onSettingChanged('emailNotifications', value),
            enabled: settingsData['notificationsEnabled'],
          ),

          _buildSwitchTile(
            title: 'SMS Notifications',
            subtitle: 'Receive updates via text messages',
            icon: 'sms',
            value: settingsData['smsNotifications'],
            onChanged: (value) => onSettingChanged('smsNotifications', value),
            enabled: settingsData['notificationsEnabled'],
          ),

          SizedBox(height: 3.h),

          // Content Preferences
          _buildSectionHeader('Content Preferences'),

          _buildSwitchTile(
            title: 'Academic Updates',
            subtitle: 'Grades, assignments, and course updates',
            icon: 'school',
            value: settingsData['academicUpdates'],
            onChanged: (value) => onSettingChanged('academicUpdates', value),
          ),

          _buildSwitchTile(
            title: 'Event Notifications',
            subtitle: 'Campus events and activities',
            icon: 'event',
            value: settingsData['eventNotifications'],
            onChanged: (value) => onSettingChanged('eventNotifications', value),
          ),

          SizedBox(height: 3.h),

          // Privacy Section
          _buildSectionHeader('Privacy'),

          _buildOptionTile(
            title: 'Privacy Level',
            subtitle: 'Who can see your profile',
            icon: 'privacy_tip',
            value: settingsData['privacyLevel'],
            options: ['Everyone', 'University', 'Friends', 'Private'],
            onChanged: (value) => onSettingChanged('privacyLevel', value),
          ),

          _buildOptionTile(
            title: 'Profile Visibility',
            subtitle: 'How others can find you',
            icon: 'visibility',
            value: settingsData['profileVisibility'],
            options: ['Public', 'University', 'Friends Only', 'Hidden'],
            onChanged: (value) => onSettingChanged('profileVisibility', value),
          ),

          _buildSwitchTile(
            title: 'Show Contact Info',
            subtitle: 'Allow others to see your contact details',
            icon: 'contact_phone',
            value: settingsData['contactInfoVisible'],
            onChanged: (value) => onSettingChanged('contactInfoVisible', value),
          ),

          SizedBox(height: 3.h),

          // Account Actions
          _buildSectionHeader('Account'),

          _buildActionTile(
            title: 'Data Export',
            subtitle: 'Download your data',
            icon: 'download',
            onTap: () => _showDataExportDialog(context),
          ),

          _buildActionTile(
            title: 'Account Security',
            subtitle: 'Password and security settings',
            icon: 'security',
            onTap: () => _showSecurityDialog(context),
          ),

          _buildActionTile(
            title: 'Help & Support',
            subtitle: 'Get help or contact support',
            icon: 'help',
            onTap: () => _showHelpDialog(context),
          ),

          SizedBox(height: 2.h),

          // Logout Button
          Container(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onLogout,
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.error,
                ),
                foregroundColor: AppTheme.lightTheme.colorScheme.error,
                padding: EdgeInsets.symmetric(vertical: 2.h),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'logout',
                    color: AppTheme.lightTheme.colorScheme.error,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Logout',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Text(
        title,
        style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: AppTheme.lightTheme.colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required String icon,
    required bool value,
    required Function(bool) onChanged,
    bool enabled = true,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      child: ListTile(
        leading: CustomIconWidget(
          iconName: icon,
          color: enabled
              ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
              : AppTheme.lightTheme.colorScheme.onSurfaceVariant.withAlpha(128),
          size: 20,
        ),
        title: Text(
          title,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: enabled
                ? AppTheme.lightTheme.colorScheme.onSurface
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: enabled
                ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                    .withAlpha(128),
          ),
        ),
        trailing: Switch(
          value: enabled ? value : false,
          onChanged: enabled ? onChanged : null,
        ),
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required String title,
    required String subtitle,
    required String icon,
    required String value,
    required List<String> options,
    required Function(String) onChanged,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      child: ListTile(
        leading: CustomIconWidget(
          iconName: icon,
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          size: 20,
        ),
        title: Text(
          title,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 2.w),
            CustomIconWidget(
              iconName: 'chevron_right',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 16,
            ),
          ],
        ),
        onTap: () => _showOptionSelector(title, value, options, onChanged),
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required String title,
    required String subtitle,
    required String icon,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      child: ListTile(
        leading: CustomIconWidget(
          iconName: icon,
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          size: 20,
        ),
        title: Text(
          title,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: CustomIconWidget(
          iconName: 'chevron_right',
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          size: 16,
        ),
        onTap: onTap,
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _showOptionSelector(
    String title,
    String currentValue,
    List<String> options,
    Function(String) onChanged,
  ) {
    // Implementation for option selector dialog
  }

  void _showDataExportDialog(BuildContext context) {
    // Implementation for data export dialog
  }

  void _showSecurityDialog(BuildContext context) {
    // Implementation for security dialog
  }

  void _showHelpDialog(BuildContext context) {
    // Implementation for help dialog
  }
}
