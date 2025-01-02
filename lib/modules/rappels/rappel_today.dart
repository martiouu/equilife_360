import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TodayPage extends StatefulWidget {
  const TodayPage({super.key});

  @override
  State<TodayPage> createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {
  bool _isMatin = false;
  bool _isAprem = false;
  bool _isSoir = false;
  final TextEditingController _rappelMatinController = TextEditingController();
  final TextEditingController _rappelApremController = TextEditingController();
  final TextEditingController _rappelSoirController = TextEditingController();

  // Fonction pour afficher le sélecteur d'heure Cupertino avec heures et minutes côte à côte
  Future<void> _selectTime(TextEditingController controller) async {
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        int selectedHour = DateTime.now().hour;
        int selectedMinute = DateTime.now().minute;

        return CupertinoActionSheet(
          title: const Text('Sélectionnez l\'heure'),
          message: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            height: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: CupertinoPicker(
                    itemExtent: 40,
                    scrollController: FixedExtentScrollController(
                      initialItem: selectedHour,
                    ),
                    onSelectedItemChanged: (int index) {
                      selectedHour = index;
                    },
                    children: List<Widget>.generate(24, (int index) {
                      return Center(
                        child: Text(index.toString().padLeft(2, '0')),
                      );
                    }),
                  ),
                ),
                Expanded(
                  child: CupertinoPicker(
                    itemExtent: 40,
                    scrollController: FixedExtentScrollController(
                      initialItem: selectedMinute ~/ 5,
                    ),
                    onSelectedItemChanged: (int index) {
                      selectedMinute = index * 5;
                    },
                    children: List<Widget>.generate(12, (int index) {
                      return Center(
                        child: Text((index * 5).toString().padLeft(2, '0')),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            CupertinoActionSheetAction(
              child: const Text('OK'),
              onPressed: () {
                final String formattedTime = '${selectedHour.toString().padLeft(2, '0')}:${selectedMinute.toString().padLeft(2, '0')}';
                setState(() {
                  controller.text = formattedTime;
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey.shade200,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.cyan),
        ),
        actions: [
          if (_isMatin)
            TextButton(
              onPressed: () {
                // Action à réaliser lors de l'appui sur le bouton "OK"
              },
              child: const Text(
                "OK",
                style: TextStyle(color: Colors.cyan, fontSize: 16),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Text(
                    "Aujourd'hui",
                    style: TextStyle(
                        color: Colors.cyan,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.black12),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isMatin = !_isMatin;
                  _isAprem = false;
                  _isSoir = false;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.transparent,
                      child: const Row(
                        children: [
                          Text(
                            "Réglages",
                            style: TextStyle(
                              color: Colors.black12,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_isMatin) ...[
                      const SizedBox(height: 10),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset("assets/rond.webp", width: 20),
                                  const SizedBox(width: 5),
                                  SizedBox(
                                    width: 200, // Ajustez la largeur selon vos besoins
                                    child: TextField(
                                      autofocus: true,
                                      controller: _rappelMatinController,
                                      cursorColor: Colors.cyan, // Couleur du curseur
                                      decoration: const InputDecoration(
                                        border: InputBorder.none, // Aucune bordure
                                      ),
                                      style: const TextStyle(
                                        color: Colors.black, // Couleur du texte saisi
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () => _selectTime(_rappelMatinController),
                                child: Image.asset("assets/info.webp", width: 20),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const SizedBox(width: 25),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: 'Rappels - ',
                                      style: TextStyle(color: Colors.black26),
                                    ),
                                    TextSpan(
                                      text: _rappelMatinController.text.isNotEmpty
                                          ? _rappelMatinController.text
                                          : '09:00',
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset("assets/rond.webp", width: 20),
                                  const SizedBox(width: 5),
                                  const SizedBox(
                                    width: 200, // Ajustez la largeur selon vos besoins
                                    child: TextField(
                                      autofocus: true,
                                      //controller: _rappelApremController,
                                      cursorColor: Colors.cyan, // Couleur du curseur
                                      decoration: InputDecoration(
                                        border: InputBorder.none, // Aucune bordure
                                      ),
                                      style: TextStyle(
                                        color: Colors.black, // Couleur du texte saisi
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () => _selectTime(_rappelApremController),
                                child: Image.asset("assets/info.webp", width: 20),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const SizedBox(width: 25),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: 'Rappels - ',
                                      style: TextStyle(color: Colors.black26),
                                    ),
                                    TextSpan(
                                      text: _rappelApremController.text.isNotEmpty
                                          ? _rappelApremController.text
                                          : '11:00',
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset("assets/rond.webp", width: 20),
                                  const SizedBox(width: 5),
                                  const SizedBox(
                                    width: 200, // Ajustez la largeur selon vos besoins
                                    child: TextField(
                                      autofocus: true,
                                      //controller: _rappelApremController,
                                      cursorColor: Colors.cyan, // Couleur du curseur
                                      decoration: InputDecoration(
                                        border: InputBorder.none, // Aucune bordure
                                      ),
                                      style: TextStyle(
                                        color: Colors.black, // Couleur du texte saisi
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () => _selectTime(_rappelSoirController),
                                child: Image.asset("assets/info.webp", width: 20),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const SizedBox(width: 25),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: 'Rappels - ',
                                      style: TextStyle(color: Colors.black26),
                                    ),
                                    TextSpan(
                                      text: _rappelSoirController.text.isNotEmpty
                                          ? _rappelSoirController.text
                                          : '18:00',
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            // Ajoutez des widgets pour les autres parties de la journée, comme "Après-midi" ou "Soir", si nécessaire.
          ],
        ),
      ),
    );
  }
}
