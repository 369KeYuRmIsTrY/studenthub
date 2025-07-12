import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/class_details_bottom_sheet.dart';
import './widgets/day_selector_widget.dart';
import './widgets/time_slot_widget.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  DateTime selectedDate = DateTime.now();
  bool isWeekView = false;
  String selectedMonth = 'July';
  int selectedDay = 12;

  final List<String> months = [
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

  final List<Map<String, dynamic>> timetableData = [
    {
      "id": 1,
      "subject": "Data Structures",
      "subjectCode": "CS301",
      "instructor": "Dr. Sarah Johnson",
      "instructorContact": "sarah.johnson@university.edu",
      "room": "Lab 204",
      "startTime": "09:00",
      "endTime": "10:30",
      "duration": "1h 30m",
      "department": "Computer Science",
      "attendancePercentage": 85,
      "dayOfWeek": "Monday",
      "color": 0xFF2563EB,
    },
    {
      "id": 2,
      "subject": "Database Management",
      "subjectCode": "CS302",
      "instructor": "Prof. Michael Chen",
      "instructorContact": "michael.chen@university.edu",
      "room": "Room 301",
      "startTime": "11:00",
      "endTime": "12:30",
      "duration": "1h 30m",
      "department": "Computer Science",
      "attendancePercentage": 92,
      "dayOfWeek": "Monday",
      "color": 0xFF059669,
    },
    {
      "id": 3,
      "subject": "Software Engineering",
      "subjectCode": "CS303",
      "instructor": "Dr. Emily Rodriguez",
      "instructorContact": "emily.rodriguez@university.edu",
      "room": "Room 205",
      "startTime": "14:00",
      "endTime": "15:30",
      "duration": "1h 30m",
      "department": "Computer Science",
      "attendancePercentage": 78,
      "dayOfWeek": "Monday",
      "color": 0xFFD97706,
    },
    {
      "id": 4,
      "subject": "Computer Networks",
      "subjectCode": "CS304",
      "instructor": "Prof. David Wilson",
      "instructorContact": "david.wilson@university.edu",
      "room": "Lab 101",
      "startTime": "10:00",
      "endTime": "11:30",
      "duration": "1h 30m",
      "department": "Computer Science",
      "attendancePercentage": 88,
      "dayOfWeek": "Tuesday",
      "color": 0xFF7C3AED,
    },
    {
      "id": 5,
      "subject": "Machine Learning",
      "subjectCode": "CS305",
      "instructor": "Dr. Lisa Anderson",
      "instructorContact": "lisa.anderson@university.edu",
      "room": "Room 401",
      "startTime": "13:00",
      "endTime": "14:30",
      "duration": "1h 30m",
      "department": "Computer Science",
      "attendancePercentage": 95,
      "dayOfWeek": "Tuesday",
      "color": 0xFFDC2626,
    },
  ];

  final List<String> timeSlots = [
    "08:00",
    "09:00",
    "10:00",
    "11:00",
    "12:00",
    "13:00",
    "14:00",
    "15:00",
    "16:00",
    "17:00",
    "18:00"
  ];

  final List<String> weekDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
    _tabController.index = DateTime.now().weekday - 1;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> getClassesForDay(String day) {
    return timetableData
        .where((classItem) => classItem["dayOfWeek"] == day)
        .toList();
  }

  void _showClassDetails(Map<String, dynamic> classData) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ClassDetailsBottomSheet(classData: classData),
    );
  }

  void _showSearchFilter() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Search Classes',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search by subject or instructor',
                prefixIcon: CustomIconWidget(
                  iconName: 'search',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Filter by Department',
              ),
              items: ['All', 'Computer Science', 'Mathematics', 'Physics']
                  .map((dept) => DropdownMenuItem(
                        value: dept,
                        child: Text(dept),
                      ))
                  .toList(),
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  Widget _buildDayView() {
    String currentDay = weekDays[_tabController.index];
    List<Map<String, dynamic>> todayClasses = getClassesForDay(currentDay);

    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            children: [
              ...timeSlots.map((timeSlot) {
                Map<String, dynamic>? classAtTime = todayClasses
                    .cast<Map<String, dynamic>?>()
                    .firstWhere(
                      (dynamic classItem) =>
                          (classItem as Map<String, dynamic>)["startTime"] ==
                          timeSlot,
                      orElse: () => null,
                    );

                return TimeSlotWidget(
                  timeSlot: timeSlot,
                  classData: classAtTime,
                  onClassTap: classAtTime != null
                      ? () => _showClassDetails(classAtTime)
                      : null,
                );
              }).toList(),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeekView() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        width: 200.w,
        padding: EdgeInsets.all(4.w),
        child: Column(
          children: [
            // Week header
            Row(
              children: weekDays
                  .map(
                    (day) => Container(
                      width: 25.w,
                      padding: EdgeInsets.symmetric(vertical: 1.h),
                      child: Text(
                        day.substring(0, 3),
                        textAlign: TextAlign.center,
                        style: AppTheme.lightTheme.textTheme.titleSmall,
                      ),
                    ),
                  )
                  .toList(),
            ),
            // Time slots with classes
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: timeSlots
                      .map(
                        (timeSlot) => Container(
                          height: 8.h,
                          child: Row(
                            children: [
                              Container(
                                width: 15.w,
                                padding: EdgeInsets.symmetric(vertical: 1.h),
                                child: Text(
                                  timeSlot,
                                  style:
                                      AppTheme.lightTheme.textTheme.bodySmall,
                                ),
                              ),
                              ...weekDays.map((day) {
                                List<Map<String, dynamic>> dayClasses =
                                    getClassesForDay(day);
                                Map<String, dynamic>? classAtTime = dayClasses
                                    .cast<Map<String, dynamic>?>()
                                    .firstWhere(
                                      (dynamic classItem) =>
                                          (classItem as Map<String, dynamic>)[
                                              "startTime"] ==
                                          timeSlot,
                                      orElse: () => null,
                                    );

                                return Container(
                                  width: 25.w,
                                  margin: EdgeInsets.all(0.5.w),
                                  child: classAtTime != null
                                      ? GestureDetector(
                                          onTap: () =>
                                              _showClassDetails(classAtTime),
                                          child: Container(
                                            padding: EdgeInsets.all(2.w),
                                            decoration: BoxDecoration(
                                              color: Color(classAtTime["color"]
                                                      as int)
                                                  .withValues(alpha: 0.1),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color: Color(
                                                    classAtTime["color"]
                                                        as int),
                                                width: 1,
                                              ),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  classAtTime["subject"]
                                                      as String,
                                                  style: AppTheme.lightTheme
                                                      .textTheme.bodySmall
                                                      ?.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 8.sp,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  classAtTime["room"] as String,
                                                  style: AppTheme.lightTheme
                                                      .textTheme.bodySmall
                                                      ?.copyWith(
                                                    fontSize: 7.sp,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      : Container(),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
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
          'Timetable',
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: AppTheme.lightTheme.appBarTheme.elevation,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isWeekView = !isWeekView;
              });
            },
            icon: CustomIconWidget(
              iconName: isWeekView ? 'view_day' : 'view_week',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
          ),
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, '/attendance-tracking'),
            icon: CustomIconWidget(
              iconName: 'analytics',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Date selector
          DaySelectorWidget(
            selectedMonth: selectedMonth,
            selectedDay: selectedDay,
            months: months,
            onMonthChanged: (month) {
              setState(() {
                selectedMonth = month;
              });
            },
            onDayChanged: (day) {
              setState(() {
                selectedDay = day;
              });
            },
          ),

          // Tab bar for days (only in day view)
          if (!isWeekView)
            Container(
              color: AppTheme.lightTheme.cardColor,
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                tabs: weekDays
                    .map((day) => Tab(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.w, vertical: 1.h),
                            child: Text(
                              day.substring(0, 3),
                              style: AppTheme.lightTheme.tabBarTheme.labelStyle,
                            ),
                          ),
                        ))
                    .toList(),
                onTap: (index) {
                  setState(() {});
                },
              ),
            ),

          // Content
          Expanded(
            child: isWeekView
                ? _buildWeekView()
                : TabBarView(
                    controller: _tabController,
                    children: weekDays.map((day) => _buildDayView()).toList(),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showSearchFilter,
        backgroundColor:
            AppTheme.lightTheme.floatingActionButtonTheme.backgroundColor,
        child: CustomIconWidget(
          iconName: 'search',
          color: AppTheme.lightTheme.floatingActionButtonTheme.foregroundColor!,
          size: 24,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 1,
        backgroundColor:
            AppTheme.lightTheme.bottomNavigationBarTheme.backgroundColor,
        selectedItemColor:
            AppTheme.lightTheme.bottomNavigationBarTheme.selectedItemColor,
        unselectedItemColor:
            AppTheme.lightTheme.bottomNavigationBarTheme.unselectedItemColor,
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'dashboard',
              color: AppTheme
                  .lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
              size: 24,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'dashboard',
              color: AppTheme
                  .lightTheme.bottomNavigationBarTheme.selectedItemColor!,
              size: 24,
            ),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'schedule',
              color: AppTheme
                  .lightTheme.bottomNavigationBarTheme.selectedItemColor!,
              size: 24,
            ),
            label: 'Timetable',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'event',
              color: AppTheme
                  .lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
              size: 24,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'event',
              color: AppTheme
                  .lightTheme.bottomNavigationBarTheme.selectedItemColor!,
              size: 24,
            ),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'assignment',
              color: AppTheme
                  .lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
              size: 24,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'assignment',
              color: AppTheme
                  .lightTheme.bottomNavigationBarTheme.selectedItemColor!,
              size: 24,
            ),
            label: 'Assignments',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/student-dashboard');
              break;
            case 1:
              // Current screen
              break;
            case 2:
              Navigator.pushNamed(context, '/events-listing');
              break;
            case 3:
              Navigator.pushNamed(context, '/assignments-screen');
              break;
          }
        },
      ),
    );
  }
}
