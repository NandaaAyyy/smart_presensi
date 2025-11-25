import 'package:flutter/material.dart';

class TeacherRealtimeScreen extends StatefulWidget {
  const TeacherRealtimeScreen({super.key});

  @override
  State<TeacherRealtimeScreen> createState() => _TeacherRealtimeScreenState();
}

class _TeacherRealtimeScreenState extends State<TeacherRealtimeScreen> {
  // Mock data for real-time attendance
  final List<Map<String, dynamic>> _attendanceData = [
    {'name': 'Alice Johnson', 'nim': '12345678', 'status': 'Present', 'time': '08:30'},
    {'name': 'Bob Smith', 'nim': '12345679', 'status': 'Present', 'time': '08:32'},
    {'name': 'Charlie Brown', 'nim': '12345680', 'status': 'Present', 'time': '08:35'},
    {'name': 'Diana Prince', 'nim': '12345681', 'status': 'Late', 'time': '08:45'},
    {'name': 'Eve Wilson', 'nim': '12345682', 'status': 'Absent', 'time': null},
  ];

  @override
  Widget build(BuildContext context) {
    int presentCount = _attendanceData.where((student) => student['status'] == 'Present').length;
    int lateCount = _attendanceData.where((student) => student['status'] == 'Late').length;
    int absentCount = _attendanceData.where((student) => student['status'] == 'Absent').length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Real-time Attendance'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue[50],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard('Present', presentCount, Colors.green),
                _buildStatCard('Late', lateCount, Colors.orange),
                _buildStatCard('Absent', absentCount, Colors.red),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Live Attendance List',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _attendanceData.length,
              itemBuilder: (context, index) {
                final student = _attendanceData[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getStatusColor(student['status']),
                      child: Icon(
                        _getStatusIcon(student['status']),
                        color: Colors.white,
                      ),
                    ),
                    title: Text(student['name']),
                    subtitle: Text('NIM: ${student['nim']}'),
                    trailing: Text(
                      student['time'] ?? 'Not checked in',
                      style: TextStyle(
                        color: student['status'] == 'Absent' ? Colors.red : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
        ),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Present':
        return Colors.green;
      case 'Late':
        return Colors.orange;
      case 'Absent':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Present':
        return Icons.check;
      case 'Late':
        return Icons.access_time;
      case 'Absent':
        return Icons.close;
      default:
        return Icons.help;
    }
  }
}