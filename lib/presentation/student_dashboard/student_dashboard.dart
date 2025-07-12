import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/announcements_widget.dart';
import './widgets/quick_actions_widget.dart';
import './widgets/quick_stats_card_widget.dart';
import './widgets/recent_events_widget.dart';
import './widgets/student_profile_card_widget.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isRefreshing = false;
  DateTime _lastUpdated = DateTime.now();

  // Mock student data
  final Map<String, dynamic> studentData = {
    "id": "STU2024001",
    "name": "Sarah Johnson",
    "rollNumber": "CS21B1001",
    "semester": "6th Semester",
    "course": "Computer Science Engineering",
    "department": "Computer Science",
    "profileImage":
        "https://images.unsplash.com/photo-1494790108755-2616b612b786?fm=jpg&q=60&w=400&ixlib=rb-4.0.3",
    "email": "sarah.johnson@university.edu",
    "phone": "+1 (555) 123-4567"
  };

  // Mock quick stats data
  final Map<String, dynamic> quickStats = {
    "todayClasses": 4,
    "pendingAssignments": 3,
    "attendancePercentage": 87.5,
    "totalSubjects": 6
  };

  // Mock recent events data
  final List<Map<String, dynamic>> recentEvents = [
    {
      "id": 1,
      "title": "Annual Tech Fest 2024",
      "date": "2024-07-15",
      "time": "10:00 AM",
      "location": "Main Auditorium",
      "description":
          "Join us for the biggest tech event of the year featuring workshops, competitions, and guest speakers from leading tech companies.",
      "image":
          "https://images.unsplash.com/photo-1540575467063-178a50c2df87?fm=jpg&q=60&w=400&ixlib=rb-4.0.3",
      "category": "Academic"
    },
    {
      "id": 2,
      "title": "Career Guidance Workshop",
      "date": "2024-07-18",
      "time": "2:00 PM",
      "location": "Conference Hall B",
      "description":
          "Expert guidance on career planning, resume building, and interview preparation for final year students.",
      "image":
          "https://images.unsplash.com/photo-1552664730-d307ca884978?fm=jpg&q=60&w=400&ixlib=rb-4.0.3",
      "category": "Career"
    },
    {
      "id": 3,
      "title": "Sports Day 2024",
      "date": "2024-07-20",
      "time": "8:00 AM",
      "location": "Sports Complex",
      "description":
          "Annual sports competition featuring various indoor and outdoor games. Participate and showcase your athletic skills.",
      "image":
          "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?fm=jpg&q=60&w=400&ixlib=rb-4.0.3",
      "category": "Sports"
    }
  ];

  // Mock announcements data
  final List<Map<String, dynamic>> announcements = [
    {
      "id": 1,
      "title": "Mid-term Exam Schedule Released",
      "message":
          "The mid-term examination schedule for all departments has been published. Check your student portal for detailed timings.",
      "date": "2024-07-12",
      "priority": "high",
      "type": "academic"
    },
    {
      "id": 2,
      "title": "Library Extended Hours",
      "message":
          "Library will remain open until 10 PM during exam week to support student preparation.",
      "date": "2024-07-11",
      "priority": "medium",
      "type": "facility"
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _handleTabNavigation(_tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabNavigation(int index) {
    switch (index) {
      case 0:
        // Dashboard - already here
        break;
      case 1:
        Navigator.pushNamed(context, '/timetable-screen');
        break;
      case 2:
        Navigator.pushNamed(context, '/assignments-screen');
        break;
      case 3:
        // Profile tab - could navigate to profile screen
        break;
    }
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
      _lastUpdated = DateTime.now();
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Academic data refreshed successfully',
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

  void _navigateToEventDetails(Map<String, dynamic> event) {
    Navigator.pushNamed(context, '/events-listing');
  }

  void _dismissAnnouncement(int announcementId) {
    setState(() {
      announcements.removeWhere(
          (announcement) => (announcement["id"] as int) == announcementId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'StudentHub',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
            Text(
              'Last updated: ${_lastUpdated.hour.toString().padLeft(2, '0')}:${_lastUpdated.minute.toString().padLeft(2, '0')}',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 4.w),
            child: CustomIconWidget(
              iconName: 'wifi',
              color: AppTheme.lightTheme.colorScheme.tertiary,
              size: 20,
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Dashboard'),
            Tab(text: 'Timetable'),
            Tab(text: 'Assignments'),
            Tab(text: 'Profile'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Dashboard Tab
          RefreshIndicator(
            onRefresh: _handleRefresh,
            color: AppTheme.lightTheme.colorScheme.primary,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Student Profile Card
                  StudentProfileCardWidget(
                    studentData: studentData,
                  ),

                  SizedBox(height: 3.h),

                  // Quick Stats Cards
                  QuickStatsCardWidget(
                    quickStats: quickStats,
                    onTodayClassesTap: () {
                      Navigator.pushNamed(context, '/timetable-screen');
                    },
                    onAssignmentsTap: () {
                      Navigator.pushNamed(context, '/assignments-screen');
                    },
                    onAttendanceTap: () {
                      Navigator.pushNamed(context, '/attendance-tracking');
                    },
                  ),

                  SizedBox(height: 3.h),

                  // Recent Events Section
                  Text(
                    'Recent Events',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  SizedBox(height: 1.h),

                  RecentEventsWidget(
                    events: recentEvents,
                    onEventTap: _navigateToEventDetails,
                  ),

                  SizedBox(height: 3.h),

                  // Announcements Section
                  if (announcements.isNotEmpty) ...[
                    Text(
                      'Latest Announcements',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    AnnouncementsWidget(
                      announcements: announcements,
                      onDismiss: _dismissAnnouncement,
                    ),
                    SizedBox(height: 3.h),
                  ],

                  // Quick Actions
                  QuickActionsWidget(
                    onTimetableTap: () {
                      Navigator.pushNamed(context, '/timetable-screen');
                    },
                    onAssignmentUploadTap: () {
                      Navigator.pushNamed(context, '/assignment-submission');
                    },
                    onAttendanceCheckTap: () {
                      Navigator.pushNamed(context, '/attendance-tracking');
                    },
                  ),

                  SizedBox(height: 10.h), // Bottom padding for FAB
                ],
              ),
            ),
          ),

          // Placeholder tabs (navigation handled in _handleTabNavigation)
          const Center(child: Text('Timetable')),
          const Center(child: Text('Assignments')),
          const Center(child: Text('Profile')),
        ],
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton.extended(
              onPressed: () {
                // Quick note creation functionality
                _showQuickNoteDialog();
              },
              backgroundColor: AppTheme.lightTheme.colorScheme.primary,
              foregroundColor: Colors.white,
              icon: CustomIconWidget(
                iconName: 'add',
                color: Colors.white,
                size: 20,
              ),
              label: Text(
                'Add Note',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : null,
    );
  }

  void _showQuickNoteDialog() {
    final TextEditingController noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.lightTheme.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            'Quick Note',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          content: TextField(
            controller: noteController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Enter your note here...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (noteController.text.trim().isNotEmpty) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Note saved successfully',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
                    ),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
