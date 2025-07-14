import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingPage1 extends StatefulWidget {
  const OnboardingPage1({super.key});

  @override
  State<OnboardingPage1> createState() => _OnboardingPage1State();
}

class _OnboardingPage1State extends State<OnboardingPage1>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.school_rounded, size: 90, color: Colors.indigo[700]),
                const SizedBox(height: 32),
                Text(
                  'AI Interview Coach',
                  style: GoogleFonts.montserrat(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 18),
                Text(
                  'Préparez vos entretiens tech avec l’IA !',
                  style: GoogleFonts.montserrat(
                    fontSize: 20,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo[700],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/onboarding2');
                    },
                    child: const Text('Suivant'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
