import 'package:flutter/material.dart';

class StudentSessionsScreen extends StatelessWidget {
  const StudentSessionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for upcoming sessions
    final List<Map<String, String>> upcomingSessions = [
      {
        'subject': 'Mathematics',
        'teacher': 'Dr. Ahmad',
        'time': '08:00 - 09:30',
        'date': '2023-11-25',
        'location': 'Room 101',
        'status': 'upcoming'
      },
      {
        'subject': 'Physics',
        'teacher': 'Prof. Siti',
        'time': '10:00 - 11:30',
        'date': '2023-11-25',
        'location': 'Lab 201',
        'status': 'upcoming'
      },
      {
        'subject': 'Chemistry',
        'teacher': 'Dr. Budi',
        'time': '13:00 - 14:30',
        'date': '2023-11-26',
        'location': 'Lab 301',
        'status': 'scheduled'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Session Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Upcoming Sessions',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: upcomingSessions.length,
                itemBuilder: (context, index) {
                  final session = upcomingSessions[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: session['status'] == 'upcoming'
                                      ? Colors.green[100]
                                      : Colors.blue[100],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  session['status']!.toUpperCase(),
                                  style: TextStyle(
                                    color: session['status'] == 'upcoming'
                                        ? Colors.green[800]
                                        : Colors.blue[800],
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                session['date']!,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            session['subject']!,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Teacher: ${session['teacher']}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Time: ${session['time']}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Location: ${session['location']}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}