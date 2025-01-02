
import 'package:flutter/material.dart';

import '../accueil/accueil.dart';
import '../categorie/category.dart';
import '../parametre/setting.dart';

class BottomNavigationBarPage extends StatefulWidget {
  const BottomNavigationBarPage({super.key});

  @override
  State<BottomNavigationBarPage> createState() => _BottomNavigationBarPageState();
}

class _BottomNavigationBarPageState extends State<BottomNavigationBarPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          // Ajoutez ici les différentes pages de votre application
          Accueil(),
          Categorie(),
          Parametre(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image.asset("assets/icons/icons8-home-48.webp", width: 30,),
            activeIcon: Image.asset("assets/icons/icons8-home-48 (1).webp", width: 30,),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/icons/icons8-module-100.webp", width: 30,),
            activeIcon: Image.asset("assets/icons/icons8-module-50.webp", width: 30, color: Colors.cyan.shade700,),
            label: 'Catégories',
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/icons/icons8-gear-ios.webp", width: 30,),
            activeIcon: Image.asset("assets/icons/icons8-gear-ios (1).webp", width: 30, color: Colors.cyan.shade700,),
            label: 'Paramètres',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.cyan.shade700, // Couleur de l'icône sélectionnée
        onTap: _onItemTapped,
      ),
    );
  }
}
