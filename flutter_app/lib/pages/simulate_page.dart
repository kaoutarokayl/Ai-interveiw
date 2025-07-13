import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  @override
  void initState() {
    super.initState();
    _fetchQuestion();
  }

  Future<void> _fetchQuestion() async {
    setState(() {
      _isLoadingQuestion = true;
      _question = 'Chargement de la question...';
    });
    try {
      final response = await http
          .get(Uri.parse('http://192.168.12.19:5000/ask'))
          .timeout(const Duration(seconds: 60));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _question = data['response'] as String;
        });
      } else {
        setState(() {
          _question = 'Échec du chargement. Statut : ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _question = 'Erreur de connexion : $e';
        debugPrint(e.toString());
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
            Uri.parse('http://192.168.12.19:5000/analyze'),
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
    return Scaffold(
      appBar: AppBar(title: const Text('Simulation d\'Entretien')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_isLoadingQuestion)
                const Center(child: CircularProgressIndicator())
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _question,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _isLoadingQuestion ? null : _fetchQuestion,
                      child: const Text('Nouvelle Question'),
                    ),
                  ],
                ),
              const SizedBox(height: 20),
              TextField(
                controller: _answerController,
                maxLines: 8,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: 'Tapez votre réponse ici...',
                ),
                enabled: !_isLoadingQuestion,
              ),
              const SizedBox(height: 20),
              Center(
                child:
                    _isAnalyzing
                        ? const Column(
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 10),
                            Text("Analyse en cours..."),
                          ],
                        )
                        : ElevatedButton(
                          onPressed: _isLoadingQuestion ? null : _analyzeAnswer,
                          child: const Text('Envoyer et Analyser'),
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
