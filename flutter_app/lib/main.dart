import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/simulate_page.dart';
import 'pages/result_page.dart';
import 'pages/about_page.dart';

void main() {
  runApp(const AIInterviewCoachApp());
}

class AIInterviewCoachApp extends StatelessWidget {
  const AIInterviewCoachApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Interview Coach',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/simulate': (context) => const SimulatePage(),
        '/result': (context) => const ResultPage(),
        '/about': (context) => const AboutPage(),
      },
    );
  }
}
