import 'package:flutter/material.dart';
import '../widgets/student_bottom_nav.dart';
import 'student_home_screen.dart';
import 'student_attendance_screen.dart';
import 'student_history_screen.dart';
import 'student_profile_screen.dart';

class StudentMainScreen extends StatefulWidget {
  const StudentMainScreen({super.key});

  @override
  State<StudentMainScreen> createState() => _StudentMainScreenState();
}

class _StudentMainScreenState extends State<StudentMainScreen> {
  int _currentIndex = 0;
  int _notificationCount = 2; // Sample notifications for attendance reminders

  final List<Widget> _screens = [
    const StudentHomeScreen(),
    const StudentAttendanceScreen(),
    const StudentHistoryScreen(),
    const StudentProfileScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      // Clear notifications when viewing attendance tab
      if (index == 1) {
        _notificationCount = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: StudentBottomNav(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        notificationCount: _notificationCount,
      ),
    );
  }
}