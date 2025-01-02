import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import '../../services/liste_tache_service.dart';

class Categorie extends StatefulWidget {
  const Categorie({super.key});

  @override
  State<Categorie> createState() => _CategorieState();
}

class _CategorieState extends State<Categorie> {
  final TextEditingController _controller = TextEditingController();
  List<dynamic>? taches; // Pour stocker les tâches
  bool isLoading = true; // Pour suivre l'état de chargement

  List<String> tabs = [
    "Mes Activités",
    "Pyramide de productivité",
  ];
  int current = 0;

  // Mesurer la largeur du texte pour ajuster l'indicateur
  double _getTextWidth(String text) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: GoogleFonts.ubuntu(fontSize: 16, fontWeight: FontWeight.w400),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    return textPainter.width;
  }

  // Calculer la position du trait indicateur en fonction de l'index
  double changePositionedOfLine() {
    double position = 10; // Distance initiale
    for (int i = 0; i < current; i++) {
      position += _getTextWidth(tabs[i]) + 5; // Ajouter l'espacement entre les onglets
    }
    return position;
  }
  // Largeur dynamique du container indicateur en fonction du texte actuel
  double changeContainerWidth() {
    return _getTextWidth(tabs[current]);
  }

  List<Map<String, dynamic>> cards = [
    {
      "title": "Pyramide de productivité",
      "image": "assets/pyramide-de-jouets.webp",
      "route": 'Pyramide'
    },
    {
      "title": "Matrice de Covey",
      "image": "assets/roue_m.webp",
      "route": 'Matrice'
    },
    {
      "title": "Mes activités / taches",
      "image": "assets/taches.webp",
      "route": 'Tache'
    },
    {
      "title": "Calcul cout horaire",
      "image": "assets/calculatrice.webp",
      "route": 'CoutHoraire'
    },
    {
      "title": "Mes roles",
      "image": "assets/soutien.webp",
      "route": 'Role'
    },
    {
      "title": "Plan d'action",
      "image": "assets/letter-q.webp",
      "route": 'TroisQ'
    },
    /*{
      "title": "Agenda",
      "image": "assets/schedule.png",
      "route": 'Calendar'
    },*/
  ];

  List<Map<String, dynamic>> filteredCards = [];

  @override
  void initState() {
    super.initState();
    filteredCards = cards;
    _controller.addListener(() {
      filterCards();
    });

    // Initialisation des tâches ici
    fetchTaches();
  }

  // Méthode pour récupérer les tâches
  Future<void> fetchTaches() async {
    setState(() {
      isLoading = true; // Indique le début du chargement
    });
    try {
      taches = await ListeTacheService().fetchTaches();
    } catch (e) {
      // Gérez l'erreur ici si nécessaire
      print('Erreur lors du chargement des tâches: $e');
    } finally {
      setState(() {
        isLoading = false; // Fin du chargement
      });
    }
  }

  void filterCards() {
    final query = _controller.text.toLowerCase();
    setState(() {
      filteredCards = cards.where((card) {
        return card["title"].toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(

        appBar: AppBar(
          automaticallyImplyLeading: false,

          elevation: 0,
          actions: [
            IconButton(
              onPressed: () {},
              icon: Image.asset("assets/menu-points.webp", width: 30),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Fonctionnalités",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 40,
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 10),
                        filled: true,
                        fillColor: Colors.cyan.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        hintText: "Recherche",
                        prefixIcon: const Icon(Ionicons.search, color: Colors.cyan),
                        suffixIcon: _controller.text.isNotEmpty
                            ? IconButton(
                          icon: const Icon(Ionicons.close, color: Colors.cyan),
                          onPressed: () => _controller.clear(),
                        )
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: 170,
                        decoration: BoxDecoration(
                          color: Colors.cyan.shade50,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                    bottomRight: Radius.circular(20)),
                                child: Image.asset(
                                  "assets/protection-ecologique-preservation-environnement.webp",
                                  width: 70,
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset(
                                            "assets/pari.webp",
                                            width: 40,
                                          ),
                                        ],
                                      ),
                                      const Text(
                                        "Roue de la vie",
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.brown,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Text(
                                        "Evaluez les différents domaines de Votre Vie",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Center(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, 'Quizz');
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.cyan,
                                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // Ajustez la hauteur ici
                                      minimumSize: const Size(0, 30), // Définissez une taille minimale si nécessaire
                                    ),
                                    child: const Text(
                                      "Explorez",
                                      style: TextStyle(color: Colors.white, fontSize: 14),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              // Action à effectuer lorsque le container est cliqué
                              Navigator.pushNamed(context, 'VieIdeale');
                            },
                            borderRadius: BorderRadius.circular(10), // Gère l'effet ripple avec des coins arrondis
                            splashColor: Colors.indigo.shade100, // Couleur de l'effet ripple
                            child: Ink(
                              height: 100,
                              width: MediaQuery.of(context).size.width * 0.44,
                              decoration: BoxDecoration(
                                color: Colors.indigo.shade50,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Image.asset("assets/vers-le-haut.webp", width: 20),
                                    ],
                                  ),
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.grey.shade50,
                                    child: Image.asset("assets/attentes.webp", width: 25, color: Colors.blue),
                                  ),
                                  const SizedBox(height: 3),
                                  const Text("Ma vie idéale", style: TextStyle(fontSize: 14)),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              // Action à effectuer lorsque le container est cliqué
                              Navigator.pushNamed(context, 'MissionDeVie');
                            },
                            borderRadius: BorderRadius.circular(10), // Gère l'effet ripple avec des coins arrondis
                            splashColor: Colors.teal.shade100, // Couleur de l'effet ripple
                            child: Ink(
                              height: 100,
                              width: MediaQuery.of(context).size.width * 0.44,
                              decoration: BoxDecoration(
                                color: Colors.teal.shade50,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Image.asset("assets/vers-le-haut.webp", width: 20),
                                    ],
                                  ),
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.grey.shade50,
                                    child: Image.asset("assets/mission-accomplie (1).webp", width: 25),
                                  ),
                                  const SizedBox(height: 3),
                                  const Text("Mission de vie", style: TextStyle(fontSize: 14)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ...filteredCards.map((card) => Card(
                        elevation: 0,

                        child: ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          title: Text(card["title"], style: TextStyle(fontSize: 14),),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 15,),
                          leading: Image.asset(card["image"], width: 25),
                          onTap: () {
                            Navigator.pushNamed(context, card["route"]);
                          },
                        ),
                      )).toList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

