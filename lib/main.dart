import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'constantes/constants.dart';
import 'modules/accueil/accueil.dart';
import 'modules/activites/tache.dart';
import 'modules/agenda/agenda.dart';
import 'modules/authentification/enregistrer_form.dart';
import 'modules/authentification/login.dart';
import 'modules/authentification/login_form.dart';
import 'modules/authentification/reset_password.dart';
import 'modules/authentification/singIn_form.dart';
import 'modules/calendar/calendar.dart';
import 'modules/cout_horaire/cout_horaire.dart';
import 'modules/introScreen.dart';
import 'modules/matrice/matrice.dart';
import 'modules/mission_de_vie/mission_de_vie.dart';
import 'modules/pyramide_productivite/productivite.dart';
import 'modules/rappels/rappel_today.dart';
import 'modules/rappels/rappels.dart';
import 'modules/role/role.dart';
import 'modules/roue_la_vie/life_wheel.dart';
import 'modules/roue_la_vie/quizz_roue.dart';
import 'modules/roue_la_vie/roue_vie.dart';
import 'modules/theme_provider.dart';
import 'modules/plan_action/trois_q.dart';
import 'modules/vie_ideale/vie_ideale.dart';
import 'modules/vie_ideale/vue_vie_ideale.dart';

void main() async {

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(), // Initialisation correcte du ThemeProvider
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: "TitilliumWeb",
        scaffoldBackgroundColor: kBackgroundColor,
        platform: TargetPlatform.iOS,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData.dark(),
      themeMode: themeProvider.themeMode, // Assure que le themeProvider n'est pas null
      initialRoute: '/',
      routes: {
        '/': (context) => const IntroScreen(),
        'Accueil': (context) => const Accueil(),
        'Quizz': (context) => const RoueQuizz(),
        'RoueVie': (context) => const RoueVie(),
        'Login': (context) => const LoginPage(),
        'Rappel': (context) => const RappelPage(),
        'LoginForm': (context) => const LoginForm(),
        'Today': (context) => const TodayPage(),
        'Matrice': (context) => const MatricePage(),
        'Role': (context) => const RoleForm(),
        'Pyramide': (context) => const PyramidePage(),
        'Agenda': (context) => const PlanificationAgenda(),
        'TroisQ': (context) => const TroisQ(),
        'SignForm': (context) => const SignForm(),
        'EnregistrerForm': (context) => const EnregisterForm(),
        'MotDePasseOublie': (context) => const ResetPassword(),
        'LifeWheel': (context) => const LifeWheel(),
        'VieIdeale': (context) => const VieIdeale(),
        'VueVieIdeale': (context) => const VueVieIdeale(),
        'Tache': (context) => const TachePage(),
        //'SemiPyramid': (context) => const ProductivityPyramid(),
        'CoutHoraire': (context) => const CoutHoraire(),
        'MissionDeVie': (context) => const MissionDeVie(),
        'Calendar': (context) => const CalendarPage(),
      },
    );
  }
}
