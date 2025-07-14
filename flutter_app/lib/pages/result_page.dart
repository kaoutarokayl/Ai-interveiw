// result_page.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

    // Découper l'analyse en sections si possible
    final sections = _parseAnalysis(analysis);

    return Scaffold(
      appBar: AppBar(title: const Text('Analyse de la Réponse')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SectionCard(
                icon: Icons.question_answer_rounded,
                color: Colors.indigo[50]!,
                title: 'Question',
                child: Text(
                  question,
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              _SectionCard(
                icon: Icons.edit_note_rounded,
                color: Colors.green[50]!,
                title: 'Votre Réponse',
                child: Text(
                  answer,
                  style: GoogleFonts.montserrat(fontSize: 16),
                ),
              ),
              const SizedBox(height: 18),
              _SectionCard(
                icon: Icons.analytics_rounded,
                color: Colors.amber[50]!,
                title: 'Analyse de l\'IA',
                child:
                    sections.isNotEmpty
                        ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (sections['Évaluation Générale'] != null)
                              _AnalysisTile(
                                icon: Icons.verified_rounded,
                                color: Colors.blue[200]!,
                                title: 'Évaluation Générale',
                                text: sections['Évaluation Générale']!,
                              ),
                            if (sections['Points Forts'] != null)
                              _AnalysisTile(
                                icon: Icons.thumb_up_alt_rounded,
                                color: Colors.green[200]!,
                                title: 'Points Forts',
                                text: sections['Points Forts']!,
                              ),
                            if (sections['Axes d’Amélioration'] != null)
                              _AnalysisTile(
                                icon: Icons.trending_up_rounded,
                                color: Colors.red[200]!,
                                title: 'Axes d’Amélioration',
                                text: sections['Axes d’Amélioration']!,
                              ),
                            if (sections['Réponse Idéale'] != null)
                              _AnalysisTile(
                                icon: Icons.lightbulb_rounded,
                                color: Colors.amber[200]!,
                                title: 'Réponse Idéale',
                                text: sections['Réponse Idéale']!,
                              ),
                          ],
                        )
                        : Text(
                          analysis,
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
              ),
              const SizedBox(height: 36),
              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.refresh_rounded),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 28,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    elevation: 2,
                  ),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/simulate',
                      (route) => route.isFirst,
                    );
                  },
                  label: const Text('Poser une autre question'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper pour parser l'analyse en sections (si formatée)
  Map<String, String> _parseAnalysis(String analysis) {
    final Map<String, String> sections = {};
    final reg = RegExp(r'\*\*(.*?)\*\*\s*([\s\S]*?)(?=(\*\*|\$))');
    for (final match in reg.allMatches(analysis + '\n**')) {
      final title = match.group(1)?.trim() ?? '';
      final content = match.group(2)?.trim() ?? '';
      if (title.isNotEmpty && content.isNotEmpty) {
        sections[title] = content;
      }
    }
    return sections;
  }
}

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final Widget child;
  const _SectionCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.indigo[700], size: 32),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  child,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnalysisTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String text;
  const _AnalysisTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.indigo[700], size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo[800],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  text,
                  style: GoogleFonts.montserrat(
                    fontSize: 15,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
