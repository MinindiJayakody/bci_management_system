import 'package:flutter/material.dart';

import 'data/app_scope.dart';
import 'data/data_store.dart';
import 'screens/home_screen.dart';
import 'screens/landing_screen.dart';

void main() {
  runApp(const BciApp());
}

class BciApp extends StatefulWidget {
  const BciApp({super.key});

  @override
  State<BciApp> createState() => _BciAppState();
}

class _BciAppState extends State<BciApp> {
  final DataStore _dataStore = DataStore();

  @override
  Widget build(BuildContext context) {
    return AppScope(
      dataStore: _dataStore,
      child: MaterialApp(
        title: 'BCI Management System',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: const Color(0xFF1E5AA8),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF5F7FA),
          appBarTheme: const AppBarTheme(
            centerTitle: false,
            elevation: 0,
            scrolledUnderElevation: 1,
          ),
          cardTheme: CardThemeData(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: EdgeInsets.zero,
          ),
          inputDecorationTheme: const InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        home: const LandingScreen(),
      ),
    );
  }
}
