import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../services/ajout_tache_service.dart';
import '../../services/deleteTacheService.dart';
import '../../services/liste_tache_service.dart';

class TachePage extends StatefulWidget {
  const TachePage({super.key});

  @override
  State<TachePage> createState() => _TachePageState();
}

class _TachePageState extends State<TachePage> {
  // Création des controllers pour les champs de texte
  final TextEditingController _tacheController = TextEditingController();
  final TextEditingController _dureeController = TextEditingController();
  String? _selectedType; // Variable pour le Dropdown (type d'activité)
  String letter = "H";

  final PageController _pageController = PageController();
  int _currentIndex = 0; // Pour suivre l'index de la page courante

  List<dynamic>? taches; // Pour stocker les tâches
  bool isLoading = true; // Pour suivre l'état de chargement

  @override
  void initState() {
    super.initState();
    fetchTaches(); // Initialisation des tâches ici
  }

  // Fonction pour ajouter une tâche en appelant le service
  Future<void> _ajouterTache() async {
    final String tache = _tacheController.text;
    final String type = _selectedType ?? "professionnelle"; // Valeur par défaut
    final int? duree = letter == "H" ? int.tryParse(_dureeController.text) : 0;
    final int? minutes = letter == "Min" ? int.tryParse(_dureeController.text) : 0;

    print("tache : $tache");
    print("type : $type");
    print("duree : $duree");
    print("minutes : $minutes");
    if (tache.isNotEmpty) {
      try {
        // Appel du service pour ajouter la tâche
        final response = await AjoutTacheService().ajoutTache(
          tache,
          type,
          duree: duree,
          minutes: minutes,
          status: 0,
        );

        // Affichage de la notification de succès
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? 'Tâche ajoutée avec succès !'),
            backgroundColor: Colors.teal,
          ),
        );

        // Vider les champs
        _tacheController.clear();
        _dureeController.clear();
        setState(() {
          _selectedType = null; // Réinitialiser le type sélectionné
          letter = "H"; // Réinitialiser le bouton de sélection
        });

