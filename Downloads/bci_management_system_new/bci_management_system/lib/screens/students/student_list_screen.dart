import 'package:flutter/material.dart';

import '../../data/app_scope.dart';
import 'student_detail_screen.dart';
import 'student_form_screen.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final dataStore = AppScope.of(context);

    return ListenableBuilder(
      listenable: dataStore,
      builder: (context, _) {
        final students = dataStore.students.where((s) {
          final q = _query.toLowerCase();
          return q.isEmpty ||
              s.fullName.toLowerCase().contains(q) ||
              s.email.toLowerCase().contains(q) ||
              s.phone.contains(q);
        }).toList()
          ..sort((a, b) => a.firstName.compareTo(b.firstName));

        return Scaffold(
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search students by name, email or phone',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _query.isEmpty
                        ? null
                        : IconButton(
                            onPressed: () => setState(() => _query = ''),
                            icon: const Icon(Icons.clear),
                          ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (v) => setState(() => _query = v),
                ),
              ),
              Expanded(
                child: students.isEmpty
                    ? _EmptyState(hasQuery: _query.isNotEmpty)
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 88),
                        itemCount: students.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, i) {
                          final s = students[i];
                          final courseCount = dataStore.enrolledCourseCount(s.id);
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              leading: CircleAvatar(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primaryContainer,
                                child: Text(
                                  s.initials,
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                s.fullName,
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              subtitle: Text(
                                '${s.email}\n$courseCount course(s) enrolled',
                                style: const TextStyle(height: 1.4),
                              ),
                              isThreeLine: true,
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      StudentDetailScreen(studentId: s.id),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            heroTag: 'addStudent',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const StudentFormScreen()),
            ),
            icon: const Icon(Icons.person_add_alt),
            label: const Text('Add Student'),
          ),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool hasQuery;
  const _EmptyState({required this.hasQuery});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              hasQuery ? Icons.search_off : Icons.people_outline,
              size: 56,
              color: Colors.grey,
            ),
            const SizedBox(height: 12),
            Text(
              hasQuery
                  ? 'No students match your search'
                  : 'No students yet.\nTap "Add Student" to create one.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
