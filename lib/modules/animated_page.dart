import 'package:flutter/material.dart';
import '../services/AjoutResultatService.dart';
import '../services/ajoutObjectifService.dart';
import '../services/liste_objectif_service.dart';
import '../services/resultatService.dart';

class AnimatedPage extends StatefulWidget {
  final String uuid;

  const AnimatedPage({Key? key, required this.uuid}) : super(key: key);

  @override
  _AnimatedPageState createState() => _AnimatedPageState();
}

class _AnimatedPageState extends State<AnimatedPage> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _resultatUnController = TextEditingController();
  final TextEditingController _resultatDeuxController = TextEditingController();
  final TextEditingController _resultatTroisController = TextEditingController();
  final TextEditingController _resultatQuatreController = TextEditingController();
  final TextEditingController _resultatCinqController = TextEditingController();
  final ObjectifService _objectifService = ObjectifService();
  final AjoutObjectifService _ajoutObjectifService = AjoutObjectifService();
  final AjoutResultatService _ajoutResultatService = AjoutResultatService(); // Initialisez le service
  bool _showPositioned = false;
  List<dynamic> _objectifs = []; // Liste pour stocker les objectifs
  List<dynamic> listResultat = [];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _showPositioned = _controller.text.isNotEmpty;
      });
    });
    _fetchObjectifs(); // Récupérer les objectifs au démarrage
  }

  Future<void> loadAndFilterObjectifs(String objectifUuid) async {
    ResultatService service = ResultatService();
    List<dynamic> objectifs = await service.fetchObjectifs(objectifUuid);

    if (objectifs.isNotEmpty) {
      // Filtrer les 5 premiers objectifs
      List<dynamic> firstFiveObjectifs = objectifs.take(5).toList();

      // Assigner les descriptions aux TextEditingControllers
      if (firstFiveObjectifs.isNotEmpty) _resultatUnController.text = firstFiveObjectifs[0]['description'] ?? '';
      if (firstFiveObjectifs.length > 1) _resultatDeuxController.text = firstFiveObjectifs[1]['description'] ?? '';
      if (firstFiveObjectifs.length > 2) _resultatTroisController.text = firstFiveObjectifs[2]['description'] ?? '';
      if (firstFiveObjectifs.length > 3) _resultatQuatreController.text = firstFiveObjectifs[3]['description'] ?? '';
      if (firstFiveObjectifs.length > 4) _resultatCinqController.text = firstFiveObjectifs[4]['description'] ?? '';
    }
  }

  // Fonction pour récupérer les objectifs
  Future<void> _fetchObjectifs() async {
    try {
      final objectifs = await _objectifService.fetchObjectifs();
      // Filtrer les objectifs basés sur l'UUID passé en paramètre
      final objectifsFiltres = objectifs.where((objectif) {
        return objectif['equi_role_uuid'] == widget.uuid;
      }).toList();

      setState(() {
        _objectifs = objectifsFiltres; // Met à jour la liste des objectifs filtrés
        print("Objectifs filtrés : $_objectifs");
      });
    } catch (e) {
      print('Erreur lors de la récupération des objectifs: $e');
    }
  }

  // Fonction pour enregistrer l'objectif en utilisant le service
  Future<void> _saveObjective() async {
    if (_controller.text.isNotEmpty) {
      try {
        final response = await _ajoutObjectifService.ajoutObjectifService(
          roleUuid: widget.uuid,
          libelle: _controller.text,
        );

        // Vérifiez si la réponse est réussie
        if (response != null) {
          // Actualiser la liste des objectifs après l'ajout
          await _fetchObjectifs();
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Objectif enregistré avec succès')),
        );
        _controller.clear();
        _showPositioned = false;
      } catch (e) {
        print('Erreur lors de l\'enregistrement de l\'objectif: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de l\'enregistrement de l\'objectif')),
        );
      }
    }
  }

  void _validateInput(TextEditingController controller, String objectifUuid) async {
    String resultat = controller.text.trim();

    if (resultat.isNotEmpty) {
      try {
        final data = await _ajoutResultatService.storeResultat(
          objectifUuid: objectifUuid,
          description: resultat,
        );

        if (data != null) {
          // Assigner les données à listResultat
          listResultat = data;

          // Filtrer les éléments dont 'equi_objectif_uuid' correspond à 'objectifUuid'
          List filteredResults = listResultat.where(
                  (item) => item['equi_objectif_uuid'] == objectifUuid
          ).toList();

          // Afficher les résultats filtrés
          print('Résultats pour l\'objectif $objectifUuid :');
          for (var result in filteredResults) {
            print(result); // Affiche l'ensemble des résultats correspondants
          }

          // Extraire uniquement les descriptions et limiter à 5 maximum
          List<String> descriptions = filteredResults.map(
                  (item) => item['description'].toString()
          ).take(5).toList();

          // Afficher les descriptions
          print('Descriptions pour l\'objectif $objectifUuid :');
          for (var description in descriptions) {
            print(description);
          }

          // Affecter les descriptions aux contrôleurs correspondants
          if (descriptions.isNotEmpty) {
            if (descriptions.length > 0) _resultatUnController.text = descriptions[0];
            if (descriptions.length > 1) _resultatDeuxController.text = descriptions[1];
            if (descriptions.length > 2) _resultatTroisController.text = descriptions[2];
            if (descriptions.length > 3) _resultatQuatreController.text = descriptions[3];
            if (descriptions.length > 4) _resultatCinqController.text = descriptions[4];
          }
        }

        print(_resultatUnController.text);
        print(_resultatDeuxController.text);
        print(_resultatTroisController.text);
        print(_resultatQuatreController.text);
        print(_resultatCinqController.text);
        //controller.clear(); // Réinitialiser le champ après validation
      } catch (e) {
        print('Erreur: $e');
      }
    }
  }


  void showCardModal(BuildContext context, String objectifUuid) {
    showModalBottomSheet(
      isScrollControlled: true,  // Permet au modal de redimensionner en fonction du clavier
      isDismissible: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      context: context,
      builder: (context) {
        // Calculer la hauteur disponible en fonction de la hauteur du clavier
        final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
        return Padding(
          padding: EdgeInsets.only(bottom: keyboardHeight), // Ajuste en fonction du clavier
          child: Container(
            color: Colors.indigo.shade50,
            height: MediaQuery.of(context).size.height * 0.8,
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 5,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        "Mes Résultats Clés",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 3),
                      Text(
                        "Nous fixons au plus 5 résultats clés pour chaque objectif renseigné",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildResultContainer(
                                _resultatUnController,
                                objectifUuid,
                                'Renseigner les résultats attendus',
                              ),
                              _buildResultContainer(
                                _resultatDeuxController,
                                objectifUuid,
                                'Renseigner les résultats attendus',
                              ),
                              _buildResultContainer(
                                _resultatTroisController,
                                objectifUuid,
                                'Renseigner les résultats attendus',
                              ),
                              _buildResultContainer(
                                _resultatQuatreController,
                                objectifUuid,
                                'Renseigner les résultats attendus',
                              ),
                              _buildResultContainer(
                                _resultatCinqController,
                                objectifUuid,
                                'Renseigner les résultats attendus',
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
        );
      },
    );
  }


  Widget _buildResultContainer(TextEditingController controller, String objectifUuid, String hintText) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: Column(
        children: [
          Container(
            height: 150,
            width: 350,
            decoration: BoxDecoration(
              color: Colors.cyan.shade100,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.asset("assets/affaires-noir-expression-heureuse.webp"),
              ],
            ),
          ),
          Container(
            height: 80,
            width: 350,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Material(
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: hintText,
                          hintStyle: const TextStyle(color: Colors.black54, fontSize: 12),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Image.asset("assets/click-gauche (1).webp", width: 30,),
                      onPressed: () => _validateInput(controller, objectifUuid),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.cyan.shade50,
            expandedHeight: 200,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                "assets/but.webp",
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            fillColor: Colors.indigo.shade50,
                            filled: true,
                            hintText: "Entrer l'objectif",
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 30,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (_showPositioned) // Afficher l'icône seulement si nécessaire
                        GestureDetector(
                          onTap: () {
                            _saveObjective();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: const Icon(Icons.vertical_align_bottom, color: Colors.indigo, size: 30),
                          ),
                        ),
                    ],
                  ),
                ),

                buildObjectiveContainer(),
              ],
            ),
          )
        ],
      ),
    );
  }


  Widget buildObjectiveContainer() {
    return Column(
      children: _objectifs.map((objectif) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () async {
              await loadAndFilterObjectifs(objectif['uuid']);
              showCardModal(context, objectif['uuid']);
            },
            borderRadius: BorderRadius.circular(20),
            splashColor: Colors.blueAccent.withOpacity(0.2),
            highlightColor: Colors.blueAccent.withOpacity(0.1),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white70),
              ),
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded( // Utilisez Expanded pour permettre au texte de revenir à la ligne
                    child: Text(
                      objectif['libelle'],
                      style: const TextStyle(fontSize: 15),
                      maxLines: 3, // Limitez le nombre de lignes si nécessaire
                      overflow: TextOverflow.ellipsis, // Ajoutez des points de suspension si le texte est trop long
                    ),
                  ),
                 Image.asset("assets/ciblett.webp", width: 30,)
                 /* CircularPercentIndicator(
                    radius: 25.0,
                    lineWidth: 5.0,
                    percent: 0.0, // Modifier cette valeur en fonction des besoins
                    center: const Text("0%"),
                    progressColor: Colors.cyan,
                  ), */
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
