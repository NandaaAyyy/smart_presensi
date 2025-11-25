import 'package:flutter/material.dart';

class TeacherClassesScreen extends StatelessWidget {
  const TeacherClassesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for classes
    final List<Map<String, String>> classes = [
      {'name': 'Mathematics 101', 'code': 'MATH101', 'students': '45'},
      {'name': 'Physics 201', 'code': 'PHYS201', 'students': '38'},
      {'name': 'Computer Science 301', 'code': 'CS301', 'students': '52'},
      {'name': 'Chemistry 102', 'code': 'CHEM102', 'students': '41'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Class Management'),
      ),
      body: ListView.builder(
        itemCount: classes.length,
        itemBuilder: (context, index) {
          final classData = classes[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.class_),
              ),
              title: Text(classData['name']!),
              subtitle: Text('Code: ${classData['code']} • Students: ${classData['students']}'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // TODO: Navigate to class details
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Selected ${classData['name']}')),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Add new class
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add new class feature coming soon!')),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}