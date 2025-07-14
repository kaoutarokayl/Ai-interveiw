import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedDomain = 'web';
  final List<String> _domains = ['web', 'mobile', 'ai', 'cybersecurity'];

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: const Text('AI Interview Coach'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.indigo[800],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            margin: EdgeInsets.symmetric(
              horizontal: screenWidth < 500 ? 16 : 64,
              vertical: 32,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Illustration/logo
                  Icon(
                    Icons.emoji_objects_rounded,
                    size: 80,
                    color: Colors.amber[600],
                  ),
                  const SizedBox(height: 18),
                  // Message de bienvenue
                  Text(
                    'Bienvenue !',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.indigo[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Préparez vos entretiens tech avec l’IA',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.indigo[400],
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Card de sélection du domaine
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.indigo[50],
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.indigo.withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.category,
                          color: Colors.indigo,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Domaine : ',
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(width: 10),
                        // Badge coloré pour le domaine
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.indigo[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButton<String>(
                            value: _selectedDomain,
                            borderRadius: BorderRadius.circular(12),
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black87,
                            ),
                            dropdownColor: Colors.white,
                            underline: const SizedBox(),
                            items:
                                _domains
                                    .map(
                                      (domain) => DropdownMenuItem(
                                        value: domain,
                                        child: Text(domain.toUpperCase()),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _selectedDomain = value;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 36),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.play_arrow_rounded, size: 26),
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
                        elevation: 2,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/simulate',
                          arguments: {'domain': _selectedDomain},
                        );
                      },
                      label: const Text('Commencer la Pratique d\'Entretien'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
