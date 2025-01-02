import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lottie/lottie.dart';
import '../../services/ajoutRoleService.dart';
import '../../services/deleteRoleService.dart';
import '../../services/list_role_service.dart';
import '../../services/modifier_role_service.dart';
import '../animated_page.dart';

class RoleForm extends StatefulWidget {
  const RoleForm({super.key});

  @override
  State<RoleForm> createState() => _RoleFormState();
}

class _RoleFormState extends State<RoleForm> with TickerProviderStateMixin {
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _roleModifController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _descriptionModifController = TextEditingController();
  List<dynamic> roles = [];
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    // Initialize the animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showInfo(context); // Lancement du dialogue après la première frame
    });
    _loadRoles();
  }

  @override
  void dispose() {
    // Always dispose controllers to avoid memory leaks
    _roleController.dispose();
    _roleModifController.dispose();
    _descriptionController.dispose();
    _descriptionModifController.dispose();
    _animationController.dispose();
    super.dispose();
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "La fonctionnalité Rôle",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Image.asset("assets/swipe-right.webp", width: 30, color: Colors.cyan.shade900),
                    const SizedBox(height: 8),
                    const Text(
                      "Swipe à gauche\npour modifier",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Image.asset("assets/swipe-left.webp", width: 30, color: Colors.cyan.shade900),
                    const SizedBox(height: 8),
                    const Text(
                      "Swipe à droite\npour fixer un objectif",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }



  Future<void> _loadRoles() async {
    try {
      // Créez une instance de ListRoleService et récupérez les données
      final listRoleService = ListRoleService();
      final response = await listRoleService.fetchRoles();

      if (response != null && response['data'] != null) {
        // Mettez à jour la liste des rôles
        setState(() {
          roles = response['data'];

          print("role: $roles");
        });
      } else {
        // Gérer les cas où il n'y a pas de données ou une erreur
        print('Aucune donnée disponible ou erreur lors de la récupération des rôles.');
      }
    } catch (e) {
      // Gérer les exceptions
      print('Exception lors du chargement des rôles : $e');
    }
  }
  // Fonction pour afficher le modal de modification du rôle
  void _showModifRole(BuildContext context, String uuid) {
    print("UUID : $uuid");

    // Parcourez la liste des rôles et trouvez celui correspondant à l'UUID
    for (var role in roles) {
      if (role['uuid'] == uuid) {
        // Remplissez les champs avec les valeurs du rôle correspondant
        _roleModifController.text = role['libelle'] ?? ''; // Utilisez une valeur par défaut si null
        _descriptionModifController.text = role['description'] ?? ''; // Utilisez une valeur par défaut si null
        break; // Sortir de la boucle une fois que le rôle est trouvé
      }
    }

    showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext modalContext, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(modalContext).viewInsets.bottom,
              ),
              child: Container(
                color: Colors.cyan.withOpacity(0.08),
                height: MediaQuery.of(modalContext).size.height * 0.5,
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 3),
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
                    const SizedBox(height: 10),
                    Container(
                      height: 63,
                      padding: const EdgeInsets.all(10.0),
                      child: const Center(
                        child: Text(
                          "MODIFIER UN ROLE",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ),
                    ),
                    // Champs du formulaire, modifiés avec les valeurs du rôle trouvé
                    TextFormField(
                      controller: _roleModifController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(5.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(5.5),
                        ),
                        prefixIcon: const Icon(Icons.person_outline, color: Colors.black),
                        hintText: 'Saisir le rôle',
                        hintStyle: const TextStyle(color: Colors.black, fontSize: 15),
                        filled: true,
                        fillColor: Colors.white70,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _descriptionModifController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(5.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(5.5),
                        ),
                        prefixIcon: const Icon(Icons.description, color: Colors.black),
                        hintText: 'Entrer une description',
                        hintStyle: const TextStyle(color: Colors.black, fontSize: 15),
                        filled: true,
                        fillColor: Colors.white70,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      ),
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () async {
                        final updateRoleService = UpdateRoleService();

                        // Appel du service pour mettre à jour le rôle
                        final response = await updateRoleService.updateRole(
                          libelle: _roleModifController.text,
                          description: _descriptionModifController.text,
                          uuid: uuid, // L'UUID du rôle passé au modal
                        );

                        if (response != null) {
                          // Met à jour la liste des rôles
                          await _loadRoles();
                          // Réinitialise les champs de saisie après l'enregistrement
                          _roleModifController.clear();
                          _descriptionModifController.clear();

                          Navigator.pop(modalContext); // Ferme le modal après l'ajout
                        } else {
                          // Afficher un message d'erreur si l'ajout échoue
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Erreur lors de l\'ajout du rôle')),
                          );
                        }
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.06,
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.cyan),
                          color: Colors.transparent,
                        ),
                        child: const Center(
                          child: Text(
                            "Modifier",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.cyan,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }


  // Fonction pour afficher le modal d'ajout de rôle
  void _showRole(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext modalContext, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(modalContext).viewInsets.bottom,
              ),
              child: Container(
                color: Colors.cyan.withOpacity(0.08),
                height: MediaQuery.of(modalContext).size.height * 0.5, // Taille responsive
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(modalContext).size.width * 0.05, // Padding responsive
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 5),
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
                    const SizedBox(height: 10),
                    Container(
                      height: MediaQuery.of(modalContext).size.height * 0.08, // Taille responsive
                      padding: const EdgeInsets.all(10.0),
                      child: const Center(
                        child: Text(
                          "CREER VOTRE ROLE",
                          style: TextStyle(
                            fontSize: 15, // Taille responsive
                            color: Colors.blueGrey,
                          ),
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: _roleController, // Contrôleur inchangé
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(5.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(5.5),
                        ),
                        prefixIcon: const Icon(Icons.person_outline, color: Colors.black),
                        hintText: 'Entrer mon role',
                        hintStyle: const TextStyle(fontSize: 14),
                        filled: true,
                        fillColor: Colors.white70,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(modalContext).size.width * 0.05, // Padding responsive
                          vertical: MediaQuery.of(modalContext).size.height * 0.02, // Padding responsive
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _descriptionController, // Contrôleur inchangé
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(5.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(5.5),
                        ),
                        prefixIcon: const Icon(Icons.description, color: Colors.black),
                        hintText: 'Entrer une description',
                        hintStyle: const TextStyle(fontSize: 14),
                        filled: true,
                        fillColor: Colors.white70,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(modalContext).size.width * 0.05, // Padding responsive
                          vertical: MediaQuery.of(modalContext).size.height * 0.02, // Padding responsive
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () async {
                        // Appel du service pour enregistrer le rôle
                        final String libelle = _roleController.text.toLowerCase(); // Contrôleur inchangé
                        final String description = _descriptionController.text.toLowerCase(); // Contrôleur inchangé

                        // Assurez-vous d'avoir une instance de votre RoleService
                        RoleService roleService = RoleService();

                        List<dynamic>? result = await roleService.ajoutRoleService(libelle, description);

                        if (result != null) {
                          // Met à jour la liste des rôles
                          setState(() {
                            roles = result;
                          });

                          // Réinitialise les champs de saisie après l'enregistrement
                          _roleController.clear(); // Contrôleur inchangé
                          _descriptionController.clear(); // Contrôleur inchangé

                          Navigator.pop(modalContext); // Ferme le modal après l'ajout
                        } else {
                          print(libelle);
                          // Afficher un message d'erreur si l'ajout échoue
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Erreur lors de l\'ajout du rôle')),
                          );
                        }
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.06, // Taille responsive
                        width: MediaQuery.of(context).size.width * 0.9, // Taille responsive
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.cyan),
                          color: Colors.transparent,
                        ),
                        child: const Center(
                          child: Text(
                            "S'enregistrer",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.cyan,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 45, bottom: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    borderRadius: BorderRadius.circular(40),
                    child: CircleAvatar(
                      backgroundImage: const AssetImage("assets/bg.webp"),
                      radius: 30,
                      backgroundColor: Colors.grey.shade100,
                      child: Image.asset("assets/fleche-gauched.webp", height: 25),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _showRole(context);
                    },
                    borderRadius: BorderRadius.circular(40),
                    child: CircleAvatar(
                      backgroundImage: const AssetImage("assets/bg.webp"),
                      radius: 30,
                      backgroundColor: Colors.grey.shade100,
                      child: Image.asset("assets/ajouterd.webp", height: 25, color: Colors.cyan),
                    ),
                  ),
                ],
              ),
            ),
            // Affichage du texte de personnalisation en haut
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Personnaliser",
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "Votre Role",
                        style: TextStyle(color: Colors.cyan.shade900, fontSize: 25, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            // Vérification de la liste des rôles
            roles.isEmpty
                ? Flexible(
                  child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 200,
                        child: Lottie.asset(
                          "assets/animations/Animation - 1726474541662.json",
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                            'Aucun rôle disponible. Veuillez enregistrer un role selon vos objectifs',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black54
                          ),
                        ),
                      ),
                    ],
                  )),
                )
                : Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: roles.map((role) => Column(
                    children: [
                      Slidable(
                        endActionPane: ActionPane(
                          motion: const DrawerMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                final uuid = role["uuid"] ?? ''; // Assurez-vous que c'est bien une chaîne de caractères
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) =>
                                        AnimatedPage(uuid: uuid), // Passez l'UUID ici
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                      return ScaleTransition(
                                        scale: animation,
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              },
                              icon: Icons.auto_fix_high,
                              backgroundColor: Colors.cyan,
                              foregroundColor: Colors.white,
                              label: 'Fixer les objectifs',
                            ),
                          ],
                        ),
                        startActionPane: ActionPane(
                            motion: const DrawerMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  final uuid = role["uuid"] ?? ''; // Assurez-vous que c'est bien une chaîne de caractères
                                  _showModifRole(context, uuid);
                                },
                                icon: Icons.edit,
                                backgroundColor: Colors.cyan.shade900,
                                foregroundColor: Colors.white,
                                label: 'Modifier le role',
                              ),
                            ]
                        ),
                        child: InkWell(
                          onTap: (){
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  backgroundColor: Colors.cyan.shade900,
                                  child: Container(
                                    padding: const EdgeInsets.all(16), // Ajoutez du padding pour l'espacement interne
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.asset("assets/panneau-davertissement.webp", width: 80),
                                        const SizedBox(height: 10),
                                        const Text(
                                          "Alert",
                                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                        ),
                                        const Text(
                                          "Voulez vous supprimer ce role ?",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 18),
                                        ),

                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            OutlinedButton(
                                                style: OutlinedButton.styleFrom(
                                                  padding: const EdgeInsets.symmetric(
                                                    vertical: 8,
                                                    horizontal: 30,
                                                  ),
                                                  foregroundColor: Colors.red.shade900,
                                                  side: BorderSide(
                                                    color: Colors.grey.shade50
                                                  ),
                                                ),
                                              onPressed: (){
                                                  Navigator.pop(context);
                                              },
                                              child: const Text("Annuler", style: TextStyle(fontSize: 16)),
                                            ),
                                            OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                padding: const EdgeInsets.symmetric(
                                                  vertical: 8,
                                                  horizontal: 30,
                                                ),
                                                foregroundColor: Colors.green.shade900,
                                                side: BorderSide(
                                                    color: Colors.grey.shade50
                                                ),
                                              ),
                                              onPressed: () async {
                                                final uuid = role['uuid'] ?? '';
                                                try {
                                                  DeleteRoleService deleteRoleService = DeleteRoleService();
                                                  final result = await deleteRoleService.deleteRole(uuid);

                                                  print(uuid);
                                                  // Afficher un message de succès ou d'erreur
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text(result)),
                                                  );

                                                  if (result.contains('Suppression réussie')) {
                                                    setState(() {
                                                      roles.removeWhere((item) => item['uuid'] == uuid);
                                                    });
                                                  }
                                                } catch (e) {
                                                  print('Erreur lors de la suppression : $e');
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('Erreur lors de la suppression')),
                                                  );
                                                }

                                                // Fermer le dialog après l'opération
                                                Navigator.pop(context);
                                              },
                                              child: const Text("Confirmer", style: TextStyle(fontSize: 16),),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Container(
                            color: Colors.cyan.shade50,
                            child: ListTile(
                              title: Text(
                                role['libelle'] != null && role['libelle']!.isNotEmpty
                                    ? '${role['libelle']![0].toUpperCase()}${role['libelle']!.substring(1).toLowerCase()}'
                                    : '',
                              ),
                              leading: Image.asset(
                                "assets/chapeau.webp",
                                width: 30,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  )).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}