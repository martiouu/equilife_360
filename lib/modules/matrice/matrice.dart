import 'package:flutter/cupertino.dart';
import  'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../services/liste_tache_service.dart';
import '../../services/matrice_covey_service.dart';

class MatricePage extends StatefulWidget {
  const MatricePage({super.key});

  @override
  State<MatricePage> createState() => _MatricePageState();
}

class _MatricePageState extends State<MatricePage> {
  final MatriceCoveyService _coveyService = MatriceCoveyService();
  final ListeTacheService _listeTacheService = ListeTacheService();
  List<dynamic> tachesSansCovey = [];

  //Filtre des listes
  List importantUrgent = [];
  List importantNonUrgent = [];
  List nonImportantUrgent = [];
  List nonImportantNonUrgent = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Appel de _showMyBottomSheet dès que la page est affichée
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showMyBottomSheet(context);
    });

    filterTachesByStatus();
  }

  Future<void> filterTachesByStatus() async {
    // Réinitialiser les listes pour éviter les doublons
    importantUrgent.clear();
    importantNonUrgent.clear();
    nonImportantUrgent.clear();
    nonImportantNonUrgent.clear();
    final taches = await ListeTacheService().fetchTaches();

    setState(() {
      for (var tache in taches) {
        String? statusCovey = tache['status_covey'];

        if (statusCovey == 'important_urg') {
          importantUrgent.add(tache);
        } else if (statusCovey == 'important_non_urg') {
          importantNonUrgent.add(tache);
        } else if (statusCovey == 'non_important_urg') {
          nonImportantUrgent.add(tache);
        } else if (statusCovey == 'non_important_non_urg') {
          nonImportantNonUrgent.add(tache);
        }
      }
      isLoading = false; // Fin du chargement
    });
  }


  // Méthode pour charger les tâches filtrées
  Future<List<dynamic>> fetchTachesSansCovey() async {
    final taches = await ListeTacheService().fetchTaches();
    // Filtrer les tâches dont status_covey est null
    return taches.where((tache) => tache['status_covey'] == null).toList();
  }


  // Méthode pour mettre à jour une tâche spécifique avec un statut Covey
  Future<void> _updateTacheCovey(String uuid, String statusCovey, StateSetter setModalState) async {
    // Mettez à jour une seule touche avec son statut Covey
    bool success = await _coveyService.updateTachesMatrice([uuid], [statusCovey]);
    if (success) {
      print('Tâche mise à jour avec succès');
      // Recharger la liste des tâches après mise à jour
      final updatedTaches = await fetchTachesSansCovey();
      setModalState(() {
        tachesSansCovey = updatedTaches; // Actualiser la liste des tâches affichée
      });
    } else {
      print('Erreur lors de la mise à jour de la tâche');
    }
  }

  // Méthode pour afficher la feuille de sélection des tâches
  void _showMyBottomSheet(BuildContext context) async {
    // Charger les tâches avant d'afficher le BottomSheet
    tachesSansCovey = await fetchTachesSansCovey();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext modalContext, StateSetter setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Colors.black87.withOpacity(0.8),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 80),
                        const Center(
                          child: Text(
                            'Voulez-vous classifier vos tâches pour un aperçu de la matrice de Covey',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Affichage de la liste des tâches sans statut Covey
                        Expanded(
                          child: tachesSansCovey.isEmpty
                              ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset("assets/erreur-404.webp", width: 50, color: Colors.white70),
                                const SizedBox(height: 5),
                                const Text(
                                  'Veuillez ajouter une tâche dans le module activités/tâches',
                                  style: TextStyle(color: Colors.white70, fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                              : ListView.builder(
                            itemCount: tachesSansCovey.length,
                            itemBuilder: (context, index) {
                              final tache = tachesSansCovey[index];
                              return ListTile(
                                leading: const Icon(Icons.emoji_objects, size: 30, color: Colors.white),
                                title: Text(
                                  tache['tache_executer'],
                                    style: const TextStyle(color: Colors.white, fontSize: 15),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  tache['type'],
                                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                onTap: () {
                                  // Afficher le CupertinoActionSheet pour le choix du statut
                                  showCupertinoModalPopup(
                                    context: context,
                                    builder: (BuildContext context) => CupertinoActionSheet(
                                      actions: [
                                        CupertinoActionSheetAction(
                                          onPressed: () async {
                                            await _updateTacheCovey(tache['uuid'], 'important_urg', setModalState);
                                            Navigator.pop(context); // Fermer la fenêtre de choix
                                          },
                                          child: const Text('Important Urgent', style: TextStyle(color: Colors.indigo)),
                                        ),
                                        CupertinoActionSheetAction(
                                          onPressed: () async {
                                            await _updateTacheCovey(tache['uuid'], 'important_non_urg', setModalState);
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Important non urgent', style: TextStyle(color: Colors.indigo)),
                                        ),
                                        CupertinoActionSheetAction(
                                          onPressed: () async {
                                            await _updateTacheCovey(tache['uuid'], 'non_important_urg', setModalState);
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Non important urgent', style: TextStyle(color: Colors.indigo)),
                                        ),
                                        CupertinoActionSheetAction(
                                          onPressed: () async {
                                            await _updateTacheCovey(tache['uuid'], 'non_important_non_urg', setModalState);
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Non important non urgent', style: TextStyle(color: Colors.indigo)),
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
                              );
                            },
                          ),
                        ),

                      ],
                    ),
                  ),
                  // Bouton de fermeture du BottomSheet
                  Positioned(
                    bottom: 16,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white, size: 30),
                        onPressed: () {
                          filterTachesByStatus();
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(20.0),
            bottomLeft: Radius.circular(20.0),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.cyan.shade700,
        centerTitle: true,
        title: const Text(
          "Matrice",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, // Change la couleur de l'icône de retour ici
        ),
        actions: [
          IconButton(
              onPressed: (){
                _showMyBottomSheet(context);
              },
              icon: Icon(Icons.offline_share_rounded, size: 25),
          )
        ],
      ),

      body: isLoading
          ? Center(
        child: SpinKitWanderingCubes(
          color: Colors.cyan, // Couleur de votre choix
          size: 25.0,
        ),
      )
          : SingleChildScrollView(
        child: Column(
          children: [
            // Ajout du GridView ici
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                shrinkWrap: true, // Important pour le GridView dans un SingleChildScrollView
                physics: NeverScrollableScrollPhysics(), // Désactive le défilement dans le GridView
                children: [
                  CoveyQuadrant(
                    title: 'Important et urgent',
                    subTitle: '(A faire soi même)',
                    description: 'Important et Urgent',
                    color: Colors.red.shade900,
                  ),
                  CoveyQuadrant(
                    title: 'Important non urgent',
                    subTitle: '(A planifier)',
                    description: 'Important mais Pas Urgent',
                    color: Colors.red.shade600,
                  ),
                  CoveyQuadrant(
                    title: 'Non important et urgent',
                    subTitle: '(A déléguer)',
                    description: 'Pas Important mais Urgent',
                    color: Colors.green.shade900,
                  ),
                  CoveyQuadrant(
                    title: 'Non important et non urgent',
                    subTitle: '(A éliminer)',
                    description: 'Pas Important et Pas Urgent',
                    color: Colors.green.shade600,
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),
            // Liste 1: importantUrgent
            Padding(
              padding: const EdgeInsets.only(right: 50.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(20),
                    topRight: Radius.circular(20),
                  )
                ),
                height: 60,
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 10,
                      child: Image.asset("assets/ombre.webp", width: 30, color: Colors.red.shade900),
                    ),
                    SizedBox(width: 10),
                    Text("Important et urgent",style: TextStyle(fontSize: 16),)
                  ],
                ),
              ),
            ),
            SizedBox(height: 5),
            Column(
              children: importantUrgent.isNotEmpty
                  ? importantUrgent.map((tache) {
                return ListTile(
                  title: Text(
                    tache['tache_executer'] ?? '',
                    style: const TextStyle(color: Colors.black, fontSize: 15),
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    tache['type'] ?? '',
                    style: const TextStyle(color: Colors.black54, fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList()
                  : [
                SizedBox(height: 10),
                Text("Aucune tâche importante et urgente.", style: TextStyle(color: Colors.grey)),
              ], // Message si la liste est vide
            ),
            SizedBox(height: 10),
            // Liste 2: importantNonUrgent
            Padding(
              padding: const EdgeInsets.only(right: 50.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20),
                      topRight: Radius.circular(20),
                    )
                ),
                height: 60,
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 10,
                      child: Image.asset("assets/ombre.webp", width: 30, color: Colors.red.shade600),
                    ),
                    SizedBox(width: 10),
                    Text("Important et non urgent",style: TextStyle(fontSize: 16),)
                  ],
                ),
              ),
            ),
            Column(
              children: importantNonUrgent.isNotEmpty
                  ? importantNonUrgent.map((tache) {
                return ListTile(
                  title: Text(
                    tache['tache_executer'] ?? '',
                    style: const TextStyle(color: Colors.black, fontSize: 15),
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    tache['type'] ?? '',
                    style: const TextStyle(color: Colors.black54, fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList()
                  : [
                SizedBox(height: 10),
                Text("Aucune tâche importante non urgente.", style: TextStyle(color: Colors.grey)),
              ],
            ),
            SizedBox(height: 10),
            // Liste 3: nonImportantUrgent
            Padding(
              padding: const EdgeInsets.only(right: 50.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20),
                      topRight: Radius.circular(20),
                    )
                ),
                height: 60,
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 10,
                      child: Image.asset("assets/ombre.webp", width: 30, color: Colors.green.shade900),
                    ),
                    SizedBox(width: 10),
                    Text("Non important et urgent",style: TextStyle(fontSize: 16),)
                  ],
                ),
              ),
            ),
            Column(
              children: nonImportantUrgent.isNotEmpty
                  ? nonImportantUrgent.map((tache) {
                return ListTile(
                  title: Text(
                    tache['tache_executer'] ?? '',
                    style: const TextStyle(color: Colors.black, fontSize: 15),
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    tache['type'] ?? '',
                    style: const TextStyle(color: Colors.black54, fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList()
                  : [
                SizedBox(height: 10),
                Text("Aucune tâche non importante urgente.", style: TextStyle(color: Colors.grey)),
              ],
            ),
            SizedBox(height: 10),
            // Liste 4: nonImportantNonUrgent
            Padding(
              padding: const EdgeInsets.only(right: 50.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20),
                      topRight: Radius.circular(20),
                    )
                ),
                height: 60,
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 10,
                      child: Image.asset("assets/ombre.webp", width: 30, color: Colors.green.shade600),
                    ),
                    SizedBox(width: 10),
                    Text("Non important et non urgent",style: TextStyle(fontSize: 16),)
                  ],
                ),
              ),
            ),
            Column(
              children: nonImportantNonUrgent.isNotEmpty
                  ? nonImportantNonUrgent.map((tache) {
                return ListTile(
                  title: Text(
                    tache['tache_executer'] ?? '',
                    style: const TextStyle(color: Colors.black, fontSize: 15),
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    tache['type'] ?? '',
                    style: const TextStyle(color: Colors.black54, fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList()
                  : [
                SizedBox(height: 10),
                Text("Aucune tâche non importante non urgente.", style: TextStyle(color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),


    );
  }
}

class CoveyQuadrant extends StatelessWidget {
  final String title;
  final String subTitle;
  final String description;
  final Color color;

  const CoveyQuadrant({super.key,
    required this.title,
    required this.subTitle,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            subTitle,
            style: const TextStyle(
              fontSize: 12.0,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10.0),
          Text(
            description,
            style: const TextStyle(
              fontSize: 13.0,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
