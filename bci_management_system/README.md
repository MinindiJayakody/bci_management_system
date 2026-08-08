# BCI Management System

A Flutter-based student and course management app with a modern Material 3 interface, a branded splash screen, and an in-memory data layer for demo use.

The app has been structured with cleaner separation of responsibilities so the UI, data access, and screen flow are easier to maintain and extend.

## Features

- Branded splash screen with improved contrast and updated colors
- Professional landing page with a clear call to action
- Student management: add, edit, delete, search, and view student records
- Course management: add, edit, delete, search, and view course records
- Enrolment support: enrol students in courses, view enrolled students, and unenrol them
- Responsive home screen with bottom navigation and dashboard summary cards
- In-memory repository pattern for demo-friendly data handling
- Cleaner structure that follows SOLID principles where appropriate

## Project Structure

```
lib/
  main.dart                      # App entry point and theme
  screens/
    splash_screen.dart           # Initial branded splash screen
    landing_screen.dart          # Welcome landing page
    home_screen.dart             # Main tabbed app shell
    students/
      student_list_screen.dart   # Student list + search + add
      student_form_screen.dart   # Add / edit student form
      student_detail_screen.dart # Student detail + enrolments
    courses/
      course_list_screen.dart    # Course list + search + add
      course_form_screen.dart    # Add / edit course form
      course_detail_screen.dart  # Course detail + enrolled students
  data/
    data_store.dart              # In-memory data store and enrolment logic
    app_scope.dart               # App-level access to the data store
    bci_data_repository.dart     # Repository contract for the app data layer
  models/
    student.dart                 # Student model
    course.dart                  # Course model
```

## How to Run

Open a terminal in `bci_management_system` and use the following commands.

### Install dependencies

```bash
flutter pub get
```

### Run in Chrome

```bash
flutter run -d chrome
```

### Run on Windows desktop

If you have Visual Studio with the Desktop development with C++ workload installed:

```bash
flutter run -d windows
```

### List available devices

```bash
flutter devices
```

## Notes

- Data is stored in memory only, so closing the app clears all records.
- The splash screen appears first, then the landing page, then the main management UI.
- If Windows desktop fails, Chrome is the easiest target to use during development.

## Future Improvements

- Add persistent storage using SQLite, REST API, or Firebase
- Add authentication and user roles
- Add real backend integration with Spring Boot + PostgreSQL
- Add pagination or filtering for large datasets
- Improve form UX with inline validation hints
