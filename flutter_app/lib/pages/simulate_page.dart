import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

class SimulatePage extends StatefulWidget {
  const SimulatePage({super.key});

  @override
  _SimulatePageState createState() => _SimulatePageState();
}

class _SimulatePageState extends State<SimulatePage> {
  String _question = 'Chargement de la question...';
  final TextEditingController _answerController = TextEditingController();
  bool _isLoadingQuestion = true;
  bool _isAnalyzing = false;
  final String _serverIp =
      'http://192.168.12.19:5000'; // Ajustez selon votre IP
  String _selectedDomain = 'web';
  final List<String> _domains = ['web', 'mobile', 'ai', 'cybersecurity'];
  bool _domainLoaded = false;
  String _selectedLang = 'fr';
  final List<Map<String, String>> _langs = [
    {'code': 'fr', 'label': 'Français'},
    {'code': 'en', 'label': 'English'},
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_domainLoaded) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null && args['domain'] != null) {
        _selectedDomain = args['domain'] as String;
        debugPrint('Domaine sélectionné : $_selectedDomain');
      } else {
        debugPrint('Aucun domaine transmis, utilisation par défaut : web');
      }
      _domainLoaded = true;
      _fetchQuestion();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> _fetchQuestion() async {
    setState(() {
      _isLoadingQuestion = true;
      _question = 'Chargement de la question...';
    });
    try {
      final response = await http
          .get(
            Uri.parse(
              '$_serverIp/ask?domain=$_selectedDomain&lang=$_selectedLang',
            ),
          )
          .timeout(const Duration(seconds: 60));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint('Réponse du serveur : $data');
        setState(() {
          _question = data['response'] as String? ?? 'Aucune question reçue.';
        });
      } else {
        setState(() {
          _question = 'Échec du chargement. Statut : ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _question = 'Erreur de connexion : $e';
        debugPrint('Erreur lors de _fetchQuestion : $e');
      });
    } finally {
      setState(() {
        _isLoadingQuestion = false;
      });
    }
  }

  Future<void> _analyzeAnswer() async {
    if (_answerController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez fournir une réponse.')),
      );
      return;
    }

    setState(() {
      _isAnalyzing = true;
    });

    try {
      final response = await http
          .post(
            Uri.parse('$_serverIp/analyze'),
            headers: {'Content-Type': 'application/json; charset=UTF-8'},
            body: jsonEncode({
              'question': _question,
              'answer': _answerController.text,
            }),
          )
          .timeout(const Duration(seconds: 60));

      setState(() {
        _isAnalyzing = false;
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        if (data['response'] != null) {
          Navigator.pushNamed(
            context,
            '/result',
            arguments: {
              'question': _question,
              'answer': _answerController.text,
              'analysis': data['response'],
            },
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Aucune analyse retournée.')),
          );
        }
      } else {
        final errorData = jsonDecode(utf8.decode(response.bodyBytes));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Erreur d\'analyse : ${errorData['error'] ?? 'Erreur inconnue'}',
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isAnalyzing = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erreur : $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text('Simulation d\'Entretien')),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth < 500 ? 8 : 48,
              vertical: 18,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Sélection du domaine avec badge + sélecteur de langue
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.category, color: Colors.indigo, size: 22),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.indigo[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButton<String>(
                        value: _selectedDomain,
                        borderRadius: BorderRadius.circular(12),
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
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
                          if (value != null && value != _selectedDomain) {
                            setState(() {
                              _selectedDomain = value;
                            });
                            _fetchQuestion();
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 18),
                    // Sélecteur de langue
                    const Icon(Icons.language, color: Colors.indigo, size: 22),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.indigo[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButton<String>(
                        value: _selectedLang,
                        borderRadius: BorderRadius.circular(12),
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                        dropdownColor: Colors.white,
                        underline: const SizedBox(),
                        items:
                            _langs
                                .map(
                                  (lang) => DropdownMenuItem(
                                    value: lang['code'],
                                    child: Text(lang['label']!),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          if (value != null && value != _selectedLang) {
                            setState(() {
                              _selectedLang = value;
                            });
                            _fetchQuestion();
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Card pour la question
                Card(
                  color: Colors.indigo[50],
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 22,
                      horizontal: 18,
                    ),
                    child:
                        _isLoadingQuestion
                            ? Column(
                              children: [
                                const CircularProgressIndicator(),
                                const SizedBox(height: 14),
                                Text(
                                  'Chargement de la question...',
                                  style: GoogleFonts.montserrat(fontSize: 16),
                                ),
                              ],
                            )
                            : Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.question_answer_rounded,
                                  color: Colors.indigo[700],
                                  size: 32,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    _question,
                                    style: GoogleFonts.montserrat(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.refresh_rounded,
                                    color: Colors.indigo,
                                    size: 26,
                                  ),
                                  tooltip: 'Nouvelle Question',
                                  onPressed:
                                      _isLoadingQuestion
                                          ? null
                                          : _fetchQuestion,
                                ),
                              ],
                            ),
                  ),
                ),
                // La section 'Questions fréquemment posées' a été supprimée ici
                const SizedBox(height: 28),
                // Champ de réponse stylisé
                Text(
                  'Votre réponse',
                  style: GoogleFonts.montserrat(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo[800],
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _answerController,
                  maxLines: 8,
                  style: GoogleFonts.montserrat(fontSize: 16),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Tapez votre réponse ici...',
                    hintStyle: GoogleFonts.montserrat(color: Colors.grey[500]),
                  ),
                  enabled: !_isLoadingQuestion,
                ),
                const SizedBox(height: 24),
                Center(
                  child:
                      _isAnalyzing
                          ? Column(
                            children: [
                              const CircularProgressIndicator(),
                              const SizedBox(height: 12),
                              Text(
                                'Analyse en cours...',
                                style: GoogleFonts.montserrat(fontSize: 16),
                              ),
                            ],
                          )
                          : SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.send_rounded),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo[700],
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 18,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w600,
                                ),
                                elevation: 2,
                              ),
                              onPressed:
                                  _isLoadingQuestion ? null : _analyzeAnswer,
                              label: const Text('Envoyer et Analyser'),
                            ),
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
