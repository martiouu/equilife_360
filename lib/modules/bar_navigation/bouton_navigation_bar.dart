
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


import 'package:get/get.dart';import '../accueil/accueil.dart';
import '../categorie/category.dart';
import '../parametre/setting.dart';

class BarDeNavigation extends StatefulWidget {
  const BarDeNavigation({super.key});

  @override
  State<BarDeNavigation> createState() => _BarDeNavigationState();
}

class _BarDeNavigationState extends State<BarDeNavigation> {
  final controller = Get.put(NavigationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Colors.cyan.shade200,
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Colors.blueGrey,
            ),
          ),
        ),
        child: Obx(
              () => NavigationBar(
            height: 80,
            animationDuration: const Duration(milliseconds: 2000),
            selectedIndex: controller.selectedIndex.value,
            onDestinationSelected: (index) {
              controller.updateIndex(index);
            },
            backgroundColor: Colors.white,
                destinations: [
                  NavigationDestination(
                    icon: SvgPicture.asset(
                      'assets/icons/home.svg', // Assurez-vous que le chemin est correct
                      height: 24,
                    ),
                    label: 'Accueil',
                  ),
                  NavigationDestination(
                    icon: SvgPicture.asset(
                      'assets/icons/dashboard.svg', // Assurez-vous que le chemin est correct
                      height: 24,
                    ),
                    label: 'Menu',
                  ),
                  NavigationDestination(
                    icon: SvgPicture.asset(
                      'assets/icons/settings-svgrepo-com.svg', // Assurez-vous que le chemin est correct
                      height: 24,
                    ),
                    label: 'Paramètres',
                  ),
                ],
          ),
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  final screens = const [
    Accueil(),
    Categorie(),
    Parametre(),
  ];

  void updateIndex(int index) {
    selectedIndex.value = index;
  }
}
