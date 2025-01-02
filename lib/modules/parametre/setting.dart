import  'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constantes/widgets/forward_button.dart';
import '../../constantes/widgets/setting_item.dart';
import '../../constantes/widgets/setting_switch.dart';
import '../theme_provider.dart';
import 'edit_screen.dart';

class Parametre extends StatefulWidget {
  const Parametre({super.key});

  @override
  State<Parametre> createState() => _ParametreState();
}

class _ParametreState extends State<Parametre> {
  String welcomeMessage = '';

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String fullName = prefs.getString('first_name') ?? '';
    String lastName = prefs.getString('last_name') ?? '';

    // Extraire le premier prénom
    String firstName = fullName.isNotEmpty ? fullName.split(' ').first : '';

    setState(() {
      welcomeMessage = '${capitalize(firstName)} ${capitalize(lastName)}'; // Combine le premier prénom et le nom de famille
    });
  }

  // Fonction pour mettre la première lettre en majuscule
  String capitalize(String input) {
    if (input.isEmpty) return '';
    return input[0].toUpperCase() + input.substring(1).toLowerCase();
  }


  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return PopScope(
      canPop: true,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
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
            "Paramètres",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                const Text(
                  "Mon Compte",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    children: [
                      Image.asset("assets/utilisateur.webp", width: 30, height: 40),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            welcomeMessage,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Text(
                            "Membre Equilife360",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                      const Spacer(),
                      ForwardButton(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EditAccountScreen(),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  "Outils",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                SettingItem(
                  title: "Langue",
                  icon: Ionicons.earth,
                  bgColor: Colors.orange.shade100,
                  iconColor: Colors.orange,
                  value: "Francais",
                  onTap: () {},
                ),
                const SizedBox(height: 20),
                SettingItem(
                  title: "Notifications",
                  icon: Ionicons.notifications,
                  bgColor: Colors.blue.shade100,
                  iconColor: Colors.blue,
                  onTap: () {},
                ),
                const SizedBox(height: 20),
                SettingSwitch(
                  title: "Dark Mode",
                  icon: Ionicons.moon,
                  bgColor: Colors.purple.shade100,
                  iconColor: Colors.purple,
                  value: themeProvider.isDarkMode,
                  onTap: (value) {
                    themeProvider.toggleTheme(value);
                  },
                ),
                const SizedBox(height: 20),
                SettingItem(
                  title: "Aide",
                  icon: Ionicons.help,
                  bgColor: Colors.red.shade100,
                  iconColor: Colors.red,
                  onTap: () {},
                ),
                const SizedBox(height: 40),

                GestureDetector(
                  onTap: (){
                    //Navigator.pushNamed(context, 'Offre');

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Cette option est indisponible',
                          style: TextStyle(color: Colors.black),
                        ),
                        backgroundColor: Colors.cyan.shade100,
                        behavior: SnackBarBehavior.floating,
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.indigo.shade300,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white70,
                      ),
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          left: -10, // Ajustez cette valeur pour contrôler le débordement de l'image
                          top: -25, // Ajustez cette valeur pour positionner verticalement l'image
                          child: Image.asset(
                            'assets/fusee.webp', // Remplacez par le chemin de votre image
                            width: 65, // Ajustez la largeur de l'image
                            height: 65, // Ajustez la hauteur de l'image
                          ),
                        ),
                        const Positioned.fill(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(width: 40), // Espace pour laisser de la place à l'image
                              Text(
                                "Prêt à passer à l'offre premium",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold,
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
        ),
      ),
    );
  }
}

