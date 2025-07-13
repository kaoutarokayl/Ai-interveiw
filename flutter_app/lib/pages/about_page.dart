import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('À Propos')),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AI Interview Coach',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Cette application vous aide à pratiquer les entretiens d\'embauche en simulant des questions réelles pour les postes de développeur junior. Répondez aux questions, recevez des retours (bientôt disponible), et améliorez vos compétences !',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text('Version : 1.0.0', style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Text('Développé par : xAI', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
