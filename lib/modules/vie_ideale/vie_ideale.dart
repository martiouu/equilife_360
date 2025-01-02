import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart'; // Import pour l'initialisation

import '../../services/list_vie_ideale_service.dart';
import '../../services/roue_vie_service.dart';
import '../../services/vie_ideale_service.dart';

class VieIdeale extends StatefulWidget {
  const VieIdeale({super.key});

  @override
  State<VieIdeale> createState() => _VieIdealeState();
}

class _VieIdealeState extends State<VieIdeale> with TickerProviderStateMixin {
  int _currentIndex = 0;
  List<dynamic> _data = [];
  final RoueVieService _service = RoueVieService();

  List<String> _uuids = [];
  bool _isLoading = true;
  final ListVieIdealeService _vieIdealeservice = ListVieIdealeService();

  final Map<String, String> _responses = {}; // UUID => Réponse
  final TextEditingController _responseController = TextEditingController();
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    // Initialize the animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );


    initializeDateFormatting('fr_FR', null).then((_) {
      _initializeData(); // Méthode séparée pour les appels async
    });
  }

  // Nouvelle méthode pour initialiser les données
  void _initializeData() async {
    await _fetchData();
    await _loadUuids();
  }

  // Listes des éléments dynamiques
  final List<String> _images = [
    'assets/close-up-african.webp',
    'assets/Famille_Multiraciale 3.webp',
    'assets/medium-couple.webp',
    'assets/Image Argent Investissement.webp',
    'assets/e-business-concept.webp',
    'assets/industrial-designer_k.webp',
    'assets/2151164350.webp',
    'assets/19692.webp',
    'assets/silhouettes-people-jumping.webp',
    'assets/33044.webp',
  ];

  final List<String> _hintTexts = [
    'Pour vous, quelle est la situation idéale en matière de ',
    'Pour vous, quelle est la situation idéale en matière de ',
    'Pour vous, quelle est la situation idéale en matière de ',
    'Pour vous, quelle est la situation idéale en matière de ',
    'Pour vous, quelle est la situation idéale en matière de ',
    'Pour vous, quelle est la situation idéale en matière de ',
    'Pour vous, quelle est la situation idéale en matière de ',
    'Pour vous, quelle est la situation idéale en matière de ',
    'Pour vous, quelle est la situation idéale en matière de ',
    'Pour vous, quelle est la situation idéale en matière de ',
  ];

  Future<void> _loadUuids() async {
    try {
      final uuids = await _vieIdealeservice.listUuids();
      setState(() {
        _uuids = uuids;
        _isLoading = false;
        print(_uuids);
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchData() async {
    try {
      final response = await _service.fetchLatestResponses();
      setState(() {
        _data = response['data'];
      });
    } catch (e) {
      print('Erreur lors de la récupération des données : $e');
    }
  }

  void _showInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.transparent, // Pour éviter les bordures blanches
          child: _buildAnimatedDialog(),
        );
      },
    );
    // Start the animation
    _animationController.forward();
  }

  Widget _buildAnimatedDialog() {
    return ScaleTransition(
      scale: CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/info.webp", width: 30),
            const SizedBox(width: 5), // Espacement entre l'image et le texte
            const Expanded(
              child: Text(
                "Veuillez remplir le champ de saisie avant de continuer",
                style: TextStyle(
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }


  void _nextItem() {
    if (_responseController.text.isEmpty) {
      // Afficher un message ou un visuel si le champ est vide
      _showInfo(context);
      return; // Ne pas passer à l'élément suivant
    }

    final currentItem = _data[_currentIndex];
    final currentUUID = _uuids[_currentIndex];
    _responses[currentUUID] = _responseController.text;

    if (_currentIndex == _data.length - 1) {
      _saveResponses();
    } else {
      setState(() {
        _currentIndex = (_currentIndex + 1) % _data.length;
        _responseController.clear();
      });
    }
  }


  void _saveResponses() async {
    // Instancier le service
    final vieIdealeService = VieIdealeService();

    // Afficher les réponses dans la console (pour débogage)
    print('Réponses enregistrées :');
    _responses.forEach((uuid, response) {
      print('UUID: $uuid, Réponse: $response');
    });

    // Envoyer les données au serveur via le service
    try {
      await vieIdealeService.saveResponses(_responses);
      print('Les réponses ont été envoyées avec succès.');
      Navigator.pushNamed(context, 'VueVieIdeale');
    } catch (e) {
      print('Erreur lors de l\'envoi des réponses : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_data.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.grey.shade50,
        body: const Center(
          child: SpinKitWanderingCubes(
            color: Colors.cyan,
            size: 30.0,
          ),
        ),
      );
    }

    final currentItem = _data[_currentIndex];
    final currentQuestion = currentItem['question'] ?? 'Question non disponible';
    final currentTitle = currentItem['title'] ?? 'Titre non disponible';
    final currentAnswer = double.tryParse(currentItem['answer'] ?? '0.0') ?? 0.0;
    final dateString = currentItem['created_at'] ?? 'Pas disponible';

    // Convertir la chaîne de date en objet DateTime
    DateTime? dateTime;
    if (dateString != 'Pas disponible') {
      dateTime = DateTime.tryParse(dateString);
    }

    // Formater la date si elle est valide
    String formattedDate = 'Date non disponible';
    if (dateTime != null) {
      formattedDate = DateFormat("dd MMMM yyyy 'à' HH 'h' mm", 'fr_FR').format(dateTime);
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
                child: Image.asset(
                  _images[_currentIndex], // Image dynamique
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.arrow_back_ios_rounded, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05, // 5% de la largeur de l'écran
                  vertical: MediaQuery.of(context).size.height * 0.01, // 1% de la hauteur de l'écran
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentTitle,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      currentQuestion,
                      style: const TextStyle(
                        color: Colors.brown,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        const Text(
                          "Vos derniers résultats : ",
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          formattedDate,
                          style: TextStyle(color: Colors.black54),
                        ), // Affiche la date formatée
                      ],
                    ),
                    RatingBar.builder(
                      initialRating: currentAnswer,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 10,
                      itemSize: 10,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        print(rating);
                      },
                    ),
                    const SizedBox(height: 30),
                    Text(
                      _hintTexts[_currentIndex],
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      currentTitle,
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 100,
                      width: double.infinity,
                      child: TextField(
                        controller: _responseController,
                        maxLines: 3,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Ecrivez ici',
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center, // Aligne verticalement les éléments
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, 'VueVieIdeale');
                    },
                    child: SizedBox(
                      height: 45, // Définissez la hauteur que vous souhaitez
                      child: Image.asset("assets/lister.webp", height: 40),
                    ),
                  ),
                  SizedBox(width: 5),
                  GestureDetector(
                    onTap: _nextItem,
                    child: Container(
                      width: 300,
                      height: 40, // Assurez-vous que la hauteur est la même que celle de l'image
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.indigo.shade900,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Continuer',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),


        ],
      ),
    );
  }
}
