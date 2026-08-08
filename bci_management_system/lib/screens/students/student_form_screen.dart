import 'package:flutter/material.dart';

import '../../data/app_scope.dart';
import '../../models/student.dart';

class StudentFormScreen extends StatefulWidget {
  /// Pass an existing student to edit it; leave null to add a new one.
  final Student? student;
  const StudentFormScreen({super.key, this.student});

  @override
  State<StudentFormScreen> createState() => _StudentFormScreenState();
}

class _StudentFormScreenState extends State<StudentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstName;
  late final TextEditingController _lastName;
  late final TextEditingController _email;
  late final TextEditingController _phone;
  late final TextEditingController _address;
  late DateTime _dob;

  bool get _isEdit => widget.student != null;

  @override
  void initState() {
    super.initState();
    final s = widget.student;
    _firstName = TextEditingController(text: s?.firstName ?? '');
    _lastName = TextEditingController(text: s?.lastName ?? '');
    _email = TextEditingController(text: s?.email ?? '');
    _phone = TextEditingController(text: s?.phone ?? '');
    _address = TextEditingController(text: s?.address ?? '');
    _dob = s?.dateOfBirth ?? DateTime(DateTime.now().year - 18, 1, 1);
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _phone.dispose();
    _address.dispose();
    super.dispose();
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dob,
      firstDate: DateTime(now.year - 80),
      lastDate: now,
    );
    if (picked != null) setState(() => _dob = picked);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final dataStore = AppScope.of(context);

    if (_isEdit) {
      final updated = widget.student!.copyWith(
        firstName: _firstName.text.trim(),
        lastName: _lastName.text.trim(),
        email: _email.text.trim(),
        phone: _phone.text.trim(),
        address: _address.text.trim(),
        dateOfBirth: _dob,
      );
      dataStore.updateStudent(updated);
    } else {
      final student = Student(
        id: 'STU-${DateTime.now().microsecondsSinceEpoch}',
        firstName: _firstName.text.trim(),
        lastName: _lastName.text.trim(),
        email: _email.text.trim(),
        phone: _phone.text.trim(),
        address: _address.text.trim(),
        dateOfBirth: _dob,
      );
      dataStore.addStudent(student);
    }

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_isEdit ? 'Student updated' : 'Student added')),
    );
  }

  String? _required(String? v, String label) {
    if (v == null || v.trim().isEmpty) return '$label is required';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? 'Edit Student' : 'Add Student')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _firstName,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(),
              ),
              validator: (v) => _required(v, 'First name'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _lastName,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Last Name',
                border: OutlineInputBorder(),
              ),
              validator: (v) => _required(v, 'Last name'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Email is required';
                final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim());
                return ok ? null : 'Enter a valid email address';
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone',
                border: OutlineInputBorder(),
              ),
              validator: (v) => _required(v, 'Phone'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _address,
              decoration: const InputDecoration(
                labelText: 'Address (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: _pickDob,
              borderRadius: BorderRadius.circular(4),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Date of Birth',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today_outlined),
                ),
                child: Text(
                  '${_dob.year}-${_dob.month.toString().padLeft(2, '0')}-'
                  '${_dob.day.toString().padLeft(2, '0')}',
                ),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save_outlined),
              label: Text(_isEdit ? 'Save Changes' : 'Add Student'),
            ),
          ],
        ),
      ),
    );
  }
}
