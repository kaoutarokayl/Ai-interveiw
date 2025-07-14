import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/simulate_page.dart';
import 'pages/result_page.dart';
import 'pages/about_page.dart';
import 'pages/onboarding_page1.dart';
import 'pages/onboarding_page2.dart';
import 'package:google_fonts/google_fonts.dart';

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
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey[50],
        textTheme: GoogleFonts.montserratTextTheme(),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo[700],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            elevation: 3,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.indigo[700],
            side: BorderSide(color: Colors.indigo[200]!, width: 2),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.indigo[800],
          elevation: 0,
          titleTextStyle: GoogleFonts.montserrat(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      initialRoute: '/onboarding1',
      routes: {
        '/onboarding1': (context) => const OnboardingPage1(),
        '/onboarding2': (context) => const OnboardingPage2(),
        '/': (context) => const HomePage(),
        '/simulate': (context) => const SimulatePage(),
        '/result': (context) => const ResultPage(),
        '/about': (context) => const AboutPage(),
      },
      // Animation de transition entre les pages
      onGenerateRoute: (settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case '/onboarding1':
            builder = (context) => const OnboardingPage1();
            break;
          case '/onboarding2':
            builder = (context) => const OnboardingPage2();
            break;
          case '/':
            builder = (context) => const HomePage();
            break;
          case '/simulate':
            builder = (context) => const SimulatePage();
            break;
          case '/result':
            builder = (context) => const ResultPage();
            break;
          case '/about':
            builder = (context) => const AboutPage();
            break;
          default:
            builder = (context) => const HomePage();
        }
        return PageRouteBuilder(
          pageBuilder:
              (context, animation, secondaryAnimation) => builder(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.ease;
            var tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: curve));
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
      },
    );
  }
}
