import 'package:flutter/material.dart';

import 'data/app_scope.dart';
import 'data/data_store.dart';
import 'screens/splash_screen.dart';

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
          colorSchemeSeed: const Color(0xFF0F4C81),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF4F7FB),
          appBarTheme: const AppBarTheme(
            centerTitle: false,
            elevation: 0,
            scrolledUnderElevation: 1,
            backgroundColor: Colors.transparent,
          ),
          cardTheme: CardThemeData(
            elevation: 1,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: EdgeInsets.zero,
          ),
          inputDecorationTheme: const InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(),
          ),
          navigationBarTheme: NavigationBarThemeData(
            backgroundColor: Colors.white,
            indicatorColor: const Color(0xFF0F4C81).withOpacity(0.12),
          ),
          filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
