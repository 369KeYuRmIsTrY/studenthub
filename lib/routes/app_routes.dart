import 'package:flutter/material.dart';
import '../presentation/student_dashboard/student_dashboard.dart';
import '../presentation/events_listing/events_listing.dart';
import '../presentation/timetable_screen/timetable_screen.dart';
import '../presentation/assignment_submission/assignment_submission.dart';
import '../presentation/assignments_screen/assignments_screen.dart';
import '../presentation/attendance_tracking/attendance_tracking.dart';
import '../presentation/notes_library/notes_library.dart';
import '../presentation/student_profile/student_profile.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String studentDashboard = '/student-dashboard';
  static const String eventsListing = '/events-listing';
  static const String timetableScreen = '/timetable-screen';
  static const String assignmentSubmission = '/assignment-submission';
  static const String assignmentsScreen = '/assignments-screen';
  static const String attendanceTracking = '/attendance-tracking';
  static const String notesLibrary = '/notes-library';
  static const String studentProfile = '/student-profile';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const StudentDashboard(),
    studentDashboard: (context) => const StudentDashboard(),
    eventsListing: (context) => const EventsListing(),
    timetableScreen: (context) => const TimetableScreen(),
    assignmentSubmission: (context) => const AssignmentSubmission(),
    assignmentsScreen: (context) => const AssignmentsScreen(),
    attendanceTracking: (context) => const AttendanceTracking(),
    notesLibrary: (context) => const NotesLibrary(),
    studentProfile: (context) => const StudentProfile(),
    // TODO: Add your other routes here
  };
}
