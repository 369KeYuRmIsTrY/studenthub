import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/assignment_details_widget.dart';
import './widgets/file_upload_widget.dart';
import './widgets/submission_form_widget.dart';

class AssignmentSubmission extends StatefulWidget {
  const AssignmentSubmission({super.key});

  @override
  State<AssignmentSubmission> createState() => _AssignmentSubmissionState();
}

class _AssignmentSubmissionState extends State<AssignmentSubmission>
    with TickerProviderStateMixin {
  final TextEditingController _commentsController = TextEditingController();
  final List<Map<String, dynamic>> _selectedFiles = [];
  bool _isSubmitting = false;
  bool _hasUnsavedChanges = false;
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  // Mock assignment data
  final Map<String, dynamic> assignmentData = {
    "id": 1,
    "subject": "Computer Science",
    "title": "Data Structures and Algorithms Project",
    "description":
        """Implement a comprehensive binary search tree with the following operations:
    
1. Insert operation with duplicate handling
2. Delete operation with three cases
3. Search operation with path tracking
4. In-order, pre-order, and post-order traversals
5. Height calculation and balance factor
6. Visualization of tree structure

Requirements:
- Use any programming language (Python, Java, C++ preferred)
- Include comprehensive test cases
- Document time and space complexity
- Provide clear code comments
- Submit source code and documentation""",
    "dueDate": DateTime.now().add(const Duration(days: 3)),
    "uploadDate": DateTime.now().subtract(const Duration(days: 7)),
    "maxFileSize": "10 MB",
    "allowedFormats": ["PDF", "DOC", "DOCX", "ZIP", "JPG", "PNG"],
    "maxFiles": 5,
    "instructor": "Dr. Sarah Johnson",
    "points": 100,
    "submissionCount": 0,
    "isLate": false,
  };

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));

    _commentsController.addListener(() {
      if (!_hasUnsavedChanges && _commentsController.text.isNotEmpty) {
        setState(() {
          _hasUnsavedChanges = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _commentsController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    if (_hasUnsavedChanges || _selectedFiles.isNotEmpty) {
      return await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(
                'Unsaved Changes',
                style: AppTheme.lightTheme.textTheme.titleLarge,
              ),
              content: Text(
                'You have unsaved changes. Are you sure you want to leave?',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(
                    'Leave',
                    style:
                        TextStyle(color: AppTheme.lightTheme.colorScheme.error),
                  ),
                ),
              ],
            ),
          ) ??
          false;
    }
    return true;
  }

  void _addFiles() async {
    // Simulate file picker
    await Future.delayed(const Duration(milliseconds: 500));

    final List<Map<String, dynamic>> mockFiles = [
      {
        "name": "BST_Implementation.py",
        "size": "2.4 MB",
        "type": "Python",
        "icon": "code",
        "uploadProgress": 0.0,
      },
      {
        "name": "Test_Cases.pdf",
        "size": "1.8 MB",
        "type": "PDF",
        "icon": "picture_as_pdf",
        "uploadProgress": 0.0,
      },
      {
        "name": "Documentation.docx",
        "size": "956 KB",
        "type": "Document",
        "icon": "description",
        "uploadProgress": 0.0,
      },
    ];

    if (mounted) {
      HapticFeedback.lightImpact();
      setState(() {
        _selectedFiles.addAll(mockFiles);
        _hasUnsavedChanges = true;
      });

      // Simulate file upload progress
      for (int i = 0; i < _selectedFiles.length; i++) {
        _simulateFileUpload(i);
      }
    }
  }

  void _simulateFileUpload(int index) async {
    for (double progress = 0.0; progress <= 1.0; progress += 0.1) {
      await Future.delayed(const Duration(milliseconds: 200));
      if (mounted && index < _selectedFiles.length) {
        setState(() {
          _selectedFiles[index]["uploadProgress"] = progress;
        });
      }
    }
  }

  void _removeFile(int index) {
    HapticFeedback.lightImpact();
    setState(() {
      _selectedFiles.removeAt(index);
      if (_selectedFiles.isEmpty && _commentsController.text.isEmpty) {
        _hasUnsavedChanges = false;
      }
    });
  }

  void _submitAssignment() async {
    if (_selectedFiles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please add at least one file to submit'),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    _progressController.forward();
    HapticFeedback.mediumImpact();

    // Simulate submission process
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      setState(() {
        _isSubmitting = false;
        _hasUnsavedChanges = false;
      });

      HapticFeedback.heavyImpact();

      // Show success dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'check_circle',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Submission Successful',
                style: AppTheme.lightTheme.textTheme.titleLarge,
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your assignment has been submitted successfully.',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              SizedBox(height: 2.h),
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Submission Details:',
                      style: AppTheme.lightTheme.textTheme.labelLarge,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Receipt: #SUB-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
                      style:
                          AppTheme.dataTextStyle(isLight: true, fontSize: 12),
                    ),
                    Text(
                      'Submitted: ${DateTime.now().toString().substring(0, 16)}',
                      style:
                          AppTheme.dataTextStyle(isLight: true, fontSize: 12),
                    ),
                    Text(
                      'Files: ${_selectedFiles.length}',
                      style:
                          AppTheme.dataTextStyle(isLight: true, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Done'),
            ),
          ],
        ),
      );
    }
  }

  Duration get _timeRemaining {
    return (assignmentData["dueDate"] as DateTime).difference(DateTime.now());
  }

  String get _formattedTimeRemaining {
    final duration = _timeRemaining;
    if (duration.isNegative) return "Overdue";

    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;

    if (days > 0) {
      return "${days}d ${hours}h remaining";
    } else if (hours > 0) {
      return "${hours}h ${minutes}m remaining";
    } else {
      return "${minutes}m remaining";
    }
  }

  Color get _deadlineColor {
    final duration = _timeRemaining;
    if (duration.isNegative) return AppTheme.lightTheme.colorScheme.error;
    if (duration.inHours < 24) return AppTheme.lightTheme.colorScheme.error;
    if (duration.inDays < 3) return AppTheme.lightTheme.colorScheme.error;
    return AppTheme.lightTheme.colorScheme.tertiary;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text('Submit Assignment'),
          leading: IconButton(
            onPressed: () async {
              if (await _onWillPop()) {
                Navigator.of(context).pop();
              }
            },
            icon: CustomIconWidget(
              iconName: 'arrow_back',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 4.w),
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: _deadlineColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _deadlineColor),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'schedule',
                    color: _deadlineColor,
                    size: 16,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    _formattedTimeRemaining,
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: _deadlineColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Assignment Details
              AssignmentDetailsWidget(
                assignmentData: assignmentData,
              ),

              SizedBox(height: 3.h),

              // File Upload Section
              FileUploadWidget(
                selectedFiles: _selectedFiles,
                onAddFiles: _addFiles,
                onRemoveFile: _removeFile,
                maxFiles: assignmentData["maxFiles"] as int,
                allowedFormats:
                    (assignmentData["allowedFormats"] as List).cast<String>(),
                maxFileSize: assignmentData["maxFileSize"] as String,
              ),

              SizedBox(height: 3.h),

              // Submission Form
              SubmissionFormWidget(
                commentsController: _commentsController,
                onCommentsChanged: () {
                  if (!_hasUnsavedChanges) {
                    setState(() {
                      _hasUnsavedChanges = true;
                    });
                  }
                },
              ),

              SizedBox(height: 4.h),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 6.h,
                child: ElevatedButton(
                  onPressed: _selectedFiles.isNotEmpty && !_isSubmitting
                      ? _submitAssignment
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedFiles.isNotEmpty
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.outline,
                    foregroundColor: Colors.white,
                    elevation: _selectedFiles.isNotEmpty ? 2 : 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isSubmitting
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Text(
                              'Submitting...',
                              style: AppTheme.lightTheme.textTheme.labelLarge
                                  ?.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          'Submit Assignment',
                          style: AppTheme.lightTheme.textTheme.labelLarge
                              ?.copyWith(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),

              SizedBox(height: 2.h),

              // Submission Guidelines
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'info',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Submission Guidelines',
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      '• Maximum ${assignmentData["maxFiles"]} files allowed\n'
                      '• File size limit: ${assignmentData["maxFileSize"]} per file\n'
                      '• Supported formats: ${(assignmentData["allowedFormats"] as List).join(", ")}\n'
                      '• Late submissions may incur penalty\n'
                      '• Ensure all files are properly named',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }
}
