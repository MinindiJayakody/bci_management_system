import 'package:flutter/material.dart';

import '../../data/app_scope.dart';
import '../../models/course.dart';

class CourseFormScreen extends StatefulWidget {
  /// Pass an existing course to edit it; leave null to add a new one.
  final Course? course;
  const CourseFormScreen({super.key, this.course});

  @override
  State<CourseFormScreen> createState() => _CourseFormScreenState();
}

class _CourseFormScreenState extends State<CourseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _code;
  late final TextEditingController _title;
  late final TextEditingController _description;
  late final TextEditingController _instructor;
  late final TextEditingController _credits;

  bool get _isEdit => widget.course != null;

  @override
  void initState() {
    super.initState();
    final c = widget.course;
    _code = TextEditingController(text: c?.code ?? '');
    _title = TextEditingController(text: c?.title ?? '');
    _description = TextEditingController(text: c?.description ?? '');
    _instructor = TextEditingController(text: c?.instructor ?? '');
    _credits = TextEditingController(text: c?.credits.toString() ?? '');
  }

  @override
  void dispose() {
    _code.dispose();
    _title.dispose();
    _description.dispose();
    _instructor.dispose();
    _credits.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final dataStore = AppScope.of(context);
    final credits = int.tryParse(_credits.text.trim()) ?? 0;

    if (_isEdit) {
      final updated = widget.course!.copyWith(
        code: _code.text.trim(),
        title: _title.text.trim(),
        description: _description.text.trim(),
        instructor: _instructor.text.trim(),
        credits: credits,
      );
      dataStore.updateCourse(updated);
    } else {
      final course = Course(
        id: 'CRS-${DateTime.now().microsecondsSinceEpoch}',
        code: _code.text.trim(),
        title: _title.text.trim(),
        description: _description.text.trim(),
        instructor: _instructor.text.trim(),
        credits: credits,
      );
      dataStore.addCourse(course);
    }

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_isEdit ? 'Course updated' : 'Course added')),
    );
  }

  String? _required(String? v, String label) {
    if (v == null || v.trim().isEmpty) return '$label is required';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? 'Edit Course' : 'Add Course')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _code,
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(
                labelText: 'Course Code (e.g. CS101)',
                border: OutlineInputBorder(),
              ),
              validator: (v) => _required(v, 'Course code'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _title,
              decoration: const InputDecoration(
                labelText: 'Course Title',
                border: OutlineInputBorder(),
              ),
              validator: (v) => _required(v, 'Title'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _instructor,
              decoration: const InputDecoration(
                labelText: 'Instructor',
                border: OutlineInputBorder(),
              ),
              validator: (v) => _required(v, 'Instructor'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _credits,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Credits',
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Credits is required';
                final n = int.tryParse(v.trim());
                if (n == null || n <= 0) return 'Enter a valid number';
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _description,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save_outlined),
              label: Text(_isEdit ? 'Save Changes' : 'Add Course'),
            ),
          ],
        ),
      ),
    );
  }
}
