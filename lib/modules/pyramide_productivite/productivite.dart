import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../../services/classification_service.dart';
import '../../services/liste_tache_service.dart';

class PyramidePage extends StatefulWidget {
  const PyramidePage({super.key});

  @override
  State<PyramidePage> createState() => _PyramidePageState();
}

class _PyramidePageState extends State<PyramidePage> {
  late ListeTacheService _tacheService;
  List<dynamic> _taches = []; // Liste de toutes les tâches
  List<dynamic> listeTachePro = []; // Liste des tâches professionnelles
  List<dynamic> listeTachePerso = []; // Liste des tâches personnelles
  bool isLoading = true; // Pour suivre l'état de chargement

  // Initialisation des durées par statut
  int totalDureeStatus1Pro = 0;
  int totalDureeStatus1Perso = 0;
  int totalDureeStatus2Pro = 0;
  int totalDureeStatus2Perso = 0;
  int totalDureeStatus3Pro = 0;
  int totalDureeStatus3Perso = 0;
  int totalDureeStatus4Pro = 0;
  int totalDureeStatus4Perso = 0;

  // Variables pour calculer les minutes totales par statut et type
  int totalMinutesStatus1Pro = 0;
  int totalMinutesStatus1Perso = 0;
  int totalMinutesStatus2Pro = 0;
  int totalMinutesStatus2Perso = 0;
  int totalMinutesStatus3Pro = 0;
  int totalMinutesStatus3Perso = 0;
  int totalMinutesStatus4Pro = 0;
  int totalMinutesStatus4Perso = 0;

