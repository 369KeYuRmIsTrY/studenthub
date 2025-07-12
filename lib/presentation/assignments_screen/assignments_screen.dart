import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/assignment_card_widget.dart';
import './widgets/assignment_filter_widget.dart';
import './widgets/assignment_search_widget.dart';

class AssignmentsScreen extends StatefulWidget {
  const AssignmentsScreen({Key? key}) : super(key: key);

  @override
  State<AssignmentsScreen> createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends State<AssignmentsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  String _selectedFilter = 'All';
  bool _isLoading = false;

  final List<Map<String, dynamic>> _assignments = [
    {
      "id": 1,
      "subject": "Computer Science",
      "title": "Data Structures Implementation",
      "description":
          "Implement binary search tree with insertion, deletion, and traversal operations. Include proper documentation and test cases.",
      "dueDate": DateTime(2025, 7, 15, 23, 59),
      "uploadDate": DateTime(2025, 7, 1, 10, 30),
      "status": "pending",
      "priority": "high",
      "maxMarks": 100,
      "submissionType": "file",
      "attachments": [
        {
          "name": "Assignment_Guidelines.pdf",
          "url": "https://example.com/guidelines.pdf",
          "size": "2.5 MB"
        }
      ],
      "instructor": "Dr. Sarah Johnson",
      "isOverdue": false,
      "isDueSoon": true,
      "hasNote": false,
      "isPriority": true
    },
    {
      "id": 2,
      "subject": "Mathematics",
      "title": "Calculus Problem Set 3",
      "description":
          "Solve differential equations and integration problems from chapter 8. Show all working steps clearly.",
      "dueDate": DateTime(2025, 7, 18, 23, 59),
      "uploadDate": DateTime(2025, 7, 3, 14, 15),
      "status": "submitted",
      "priority": "medium",
      "maxMarks": 50,
      "submissionType": "file",
      "submittedDate": DateTime(2025, 7, 10, 16, 30),
      "attachments": [
        {
          "name": "Problem_Set_3.pdf",
          "url": "https://example.com/problemset.pdf",
          "size": "1.8 MB"
        }
      ],
      "instructor": "Prof. Michael Chen",
      "isOverdue": false,
      "isDueSoon": false,
      "hasNote": true,
      "isPriority": false
    },
    {
      "id": 3,
      "subject": "Physics",
      "title": "Lab Report - Wave Interference",
      "description":
          "Analyze wave interference patterns and calculate wavelengths. Include experimental setup, observations, and conclusions.",
      "dueDate": DateTime(2025, 7, 12, 23, 59),
      "uploadDate": DateTime(2025, 6, 28, 9, 45),
      "status": "overdue",
      "priority": "high",
      "maxMarks": 75,
      "submissionType": "file",
      "attachments": [
        {
          "name": "Lab_Instructions.pdf",
          "url": "https://example.com/lab_instructions.pdf",
          "size": "3.2 MB"
        },
        {
          "name": "Data_Template.xlsx",
          "url": "https://example.com/template.xlsx",
          "size": "0.8 MB"
        }
      ],
      "instructor": "Dr. Emily Rodriguez",
      "isOverdue": true,
      "isDueSoon": false,
      "hasNote": false,
      "isPriority": true
    },
    {
      "id": 4,
      "subject": "English Literature",
      "title": "Essay on Modern Poetry",
      "description":
          "Write a 2000-word essay analyzing themes in contemporary poetry. Include at least 5 scholarly references.",
      "dueDate": DateTime(2025, 7, 25, 23, 59),
      "uploadDate": DateTime(2025, 7, 5, 11, 20),
      "status": "graded",
      "priority": "medium",
      "maxMarks": 100,
      "submissionType": "file",
      "submittedDate": DateTime(2025, 7, 8, 14, 45),
      "grade": 85,
      "feedback":
          "Excellent analysis of themes. Consider expanding on the historical context in future essays.",
      "attachments": [
        {
          "name": "Essay_Guidelines.pdf",
          "url": "https://example.com/essay_guidelines.pdf",
          "size": "1.5 MB"
        }
      ],
      "instructor": "Prof. David Thompson",
      "isOverdue": false,
      "isDueSoon": false,
      "hasNote": false,
      "isPriority": false
    },
    {
      "id": 5,
      "subject": "Chemistry",
      "title": "Organic Synthesis Project",
      "description":
          "Design and propose a synthetic route for the given organic compound. Include mechanism and yield calculations.",
      "dueDate": DateTime(2025, 7, 20, 23, 59),
      "uploadDate": DateTime(2025, 7, 2, 13, 10),
      "status": "pending",
      "priority": "high",
      "maxMarks": 120,
      "submissionType": "file",
      "attachments": [
        {
          "name": "Project_Brief.pdf",
          "url": "https://example.com/project_brief.pdf",
          "size": "2.1 MB"
        }
      ],
      "instructor": "Dr. Lisa Wang",
      "isOverdue": false,
      "isDueSoon": false,
      "hasNote": true,
      "isPriority": false
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredAssignments {
    List<Map<String, dynamic>> filtered = _assignments;

    // Filter by tab
    switch (_tabController.index) {
      case 0: // Pending
        filtered = filtered
            .where((assignment) =>
                (assignment["status"] as String) == "pending" ||
                (assignment["status"] as String) == "overdue")
            .toList();
        break;
      case 1: // Submitted
        filtered = filtered
            .where(
                (assignment) => (assignment["status"] as String) == "submitted")
            .toList();
        break;
      case 2: // Graded
        filtered = filtered
            .where((assignment) => (assignment["status"] as String) == "graded")
            .toList();
        break;
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((assignment) =>
              (assignment["title"] as String)
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              (assignment["subject"] as String)
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
          .toList();
    }

    // Filter by subject
    if (_selectedFilter != 'All') {
      filtered = filtered
          .where((assignment) =>
              (assignment["subject"] as String) == _selectedFilter)
          .toList();
    }

    return filtered;
  }

  int get _pendingCount => _assignments
      .where((a) =>
          (a["status"] as String) == "pending" ||
          (a["status"] as String) == "overdue")
      .length;

  int get _submittedCount =>
      _assignments.where((a) => (a["status"] as String) == "submitted").length;

  int get _gradedCount =>
      _assignments.where((a) => (a["status"] as String) == "graded").length;

  Future<void> _refreshAssignments() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _onFilterChanged(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
  }

  void _onAssignmentTap(Map<String, dynamic> assignment) {
    // Navigate to assignment details or submission screen
    Navigator.pushNamed(context, '/assignment-submission');
  }

  void _onStartSubmission(Map<String, dynamic> assignment) {
    Navigator.pushNamed(context, '/assignment-submission');
  }

  void _onSetReminder(Map<String, dynamic> assignment) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reminder set for ${assignment["title"]}'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
      ),
    );
  }

