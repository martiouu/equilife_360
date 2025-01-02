import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:text_marquee/text_marquee.dart';

import '../../services/list_question_service.dart';
import '../../services/questionnaire_service.dart';

class RoueQuizz extends StatefulWidget {
  const RoueQuizz({super.key});

  @override
  State<RoueQuizz> createState() => _RoueQuizzState();
}

class _RoueQuizzState extends State<RoueQuizz> {
  final PageController _pageController = PageController();
  final List<double> _sliderValues = List.filled(10, 1); // Valeurs initiales pour chaque curseur
  int _currentPageIndex = 0;
  final ListQuestionService _listQuestionService = ListQuestionService();
  late Future<List<Map<String, dynamic>>> _questionsFuture;
  final Map<String, double> _responses = {}; // Stocker les notes associées aux UUID des questions

  @override
  void initState() {
    super.initState();
    _questionsFuture = _fetchQuestions(); // Initialise la future pour récupérer les questions
  }

  List<String> images = [
    "assets/kit-medical.webp",
    "assets/reunion-de-famille.webp",
    "assets/couple-de-mariage.webp",
    "assets/argent.webp",
    "assets/liberte.webp",
    "assets/constructeur.webp",
    "assets/sante-mentale.webp",
    "assets/collaboration.webp",
    "assets/plage.webp",
    "assets/maison_k.webp",
  ];

  Future<List<Map<String, dynamic>>> _fetchQuestions() async {
    try {
      final data = await _listQuestionService.fetchQuestions();
      if (data['type'] == 'success') {
        print('Données reçues avec succès :');
        print(data);
        // Extraire les questions et leurs UUID
        final questions = data['data'] as List<dynamic>;

        // Initialiser les réponses par défaut à 1
        for (var item in questions) {
          final uuid = item['uuid'] as String;
          _responses[uuid] = 1;
        }

        return questions.map((item) {
          return {
            'uuid': item['uuid'], // UUID de la question
            'title': item['title'],
            'question': item['question'],
          };
        }).toList();
      } else {
        throw Exception('Erreur: ${data['message']}');
      }
    } catch (e) {
      print('Une erreur est survenue: $e');
      return [];
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const TextMarquee(
          'Veuillez ne pas choisir la valeur 5 pour un meilleur apercu de la roue',
          spaceSize: 72,
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 16
          ),
        ),
      ),
      body: SizedBox(
        height: size.height,
        width: double.infinity,
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              child: SizedBox(
                width: size.width * 0.2,
                child: Image.asset("assets/main_bottom.webp"),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: SizedBox(
                width: size.width * 0.3,
                child: Image.asset("assets/login_bottom.webp"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: size.height * 0.15,
                    child: Image.asset(
                      images[_currentPageIndex],
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 60),
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _questionsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: SpinKitThreeBounce(
                      color: Colors.cyan.shade900,
                      size: 15.0,
                    ));
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Erreur: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Aucune question trouvée.'));
                  } else {
                    final questions = snapshot.data!;
                    return PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPageIndex = index;
                        });
                      },
                      itemCount: questions.length,
                      itemBuilder: (context, index) {
                        final questionData = questions[index];
                        final uuid = questionData['uuid'] as String;
                        final title = questionData['title'] as String;
                        final question = questionData['question'] as String;

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              question,
                              style: const TextStyle(fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            Slider(
                              value: _sliderValues[index],
                              min: 1, // Valeur minimale mise à 1 pour éviter la sélection de 0
                              max: 10,
                              activeColor: Colors.cyan,
                              divisions: 9, // 8 divisions pour obtenir des valeurs de 1 à 9
                              label: _sliderValues[index].toStringAsFixed(0),
                              onChanged: (double value) {
                                setState(() {
                                  _sliderValues[index] = value;
                                  _responses[uuid] = value; // Mettre à jour la note pour l'UUID correspondant
                                  print('Valeur enregistrée: UUID: $uuid, Note: $value');
                                });
                              },
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: size.width * 0.5,
                              height: size.height * 0.03,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (index < questions.length - 1) {
                                    _pageController.nextPage(
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeIn,
                                    );
                                  } else {
                                    _saveResponses(); // Fonction pour sauvegarder les réponses
                                    Navigator.pushNamed(context, 'LifeWheel');
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.cyan.shade500,
                                ),
                                child: Text(
                                  index < questions.length - 1 ? "Suivant" : "Terminé",
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 20.0, bottom: 10.0),
                                child: Text(
                                  '${_currentPageIndex + 1} / ${questions.length}',
                                  style: const TextStyle(fontSize: 13, color: Colors.cyan, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                              child: Text(
                                "1 => « Je suis à l’opposé de là où je souhaite être » et 10 => « Je suis exactement là où je souhaite être »",
                                style: TextStyle(fontSize: 14, color: Colors.brown),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveResponses() {
    final questionnaireService = QuestionnaireService();
    questionnaireService.submitResponses(_responses).then((_) {
      print('Réponses envoyées : $_responses');
    }).catchError((e) {
      print('Erreur lors de l\'envoi des réponses : $e');
    });
  }

}