  @override
  void initState() {
    super.initState();
    _tacheService = ListeTacheService();
    filterTachesByStatus(); // Appeler la fonction pour récupérer les tâches au démarrage
    _loadTachesAndCalculateDurees();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Méthode pour charger les tâches et calculer les durées
  void _loadTachesAndCalculateDurees() async {
    try {
      // Récupérer les tâches depuis le service
      List<dynamic> taches = await ListeTacheService().fetchTaches();
      // Calculer les durées par statut
      calculerDureesParStatus(taches);
    } catch (e) {
      print('Erreur lors de la récupération des tâches: $e');
    }
  }

  // Fonction pour calculer les durées par status
  void calculerDureesParStatus(List<dynamic> taches) {
    // Initialisation des totaux
    totalDureeStatus1Pro = 0;
    totalDureeStatus1Perso = 0;
    totalDureeStatus2Pro = 0;
    totalDureeStatus2Perso = 0;
    totalDureeStatus3Pro = 0;
    totalDureeStatus3Perso = 0;
    totalDureeStatus4Pro = 0;
    totalDureeStatus4Perso = 0;

    totalMinutesStatus1Pro = 0;
    totalMinutesStatus1Perso = 0;
    totalMinutesStatus2Pro = 0;
    totalMinutesStatus2Perso = 0;
    totalMinutesStatus3Pro = 0;
    totalMinutesStatus3Perso = 0;
    totalMinutesStatus4Pro = 0;
    totalMinutesStatus4Perso = 0;

    // Parcours des tâches
    for (var tache in taches) {
      int status = int.parse(tache['status']);
      int duree = int.tryParse(tache['duree']) ?? 0;
      int minutes = int.tryParse(tache['minutes']) ?? 0;
      String type = tache['type'];

      // Vérification du status et du type, ajout de la durée correspondante
      if (status == 1) {
        if (type == 'professionnelle') {
          totalDureeStatus1Pro += duree;
          totalMinutesStatus1Pro += minutes; // Somme des minutes
        } else if (type == 'personnelle') {
          totalDureeStatus1Perso += duree;
          totalMinutesStatus1Perso += minutes; // Somme des minutes
        }
      } else if (status == 2) {
        if (type == 'professionnelle') {
          totalDureeStatus2Pro += duree;
          totalMinutesStatus2Pro += minutes; // Somme des minutes
        } else if (type == 'personnelle') {
          totalDureeStatus2Perso += duree;
          totalMinutesStatus2Perso += minutes; // Somme des minutes
        }
      } else if (status == 3) {
        if (type == 'professionnelle') {
          totalDureeStatus3Pro += duree;
          totalMinutesStatus3Pro += minutes; // Somme des minutes
        } else if (type == 'personnelle') {
          totalDureeStatus3Perso += duree;
          totalMinutesStatus3Perso += minutes; // Somme des minutes
        }
      } else if (status == 4) {
        if (type == 'professionnelle') {
          totalDureeStatus4Pro += duree;
          totalMinutesStatus4Pro += minutes; // Somme des minutes
        } else if (type == 'personnelle') {
          totalDureeStatus4Perso += duree;
          totalMinutesStatus4Perso += minutes; // Somme des minutes
        }
      }
    }

    // Conversion des minutes en heures pour le statut 1
    _convertirMinutesEnHeures(1);
    _convertirMinutesEnHeures(2);
    _convertirMinutesEnHeures(3);
    _convertirMinutesEnHeures(4);

    // Affichage des résultats
    print('Durée totale pour les tâches professionnelles avec status 1: $totalDureeStatus1Pro H $totalMinutesStatus1Pro minutes');
    print('Durée totale pour les tâches personnelles avec status 1: $totalDureeStatus1Perso H $totalMinutesStatus1Perso minutes');
    print('Durée totale pour les tâches professionnelles avec status 2: $totalDureeStatus2Pro');
    print('Durée totale pour les tâches personnelles avec status 2: $totalDureeStatus2Perso');
    print('Durée totale pour les tâches professionnelles avec status 3: $totalDureeStatus3Pro');
    print('Durée totale pour les tâches personnelles avec status 3: $totalDureeStatus3Perso');
    print('Durée totale pour les tâches professionnelles avec status 4: $totalDureeStatus4Pro');
    print('Durée totale pour les tâches personnelles avec status 4: $totalDureeStatus4Perso');

    // Mise à jour de l'UI avec setState pour prendre en compte les nouvelles valeurs
    setState(() {});
  }

  void _convertirMinutesEnHeures(int status) {
    // Conversion des minutes pour chaque statut en heures
    if (status == 1) {
      totalDureeStatus1Pro += totalMinutesStatus1Pro ~/ 60;
      totalMinutesStatus1Pro %= 60;

      totalDureeStatus1Perso += totalMinutesStatus1Perso ~/ 60;
      totalMinutesStatus1Perso %= 60;
    } else if (status == 2) {
      totalDureeStatus2Pro += totalMinutesStatus2Pro ~/ 60;
      totalMinutesStatus2Pro %= 60;

      totalDureeStatus2Perso += totalMinutesStatus2Perso ~/ 60;
      totalMinutesStatus2Perso %= 60;
    } else if (status == 3) {
      totalDureeStatus3Pro += totalMinutesStatus3Pro ~/ 60;
      totalMinutesStatus3Pro %= 60;

      totalDureeStatus3Perso += totalMinutesStatus3Perso ~/ 60;
      totalMinutesStatus3Perso %= 60;
    } else if (status == 4) {
      totalDureeStatus4Pro += totalMinutesStatus4Pro ~/ 60;
      totalMinutesStatus4Pro %= 60;

      totalDureeStatus4Perso += totalMinutesStatus4Perso ~/ 60;
      totalMinutesStatus4Perso %= 60;
    }
  }






  Future<void> filterTachesByStatus() async {
    // Réinitialiser les listes pour éviter les doublons
    listeTachePro.clear();
    listeTachePerso.clear();

    // Récupérer les tâches depuis le service
    final taches = await ListeTacheService().fetchTaches();

    setState(() {
      _taches = taches; // Met à jour la liste principale des tâches

      print (_taches);
      for (var tache in taches) {
        String? typeTache = tache['type'];
        String? statusTache = tache['status'].toString(); // S'assurer que le statut est une chaîne

        if (typeTache == 'professionnelle' && statusTache == '0') {
          listeTachePro.add(tache);
        } else if (typeTache == 'personnelle' && statusTache == '0') {
          listeTachePerso.add(tache);
          print("Tâche personnelle trouvée: $tache");
        }
      }
      print("Liste tâches pro: $listeTachePro");
      print("Liste tâches perso: $listeTachePerso");

      // Calculer les durées après la mise à jour des tâches
      calculerDureesParStatus(taches);

      isLoading = false; // Fin du chargement
    });

  }


  // Méthode pour charger les tâches filtrées
  Future<List<dynamic>> fetchTachesSansStatus() async {
    final taches = await ListeTacheService().fetchTaches();
    // Filtrer les tâches dont status_covey est null
    return taches.where((tache) => tache['status'] == 0).toList();
  }

  // Fonction pour mettre à jour le statut de la tâche
  Future<void> _updateTacheStatus(String uuid, int status) async {
    ClassificationService classificationService = ClassificationService();
    List<String> taches = [uuid];
    List<int> statuses = [status];

    bool result = await classificationService.updateTachesStatus(taches, statuses);

    if (result) {
      print('Statut de la tâche mis à jour avec succès');

      // Actualiser les listes après la mise à jour du statut
      await filterTachesByStatus(); // Utilisez _fetchTaches() ici
      _loadTachesAndCalculateDurees();
    } else {
      print('Échec de la mise à jour du statut de la tâche');
    }
  }

  // Fonction pour construire les cartes des tâches
  Widget buildTacheCard(Map<String, dynamic> tache) {
    return GestureDetector(
      onTap: () {
        showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) => CupertinoActionSheet(
            actions: [
              CupertinoActionSheetAction(
                onPressed: () async {
                  await _updateTacheStatus(tache['uuid'], 1); // UUID et statut 1
                  Navigator.pop(context);
                },
                child: Text('Forte valeur à long terme', style: TextStyle(color: Colors.indigo.shade900)),
              ),
              CupertinoActionSheetAction(
                onPressed: () async {
                  await _updateTacheStatus(tache['uuid'], 2); // UUID et statut 2
                  Navigator.pop(context);
                },
                child: Text('Forte valeur monétaire', style: TextStyle(color: Colors.indigo.shade900)),
              ),
              CupertinoActionSheetAction(
                onPressed: () async {
                  await _updateTacheStatus(tache['uuid'], 3); // UUID et statut 3
                  Navigator.pop(context);
                },
                child: Text('Faible valeur monétaire', style: TextStyle(color: Colors.indigo.shade900)),
              ),
              CupertinoActionSheetAction(
                onPressed: () async {
                  await _updateTacheStatus(tache['uuid'], 4); // UUID et statut 4
                  Navigator.pop(context);
                },
                child: Text('Valeur négative ou nulle', style: TextStyle(color: Colors.indigo.shade900)),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Annuler'),
            ),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        color: Colors.indigo.shade700,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 15),
            title: Text(
              tache['type'],
              style: const TextStyle(fontSize: 14, color: Colors.white),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  tache['tache_executer'],
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
                const SizedBox(height: 10),
                Text(
                  'Durée : ${tache['duree'] == "0" || tache['duree'] == null || tache['duree'] == "" ? "${tache['minutes']} minutes" : "${tache['duree']} H ${tache['minutes']} minutes"}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            trailing: Image.asset(
              "assets/relax.webp",
              width: 50,
            ),
          ),
        ),
      ),
    );
  }

