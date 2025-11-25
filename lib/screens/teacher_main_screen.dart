import 'package:flutter/material.dart';
import '../widgets/teacher_bottom_nav.dart';
import 'teacher_home_screen.dart';
import 'teacher_classes_screen.dart';
import 'teacher_realtime_screen.dart';
import 'teacher_reports_screen.dart';

class TeacherMainScreen extends StatefulWidget {
  const TeacherMainScreen({super.key});

  @override
  State<TeacherMainScreen> createState() => _TeacherMainScreenState();
}

class _TeacherMainScreenState extends State<TeacherMainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const TeacherHomeScreen(),
    const TeacherClassesScreen(),
    const TeacherRealtimeScreen(),
    const TeacherReportsScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: TeacherBottomNav(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}