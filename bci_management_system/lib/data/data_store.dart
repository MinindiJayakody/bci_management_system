import 'dart:math';

import 'package:flutter/foundation.dart';

import 'bci_data_repository.dart';
import '../models/course.dart';
import '../models/student.dart';

/// Single source of truth for the app.
///
/// Holds students, courses and the many-to-many enrolment relationship
/// between them. Notifies listeners whenever data changes so screens can
/// rebuild automatically via [ListenableBuilder].
class DataStore extends ChangeNotifier implements BciDataRepository {
  final List<Student> _students = [];
  final List<Course> _courses = [];

  /// studentId -> set of courseIds the student is enrolled in.
  final Map<String, Set<String>> _enrollments = {};

  final Random _random = Random();

  DataStore() {
    _seed();
  }

  List<Student> get students => List.unmodifiable(_students);
  List<Course> get courses => List.unmodifiable(_courses);

  String _generateId(String prefix) {
    return '$prefix-${DateTime.now().microsecondsSinceEpoch}-${_random.nextInt(9999)}';
  }

  void _seed() {
    final s1 = Student(
      id: _generateId('STU'),
      firstName: 'Amara',
      lastName: 'Silva',
      email: 'amara.silva@example.com',
      phone: '077 123 4567',
      address: 'Colombo',
      dateOfBirth: DateTime(2001, 4, 12),
    );
    final s2 = Student(
      id: _generateId('STU'),
      firstName: 'Kavindu',
      lastName: 'Perera',
      email: 'kavindu.perera@example.com',
      phone: '077 987 6543',
      address: 'Kandy',
      dateOfBirth: DateTime(2000, 11, 2),
    );
    final s3 = Student(
      id: _generateId('STU'),
      firstName: 'Nadeesha',
      lastName: 'Fernando',
      email: 'nadeesha.fernando@example.com',
      phone: '071 222 3344',
      address: 'Galle',
      dateOfBirth: DateTime(2002, 2, 20),
    );
    _students.addAll([s1, s2, s3]);

    final c1 = Course(
      id: _generateId('CRS'),
      code: 'CS101',
      title: 'Introduction to Programming',
      description: 'Fundamentals of programming using Dart.',
      credits: 3,
      instructor: 'Mr. Jayasuriya',
    );
    final c2 = Course(
      id: _generateId('CRS'),
      code: 'CS201',
      title: 'Data Structures & Algorithms',
      description: 'Core data structures and algorithmic thinking.',
      credits: 4,
      instructor: 'Ms. Wickrama',
    );
    final c3 = Course(
      id: _generateId('CRS'),
      code: 'BUS110',
      title: 'Business Communication',
      description: 'Professional communication skills for the workplace.',
      credits: 2,
      instructor: 'Mrs. Ranasinghe',
    );
    _courses.addAll([c1, c2, c3]);

    _enrollments[s1.id] = {c1.id, c2.id};
    _enrollments[s2.id] = {c1.id};
    _enrollments[s3.id] = {c2.id, c3.id};
  }

  // ---------------- Students ----------------

  void addStudent(Student student) {
    _students.add(student);
    notifyListeners();
  }

  void updateStudent(Student updated) {
    final idx = _students.indexWhere((s) => s.id == updated.id);
    if (idx != -1) {
      _students[idx] = updated;
      notifyListeners();
    }
  }

  void deleteStudent(String studentId) {
    _students.removeWhere((s) => s.id == studentId);
    _enrollments.remove(studentId);
    notifyListeners();
  }

  Student? studentById(String id) {
    for (final s in _students) {
      if (s.id == id) return s;
    }
    return null;
  }

  // ---------------- Courses ----------------

  void addCourse(Course course) {
    _courses.add(course);
    notifyListeners();
  }

  void updateCourse(Course updated) {
    final idx = _courses.indexWhere((c) => c.id == updated.id);
    if (idx != -1) {
      _courses[idx] = updated;
      notifyListeners();
    }
  }

  void deleteCourse(String courseId) {
    _courses.removeWhere((c) => c.id == courseId);
    for (final set in _enrollments.values) {
      set.remove(courseId);
    }
    notifyListeners();
  }

  Course? courseById(String id) {
    for (final c in _courses) {
      if (c.id == id) return c;
    }
    return null;
  }

  // ---------------- Enrolment ----------------

  void enrollStudent(String studentId, String courseId) {
    _enrollments.putIfAbsent(studentId, () => <String>{}).add(courseId);
    notifyListeners();
  }

  void unenrollStudent(String studentId, String courseId) {
    _enrollments[studentId]?.remove(courseId);
    notifyListeners();
  }

  List<Course> coursesForStudent(String studentId) {
    final ids = _enrollments[studentId] ?? <String>{};
    return _courses.where((c) => ids.contains(c.id)).toList();
  }

  List<Student> studentsForCourse(String courseId) {
    final ids = _enrollments.entries
        .where((e) => e.value.contains(courseId))
        .map((e) => e.key)
        .toSet();
    return _students.where((s) => ids.contains(s.id)).toList();
  }

  List<Course> availableCoursesForStudent(String studentId) {
    final enrolled = _enrollments[studentId] ?? <String>{};
    return _courses.where((c) => !enrolled.contains(c.id)).toList();
  }

  int enrolledCourseCount(String studentId) =>
      (_enrollments[studentId] ?? const {}).length;

  int enrolledStudentCount(String courseId) =>
      _enrollments.values.where((set) => set.contains(courseId)).length;
}
