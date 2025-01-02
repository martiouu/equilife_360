import  'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/logout_out_service.dart';
import '../authentification/login_form.dart';

class Accueil extends StatefulWidget {
  const Accueil({super.key});

  @override
  State<Accueil> createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  String welcomeMessage = '';
  final LogoutService _logoutService = LogoutService();

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _handleLogout(BuildContext context) async {
    // Appel au service de déconnexion
    final result = await _logoutService.deconnexionUtilisateur();

    if (result['success'] == true) {
      // Déconnexion réussie, naviguez vers la page de connexion ou l'écran d'accueil
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginForm()), // Remplacez par votre page de connexion ou écran d'accueil
      );
    } else {
      // Afficher un message d'erreur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Échec de la déconnexion')),
      );
    }
  }

  Future<void> _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String fullName = prefs.getString('first_name') ?? '';
    String lastName = prefs.getString('last_name') ?? '';

    // Extraire le premier prénom
    String firstName = fullName.isNotEmpty ? fullName.split(' ').first : '';

    setState(() {
      welcomeMessage = '$firstName $lastName'; // Combine le premier prénom et le nom de famille
    });
  }



  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return PopScope(
      canPop: true,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset("assets/pere.webp", width: 50,),
                    IconButton(
                      onPressed: () => _handleLogout(context),
                      icon: Icon(Ionicons.power, color: Colors.red.shade800, size: 30,),),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // welcome home
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Bienvenue chez vous,",
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
                    ),
                    const SizedBox(height: 3), // Ajoute un espace entre les deux lignes de texte
                    Text(
                      welcomeMessage,
                      style: GoogleFonts.bebasNeue(fontSize: 16),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        SizedBox(height: 40),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          child: Container(
                            height: screenHeight * 0.18, // Hauteur responsive ajustée
                            decoration: BoxDecoration(
                              color: Colors.cyan.shade800,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Stack(
                              clipBehavior: Clip.none, // Permet à l'image de déborder hors du Container
                              children: [
                                // Image en arrière-plan qui déborde
                                Positioned(
                                  bottom: -screenHeight * 0.00, // Décalage négatif pour faire déborder l'image
                                  left: screenWidth * 0.35,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.asset(
                                      "assets/rejouissant-jeune.webp",
                                      fit: BoxFit.cover,
                                      height: screenHeight * 0.22, // Hauteur de l'image ajustée pour déborder
                                    ),
                                  ),
                                ),
                                // Texte animé
                                Positioned(
                                  left: 10,
                                  top: screenHeight * 0.05, // Position responsive
                                  child: SizedBox(
                                    width: screenWidth * 0.4, // Largeur responsive
                                    child: Text(
                                      "Enrichissez Chaque Facette De Votre Vie",
                                      style: GoogleFonts.sofadiOne(
                                        color: Colors.white,
                                        fontSize: screenHeight * 0.023, // Taille de police responsive
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),


                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, 'Agenda');
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      height: 250,
                                      width: MediaQuery.of(context).size.width * 0.45,
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Planification Agenda",
                                                  style: TextStyle(
                                                    color: Colors.cyan,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                SizedBox(height: 4),
                                                Text(
                                                  "Structuration de routines quotidiennes",
                                                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Image.asset("assets/rappel-devenement.webp", fit: BoxFit.cover),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text("Planification agenda", style: TextStyle(fontSize: 14),),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Container(
                                      height: 270,
                                      width: MediaQuery.of(context).size.width * 0.5,
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Column(
                                                children: [
                                                  _buildIconContainerRoue(context, "assets/roue-du-dharma.webp", () {
                                                    Navigator.pushNamed(context, 'LifeWheel');
                                                  }),
                                                  const SizedBox(height: 8),
                                                  const Text("Roue de la vie", style: TextStyle(fontSize: 14),),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  _buildIconContainer(context, "assets/calculatrice.webp", (){
                                                    Navigator.pushNamed(context, 'CoutHoraire');
                                                  }),
                                                  const SizedBox(height: 8),
                                                  const Text("Cout horaire", style: TextStyle(fontSize: 14)),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 30),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Column(
                                                children: [
                                                  _buildIconContainer(context, "assets/pyramide (1).webp", () {
                                                    Navigator.pushNamed(context, 'Pyramide');
                                                  }),
                                                  const SizedBox(height: 8),
                                                  const Text("Pyramide", style: TextStyle(fontSize: 14)),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  _buildIconContainer(context, "assets/matriceP.webp", () {
                                                    Navigator.pushNamed(context, 'Matrice');
                                                  }),
                                                  const SizedBox(height: 8),
                                                  const Text("Matrice", style: TextStyle(fontSize: 14)),
                                                ],
                                              ),
                                            ],
                                          )

                                        ],
                                      ),
                                    ),
                                  ],
                                ),
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
          ),
        ),
      ),
    );
  }

  Widget _buildIconContainer(BuildContext context, String assetPath, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      child: SizedBox(
        height: 90,
        width: MediaQuery.of(context).size.width * 0.09,
        child: Center(
          child: CircleAvatar(
            radius: 15, // Ajustez ce rayon selon vos besoins
            backgroundColor: Colors.transparent,
            backgroundImage: AssetImage(assetPath),
          ),
        ),
      ),
    );
  }

  Widget _buildIconContainerRoue(BuildContext context, String assetPath, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      child: SizedBox(
        height: 90,
        width: MediaQuery.of(context).size.width * 0.09,
        child: Center(
          child: Hero(
            tag: 'lifeWheelHero', // Tag unique pour l'animation
            child: CircleAvatar(
              radius: 15,
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage(assetPath),
            ),
          ),
        ),
      ),
    );
  }

}
