# BCI Management System - Flutter MVP

A mobile application for managing students, courses, and course enrolments.

## Features

- **Students**: add, view, edit, delete, and search student records
  (name, email, phone, address, date of birth).
- **Courses**: add, view, edit, delete, and search course records
  (code, title, description, credits, instructor).
- **Enrolment**: enrol a student in one or more courses from their profile,
  view all courses assigned to a student, unenrol them, and — from the
  course side — see every student currently enrolled in a course.
- Responsive Material 3 interface with bottom navigation, search, and
  confirmation dialogs for destructive actions.
- Uses only the Flutter SDK — no third-party package dependencies.
- Data is currently stored in memory for demonstration purposes. Closing the
  app clears newly entered records. The next production step is to connect
  this UI to a Spring Boot REST API and PostgreSQL database.

## Project structure

```
lib/
  main.dart                       # App entry point, theme
  models/
    student.dart                  # Student model
    course.dart                   # Course model
  data/
    data_store.dart                # In-memory data + enrolment logic (ChangeNotifier)
    app_scope.dart                  # App-wide access to DataStore (no package needed)
  screens/
    home_screen.dart                # Bottom navigation shell
    students/
      student_list_screen.dart      # Search + list + add FAB
      student_form_screen.dart      # Add / edit student
      student_detail_screen.dart    # Profile, enrolled courses, enrol/unenrol
    courses/
      course_list_screen.dart       # Search + list + add FAB
      course_form_screen.dart       # Add / edit course
      course_detail_screen.dart     # Course info, enrolled students
```

## Project setup on macOS

### Option A: Create platform folders inside this project

1. Extract the ZIP file.
2. Open Terminal in the extracted folder.
3. Run:

```bash
flutter create --project-name bci_management_system .
flutter pub get
flutter run
```

`flutter create --project-name bci_management_system .` generates the Android, iOS, web and desktop folders while
keeping the supplied `lib` source code.

### Option B: Create a new Flutter project

```bash
flutter create bci_management_system
cd bci_management_system
```

Replace its `lib` folder and `pubspec.yaml` with the files from this starter.
Then run:

```bash
flutter pub get
flutter run
```

## Run targets

List devices:

```bash
flutter devices
```

Run Android emulator or phone:

```bash
flutter run
```

Run in Chrome:

```bash
flutter run -d chrome
```

## Recommended production improvements

- Spring Boot REST API + PostgreSQL database for persistence
- JWT authentication and role permissions
- Student attendance and results
- Pagination for large student/course lists
- Audit logs and database backups
