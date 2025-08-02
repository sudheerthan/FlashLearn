import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlashLearn',
      theme: ThemeData(
        primaryColor: const Color(0xFF64B5F6), // Soft blue
        scaffoldBackgroundColor: const Color(0xFFF8F9FA), // Very light grey
        fontFamily: 'Inter',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFFFFFF), // White app bar
          foregroundColor: Color(0xFF333333),
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xFF64B5F6)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF64B5F6),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF64B5F6),
          ),
        ),
        tabBarTheme: const TabBarThemeData(
          labelColor: Color(0xFF64B5F6),
          unselectedLabelColor: Colors.grey,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(color: Color(0xFF64B5F6), width: 2),
          ),
        ),
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
