
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constantes/sizes.dart';
import '../../services/faceid_service.dart';
import '../../services/login_service.dart';
import '../bar_navigation/bouton_navigation_bar.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  dynamic dataRetour;
  bool _rememberMe = false;
  bool _showAnimation = false;
  bool _obscurePassword = true; // Gère l'état de visibilité du mot de passe

  final LoginService _loginService = LoginService();
  final FaceIDService faceIDService = FaceIDService(); // Service Face ID

  void _handleLogin() async {
    // Validation des champs
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs.')),
      );
      return;
    }

    // Appel au service de connexion
    final result = await _loginService.connexionUtilisateur(
      _emailController.text,
      _passwordController.text,
    );

    if (result['success'] == true) {
      // Connexion réussie, déclenchez l'animation
      setState(() {
        _showAnimation = true;
      });

      // Ajoutez un délai pour laisser l'animation se dérouler si nécessaire
      await Future.delayed(const Duration(seconds: 3));

      // Sauvegarde les informations dans SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('uuid', result['data']['uuid'] ?? '');
      prefs.setString('first_name', result['data']['first_name'] ?? '');
      prefs.setString('last_name', result['data']['last_name'] ?? '');
      prefs.setString('email', result['data']['email'] ?? '');
      prefs.setString('contact', result['data']['contact'] ?? '');
      prefs.setString('pack', result['pack']['name'] ?? '');

      // Stockage du access_token
      prefs.setString('access_token', result['token']['access_token']);

      // Naviguer vers la nouvelle page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BarDeNavigation()),
      );
    } else {
      // Afficher un message d'erreur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Échec de la connexion')),
      );
    }
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Vérifier l'état de la connexion lors du démarrage
  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUuid = prefs.getString('uuid');

    if (storedUuid != null && storedUuid.isNotEmpty) {
      // Si un UUID est trouvé, tenter l'authentification biométrique
      _authenticate();
    } else {
      // Pas d'UUID trouvé, demander à l'utilisateur de se connecter
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez vous connecter avec votre e-mail et mot de passe.'),
        ),
      );
    }
  }

  // Fonction pour gérer la connexion avec Face ID
  void _authenticate() async {
    // Vérifier si l'appareil prend en charge l'authentification biométrique
    bool isDeviceSupported = await faceIDService.isDeviceSupported();

    if (!isDeviceSupported) {
      // Afficher un message si l'appareil ne prend pas en charge l'authentification biométrique
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.indigo.shade900,
          content: Text("L'authentification biométrique n'est pas disponible."),
        ),
      );
      return; // Sortir de la fonction si l'appareil n'est pas pris en charge
    }

    // Procéder à l'authentification
    bool isAuthenticated = await faceIDService.authenticateWithBiometrics();

    if (isAuthenticated) {
      // Authentification réussie
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? storedUuid = prefs.getString('uuid');

      if (storedUuid != null && storedUuid.isNotEmpty) {
        // Lancer la navigation ou autre logique après authentification
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BarDeNavigation()),
        );
      } else {
        // Si l'UUID est absent, demander de se connecter manuellement
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Veuillez vous connecter d\'abord avec votre e-mail et mot de passe.'),
          ),
        );
      }
    } else {
      // Échec de l'authentification
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Échec de l'authentification. Veuillez réessayer.")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                top: TSizes.appBarHeight,
                left: TSizes.defaultSpace,
                right: TSizes.defaultSpace,
                bottom: TSizes.defaultSpace,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20), // Bords arrondis
                      // Ajoutez une couleur ou une image de fond si nécessaire
                    ),
                    clipBehavior: Clip.hardEdge, // Cela permet de couper l'image aux bords arrondis
                    child: Image.asset(
                      "assets/Equilife 360 Logo.webp",
                      height: 130,
                      fit: BoxFit.cover, // Ajuste l'image pour qu'elle remplisse le conteneur
                    ),
                  ),
                  const SizedBox(height: 10.0), // Ajustez selon vos besoins
                  const Text(
                    "EquiLife360",
                    style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  const Text(
                    "Enrichissez Chaque Facette De Votre Vie",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 20.0), // Ajustez selon vos besoins
                  Container(
                    height: size.height * 0.08,
                    width: size.width * 0.9,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _emailFocusNode.hasFocus ? Colors.cyan : Colors.transparent,
                      ),
                    ),
                    child: TextField(
                      focusNode: _emailFocusNode,
                      controller: _emailController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 20),
                        border: InputBorder.none,
                        prefixIcon: const Icon(Icons.mail_outline, color: Colors.cyan),
                        hintText: "E-mail",
                        hintStyle: TextStyle(color: _emailFocusNode.hasFocus ? Colors.cyan : Colors.grey),
                      ),
                      onTap: () {
                        setState(() {
                          _emailFocusNode.requestFocus();
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 10.0), // Ajustez selon vos besoins
                  Container(
                    height: size.height * 0.08,
                    width: size.width * 0.9,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _passwordFocusNode.hasFocus ? Colors.cyan : Colors.transparent,
                      ),
                    ),
                    child: TextField(
                      focusNode: _passwordFocusNode,
                      controller: _passwordController,
                      obscureText: _obscurePassword, // Masquer ou afficher le texte
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 20),
                        border: InputBorder.none,
                        prefixIcon: const Icon(Icons.lock_outline, color: Colors.cyan),
                        hintText: "Mot de passe",
                        hintStyle: TextStyle(color: _passwordFocusNode.hasFocus ? Colors.cyan : Colors.grey),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: Colors.cyan,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _passwordFocusNode.requestFocus();
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 2.0), // Ajustez selon vos besoins
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            onChanged: (value) {
                              setState(() {
                                _rememberMe = value!;
                              });
                            },
                            activeColor: Colors.cyan,
                          ),
                          Text(
                            "Se souvenir de moi",
                            style: TextStyle(
                              fontSize: 14.0, // Ajustez selon vos besoins
                              color: _rememberMe ? Colors.cyan : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          // Action pour le bouton "Mot de passe oublié"
                          Navigator.pushNamed(context, 'MotDePasseOublie');
                        },
                        child: const Text(
                          "Mot de passe oublié",
                          style: TextStyle(
                            fontSize: 14.0, // Ajustez selon vos besoins
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0), // Ajustez selon vos besoins
                  Container(
                    height: size.height * 0.07,
                    width: size.width * 0.9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.cyan,
                    ),
                    child: TextButton(
                      onPressed: _handleLogin,
                      child: const Text(
                        "Se connecter",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0), // Ajustez selon vos besoins
                  Container(
                    height: size.height * 0.07,
                    width: size.width * 0.9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.cyan),
                      color: Colors.transparent,
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, 'SignForm');
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      child: const Text(
                        "S'enregistrer",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.cyan,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                 /* Center(
                    child: GestureDetector(
                      onTap: _authenticate,
                      child: Row(
                        mainAxisSize: MainAxisSize.min, // Adapte la taille du Row au contenu
                        children: [
                          Image.asset(
                            "assets/securite.png",
                            width: 26,
                          ),
                          const SizedBox(width: 8), // Espace entre l'image et le texte
                          const Text(
                            "Connexion via Face ID",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.brown,
                              fontSize: 16, // Taille de police ajustée pour meilleure lisibilité
                            ),
                          ),
                        ],
                      ),
                    ),
                  ), */

                ],
              ),
            ),
          ),
          if (_showAnimation)
            Center(
              child: Lottie.asset(
                "assets/animations/Animation - 1721031172360.json",
                fit: BoxFit.cover,
                width: 150,
                height: 150,
              ),
            ),
        ],
      ),
    );
  }
}
