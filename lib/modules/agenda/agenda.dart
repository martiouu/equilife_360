import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlanificationAgenda extends StatefulWidget {
  const PlanificationAgenda({super.key});

  @override
  State<PlanificationAgenda> createState() => _PlanificationAgendaState();
}

class _PlanificationAgendaState extends State<PlanificationAgenda> {
  int _selectedIndex = 0;
  late TextEditingController _controller06h;
  late TextEditingController _controller09h;
  late TextEditingController _controller12h;
  String _selectedTime = "06:00";
  String _selectedDeuxTime = "09:00";
  String _selectedTroisTime = "12:00";

  late TextEditingController _controller14h;
  late TextEditingController _controller16h;
  late TextEditingController _controller18h;
  String _selectedQuatreTime = "14:00";
  String _selectedCinqTime = "16:00";
  String _selectedSixTime = "18:00";

  late TextEditingController _controller20h;
  late TextEditingController _controller22h;
  late TextEditingController _controller00h;
  String _selectedSeptTime = "20:00";
  String _selectedHuitTime = "22:00";
  String _selectedNeufTime = "00:00";
  // Déclarez une variable dateTime avec une valeur par défaut
  DateTime dateTime = DateTime.now();


  @override
  void initState() {
    super.initState();
    _controller06h = TextEditingController();
    _controller09h = TextEditingController();
    _controller12h = TextEditingController();
    _controller14h = TextEditingController();
    _controller16h = TextEditingController();
    _controller18h = TextEditingController();
    _controller20h = TextEditingController();
    _controller22h = TextEditingController();
    _controller00h = TextEditingController();

    _loadData();
  }


  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Sauvegarde des heures sélectionnées
    await prefs.setString('selectedTime06h', _selectedTime);
    await prefs.setString('selectedTime09h', _selectedDeuxTime);
    await prefs.setString('selectedTime12h', _selectedTroisTime);
    await prefs.setString('selectedTime14h', _selectedQuatreTime);
    await prefs.setString('selectedTime16h', _selectedCinqTime);
    await prefs.setString('selectedTime18h', _selectedSixTime);
    await prefs.setString('selectedTime20h', _selectedSeptTime);
    await prefs.setString('selectedTime22h', _selectedHuitTime);
    await prefs.setString('selectedTime00h', _selectedNeufTime);

