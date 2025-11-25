import 'package:flutter/material.dart';

class TeacherSessionControlScreen extends StatefulWidget {
  const TeacherSessionControlScreen({super.key});

  @override
  State<TeacherSessionControlScreen> createState() => _TeacherSessionControlScreenState();
}

class _TeacherSessionControlScreenState extends State<TeacherSessionControlScreen> {
  String? _selectedClass = 'Mathematics 101';
  bool _isSessionActive = false;
  DateTime? _sessionStartTime;

  final List<String> _classes = [
    'Mathematics 101',
    'Physics 201',
    'Computer Science 301',
    'Chemistry 102',
  ];

  void _toggleSession() {
    setState(() {
      _isSessionActive = !_isSessionActive;
      if (_isSessionActive) {
        _sessionStartTime = DateTime.now();
      } else {
        _sessionStartTime = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Session Control'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Manage Attendance Sessions',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text('Select Class:'),
            DropdownButton<String>(
              value: _selectedClass,
              isExpanded: true,
              items: _classes.map((String className) {
                return DropdownMenuItem<String>(
                  value: className,
                  child: Text(className),
                );
              }).toList(),
              onChanged: _isSessionActive
                  ? null
                  : (String? newValue) {
                      setState(() {
                        _selectedClass = newValue;
                      });
                    },
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _isSessionActive ? Colors.green[100] : Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Icon(
                    _isSessionActive ? Icons.play_circle_fill : Icons.pause_circle_filled,
                    size: 64,
                    color: _isSessionActive ? Colors.green : Colors.grey,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _isSessionActive ? 'Session Active' : 'Session Inactive',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _isSessionActive ? Colors.green : Colors.grey,
                    ),
                  ),
                  if (_isSessionActive && _sessionStartTime != null)
                    Text(
                      'Started at: ${_sessionStartTime!.hour}:${_sessionStartTime!.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(fontSize: 14),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _toggleSession,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: _isSessionActive ? Colors.red : Colors.green,
                ),
                child: Text(
                  _isSessionActive ? 'End Session' : 'Start Session',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}