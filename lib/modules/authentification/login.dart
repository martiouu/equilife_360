import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: size.height,
        width: double.infinity,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: Image.asset(
                "assets/main_top.webp",
                width: size.width * 0.3,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Image.asset(
                "assets/main_bottom.webp",
                width: size.width * 0.2,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Image.asset(
                "assets/login_bottom.webp",
                width: size.width * 0.3,
              ),
            ),
            Positioned(
              top: 120,
              left: 0,
              right: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/28903492_7521997.svg", // Remplacez par le chemin de votre image SVG
                    height: size.height * 0.45,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: size.width * 0.8,
                    height: size.height * 0.07,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, 'LoginForm');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyan.shade700, // Couleur de fond du bouton
                      ),
                      child: Text(
                        "Se connecter".toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: size.width * 0.8,
                    height: size.height * 0.07,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, 'SignForm');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyan.shade500, // Couleur de fond du bouton
                      ),
                      child: Text(
                        "S'enregistrer".toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
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
