import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  int _currentStep = 0; // Étape actuelle pour contrôler quelle image et texte afficher

  // Listes de textes pour chaque étape
  final List<String> _displayTexts = [
    "Bienvenue dans EquiLife360",
    "Transformez votre vie avec une approche équilibrée",
    "Tout commence par une Mission de Vie",
    "Planifiez vos objectifs dans toutes les dimensions de votre vie",
    "Gérez chaque journée pour maximiser votre bien-être et votre productivité",
    "Optimisez votre temps grâce à des outils puissants",
    "Sécurité et confidentialité",
    "Prêt a commencer ?",
  ];

  final List<String> _subtileTexts = [
    "Votre guide pour harmoniser et enrichir chaque facette de votre vie.",
    "Qu'il s'agisse de votre carrière, de votre famille, ou de votre bien-être, EquiLife360 vous aide à définir et à atteindre vos objectifs dans chaque domaine de votre vie.",
    "Définissez votre mission de vie personnelle pour rester aligné avec vos aspirations profondes. Relisez-la à tout moment pour retrouver inspiration et motivation.",
    "Physique, émotionnel, intellectuel ou spirituel : chaque aspect de votre vie compte. Créez des objectifs et suivez vos progrès facilement.",
    "Planifiez votre sommeil, vos repas et les moments essentiels de votre journée pour une vie plus équilibrée et productive.",
    "Utilisez la Matrice de Covey, la Pyramide de Productivité et bien plus pour prioriser ce qui compte vraiment.",
    "Vos données sont entièrement sécurisées et protégées pour garantir votre confidentialité à chaque étape de l'utilisation.",
    "", // Pas de sous-texte pour "Pret a commencer"
  ];

  // Listes d'images associées à chaque étape
  final List<String> _imagePaths = [
    "assets/Image Balance Pierre 2.webp",
    "assets/Image Roue de la Vie OK 9.webp",
    "assets/Image Boussole 4.webp",
    "assets/rappel-devenement.webp",
    "assets/bigstock-Calendar-Planner-Agenda-Schedu-234420403 (1).webp",
    "assets/12297154_4904579.webp",
    "assets/22112338_6534510.webp",
    "assets/Image S'inscrire.webp",
  ];

  Future<void> _markIntroSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenIntro', true);
  }

  void _onContinuePressed() {
    setState(() {
      if (_currentStep < _displayTexts.length - 1) {
        _currentStep++; // Passer à l'étape suivante
      } else {
        _markIntroSeen(); // Marque l'intro comme vue après la dernière étape
        Navigator.pushNamed(context, 'LoginForm');
      }
    });
  }

  void _onSkipPressed() {
    _markIntroSeen(); // Marque l'intro comme vue
    Navigator.pushNamed(context, 'LoginForm');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 3,
                child: Stack(
                  children: [
                    // AnimatedSwitcher pour changer les images à chaque étape
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: Container(
                        key: ValueKey<int>(_currentStep),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(_imagePaths[_currentStep]), // Image associée à l'étape actuelle
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 500, // Ajustez la hauteur si nécessaire
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.transparent, Colors.cyan.shade900],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.cyan.shade900, Colors.black],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            // Texte principal
                            Text(
                              _displayTexts[_currentStep],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            // Afficher le sous-titre sauf si l'étape est "Pret a commencer"
                            if (_currentStep < _displayTexts.length - 1 && _subtileTexts[_currentStep].isNotEmpty)
                              Text(
                                _subtileTexts[_currentStep],
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Bouton pour continuer
                      Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.cyan, Colors.black45],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ElevatedButton(
                          onPressed: _onContinuePressed,
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(Colors.transparent),
                            padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 10, horizontal: 40)),
                            elevation: WidgetStateProperty.all(0),
                          ),
                          child: Text(
                            _currentStep == _displayTexts.length - 1 ? 'ALLONS-Y' : 'CONTINUER', // Changer le texte du bouton
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      if (_currentStep < _displayTexts.length - 1 && _subtileTexts[_currentStep].isNotEmpty)
                      TextButton(
                        onPressed: _onSkipPressed,
                        child: const Text(
                          'Sauter >',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