  List<String> tabs = [
    "Classification",
    "Pyramide de productivité",
  ];
  int current = 0;

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

  double changePositionedOfLine() {
    double position = 10; // Distance initiale
    for (int i = 0; i < current; i++) {
      position += _getTextWidth(tabs[i]) + 5;
    }
    return position;
  }

  double changeContainerWidth() {
    return _getTextWidth(tabs[current]);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 45, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Image.asset("assets/croix.webp", width: 25),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 15),
            width: size.width,
            height: size.height * 0.05,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    width: size.width,
                    height: size.height * 0.04,
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: tabs.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(left: index == 0 ? 10 : 23, top: 7),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                current = index;
                              });
                            },
                            child: Text(
                              tabs[index],
                              style: GoogleFonts.ubuntu(
                                fontSize: current == index ? 15 : 13,
                                fontWeight: current == index
                                    ? FontWeight.w400
                                    : FontWeight.w300,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                AnimatedPositioned(
                  curve: Curves.fastLinearToSlowEaseIn,
                  bottom: 0,
                  left: changePositionedOfLine(),
                  duration: const Duration(milliseconds: 500),
                  child: AnimatedContainer(
                    margin: const EdgeInsets.only(left: 10),
                    width: changeContainerWidth(),
                    height: size.height * 0.008,
                    decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.fastLinearToSlowEaseIn,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: IndexedStack(
              index: current,
              children: [
                // Contenu pour "Mes Activités"
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Indicateur de chargement
                        if (isLoading)
                          Center(
                            child: SpinKitPulsingGrid(
                              color: Colors.cyan.shade900,
                              size: 20.0,
                            ),
                          ),

                        // Message d'erreur si aucune tâche n'est chargée
                        if (_taches == null && !isLoading)
                          const Center(child: Text('Erreur lors du chargement des tâches')),

                        // Si des tâches existent, on les affiche
                        if (_taches.isNotEmpty) ...[
                          // Section des tâches professionnelles
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Liste des Tâches Professionnelles',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.indigo),
                            ),
                          ),
                          const SizedBox(height: 10), // Espacement

                          // Affichage des tâches professionnelles
                          if (listeTachePro.isNotEmpty)
                            ...listeTachePro.map<Widget>((tache) {
                              return buildTacheCard(tache);
                            }).toList()
                          else
                            const Center(
                              child: Text(
                                'Aucune activité professionnelle à afficher',
                                style: TextStyle(color: Colors.grey, fontSize: 16),
                              ),
                            ),

                          const SizedBox(height: 20), // Espacement entre les deux listes

                          // Section des tâches personnelles
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Liste des Tâches Personnelles',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.indigo),
                            ),
                          ),
                          const SizedBox(height: 10), // Espacement

                          // Affichage des tâches personnelles
                          if (listeTachePerso.isNotEmpty)
                            ...listeTachePerso.map<Widget>((tache) {
                              return buildTacheCard(tache);
                            }).toList()
                          else
                            const Center(
                              child: Text(
                                'Aucune activité personnelle à afficher',
                                style: TextStyle(color: Colors.grey, fontSize: 16),
                              ),
                            ),
                        ],

                        // Message pour aucune tâche disponible
                        if (_taches.isEmpty && !isLoading)
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 200,
                                  child: Lottie.asset(
                                    "assets/animations/Animation - 1726474541662.json",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const Text(
                                  'Aucune activité à afficher !',
                                  style: TextStyle(color: Colors.grey, fontSize: 14),
                                ),
                                const Text(
                                  'Veuillez renseigner vos activités dans le module Mes activités / tâches.',
                                  style: TextStyle(color: Colors.grey, fontSize: 14),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // Contenu pour "Pyramide de productivité"
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Personnelle",
                              style: TextStyle(color: Colors.indigo.shade900, fontSize: 15),
                            ),
                            Text(
                              "Professionnelle",
                              style: TextStyle(color: Colors.indigo.shade900, fontSize: 15),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 500,
                          child: Column(
                            children: [
                              // Ajout du CustomPaint qui va dessiner la pyramide
                              Expanded(
                                child: CustomPaint(
                                  painter: PyramidPainter(
                                    totalDureeStatus1Pro: totalDureeStatus1Pro,
                                    totalDureeStatus1Perso: totalDureeStatus1Perso,
                                    totalDureeStatus2Pro: totalDureeStatus2Pro,
                                    totalDureeStatus2Perso: totalDureeStatus2Perso,
                                    totalDureeStatus3Pro: totalDureeStatus3Pro,
                                    totalDureeStatus3Perso: totalDureeStatus3Perso,
                                    totalDureeStatus4Pro: totalDureeStatus4Pro,
                                    totalDureeStatus4Perso: totalDureeStatus4Perso,
                                  ),
                                  child: Container(), // Un conteneur vide pour le dessin
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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

class PyramidPainter extends CustomPainter {
  final int totalDureeStatus1Perso;
  final int totalDureeStatus1Pro;
  final int totalDureeStatus2Perso;
  final int totalDureeStatus2Pro;
  final int totalDureeStatus3Perso;
  final int totalDureeStatus3Pro;
  final int totalDureeStatus4Perso;
  final int totalDureeStatus4Pro;

  PyramidPainter({
    required this.totalDureeStatus1Perso,
    required this.totalDureeStatus1Pro,
    required this.totalDureeStatus2Perso,
    required this.totalDureeStatus2Pro,
    required this.totalDureeStatus3Perso,
    required this.totalDureeStatus3Pro,
    required this.totalDureeStatus4Perso,
    required this.totalDureeStatus4Pro,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paintPro = Paint()
      ..color = Colors.indigo; // Couleur pour les tâches professionnelles

    final paintPerso = Paint()
      ..color = Colors.indigo.shade700; // Couleur pour les tâches personnelles

    // Définir les coordonnées des triangles demi-professionnel et demi-personnel
    final professionalPath = Path();
    final personalPath = Path();

    double pyramidHeight = size.height;
    double pyramidBase = size.width;

    // Divisions pour les 4 niveaux de la pyramide
    double level1Height = pyramidHeight / 4;
    double level2Height = pyramidHeight / 2;
    double level3Height = (3 * pyramidHeight) / 4;
    double level4Height = pyramidHeight;

    double halfBase = pyramidBase / 2;

    // Dessiner les triangles demi-professionnel et demi-personnel
    // Demi triangle pour les tâches professionnelles (à droite)
    professionalPath.moveTo(halfBase, 0);
    professionalPath.lineTo(halfBase, level4Height);
    professionalPath.lineTo(pyramidBase, level4Height); // Point bas droit
    professionalPath.lineTo(halfBase, 0);
    professionalPath.close();

    // Demi triangle pour les tâches personnelles (à gauche)
    personalPath.moveTo(halfBase, 0);
    personalPath.lineTo(0, level4Height); // Point bas gauche
    personalPath.lineTo(halfBase, level4Height); // Milieu bas
    personalPath.lineTo(halfBase, 0);
    personalPath.close();

    // Dessiner les triangles
    canvas.drawPath(professionalPath, paintPerso);
    canvas.drawPath(personalPath, paintPro);

    // Optionnel: Ajouter des séparateurs pour les niveaux
    final dividerPaint = Paint()
      ..color = Colors.white70
      ..strokeWidth = 2;

    // Diviser la partie professionnelle en 4 niveaux
    canvas.drawLine(Offset(halfBase, level3Height), Offset(pyramidBase, level3Height), dividerPaint);
    canvas.drawLine(Offset(halfBase, level2Height), Offset(pyramidBase, level2Height), dividerPaint);
    canvas.drawLine(Offset(halfBase, level1Height), Offset(pyramidBase, level1Height), dividerPaint);

    // Diviser la partie personnelle en 4 niveaux
    canvas.drawLine(Offset(0, level3Height), Offset(halfBase, level3Height), dividerPaint);
    canvas.drawLine(Offset(0, level2Height), Offset(halfBase, level2Height), dividerPaint);
    canvas.drawLine(Offset(0, level1Height), Offset(halfBase, level1Height), dividerPaint);

    // Ajouter les valeurs dans chaque section, centrées
    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    // Positionner les valeurs centrées pour chaque segment
    _drawText(canvas, totalDureeStatus1Perso.toString(), Offset(halfBase / 2, level3Height + level1Height / 2), textPainter);
    _drawText(canvas, totalDureeStatus1Pro.toString(), Offset((3 * halfBase) / 2, level3Height + level1Height / 2), textPainter);

    _drawText(canvas, totalDureeStatus2Perso.toString(), Offset(halfBase / 1.6, level2Height + level1Height / 2), textPainter);
    _drawText(canvas, totalDureeStatus2Pro.toString(), Offset((2.7 * halfBase) / 2, level2Height + level1Height / 2), textPainter);

    _drawText(canvas, totalDureeStatus3Perso.toString(), Offset(halfBase / 1.3, level1Height + level1Height / 2), textPainter);
    _drawText(canvas, totalDureeStatus3Pro.toString(), Offset((2.4 * halfBase) / 2, level1Height + level1Height / 2), textPainter);

    _drawText(canvas, totalDureeStatus4Perso.toString(), Offset(halfBase / 1.1, level1Height / 2), textPainter);
    _drawText(canvas, totalDureeStatus4Pro.toString(), Offset((2.1 * halfBase) / 2, level1Height / 2), textPainter);
  }

  // Fonction pour afficher le texte centré dans chaque section
  void _drawText(Canvas canvas, String text, Offset position, TextPainter textPainter) {
    textPainter.text = TextSpan(
      text: text,
      style: const TextStyle(color: Colors.black, fontSize: 14), // Taille et couleur ajustées
    );
    textPainter.layout(minWidth: 0, maxWidth: double.infinity);
    textPainter.paint(canvas, Offset(position.dx - textPainter.width / 2, position.dy - textPainter.height / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}


