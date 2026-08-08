import 'package:flutter/material.dart';

import '../../data/app_scope.dart';
import 'course_detail_screen.dart';
import 'course_form_screen.dart';

class CourseListScreen extends StatefulWidget {
  const CourseListScreen({super.key});

  @override
  State<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final dataStore = AppScope.of(context);

    return ListenableBuilder(
      listenable: dataStore,
      builder: (context, _) {
        final courses = dataStore.courses.where((c) {
          final q = _query.toLowerCase();
          return q.isEmpty ||
              c.title.toLowerCase().contains(q) ||
              c.code.toLowerCase().contains(q);
        }).toList()
          ..sort((a, b) => a.code.compareTo(b.code));

        return Scaffold(
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search courses by code or title',
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
                child: courses.isEmpty
                    ? const _EmptyState()
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 88),
                        itemCount: courses.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, i) {
                          final c = courses[i];
                          final studentCount = dataStore.enrolledStudentCount(c.id);
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
                                    Theme.of(context).colorScheme.secondaryContainer,
                                child: Text(
                                  c.credits.toString(),
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondaryContainer,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                '${c.code} - ${c.title}',
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              subtitle: Text(
                                '${c.instructor}\n$studentCount student(s) enrolled',
                              ),
                              isThreeLine: true,
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CourseDetailScreen(courseId: c.id),
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
            heroTag: 'addCourse',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CourseFormScreen()),
            ),
            icon: const Icon(Icons.library_add),
            label: const Text('Add Course'),
          ),
        );
      },
    );
  }
}
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.menu_book_outlined,
              size: 60,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 14),
            const Text(
              'No courses yet.\nTap "Add Course" to create the first one.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