    // Sauvegarde des textes des contrôleurs
    await prefs.setString('controller06hText', _controller06h.text);
    await prefs.setString('controller09hText', _controller09h.text);
    await prefs.setString('controller12hText', _controller12h.text);
    await prefs.setString('controller14hText', _controller14h.text);
    await prefs.setString('controller16hText', _controller16h.text);
    await prefs.setString('controller18hText', _controller18h.text);
    await prefs.setString('controller20hText', _controller20h.text);
    await prefs.setString('controller22hText', _controller22h.text);
    await prefs.setString('controller00hText', _controller00h.text);

  }

  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Récupère les heures sélectionnées
    setState(() {
      _selectedTime = prefs.getString('selectedTime06h') ?? "06:00";
      _selectedDeuxTime = prefs.getString('selectedTime09h') ?? "09:00";
      _selectedTroisTime = prefs.getString('selectedTime12h') ?? "12:00";
      _selectedQuatreTime = prefs.getString('selectedTime14h') ?? "14:00";
      _selectedCinqTime = prefs.getString('selectedTime16h') ?? "16:00";
      _selectedSixTime = prefs.getString('selectedTime18h') ?? "18:00";
      _selectedSeptTime = prefs.getString('selectedTime20h') ?? "20:00";
      _selectedHuitTime = prefs.getString('selectedTime22h') ?? "22:00";
      _selectedNeufTime = prefs.getString('selectedTime00h') ?? "00:00";

      // Récupère les textes des contrôleurs
      _controller06h.text = prefs.getString('controller06hText') ?? "";
      _controller09h.text = prefs.getString('controller09hText') ?? "";
      _controller12h.text = prefs.getString('controller12hText') ?? "";
      _controller14h.text = prefs.getString('controller14hText') ?? "";
      _controller16h.text = prefs.getString('controller16hText') ?? "";
      _controller18h.text = prefs.getString('controller18hText') ?? "";
      _controller20h.text = prefs.getString('controller20hText') ?? "";
      _controller22h.text = prefs.getString('controller22hText') ?? "";
      _controller00h.text = prefs.getString('controller00hText') ?? "";
    });
  }


  Color _getContainerColor(int index) {
    return _selectedIndex == index ? Colors.cyan.shade900 : Colors.grey.shade300;
  }

  TextStyle _getTextStyle(int index) {
    return TextStyle(
      fontSize: 16,
      color: _selectedIndex == index ? Colors.white : Colors.black,
    );
  }

  Widget _buildContent(int index) {
    switch (index) {
      case 0:
        return _morningContent(context);
      case 1:
        return _afternoonContent(context);
      case 2:
        return _eveningContent(context);
      default:
        return Container();
    }
  }

  // Fonction générant un picker de temps
  void buildTimePicker(BuildContext context, DateTime initialTime, Function(DateTime) onTimeSelected) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => Container(
        height: 250,
        color: Colors.white,
        child: CupertinoDatePicker(
          initialDateTime: initialTime,
          mode: CupertinoDatePickerMode.time,
          onDateTimeChanged: (DateTime newTime) {
            onTimeSelected(newTime);
          },
        ),
      ),
    );
  }

  Widget _morningContent(BuildContext context) {
    // Récupérer la taille de l'écran
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      height: screenHeight * 0.8, // 80% de la hauteur de l'écran
      width: double.infinity, // Utiliser toute la largeur disponible
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Column(
            children: [
              Container(
                height: screenHeight * 0.15, // 15% de la hauteur de l'écran
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        DateTime initialTime = DateTime.now();
                        buildTimePicker(context, initialTime, (newTime) {
                          // Met à jour l'heure sélectionnée lorsqu'une nouvelle heure est choisie
                          setState(() {
                            _selectedTime = "${newTime.hour.toString().padLeft(2, '0')}:${newTime.minute.toString().padLeft(2, '0')}";

                            print("heure : $_selectedTime");
                            _saveData();
                          });
                        });
                      },
                      child: Text(
                        _selectedTime,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    Container(
                      height: screenHeight * 0.1, // 10% de la hauteur de l'écran
                      width: screenWidth * 0.7, // 70% de la largeur de l'écran
                      decoration: BoxDecoration(
                        color: Colors.cyan.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        controller: _controller06h,
                        decoration: const InputDecoration(
                          hintText: 'Saisir ici votre planning...',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 10, top: 10),
                        ),
                        maxLines: null,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        onChanged: (text) {
                          // Sauvegarde automatique chaque fois que l'utilisateur modifie le texte
                          _saveData();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: screenHeight * 0.15, // 15% de la hauteur de l'écran
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        DateTime initialTime = DateTime.now();
                        buildTimePicker(context, initialTime, (newTime) {
                          // Met à jour l'heure sélectionnée lorsqu'une nouvelle heure est choisie
                          setState(() {
                            _selectedDeuxTime = "${newTime.hour.toString().padLeft(2, '0')}:${newTime.minute.toString().padLeft(2, '0')}";

                            print("heure : $_selectedDeuxTime");

                            _saveData();
                          });
                        });
                      },
                      child: Text(
                        _selectedDeuxTime,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    Container(
                      height: screenHeight * 0.1, // 10% de la hauteur de l'écran
                      width: screenWidth * 0.7, // 70% de la largeur de l'écran
                      decoration: BoxDecoration(
                        color: Colors.cyan.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        controller: _controller09h,
                        decoration: const InputDecoration(
                          hintText: 'Saisir ici votre planning...',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 10, top: 10),
                        ),
                        maxLines: null,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        onChanged: (text) {
                          // Sauvegarde automatique chaque fois que l'utilisateur modifie le texte
                          _saveData();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: screenHeight * 0.15, // 15% de la hauteur de l'écran
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        DateTime initialTime = DateTime.now();
                        buildTimePicker(context, initialTime, (newTime) {
                          // Met à jour l'heure sélectionnée lorsqu'une nouvelle heure est choisie
                          setState(() {
                            _selectedTroisTime = "${newTime.hour.toString().padLeft(2, '0')}:${newTime.minute.toString().padLeft(2, '0')}";

                            print("heure : $_selectedTroisTime");

                            _saveData();
                          });
                        });
                      },
                      child: Text(
                        _selectedTroisTime,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    Container(
                      height: screenHeight * 0.1, // 10% de la hauteur de l'écran
                      width: screenWidth * 0.7, // 70% de la largeur de l'écran
                      decoration: BoxDecoration(
                        color: Colors.cyan.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        controller: _controller12h,
                        decoration: const InputDecoration(
                          hintText: 'Saisir ici votre planning...',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 10, top: 10),
                        ),
                        maxLines: null,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        onChanged: (text) {
                          // Sauvegarde automatique chaque fois que l'utilisateur modifie le texte
                          _saveData();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _afternoonContent(BuildContext context) {
    // Récupérer les dimensions de l'écran
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      height: screenHeight * 0.8, // 80% de la hauteur de l'écran
      width: double.infinity, // Utiliser toute la largeur disponible
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Column(
            children: [
              Container(
                height: screenHeight * 0.15, // 15% de la hauteur de l'écran
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        DateTime initialTime = DateTime.now();
                        buildTimePicker(context, initialTime, (newTime) {
                          // Met à jour l'heure sélectionnée lorsqu'une nouvelle heure est choisie
                          setState(() {
                            _selectedQuatreTime = "${newTime.hour.toString().padLeft(2, '0')}:${newTime.minute.toString().padLeft(2, '0')}";

                            print("heure : $_selectedQuatreTime");
                            _saveData();
                          });
                        });
                      },
                      child: Text(
                        _selectedQuatreTime,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    Container(
                      height: screenHeight * 0.1, // 10% de la hauteur de l'écran
                      width: screenWidth * 0.7, // 70% de la largeur de l'écran
                      decoration: BoxDecoration(
                        color: Colors.cyan.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        controller: _controller14h,
                        decoration: const InputDecoration(
                          hintText: 'Saisir ici votre planning...',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 10, top: 10),
                        ),
                        maxLines: null,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        onChanged: (text) {
                          // Sauvegarde automatique chaque fois que l'utilisateur modifie le texte
                          _saveData();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: screenHeight * 0.15, // 15% de la hauteur de l'écran
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        DateTime initialTime = DateTime.now();
                        buildTimePicker(context, initialTime, (newTime) {
                          // Met à jour l'heure sélectionnée lorsqu'une nouvelle heure est choisie
                          setState(() {
                            _selectedCinqTime = "${newTime.hour.toString().padLeft(2, '0')}:${newTime.minute.toString().padLeft(2, '0')}";

                            print("heure : $_selectedCinqTime");

                            _saveData();
                          });
                        });
                      },
                      child: Text(
                        _selectedCinqTime,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    Container(
                      height: screenHeight * 0.1, // 10% de la hauteur de l'écran
                      width: screenWidth * 0.7, // 70% de la largeur de l'écran
                      decoration: BoxDecoration(
                        color: Colors.cyan.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        controller: _controller16h,
                        decoration: const InputDecoration(
                          hintText: 'Saisir ici votre planning...',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 10, top: 10),
                        ),
                        maxLines: null,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        onChanged: (text) {
                          // Sauvegarde automatique chaque fois que l'utilisateur modifie le texte
                          _saveData();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: screenHeight * 0.15, // 15% de la hauteur de l'écran
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        DateTime initialTime = DateTime.now();
                        buildTimePicker(context, initialTime, (newTime) {
                          // Met à jour l'heure sélectionnée lorsqu'une nouvelle heure est choisie
                          setState(() {
                            _selectedSixTime = "${newTime.hour.toString().padLeft(2, '0')}:${newTime.minute.toString().padLeft(2, '0')}";

                            print("heure : $_selectedSixTime");

                            _saveData();
                          });
                        });
                      },
                      child: Text(
                        _selectedSixTime,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    Container(
                      height: screenHeight * 0.1, // 10% de la hauteur de l'écran
                      width: screenWidth * 0.7, // 70% de la largeur de l'écran
                      decoration: BoxDecoration(
                        color: Colors.cyan.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        controller: _controller18h,
                        decoration: const InputDecoration(
                          hintText: 'Saisir ici votre planning...',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 10, top: 10),
                        ),
                        maxLines: null,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        onChanged: (text) {
                          // Sauvegarde automatique chaque fois que l'utilisateur modifie le texte
                          _saveData();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _eveningContent(BuildContext context) {
    // Récupérer la taille de l'écran
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      height: screenHeight * 0.8, // 80% de la hauteur de l'écran
      width: double.infinity, // Utiliser toute la largeur disponible
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Column(
            children: [
              Container(
                height: screenHeight * 0.15, // 15% de la hauteur de l'écran
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        DateTime initialTime = DateTime.now();
                        buildTimePicker(context, initialTime, (newTime) {
                          // Met à jour l'heure sélectionnée lorsqu'une nouvelle heure est choisie
                          setState(() {
                            _selectedSeptTime = "${newTime.hour.toString().padLeft(2, '0')}:${newTime.minute.toString().padLeft(2, '0')}";

                            print("heure : $_selectedSeptTime");
                            _saveData();
                          });
                        });
                      },
                      child: Text(
                        _selectedSeptTime,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    Container(
                      height: screenHeight * 0.1, // 10% de la hauteur de l'écran
                      width: screenWidth * 0.7, // 70% de la largeur de l'écran
                      decoration: BoxDecoration(
                        color: Colors.cyan.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        controller: _controller20h,
                        decoration: const InputDecoration(
                          hintText: 'Saisir ici votre planning...',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 10, top: 10),
                        ),
                        maxLines: null,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        onChanged: (text) {
                          // Sauvegarde automatique chaque fois que l'utilisateur modifie le texte
                          _saveData();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: screenHeight * 0.15, // 15% de la hauteur de l'écran
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        DateTime initialTime = DateTime.now();
                        buildTimePicker(context, initialTime, (newTime) {
                          // Met à jour l'heure sélectionnée lorsqu'une nouvelle heure est choisie
                          setState(() {
                            _selectedHuitTime = "${newTime.hour.toString().padLeft(2, '0')}:${newTime.minute.toString().padLeft(2, '0')}";

                            print("heure : $_selectedHuitTime");

                            _saveData();
                          });
                        });
                      },
                      child: Text(
                        _selectedHuitTime,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    Container(
                      height: screenHeight * 0.1, // 10% de la hauteur de l'écran
                      width: screenWidth * 0.7, // 70% de la largeur de l'écran
                      decoration: BoxDecoration(
                        color: Colors.cyan.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        controller: _controller22h,
                        decoration: const InputDecoration(
                          hintText: 'Saisir ici votre planning...',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 10, top: 10),
                        ),
                        maxLines: null,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        onChanged: (text) {
                          // Sauvegarde automatique chaque fois que l'utilisateur modifie le texte
                          _saveData();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: screenHeight * 0.15, // 15% de la hauteur de l'écran
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        DateTime initialTime = DateTime.now();
                        buildTimePicker(context, initialTime, (newTime) {
                          // Met à jour l'heure sélectionnée lorsqu'une nouvelle heure est choisie
                          setState(() {
                            _selectedNeufTime = "${newTime.hour.toString().padLeft(2, '0')}:${newTime.minute.toString().padLeft(2, '0')}";

                            print("heure : $_selectedNeufTime");

                            _saveData();
                          });
                        });
                      },
                      child: Text(
                        _selectedNeufTime,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    Container(
                      height: screenHeight * 0.1, // 10% de la hauteur de l'écran
                      width: screenWidth * 0.7, // 70% de la largeur de l'écran
                      decoration: BoxDecoration(
                        color: Colors.cyan.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        controller: _controller00h,
                        decoration: const InputDecoration(
                          hintText: 'Saisir ici votre planning...',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 10, top: 10),
                        ),
                        maxLines: null,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        onChanged: (text) {
                          // Sauvegarde automatique chaque fois que l'utilisateur modifie le texte
                          _saveData();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          SizedBox(height: size.height * 0.07),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.grey.shade200,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back, size: 25, color: Colors.cyan.shade900),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    children: [
                      const TextSpan(text: "Planification de mon agenda "),
                      TextSpan(
                        text: "structuration quotidienne",
                        style: TextStyle(color: Colors.cyan.shade600),
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
              ],
            ),
          ),
          SizedBox(height: size.height * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () => setState(() => _selectedIndex = 0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Calculer la hauteur et la largeur proportionnelles en fonction de l'espace disponible
                    double containerHeight = constraints.maxHeight * 0.1; // 10% de la hauteur disponible
                    double containerWidth = constraints.maxWidth * 0.3;  // 30% de la largeur disponible

                    return Container(
                      height: containerHeight > 40 ? 40 : containerHeight, // Hauteur minimale de 40
                      width: containerWidth > 115 ? 115 : containerWidth,  // Largeur minimale de 115
                      decoration: BoxDecoration(
                        color: _getContainerColor(0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text("Le matin", style: _getTextStyle(0)),
                      ),
                    );
                  },
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => _selectedIndex = 1),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Calculer la hauteur et la largeur en fonction des contraintes parentales
                    double containerHeight = constraints.maxHeight * 0.1; // 10% de la hauteur disponible
                    double containerWidth = constraints.maxWidth * 0.3;  // 30% de la largeur disponible

                    return Container(
                      height: containerHeight > 40 ? 40 : containerHeight, // Hauteur minimale de 40
                      width: containerWidth > 115 ? 115 : containerWidth,  // Largeur minimale de 115
                      decoration: BoxDecoration(
                        color: _getContainerColor(1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text("Après-midi", style: _getTextStyle(1)),
                      ),
                    );
                  },
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => _selectedIndex = 2),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Utilisez les contraintes pour calculer la taille relative
                    double containerHeight = constraints.maxHeight * 0.1; // 10% de la hauteur disponible
                    double containerWidth = constraints.maxWidth * 0.3; // 30% de la largeur disponible

                    return Container(
                      height: containerHeight > 40 ? 40 : containerHeight, // Min 40
                      width: containerWidth > 115 ? 115 : containerWidth,  // Min 115
                      decoration: BoxDecoration(
                        color: _getContainerColor(2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text("Le soir", style: _getTextStyle(2)),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Utilisation d'AnimatedSwitcher pour une animation de transition
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _buildContent(_selectedIndex),
            ),
          ),
        ],
      ),
    );
  }
}
