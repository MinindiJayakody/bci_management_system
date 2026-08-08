import 'package:flutter/foundation.dart';

import '../models/course.dart';
import '../models/student.dart';

abstract class BciDataRepository extends Listenable {
  List<Student> get students;
  List<Course> get courses;

  void addStudent(Student student);
  void updateStudent(Student updated);
  void deleteStudent(String studentId);
  Student? studentById(String id);
  List<Course> coursesForStudent(String studentId);
  List<Course> availableCoursesForStudent(String studentId);
  int enrolledCourseCount(String studentId);

  void addCourse(Course course);
  void updateCourse(Course updated);
  void deleteCourse(String courseId);
  Course? courseById(String id);
  List<Student> studentsForCourse(String courseId);
  int enrolledStudentCount(String courseId);

  void enrollStudent(String studentId, String courseId);
  void unenrollStudent(String studentId, String courseId);
}
