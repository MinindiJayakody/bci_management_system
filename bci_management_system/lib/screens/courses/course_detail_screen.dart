import 'package:flutter/material.dart';

import '../../data/app_scope.dart';
import '../../data/bci_data_repository.dart';
import 'course_form_screen.dart';

class CourseDetailScreen extends StatelessWidget {
  final String courseId;
  const CourseDetailScreen({super.key, required this.courseId});

  Future<void> _confirmDelete(BuildContext context, BciDataRepository dataStore) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Course'),
        content: const Text(
          'This will remove the course and unenrol every student from it. '
          'This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      dataStore.deleteCourse(courseId);
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Course deleted')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dataStore = AppScope.of(context);

    return ListenableBuilder(
      listenable: dataStore,
      builder: (context, _) {
        final course = dataStore.courseById(courseId);
        if (course == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Course')),
            body: const Center(child: Text('This course no longer exists.')),
          );
        }
        final students = dataStore.studentsForCourse(courseId);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Course Details'),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                tooltip: 'Edit',
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CourseFormScreen(course: course),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                tooltip: 'Delete',
                onPressed: () => _confirmDelete(context, dataStore),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.code,
                        style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        course.title,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      _InfoRow(
                        icon: Icons.person_outline,
                        label: 'Instructor',
                        value: course.instructor,
                      ),
                      _InfoRow(
                        icon: Icons.star_outline,
                        label: 'Credits',
                        value: course.credits.toString(),
                      ),
                      if (course.description.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        const Text('Description', style: TextStyle(color: Colors.grey)),
                        const SizedBox(height: 4),
                        Text(course.description),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Enrolled Students (${students.length})',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (students.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    'No students enrolled yet.',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              else
                ...students.map(
                  (s) => Card(
                    child: ListTile(
                      leading: CircleAvatar(child: Text(s.initials)),
                      title: Text(s.fullName),
                      subtitle: Text(s.email),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          SizedBox(width: 100, child: Text(label, style: const TextStyle(color: Colors.grey))),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }
}
