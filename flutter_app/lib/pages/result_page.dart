// result_page.dart

import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Récupérer tous les arguments
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final question = args['question']?.toString() ?? 'Question non trouvée';
    final answer = args['answer']?.toString() ?? 'Réponse non trouvée';
    final analysis = args['analysis']?.toString() ?? 'Analyse non disponible.';
    return Scaffold(
      appBar: AppBar(title: const Text('Analyse de la Réponse')),
      body: SingleChildScrollView(
        // Important pour que l'analyse puisse être longue
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Question :'),
              const SizedBox(height: 8),
              Text(
                question,
                style: const TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 20),
              _buildSectionTitle('Votre Réponse :'),
              const SizedBox(height: 8),
              Text(answer, style: const TextStyle(fontSize: 16)),
              const Divider(height: 40, thickness: 1),
              _buildSectionTitle('Analyse de l\'IA :'),
              const SizedBox(height: 8),
              // Afficher l'analyse de l'IA ici !
              Text(
                analysis,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ), // Meilleure lisibilité
              ),
              const SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Remplace la pile de navigation pour éviter d'empiler les pages
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/simulate',
                      (route) => route.isFirst,
                    );
                  },
                  child: const Text('Poser une autre question'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Petit widget helper pour la consistance du style
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
    );
  }
}
