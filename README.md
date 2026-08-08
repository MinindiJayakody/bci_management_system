# 📚 BCI Management System - New Features Branch

This branch (`feature/new-features`) contains enhancements and new capabilities for the BCI Management System, a Flutter-based student and course management application.

## 📖 About This Branch

The `feature/new-features` branch introduces improvements to the existing BCI Management System. This is an active development branch where new features and enhancements are being implemented and tested before merging into the main branch.

### ⭐ Key Enhancements in This Branch

- **🏗️ SOLID Principles Implementation**: The app architecture has been refactored to adhere to SOLID principles:
  - **S** - **Single Responsibility Principle (SRP)**: Each class has a single, well-defined responsibility
  - **O** - **Open/Closed Principle (OCP)**: Classes are open for extension but closed for modification
  - **L** - **Liskov Substitution Principle (LSP)**: Proper interface contracts ensure interchangeable implementations
  - **I** - **Interface Segregation Principle (ISP)**: Focused, client-specific interfaces instead of fat interfaces
  - **D** - **Dependency Inversion Principle (DIP)**: Dependencies on abstractions rather than concrete implementations

## ✨ Base Features (from main)

- 🎨 Branded splash screen with improved contrast and updated colors
- 🏠 Professional landing page with a clear call to action
- 👥 Student management: add, edit, delete, search, and view student records
- 📖 Course management: add, edit, delete, search, and view course records
- 📝 Enrolment support: enrol students in courses, view enrolled students, and unenrol them
- 📱 Responsive home screen with bottom navigation and dashboard summary cards
- 💾 In-memory repository pattern for demo-friendly data handling
- 🧹 Cleaner code structure following SOLID principles

## 📁 Project Structure

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

## 🏛️ Architecture Highlights

The application follows clean architecture principles with:

- 🔄 **Repository Pattern**: Abstraction layer for data access, making it easy to swap implementations
- 💉 **Dependency Injection**: Proper dependency management through constructor injection
- 🎯 **Separation of Concerns**: Clear boundaries between UI, business logic, and data layers
- ✅ **SOLID Compliance**: Refactored codebase ensures maintainability and extensibility

## 🚀 How to Run

Open a terminal in the `bci_management_system` directory and use the following commands.

### 📦 Install dependencies

```bash
flutter pub get
```

### 🌐 Run in Chrome

```bash
flutter run -d chrome
```

### 🪟 Run on Windows desktop

If you have Visual Studio with the Desktop development with C++ workload installed:

```bash
flutter run -d windows
```

### 📋 List available devices

```bash
flutter devices
```

## 📝 Branch-Specific Notes

- 🔧 This is a **development branch** with enhanced code quality through SOLID principles
- 🏭 The refactored architecture makes the code more maintainable and testable
- 🔄 Should be kept up-to-date with the main branch
- 🧪 Changes are being actively developed and tested
- ✏️ Pull requests from this branch should include thorough testing and documentation
- 💾 Data is stored in memory only, so closing the app clears all records

## 🎯 Benefits of SOLID Principles in This Branch

- ✅ **Easier Testing**: Each component can be tested in isolation
- ✅ **Better Maintainability**: Clear responsibilities make code easier to understand and modify
- ✅ **Improved Extensibility**: New features can be added without modifying existing code
- ✅ **Reduced Bugs**: Better separation of concerns reduces unintended side effects
- ✅ **Code Reusability**: Well-designed abstractions promote reuse across the application

## 🔮 Future Improvements

- 💾 Add persistent storage using SQLite, REST API, or Firebase
- 🔐 Add authentication and user roles
- 🔌 Add real backend integration with Spring Boot + PostgreSQL
- 📊 Add pagination or filtering for large datasets
- 🎨 Improve form UX with inline validation hints
- 🧪 Implement unit and widget tests for better test coverage

## ❓ Getting Help

For issues or questions related to this branch, please create an issue in the repository.

---

**Branch:** `feature/new-features`  
**Last Updated:** 2026-08-08  
**Architecture:** ✨ SOLID Principles Applied
```

