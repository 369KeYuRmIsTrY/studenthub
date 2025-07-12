import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/academic_info_widget.dart';
import './widgets/contact_info_widget.dart';
import './widgets/profile_info_card_widget.dart';
import './widgets/profile_photo_widget.dart';
import './widgets/profile_settings_widget.dart';

class StudentProfile extends StatefulWidget {
  const StudentProfile({super.key});

  @override
  State<StudentProfile> createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isEditing = false;
  bool _isSaving = false;
  bool _hasUnsavedChanges = false;

  // Student data controllers
  late TextEditingController _nameController;
  late TextEditingController _rollNumberController;
  late TextEditingController _studentIdController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _emergencyContactController;
  late TextEditingController _addressController;

  // Student data
  Map<String, dynamic> studentData = {
    'id': 'STU2024001',
    'name': 'Sarah Johnson',
    'rollNumber': 'CS21B1001',
    'studentId': 'STU2024001',
    'semester': '6th Semester',
    'course': 'Computer Science Engineering',
    'department': 'Computer Science',
    'enrollmentDate': '2021-08-15',
    'expectedGraduation': '2025-05-30',
    'currentGPA': 8.75,
    'profileImage':
        'https://images.unsplash.com/photo-1494790108755-2616b612b786?fm=jpg&q=60&w=400&ixlib=rb-4.0.3',
    'email': 'sarah.johnson@university.edu',
    'phone': '+1 (555) 123-4567',
    'emergencyContact': '+1 (555) 987-6543',
    'address': '123 University Street, College Town, CT 06510',
    'dateOfBirth': '2003-03-15',
    'bloodGroup': 'A+',
    'nationality': 'American',
  };

  // Settings data
  Map<String, dynamic> settingsData = {
    'notificationsEnabled': true,
    'emailNotifications': true,
    'smsNotifications': false,
    'academicUpdates': true,
    'eventNotifications': true,
    'privacyLevel': 'Friends',
    'profileVisibility': 'University',
    'contactInfoVisible': false,
  };

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _nameController = TextEditingController(text: studentData['name']);
    _rollNumberController =
        TextEditingController(text: studentData['rollNumber']);
    _studentIdController =
        TextEditingController(text: studentData['studentId']);
    _emailController = TextEditingController(text: studentData['email']);
    _phoneController = TextEditingController(text: studentData['phone']);
    _emergencyContactController =
        TextEditingController(text: studentData['emergencyContact']);
    _addressController = TextEditingController(text: studentData['address']);

    // Add listeners to detect changes
    _nameController.addListener(_onFieldChanged);
    _emailController.addListener(_onFieldChanged);
    _phoneController.addListener(_onFieldChanged);
    _emergencyContactController.addListener(_onFieldChanged);
    _addressController.addListener(_onFieldChanged);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _rollNumberController.dispose();
    _studentIdController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _emergencyContactController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _onFieldChanged() {
    if (!_hasUnsavedChanges) {
      setState(() {
        _hasUnsavedChanges = true;
      });
    }
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        _hasUnsavedChanges = false;
        // Reset controllers to original values
        _initializeControllers();
      }
    });
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    // Update student data
    studentData.addAll({
      'name': _nameController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
      'emergencyContact': _emergencyContactController.text,
      'address': _addressController.text,
    });

    setState(() {
      _isSaving = false;
      _isEditing = false;
      _hasUnsavedChanges = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Profile updated successfully',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: Colors.white,
            ),
          ),
          backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(4.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }

  void _onPhotoChanged(String newImageUrl) {
    setState(() {
      studentData['profileImage'] = newImageUrl;
      _hasUnsavedChanges = true;
    });
  }

  void _onSettingChanged(String key, dynamic value) {
    setState(() {
      settingsData[key] = value;
    });
  }

  Future<bool> _onWillPop() async {
    if (_hasUnsavedChanges) {
      final result = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppTheme.lightTheme.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            'Unsaved Changes',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          content: Text(
            'You have unsaved changes. Do you want to discard them?',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                'Discard',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.error,
                ),
              ),
            ),
          ],
        ),
      );
      return result ?? false;
    }
    return true;
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.lightTheme.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Text(
          'Logout',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          'Are you sure you want to logout? This will clear all your local data.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Handle logout logic here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logged out successfully')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_hasUnsavedChanges,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          final shouldPop = await _onWillPop();
          if (shouldPop && mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
          elevation: 0,
          title: Text(
            'Student Profile',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
          actions: [
            if (_isEditing) ...[
              if (_isSaving)
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                  ),
                )
              else
                TextButton(
                  onPressed: _hasUnsavedChanges ? _saveChanges : null,
                  child: Text(
                    'Save',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: _hasUnsavedChanges
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ] else
              IconButton(
                onPressed: _toggleEditing,
                icon: CustomIconWidget(
                  iconName: 'edit',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
                tooltip: 'Edit Profile',
              ),
            SizedBox(width: 2.w),
          ],
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Photo
                ProfilePhotoWidget(
                  imageUrl: studentData['profileImage'],
                  isEditing: _isEditing,
                  onPhotoChanged: _onPhotoChanged,
                ),

                SizedBox(height: 3.h),

                // Basic Information Card
                ProfileInfoCardWidget(
                  title: 'Basic Information',
                  isEditing: _isEditing,
                  children: [
                    _buildEditableField(
                      label: 'Full Name',
                      controller: _nameController,
                      icon: 'person',
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Name is required';
                        }
                        return null;
                      },
                    ),
                    _buildReadOnlyField(
                      label: 'Roll Number',
                      value: studentData['rollNumber'],
                      icon: 'badge',
                    ),
                    _buildReadOnlyField(
                      label: 'Student ID',
                      value: studentData['studentId'],
                      icon: 'numbers',
                    ),
                    _buildReadOnlyField(
                      label: 'Current Semester',
                      value: studentData['semester'],
                      icon: 'school',
                    ),
                  ],
                ),

                SizedBox(height: 3.h),

                // Academic Information
                AcademicInfoWidget(
                  academicData: {
                    'course': studentData['course'],
                    'department': studentData['department'],
                    'enrollmentDate': studentData['enrollmentDate'],
                    'expectedGraduation': studentData['expectedGraduation'],
                    'currentGPA': studentData['currentGPA'],
                  },
                ),

                SizedBox(height: 3.h),

                // Contact Information Card
                ContactInfoWidget(
                  isEditing: _isEditing,
                  emailController: _emailController,
                  phoneController: _phoneController,
                  emergencyContactController: _emergencyContactController,
                  addressController: _addressController,
                ),

                SizedBox(height: 3.h),

                // Settings Section
                ProfileSettingsWidget(
                  settingsData: settingsData,
                  onSettingChanged: _onSettingChanged,
                  onLogout: _showLogoutDialog,
                ),

                SizedBox(height: 10.h), // Bottom padding
              ],
            ),
          ),
        ),
      ),
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
          if (_isEditing)
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
            Container(
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
        ],
      ),
    );
  }

  Widget _buildReadOnlyField({
    required String label,
    required String value,
    required String icon,
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
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest
                  .withAlpha(128),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline.withAlpha(128),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              value,
              style: AppTheme.dataTextStyle(
                isLight: true,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
