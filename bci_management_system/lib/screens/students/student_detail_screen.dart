import 'package:flutter/material.dart';

import '../../data/app_scope.dart';
import '../../data/bci_data_repository.dart';
import 'student_form_screen.dart';

class StudentDetailScreen extends StatelessWidget {
  final String studentId;
  const StudentDetailScreen({super.key, required this.studentId});

  Future<void> _confirmDelete(BuildContext context, BciDataRepository dataStore) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Student'),
        content: const Text(
          'This will remove the student and all of their course enrolments. '
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
      dataStore.deleteStudent(studentId);
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Student deleted')));
      }
    }
  }

  Future<void> _openEnrollSheet(BuildContext context, BciDataRepository dataStore) async {
    final available = dataStore.availableCoursesForStudent(studentId);
    if (available.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Student is already enrolled in every available course'),
        ),
      );
      return;
    }
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Enrol in Course',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(ctx).size.height * 0.5,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: available.length,
                    itemBuilder: (context, i) {
                      final c = available[i];
                      return ListTile(
                        title: Text('${c.code} - ${c.title}'),
                        subtitle: Text('${c.credits} credits · ${c.instructor}'),
                        trailing: FilledButton(
                          onPressed: () {
                            dataStore.enrollStudent(studentId, c.id);
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Enrolled in ${c.code}')),
                            );
                          },
                          child: const Text('Enrol'),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final dataStore = AppScope.of(context);

    return ListenableBuilder(
      listenable: dataStore,
      builder: (context, _) {
        final student = dataStore.studentById(studentId);
        if (student == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Student')),
            body: const Center(child: Text('This student no longer exists.')),
          );
        }
        final courses = dataStore.coursesForStudent(studentId);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Student Details'),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                tooltip: 'Edit',
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => StudentFormScreen(student: student),
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
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer,
                      child: Text(
                        student.initials,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      student.fullName,
                      style:
                          const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(student.email, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _InfoRow(icon: Icons.phone, label: 'Phone', value: student.phone),
                      _InfoRow(
                        icon: Icons.home_outlined,
                        label: 'Address',
                        value: (student.address?.isNotEmpty ?? false)
                            ? student.address!
                            : '—',
                      ),
                      _InfoRow(
                        icon: Icons.cake_outlined,
                        label: 'Date of Birth',
                        value: '${student.dateOfBirth.year}-'
                            '${student.dateOfBirth.month.toString().padLeft(2, '0')}-'
                            '${student.dateOfBirth.day.toString().padLeft(2, '0')}',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Enrolled Courses (${courses.length})',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextButton.icon(
                    onPressed: () => _openEnrollSheet(context, dataStore),
                    icon: const Icon(Icons.add),
                    label: const Text('Enrol'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (courses.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    'Not enrolled in any course yet.',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              else
                ...courses.map(
                  (c) => Card(
                    child: ListTile(
                      leading: const Icon(Icons.menu_book_outlined),
                      title: Text('${c.code} - ${c.title}'),
                      subtitle: Text('${c.credits} credits · ${c.instructor}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                        tooltip: 'Unenrol',
                        onPressed: () {
                          dataStore.unenrollStudent(studentId, c.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Unenrolled from ${c.code}')),
                          );
                        },
                      ),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          SizedBox(width: 110, child: Text(label, style: const TextStyle(color: Colors.grey))),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }
}
