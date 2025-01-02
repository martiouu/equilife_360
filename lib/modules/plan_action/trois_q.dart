import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../services/ajout_plan_service.dart';
import '../../services/list_objectifBy_resulat.dart';
import '../../services/list_role_service.dart';
import '../../services/liste_objectif_service.dart';

class TroisQ extends StatefulWidget {
  const TroisQ({super.key});

  @override
  State<TroisQ> createState() => _TroisQState();
}

class _TroisQState extends State<TroisQ> {
  final _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();
  final TextEditingController _quoiController = TextEditingController();
  final TextEditingController _quiController = TextEditingController();
  final TextEditingController _quandController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _livrableController = TextEditingController();

  final ObjectifService _objectifService = ObjectifService();
  final ListObjectifByResultat _listobjectifResultatService = ListObjectifByResultat();
  List<dynamic> roles = [];
  List<Map<String, dynamic>> _objectifs = [];
  List<Map<String, dynamic>> _resultats = []; // Pour stocker les résultats associés
  int _selectedIndex = 0;
  String selectedRoleUuid = "";
  String selectedObjectifUuid = "";
  String? _selectedUUID; // UUID sélectionné pour le résultat
  bool _showLivrable = false;
  DateTime? _selectedDate;
  DateTime? _dateSelected;

  @override
  void initState() {
    super.initState();
    _loadRoles(); // Chargement des rôles au démarrage
  }

  @override
  void dispose() {
    _quoiController.dispose();
    _quiController.dispose();
    _quandController.dispose();
    _commentController.dispose();
    _livrableController.dispose();
    super.dispose();
  }

  // Sélection d'un UUID
  void selectUUID(String? uuid) {
    setState(() {
      _selectedUUID = uuid;
    });
  }

