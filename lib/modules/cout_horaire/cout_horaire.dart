import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CoutHoraire extends StatefulWidget {
  const CoutHoraire({super.key});

  @override
  State<CoutHoraire> createState() => _CoutHoraireState();
}

class _CoutHoraireState extends State<CoutHoraire> with TickerProviderStateMixin  {
  final TextEditingController _montantController = TextEditingController();
  String? groupValue;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  String _salaireHoraire = '';
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    // Initialize the animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // Retarder l'ouverture du dialogue jusqu'à la fin de la construction de l'arbre des widgets
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showInfo(context); // Lancer le dialogue après la première frame
    });

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Start the animation when the widget is built
    _controller.forward();

    // Load the hourly salary from SharedPreferences
    _loadMontantAndGroupValue();
  }

  void _showInfo(BuildContext context) {
    // Utiliser `showDialog` ici après que l'arbre des widgets soit complètement dessiné
    if (context.mounted) {
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

      // Démarrer l'animation
      _animationController.forward();
    }
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
            Image.asset("assets/info.webp", width: 25),
            SizedBox(height: 5),
            const Text(
              "Valeur Horaire",
              style: TextStyle(
                color: Colors.cyan,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "Avoir le détail de ma valeur horaire en cliquant sur l'icone Calculatrice",
              style: TextStyle(
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),

          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleRadioValueChange(String? value) {
    setState(() {
      groupValue = value;
    });
  }

  Future<void> _calculerSalaireHoraire() async {
    // Vérifier si le montant ou le groupe n'est pas renseigné
    if (_montantController.text.isEmpty || groupValue == null) {
      // Afficher un Snackbar avec un message d'erreur
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.transparent,
          content: Text("Veuillez renseigner tous les champs."),
          duration: Duration(seconds: 2),
        ),
      );
      return; // Sortir de la fonction si les champs sont vides
    }

    double montant = double.parse(_montantController.text);
    int heures = 0;

    // Déterminez le nombre d'heures en fonction de la sélection
    switch (groupValue) {
      case 'Agent':
        heures = 40;
        break;
      case 'Cadre':
        heures = 50;
        break;
      case 'Dirigeant / Entrepreneur':
        heures = 60;
        break;
    }

    // Calcul du salaire horaire
    double salaireHoraire = montant / (heures * 4);

    // Enregistrer dans SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('salaire_horaire', salaireHoraire);
    await prefs.setDouble('montant', montant); // Enregistrer le montant
    await prefs.setString('group_value', groupValue!); // Enregistrer le groupValue

    // Mettre à jour l'état pour afficher le salaire
    setState(() {
      _salaireHoraire = salaireHoraire.toStringAsFixed(2);

      // Ne pas vider le champ montant et ne pas réinitialiser groupValue
    });
  }

  Future<void> _loadMontantAndGroupValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double? salaireHoraire = prefs.getDouble('salaire_horaire');
    double? montant = prefs.getDouble('montant');
    String? savedGroupValue = prefs.getString('group_value');

    if (salaireHoraire != null) {
      setState(() {
        _salaireHoraire = salaireHoraire.toStringAsFixed(2);
      });
    }

    if (montant != null) {
      setState(() {
        _montantController.text = montant.toString();
      });
    }

    if (savedGroupValue != null) {
      setState(() {
        groupValue = savedGroupValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          SizedBox(height: size.height * 0.04),
          Padding(
            padding: const EdgeInsets.only(top: 35, left: 10),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back, size: 25, color: Colors.cyan.shade900),
                ),
              ],
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Column(
                          children: [
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                                children: [
                                  const TextSpan(text: "Déterminer la valeur horaire d'une "),
                                  TextSpan(
                                    text: "heure de mon temps",
                                    style: TextStyle(color: Colors.cyan.shade900),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              "Vous pouvez personnaliser cet écran ultérieurement",
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                            const SizedBox(height: 20),
                            _buildContainerWithAnimation(),
                            const SizedBox(height: 10),
                            _buildRadioButton('Agent', '40 heures de travail'),
                            const SizedBox(height: 10),
                            _buildRadioButton('Cadre', '50 heures de travail'),
                            const SizedBox(height: 10),
                            _buildRadioButton('Dirigeant / Entrepreneur', '60 heures de travail'),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Material(
                                  color: Colors.transparent,
                                  elevation: MediaQuery.of(context).size.width * 0.01, // Élasticité responsive
                                  borderRadius: BorderRadius.circular(20),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(16),
                                    onTap: _calculerSalaireHoraire,
                                    splashColor: Colors.blue.withOpacity(0.2),
                                    child: Container(
                                      height: MediaQuery.of(context).size.width * 0.1, // Hauteur responsive
                                      width: MediaQuery.of(context).size.width * 0.1, // Largeur responsive
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Padding(
                                          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02), // Padding responsive
                                          child: Image.asset(
                                            'assets/calculatrice_k.webp',
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),


                            const SizedBox(height: 20),
                            Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.08, // Hauteur responsive
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                gradient: LinearGradient(
                                  colors: [Colors.cyan.shade200, Colors.purple.shade200],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Positioned(
                                    left: -MediaQuery.of(context).size.width * 0.05, // Débordement responsive
                                    top: -MediaQuery.of(context).size.height * 0.03, // Position verticale responsive
                                    child: Image.asset(
                                      'assets/lhorloge.webp',
                                      width: MediaQuery.of(context).size.width * 0.18, // Largeur responsive
                                      height: MediaQuery.of(context).size.width * 0.18, // Hauteur responsive
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(width: MediaQuery.of(context).size.width * 0.1), // Espace responsive
                                        Text(
                                          "Mon salaire horaire est : $_salaireHoraire FCFA",
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context).textScaleFactor * 14, // Taille de police responsive
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
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContainerWithAnimation() {
    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
      height: 110,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey.shade50,
            child: Image.asset("assets/revenu_t.webp", width: 40),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Revenu Mensuel Minimum",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextField(
                  controller: _montantController,
                  decoration: const InputDecoration(
                    hintText: "Montant",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    suffixText: 'FCFA',
                    suffixStyle: TextStyle(color: Colors.grey, fontSize: 16),
                    contentPadding: EdgeInsets.symmetric(vertical: 8),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioButton(String title, String message) {
    return RadioListTile<String>(
      contentPadding: const EdgeInsets.all(10.0),
      title: Text(title),
      tileColor: Colors.white,
      value: title,
      dense: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      groupValue: groupValue,
      onChanged: (value) {
        _handleRadioValueChange(value);
      },
    );
  }
}
