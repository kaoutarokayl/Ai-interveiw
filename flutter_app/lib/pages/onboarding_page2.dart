import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingPage2 extends StatefulWidget {
  const OnboardingPage2({super.key});

  @override
  State<OnboardingPage2> createState() => _OnboardingPage2State();
}

class _OnboardingPage2State extends State<OnboardingPage2>
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
                Icon(
                  Icons.auto_awesome_rounded,
                  size: 80,
                  color: Colors.amber[700],
                ),
                const SizedBox(height: 24),
                Text(
                  'Pourquoi choisir AI Interview Coach ?',
                  style: GoogleFonts.montserrat(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                FeatureCard(
                  icon: Icons.question_answer_rounded,
                  text: 'Questions adaptées à votre domaine',
                  color: Colors.indigo[100]!,
                ),
                FeatureCard(
                  icon: Icons.insights_rounded,
                  text: 'Analyse intelligente de vos réponses',
                  color: Colors.green[100]!,
                ),
                FeatureCard(
                  icon: Icons.security_rounded,
                  text: 'Multi-domaines : Web, Mobile, IA, Cyber',
                  color: Colors.amber[100]!,
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
                      Navigator.pushReplacementNamed(context, '/');
                    },
                    child: const Text('Commencer'),
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

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  const FeatureCard({
    required this.icon,
    required this.text,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
        child: Row(
          children: [
            Icon(icon, color: Colors.indigo[600], size: 30),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
