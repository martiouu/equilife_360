import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MissionDeVie extends StatefulWidget {
  const MissionDeVie({super.key});

  @override
  State<MissionDeVie> createState() => _MissionDeVieState();
}

class _MissionDeVieState extends State<MissionDeVie> {
  final TextEditingController _missionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMission(); // Charger la mission de vie au démarrage
  }

  // Fonction pour charger la mission de vie à partir des SharedPreferences
  Future<void> _loadMission() async {
    final prefs = await SharedPreferences.getInstance();
    final mission = prefs.getString('missionDeVie'); // Récupère la mission de vie sauvegardée
    if (mission != null) {
      _missionController.text = mission; // Si une mission est trouvée, la mettre dans le controller
    }
  }

  // Fonction pour sauvegarder la mission de vie dans SharedPreferences
  Future<void> _saveMission(String mission) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('missionDeVie', mission); // Sauvegarde la mission dans SharedPreferences
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Image en arrière-plan
          Positioned.fill(
            child: Image.asset(
              'assets/29376.webp', // Chemin vers ton image
              fit: BoxFit.cover, // Adapte l'image à la taille de l'écran
            ),
          ),

          // Flèche de retour en haut à gauche
          Positioned(
            top: 55, // Ajuste la position verticale
            left: 20, // Ajuste la position horizontale
            child: InkWell(
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
          ),

          // Container blanc en bas
          Positioned(
            bottom: 60, // Le container est collé en bas
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                height: 200, // Hauteur du container
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/bg.webp'), // Remplace avec ton image
                    fit: BoxFit.cover, // Adapte l'image à la taille du container
                  ),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10), // Coins arrondis
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextField(
                    controller: _missionController, // Le contrôleur du TextField
                    decoration: const InputDecoration(
                      hintText: 'Définir votre mission de vie ici...', // Placeholder
                      border: InputBorder.none, // Pas de bordure visible
                    ),
                    maxLines: null, // Permet d'écrire plusieurs lignes
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    onChanged: (text) {
                      // Sauvegarde la mission à chaque modification
                      _saveMission(text);
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
