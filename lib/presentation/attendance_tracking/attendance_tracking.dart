import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/attendance_filter_widget.dart';
import './widgets/attendance_stats_widget.dart';
import './widgets/monthly_calendar_widget.dart';
import './widgets/subject_attendance_card.dart';

class AttendanceTracking extends StatefulWidget {
  const AttendanceTracking({Key? key}) : super(key: key);

  @override
  State<AttendanceTracking> createState() => _AttendanceTrackingState();
}

class _AttendanceTrackingState extends State<AttendanceTracking>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  DateTime _selectedDate = DateTime.now();
  String _selectedSubject = 'All Subjects';
  DateTime _lastSyncTime = DateTime.now().subtract(const Duration(minutes: 15));

  // Mock attendance data
  final List<Map<String, dynamic>> _subjectAttendance = [
    {
      "id": 1,
      "subjectName": "Data Structures & Algorithms",
      "subjectCode": "CS301",
      "totalClasses": 45,
      "attendedClasses": 38,
      "percentage": 84.4,
      "instructor": "Dr. Sarah Johnson",
      "attendanceDetails": [
        {
          "date": "2025-01-08",
          "status": "present",
          "classType": "lecture",
          "topic": "Binary Trees"
        },
        {
          "date": "2025-01-06",
          "status": "present",
          "classType": "lab",
          "topic": "Tree Traversal Implementation"
        },
        {
          "date": "2025-01-03",
          "status": "absent",
          "classType": "lecture",
          "topic": "Graph Algorithms"
        },
        {
          "date": "2025-01-01",
          "status": "late",
          "classType": "lecture",
          "topic": "Dynamic Programming"
        }
      ]
    },
    {
      "id": 2,
      "subjectName": "Database Management Systems",
      "subjectCode": "CS302",
      "totalClasses": 40,
      "attendedClasses": 32,
      "percentage": 80.0,
      "instructor": "Prof. Michael Chen",
      "attendanceDetails": [
        {
          "date": "2025-01-09",
          "status": "present",
          "classType": "lecture",
          "topic": "SQL Joins"
        },
        {
          "date": "2025-01-07",
          "status": "present",
          "classType": "lab",
          "topic": "Database Design"
        },
        {
          "date": "2025-01-04",
          "status": "absent",
          "classType": "lecture",
          "topic": "Normalization"
        }
      ]
    },
    {
      "id": 3,
      "subjectName": "Software Engineering",
      "subjectCode": "CS303",
      "totalClasses": 38,
      "attendedClasses": 25,
      "percentage": 65.8,
      "instructor": "Dr. Emily Rodriguez",
      "attendanceDetails": [
        {
          "date": "2025-01-10",
          "status": "present",
          "classType": "lecture",
          "topic": "Agile Methodology"
        },
        {
          "date": "2025-01-08",
          "status": "absent",
          "classType": "lecture",
          "topic": "Requirements Engineering"
        },
        {
          "date": "2025-01-05",
          "status": "late",
          "classType": "lab",
          "topic": "Version Control"
        }
      ]
    },
    {
      "id": 4,
      "subjectName": "Computer Networks",
      "subjectCode": "CS304",
      "totalClasses": 42,
      "attendedClasses": 30,
      "percentage": 71.4,
      "instructor": "Prof. David Kim",
      "attendanceDetails": [
        {
          "date": "2025-01-11",
          "status": "present",
          "classType": "lecture",
          "topic": "TCP/IP Protocol"
        },
        {
          "date": "2025-01-09",
          "status": "present",
          "classType": "lab",
          "topic": "Network Configuration"
        },
        {
          "date": "2025-01-06",
          "status": "absent",
          "classType": "lecture",
          "topic": "OSI Model"
        }
      ]
    },
    {
      "id": 5,
      "subjectName": "Operating Systems",
      "subjectCode": "CS305",
      "totalClasses": 44,
      "attendedClasses": 41,
      "percentage": 93.2,
      "instructor": "Dr. Lisa Wang",
      "attendanceDetails": [
        {
          "date": "2025-01-12",
          "status": "present",
          "classType": "lecture",
          "topic": "Process Scheduling"
        },
        {
          "date": "2025-01-10",
          "status": "present",
          "classType": "lab",
          "topic": "Memory Management"
        },
        {
          "date": "2025-01-07",
          "status": "present",
          "classType": "lecture",
          "topic": "File Systems"
        }
      ]
    }
  ];

  double get _overallAttendancePercentage {
    if (_subjectAttendance.isEmpty) return 0.0;

    int totalClasses = 0;
    int totalAttended = 0;

    for (var subject in _subjectAttendance) {
      totalClasses += (subject["totalClasses"] as int);
      totalAttended += (subject["attendedClasses"] as int);
    }

    return totalClasses > 0 ? (totalAttended / totalClasses) * 100 : 0.0;
  }

  Color _getAttendanceColor(double percentage) {
    if (percentage >= 75) {
      return AppTheme.lightTheme.colorScheme.tertiary; // Green
    } else if (percentage >= 65) {
      return const Color(0xFFF59E0B); // Yellow/Orange
    } else {
      return AppTheme.lightTheme.colorScheme.error; // Red
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _refreshAttendance() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      _lastSyncTime = DateTime.now();
    });
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AttendanceFilterWidget(
        selectedSubject: _selectedSubject,
        selectedDate: _selectedDate,
        subjects:
            _subjectAttendance.map((s) => s["subjectName"] as String).toList(),
        onFilterApplied: (subject, date) {
          setState(() {
            _selectedSubject = subject;
            _selectedDate = date;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  void _editAttendanceStatus(Map<String, dynamic> attendanceEntry) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Edit Attendance',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Date: ${attendanceEntry["date"]}',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            Text(
              'Current Status: ${(attendanceEntry["status"] as String).toUpperCase()}',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatusButton('Present', Colors.green),
                _buildStatusButton('Absent', Colors.red),
                _buildStatusButton('Late', Colors.orange),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Attendance status updated successfully'),
                ),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusButton(String status, Color color) {
    return ElevatedButton(
      onPressed: () {
        // Handle status change
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      ),
      child: Text(
        status,
        style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Attendance Tracking',
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: AppTheme.lightTheme.appBarTheme.elevation,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _showFilterOptions,
            icon: CustomIconWidget(
              iconName: 'filter_list',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
          IconButton(
            onPressed: _refreshAttendance,
            icon: CustomIconWidget(
              iconName: 'refresh',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'By Subject'),
            Tab(text: 'By Month'),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshAttendance,
        child: Column(
          children: [
            // Overall Attendance Stats
            AttendanceStatsWidget(
              overallPercentage: _overallAttendancePercentage,
              attendanceColor:
                  _getAttendanceColor(_overallAttendancePercentage),
              lastSyncTime: _lastSyncTime,
              isLoading: _isLoading,
            ),

            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // By Subject Tab
                  _buildSubjectView(),

                  // By Month Tab
                  _buildMonthView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectView() {
    List<Map<String, dynamic>> filteredSubjects = _subjectAttendance;

    if (_selectedSubject != 'All Subjects') {
      filteredSubjects = _subjectAttendance
          .where((subject) => subject["subjectName"] == _selectedSubject)
          .toList();
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      itemCount: filteredSubjects.length,
      itemBuilder: (context, index) {
        final subject = filteredSubjects[index];
        return SubjectAttendanceCard(
          subject: subject,
          onTap: () {
            // Handle subject card tap for expansion
          },
          onEditAttendance: _editAttendanceStatus,
        );
      },
    );
  }

  Widget _buildMonthView() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        children: [
          // Month selector
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            margin: EdgeInsets.only(bottom: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: AppTheme.cardShadow(isLight: true),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _selectedDate = DateTime(
                        _selectedDate.year,
                        _selectedDate.month - 1,
                        1,
                      );
                    });
                  },
                  icon: CustomIconWidget(
                    iconName: 'chevron_left',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 24,
                  ),
                ),
                Text(
                  '${_getMonthName(_selectedDate.month)} ${_selectedDate.year}',
                  style: AppTheme.lightTheme.textTheme.titleLarge,
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _selectedDate = DateTime(
                        _selectedDate.year,
                        _selectedDate.month + 1,
                        1,
                      );
                    });
                  },
                  icon: CustomIconWidget(
                    iconName: 'chevron_right',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          // Calendar Widget
          MonthlyCalendarWidget(
            selectedDate: _selectedDate,
            attendanceData: _subjectAttendance,
            onDateSelected: (date) {
              setState(() {
                _selectedDate = date;
              });
            },
            onAttendanceEdit: _editAttendanceStatus,
          ),

          SizedBox(height: 2.h),

          // Legend
          Container(
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
                Text(
                  'Legend',
                  style: AppTheme.lightTheme.textTheme.titleMedium,
                ),
                SizedBox(height: 1.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildLegendItem('Present', Colors.green),
                    _buildLegendItem('Absent', Colors.red),
                    _buildLegendItem('Late', Colors.orange),
                    _buildLegendItem('Holiday', Colors.grey),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 3.w,
          height: 3.w,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 1.w),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall,
        ),
      ],
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }
}