        // Mise à jour de la liste des tâches
        await fetchTaches();
      } catch (e) {
        // Gestion de l'erreur
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erreur lors de l\'ajout de la tâche'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      // Message d'erreur si les champs sont vides
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Veuillez remplir tous les champs correctement.'),
          backgroundColor: Colors.orange.shade200,
        ),
      );
    }
  }


  Future<void> fetchTaches() async {
    setState(() {
      isLoading = true; // Indique le début du chargement
    });
    try {
      taches = await ListeTacheService().fetchTaches();
    } catch (e) {
      print('Erreur lors du chargement des tâches: $e');
    } finally {
      setState(() {
        isLoading = false; // Fin du chargement
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index; // Met à jour l'index courant
          });
        },
        children: [
          SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.cyan.shade900), // Icône de retour
                          onPressed: () {
                            Navigator.of(context).pop(); // Fermer la page actuelle
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20), // Espace entre le bouton et l'image
                    Image.asset(
                      "assets/activites.webp",
                      width: media.width * 0.25,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: media.width * 0.05,), // Espace entre l'image et le texte
                    const Text(
                      "Créer votre activité",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center, // Centrer le texte
                    ),
                    const Text(
                      "Compléter les tâches de la semaine",
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                      textAlign: TextAlign.center, // Centrer le texte
                    ),
                    SizedBox(height: media.height * 0.03,),


                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                              ),
                              dropdownColor: Colors.grey.shade200,
                              hint: const Text("Sélectionnez une activité", style: TextStyle(fontSize: 14),),
                              value: _selectedType,
                              items: const [
                                DropdownMenuItem(
                                  value: "professionnelle",
                                  child: Text("Activité professionnelle", style: TextStyle(fontSize: 14),),
                                ),
                                DropdownMenuItem(
                                  value: "personnelle",
                                  child: Text("Activité personnelle", style: TextStyle(fontSize: 14),),
                                ),
                              ],
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedType = newValue;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200, // Couleur de fond gris
                              borderRadius: BorderRadius.circular(8), // Bords arrondis
                            ),
                            child: TextField(
                              controller: _tacheController,
                              decoration: const InputDecoration(
                                hintText: "Ma tâche",
                                hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                                border: InputBorder.none, // Pas de bordure
                                contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 20), // Espacement intérieur
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10), // Espace entre les deux paddings
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200, // Couleur de fond gris
                                borderRadius: BorderRadius.circular(8), // Bords arrondis
                              ),
                              child: TextField(
                                controller: _dureeController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  hintText: "Renseigner la durée",
                                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                                  border: InputBorder.none, // Pas de bordure
                                  contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 20), // Espacement intérieur
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 5), // Espace entre le champ de durée et l'unité de temps
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                letter = letter == "H" ? "Min" : "H"; // Alterner entre "H" et "Min"
                              });
                            },
                            child: Container(
                              width: 60,
                              height: 60,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.cyan.shade200, // Couleur violet
                                    Colors.pinkAccent,    // Couleur rose
                                  ],
                                  begin: Alignment.topLeft,  // Direction du dégradé
                                  end: Alignment.bottomRight, // Direction du dégradé
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                letter, // Affiche la lettre actuelle
                                style: TextStyle(color: Colors.white, fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40), // Espace entre les deux paddings
                    Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Colors.cyan, // Couleur cyan
                            Colors.white, // Couleur blanche
                          ],
                          begin: Alignment.topLeft,  // Début du dégradé
                          end: Alignment.bottomRight, // Fin du dégradé
                        ),
                        borderRadius: BorderRadius.circular(50), // Bordures arrondies
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(327, 50), // Taille minimale
                          elevation: 0, // Pas d'ombre
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(50)), // Bordures arrondies
                          ),
                          backgroundColor: Colors.transparent, // Fond transparent pour laisser apparaître le dégradé
                        ),
                        onPressed: _ajouterTache,
                        child: const Text(
                          "Valider",
                          style: TextStyle(
                            fontSize: 18, // Taille du texte augmentée
                            color: Colors.white, // Texte en blanc
                            fontWeight: FontWeight.bold, // Texte en gras
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Vous pouvez ajouter d'autres pages ici en utilisant la même structure
          Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 80, left: 30),
                    child: Row(
                      children: [
                        const Text(
                          "Ma liste des activités",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center, // Centrer le texte
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            if (isLoading)
                              Center(child: SpinKitPulsingGrid(
                                color: Colors.cyan.shade900,
                                size: 20.0,
                              )),

                            if (taches == null && !isLoading)
                              const Center(child: Text('Erreur lors du chargement des tâches')),

                            if (taches != null && taches!.isNotEmpty)
                              ...taches!.map<Widget>((tache) {
                                return Column(
                                  children: [
                                    Container(
                                      width: double.maxFinite,
                                      padding: const EdgeInsets.all(15),
                                      height: media.width * 0.4,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [Colors.cyan, Colors.tealAccent],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(height: 15),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                                  child: Text(
                                                    '${tache['type'][0].toUpperCase()}${tache['type'].substring(1)}',
                                                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                                  child: Text(
                                                    '${tache['tache_executer'][0].toUpperCase()}${tache['tache_executer'].substring(1)}',
                                                    maxLines: 3,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                                  child: Text(
                                                        () {
                                                      // Vérifie si `duree` est vide ou null
                                                      final String duree = tache['duree'] ?? '';
                                                      final String minutes = tache['minutes'] ?? '';

                                                      if (duree.isEmpty || duree == 'null') {
                                                        // Affiche uniquement les minutes si `duree` est vide
                                                        return 'Durée : ${minutes} Minutes';
                                                      } else {
                                                        // Affiche les heures et minutes si `duree` n'est pas vide
                                                        return 'Durée : ${duree} H ${minutes.isNotEmpty ? '${minutes} Minutes' : ''}';
                                                      }
                                                    }(),
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.teal,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                const Spacer(),
                                                OutlinedButton(
                                                  style: OutlinedButton.styleFrom(
                                                    padding: const EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 20,
                                                    ),
                                                    foregroundColor: Colors.white,
                                                    side: const BorderSide(color: Colors.cyan),
                                                  ),
                                                  onPressed: () async {
                                                    await DeleteTacheService().deleteTache(tache['uuid']);
                                                    setState(() {
                                                      taches?.removeWhere((item) => item['uuid'] == tache['uuid']);
                                                    });
                                                  },
                                                  child: const Text("Supprimer"),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Image.asset(
                                            "assets/relax.webp",
                                            width: media.width * 0.25,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                );
                              }).toList(),

                            if (taches != null && taches!.isEmpty && !isLoading)
                              Center(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 200,
                                      child: Lottie.asset(
                                        "assets/animations/Animation - 1726474541662.json",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const Text('Aucune activité à afficher !', style: TextStyle(color: Colors.grey, fontSize: 14)),
                                    const Text(
                                      'Veuillez renseigner vos activités dans le module Mes activités / taches.',
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
                  ),
                ],
              )
          ),

        ],
      ),
      bottomNavigationBar: Container(
        height: media.width * 0.1,
        alignment: Alignment.center,
        child: SmoothPageIndicator(
          controller: _pageController, // Contrôleur de la page
          count: 2, // Nombre de pages
          effect: WormEffect(
            dotColor: Colors.grey, // Couleur des points inactifs
            activeDotColor: Colors.cyan, // Couleur du point actif
            dotHeight: 8, // Hauteur des points
            dotWidth: 8, // Largeur des points
          ),
        ),
      ),
    );
  }

}