  // Sélection de la date
  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: Colors.white,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: _selectedDate ?? DateTime.now(),
            onDateTimeChanged: (DateTime newDate) {
              setState(() {
                _selectedDate = newDate;
              });
            },
          ),
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _dateSelect(BuildContext context) async {
    final DateTime? picked = await showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: Colors.white,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: _dateSelected ?? DateTime.now(),
            onDateTimeChanged: (DateTime newDate) {
              setState(() {
                _dateSelected = newDate;
              });
            },
          ),
        );
      },
    );
    if (picked != null && picked != _dateSelected) {
      setState(() {
        _dateSelected = picked;
      });
    }
  }

  // Ajout du plan
  void ajouterPlan() async {
    AjoutPlanService service = AjoutPlanService();
    try {
      final result = await service.ajoutPlan(
        uuidRole: selectedRoleUuid,
        uuidObjectif: selectedObjectifUuid,
        uuidResultat: _selectedUUID!,
        quand: _formatDate(_selectedDate),
        comment: _commentController.text,
        livrable: _formatDate(_dateSelected),
      );

      print('Résultat : $result');

      // Affiche un message de réussite
      final message = result['message'] ?? 'Opération réussie';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
        ),
      );

    } catch (e) {
      print('Erreur : $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner le résultat'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  // Formater la date
  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd-MM-yyyy').format(date);
  }

  // Chargement des rôles
  Future<void> _loadRoles() async {
    try {
      final listRoleService = ListRoleService();
      final response = await listRoleService.fetchRoles();

      if (response != null && response['data'] != null) {
        setState(() {
          roles = response['data'];
        });
      } else {
        print('Aucune donnée disponible pour les rôles.');
      }
    } catch (e) {
      print('Erreur lors du chargement des rôles : $e');
    }
  }

  // Récupérer les objectifs
  Future<void> _fetchObjectifs() async {
    try {
      final objectifsDynamic = await _objectifService.fetchObjectifs();
      final objectifs = List<Map<String, dynamic>>.from(objectifsDynamic);

      final objectifsFiltres = objectifs.where((objectif) {
        return objectif['equi_role_uuid'] == selectedRoleUuid;
      }).toList();

      setState(() {
        _objectifs = objectifsFiltres;
      });
    } catch (e) {
      print('Erreur lors de la récupération des objectifs: $e');
    }
  }

  // Récupérer les résultats
  Future<void> _fetchResultats(String objectifUuid) async {
    try {
      final resultats = await _listobjectifResultatService.fetchResultats(objectifUuid);
      setState(() {
        _resultats = resultats;
      });
    } catch (e) {
      print('Erreur lors de la récupération des résultats: $e');
    }
  }

  // Afficher la prochaine question
  void _showNextQuestion(String currentField) {
    setState(() {
      switch (currentField) {
        case 'quand':
          break;
        case 'comment':
          _showLivrable = true;
          break;
      }
    });
  }

  // Construire les containers sélectionnables pour les rôles
  Widget _buildSelectableContainer(int index) {
    if (index >= roles.length) {
      return const SizedBox(); // Retourne un SizedBox vide si l'index est hors de portée
    }
    final role = roles[index];

    // Tronquer le texte à 11 caractères et ajouter des points de suspension si nécessaire
    final libelle = (role['libelle'] ?? 'Inconnu').length > 11
        ? (role['libelle'] ?? 'Inconnu').substring(0, 11) + '...'
        : role['libelle'] ?? 'Inconnu';

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRoleUuid = role['uuid'];
          _fetchObjectifs();
          // Revenir à la première page (objectifs) lorsque le rôle est sélectionné
          _pageController.jumpToPage(0); // Ou `animateToPage` si tu veux une animation
        });
      },
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: selectedRoleUuid == role['uuid'] ? Colors.cyan.shade100 : Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.asset(
              "assets/modele.webp", // Assurez-vous que l'image est définie dans le role
              width: 50, // Réduit la taille de l'image
              color: selectedRoleUuid == role['uuid'] ? Colors.brown : Colors.black54,
            ),
          ),
          const SizedBox(height: 2), // Espace entre l'image et le libellé
          Text(
            libelle, // Utilise le libellé tronqué
            style: const TextStyle(
              color: Colors.brown,
              fontSize: 14, // Ajustez la taille du texte si nécessaire
            ),
            textAlign: TextAlign.center, // Centre le texte
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 45, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Image.asset("assets/carre.webp", width: 25),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        "Définir le plan d'action",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black), // Personnalisez le style ici
                      ),
                    ),
                  ),
                  if (_dateSelected != null)
                    IconButton(
                      onPressed: ajouterPlan,
                      icon: Image.asset("assets/telecharger_k.webp", width: 20, color: Colors.cyan.shade900),
                    ),
                ],
              ),
            ),

            Expanded( // Utilisé pour occuper l'espace restant
              child: ListView(
                children: [
                  Column(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: roles.isNotEmpty
                            ? Row(
                          children: List.generate(
                            roles.length,
                                (index) => _buildSelectableContainer(index),
                          ),
                        )
                            : const Center(
                          child: Text(
                            "Veuillez ajouter un rôle dans le module rôle",
                            style: TextStyle(fontSize: 16, color: Colors.black54), // Personnalisez le style ici
                          ),
                        ),
                      ),

                      const SizedBox(height: 5),
                      Visibility(
                        visible: selectedRoleUuid.isNotEmpty,
                        child: Column(
                          children: [
                            if (_objectifs.isNotEmpty) ...[
                              SizedBox(
                                height: 170, // Hauteur fixe pour le conteneur des objectifs
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: _objectifs.map((objectif) {
                                      final isSelected = selectedObjectifUuid == objectif['uuid'];

                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedObjectifUuid = objectif['uuid'];
                                            _fetchResultats(selectedObjectifUuid);
                                          });
                                        },
                                        child: Container(
                                          height: 150,
                                          width: MediaQuery.of(context).size.width * 0.8, // Largeur fixe pour chaque objectif
                                          padding: const EdgeInsets.all(10),
                                          margin: const EdgeInsets.symmetric(horizontal: 8),
                                          decoration: BoxDecoration(
                                            color: isSelected ? Colors.cyan.shade100 : Colors.white,
                                            borderRadius: BorderRadius.circular(8.0),
                                            border: Border.all(
                                              color: isSelected ? Colors.cyan : Colors.grey.shade200,
                                              width: 1,
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                children: [
                                                  Image.asset("assets/aspirant.webp", width: 45, color: Colors.brown,),
                                                ],
                                              ),
                                              const SizedBox(height: 15),
                                              Row(
                                                children: [
                                                  Text(
                                                    objectif['libelle'] ?? 'Objectif',
                                                    maxLines: 3, // Limite le texte à trois lignes maximum
                                                    overflow: TextOverflow.ellipsis, // Points de suspension si le texte est trop long
                                                    style: const TextStyle(fontSize: 14, color: Colors.brown),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ],
                            if (_resultats.isNotEmpty) ...[
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _resultats.length,
                                  itemBuilder: (context, index) {
                                    final resultat = _resultats[index];
                                    return GestureDetector(
                                      onTap: () {
                                        selectUUID(resultat['uuid']);
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.all(8.0),
                                        padding: const EdgeInsets.all(16.0),
                                        decoration: BoxDecoration(
                                          color: _selectedUUID == resultat['uuid']
                                              ? Colors.cyan.shade100
                                              : Colors.grey.shade200,
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        child: Text(
                                          resultat['description'] ?? 'Résultat',
                                          style: const TextStyle(fontSize: 16, color: Colors.black),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                            Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 20),
                                  Column(
                                    children: [
                                      const Row(
                                        children: [
                                          Text("Quand ?", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      GestureDetector(
                                        onTap: () => _selectDate(context),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                                          child: Row(
                                            children: [
                                              Text(
                                                _selectedDate != null
                                                    ? '${_selectedDate!.day.toString().padLeft(2, '0')}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.year}'
                                                    : 'Sélectionner la date',
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  color: _selectedDate != null ? Colors.black : Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Column(
                                    children: [
                                      const Row(
                                        children: [
                                          Text("Comment ?", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      TextFormField(
                                        controller: _commentController,
                                        decoration: const InputDecoration(
                                          hintText: 'Remplir et valider',
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Veuillez entrer le comment';
                                          }
                                          return null;
                                        },
                                        onFieldSubmitted: (value) {
                                          if (_formKey.currentState!.validate()) {
                                            _showNextQuestion('comment');
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Column(
                                    children: [
                                      const Row(
                                        children: [
                                          Text("Livrable ?", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      GestureDetector(
                                        onTap: () => _dateSelect(context),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                                          child: Row(
                                            children: [
                                              Text(
                                                _dateSelected != null
                                                    ? '${_dateSelected!.day.toString().padLeft(2, '0')}-${_dateSelected!.month.toString().padLeft(2, '0')}-${_dateSelected!.year}'
                                                    : 'Sélectionner la date',
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  color: _dateSelected != null ? Colors.black : Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

    );
  }
}