  void _onDownloadResources(Map<String, dynamic> assignment) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloading resources for ${assignment["title"]}'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }

  void _onMarkPriority(Map<String, dynamic> assignment) {
    setState(() {
      assignment["isPriority"] = !(assignment["isPriority"] as bool);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(assignment["isPriority"]
            ? 'Marked as priority'
            : 'Removed from priority'),
      ),
    );
  }

  void _onAddNote(Map<String, dynamic> assignment) {
    setState(() {
      assignment["hasNote"] = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Note added to assignment')),
    );
  }

  void _onShareAssignment(Map<String, dynamic> assignment) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sharing ${assignment["title"]} with classmates')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          'Assignments',
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        actions: [
          IconButton(
            onPressed: () => _refreshAssignments(),
            icon: CustomIconWidget(
              iconName: 'refresh',
              color: AppTheme.lightTheme.primaryColor,
              size: 24,
            ),
          ),
          SizedBox(width: 2.w),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(12.h),
          child: Column(
            children: [
              // Search Bar
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                child: AssignmentSearchWidget(
                  onSearchChanged: _onSearchChanged,
                ),
              ),

              // Filter Options
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: AssignmentFilterWidget(
                  selectedFilter: _selectedFilter,
                  onFilterChanged: _onFilterChanged,
                  assignments: _assignments,
                ),
              ),

              // Tab Bar
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: AppTheme.cardShadow(isLight: true),
                ),
                child: TabBar(
                  controller: _tabController,
                  onTap: (index) => setState(() {}),
                  indicator: BoxDecoration(
                    color: AppTheme.lightTheme.primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorPadding: EdgeInsets.all(1.w),
                  labelColor: Colors.white,
                  unselectedLabelColor:
                      AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  labelStyle:
                      AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle:
                      AppTheme.lightTheme.textTheme.labelMedium,
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Pending'),
                          SizedBox(width: 1.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 1.5.w, vertical: 0.3.h),
                            decoration: BoxDecoration(
                              color: _tabController.index == 0
                                  ? Colors.white.withValues(alpha: 0.2)
                                  : AppTheme.lightTheme.colorScheme.error
                                      .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '$_pendingCount',
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                                color: _tabController.index == 0
                                    ? Colors.white
                                    : AppTheme.lightTheme.colorScheme.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Submitted'),
                          SizedBox(width: 1.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 1.5.w, vertical: 0.3.h),
                            decoration: BoxDecoration(
                              color: _tabController.index == 1
                                  ? Colors.white.withValues(alpha: 0.2)
                                  : AppTheme.lightTheme.colorScheme.tertiary
                                      .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '$_submittedCount',
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                                color: _tabController.index == 1
                                    ? Colors.white
                                    : AppTheme.lightTheme.colorScheme.tertiary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Graded'),
                          SizedBox(width: 1.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 1.5.w, vertical: 0.3.h),
                            decoration: BoxDecoration(
                              color: _tabController.index == 2
                                  ? Colors.white.withValues(alpha: 0.2)
                                  : AppTheme.lightTheme.primaryColor
                                      .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '$_gradedCount',
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                                color: _tabController.index == 2
                                    ? Colors.white
                                    : AppTheme.lightTheme.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAssignmentsList(),
          _buildAssignmentsList(),
          _buildAssignmentsList(),
        ],
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton.extended(
              onPressed: () =>
                  Navigator.pushNamed(context, '/assignment-submission'),
              backgroundColor: AppTheme.lightTheme.primaryColor,
              foregroundColor: Colors.white,
              icon: CustomIconWidget(
                iconName: 'upload_file',
                color: Colors.white,
                size: 20,
              ),
              label: Text(
                'Submit Assignment',
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildAssignmentsList() {
    final filteredAssignments = _filteredAssignments;

    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: AppTheme.lightTheme.primaryColor,
        ),
      );
    }

    if (filteredAssignments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'assignment',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 64,
            ),
            SizedBox(height: 2.h),
            Text(
              'No assignments found',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              _searchQuery.isNotEmpty
                  ? 'Try adjusting your search criteria'
                  : 'Check back later for new assignments',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshAssignments,
      color: AppTheme.lightTheme.primaryColor,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        itemCount: filteredAssignments.length,
        itemBuilder: (context, index) {
          final assignment = filteredAssignments[index];
          return AssignmentCardWidget(
            assignment: assignment,
            onTap: () => _onAssignmentTap(assignment),
            onStartSubmission: () => _onStartSubmission(assignment),
            onSetReminder: () => _onSetReminder(assignment),
            onDownloadResources: () => _onDownloadResources(assignment),
            onMarkPriority: () => _onMarkPriority(assignment),
            onAddNote: () => _onAddNote(assignment),
            onShare: () => _onShareAssignment(assignment),
          );
        },
      ),
    );
  }
}
