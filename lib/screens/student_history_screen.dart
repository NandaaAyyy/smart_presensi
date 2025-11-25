import 'package:flutter/material.dart';

class StudentHistoryScreen extends StatelessWidget {
  const StudentHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for attendance history
    final List<Map<String, String>> attendanceHistory = [
      {'date': '2023-11-20', 'course': 'Mathematics', 'status': 'Present'},
      {'date': '2023-11-19', 'course': 'Physics', 'status': 'Present'},
      {'date': '2023-11-18', 'course': 'Chemistry', 'status': 'Absent'},
      {'date': '2023-11-17', 'course': 'Biology', 'status': 'Present'},
      {'date': '2023-11-16', 'course': 'Computer Science', 'status': 'Late'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance History'),
      ),
      body: ListView.builder(
        itemCount: attendanceHistory.length,
        itemBuilder: (context, index) {
          final record = attendanceHistory[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: Icon(
                record['status'] == 'Present'
                    ? Icons.check_circle
                    : record['status'] == 'Absent'
                        ? Icons.cancel
                        : Icons.access_time,
                color: record['status'] == 'Present'
                    ? Colors.green
                    : record['status'] == 'Absent'
                        ? Colors.red
                        : Colors.orange,
              ),
              title: Text(record['course']!),
              subtitle: Text('Date: ${record['date']}'),
              trailing: Text(
                record['status']!,
                style: TextStyle(
                  color: record['status'] == 'Present'
                      ? Colors.green
                      : record['status'] == 'Absent'
                          ? Colors.red
                          : Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}