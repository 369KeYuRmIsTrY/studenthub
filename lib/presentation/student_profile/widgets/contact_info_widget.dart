import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './profile_info_card_widget.dart';

class ContactInfoWidget extends StatelessWidget {
  final bool isEditing;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController emergencyContactController;
  final TextEditingController addressController;

  const ContactInfoWidget({
    super.key,
    required this.isEditing,
    required this.emailController,
    required this.phoneController,
    required this.emergencyContactController,
    required this.addressController,
  });

  @override
  Widget build(BuildContext context) {
    return ProfileInfoCardWidget(
      title: 'Contact Information',
      isEditing: isEditing,
      children: [
        _buildEditableField(
          label: 'Email Address',
          controller: emailController,
          icon: 'email',
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Email is required';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),

        _buildEditableField(
          label: 'Phone Number',
          controller: phoneController,
          icon: 'phone',
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Phone number is required';
            }
            return null;
          },
        ),

        _buildEditableField(
          label: 'Emergency Contact',
          controller: emergencyContactController,
          icon: 'emergency',
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Emergency contact is required';
            }
            return null;
          },
        ),

        _buildEditableField(
          label: 'Address',
          controller: addressController,
          icon: 'location_on',
          keyboardType: TextInputType.multiline,
          maxLines: 3,
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Address is required';
            }
            return null;
          },
        ),

        // Quick Contact Actions
        if (!isEditing) ...[
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest
                  .withAlpha(128),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick Actions',
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Expanded(
                      child: _buildQuickAction(
                        icon: 'call',
                        label: 'Call',
                        onTap: () => _makeCall(phoneController.text),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: _buildQuickAction(
                        icon: 'email',
                        label: 'Email',
                        onTap: () => _sendEmail(emailController.text),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: _buildQuickAction(
                        icon: 'emergency',
                        label: 'Emergency',
                        onTap: () => _makeCall(emergencyContactController.text),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildEditableField({
    required String label,
    required TextEditingController controller,
    required String icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: icon,
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 16,
              ),
              SizedBox(width: 2.w),
              Text(
                label,
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          if (isEditing)
            TextFormField(
              controller: controller,
              validator: validator,
              keyboardType: keyboardType,
              maxLines: maxLines,
              decoration: InputDecoration(
                hintText: 'Enter $label',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            )
          else
            GestureDetector(
              onLongPress: () => _copyToClipboard(controller.text, label),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  controller.text.isEmpty ? 'Not provided' : controller.text,
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildQuickAction({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 20,
            ),
            SizedBox(height: 1.h),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _makeCall(String phoneNumber) {
    // In a real app, this would use url_launcher to make a call
    // For now, we'll just show a snackbar
  }

  void _sendEmail(String email) {
    // In a real app, this would use url_launcher to open email client
    // For now, we'll just show a snackbar
  }

  void _copyToClipboard(String text, String label) {
    // In a real app, this would copy text to clipboard
    // For now, we'll just show a snackbar
  }
}
