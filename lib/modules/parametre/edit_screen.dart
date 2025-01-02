import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constantes/widgets/edit_item.dart';
import '../../services/update_profil_service.dart';

class EditAccountScreen extends StatefulWidget {
  const EditAccountScreen({super.key});

  @override
  State<EditAccountScreen> createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  final UpdateProfileService _updateProfileService = UpdateProfileService();
  String gender = "Mr";
  File? _image;
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _loadUserData();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur de sélection d\'image: $e'),
        ),
      );
    }
  }

  Future<void> _requestPermissions() async {
    await [
      Permission.camera,
      Permission.photos,
    ].request();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('last_name') ?? '';
      _prenomController.text = prefs.getString('first_name') ?? '';
      _contactController.text = prefs.getString('contact') ?? '';
    });
  }

  Future<void> _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();

    // Récupérer le token d'accès stocké dans SharedPreferences
    final String? accessToken = prefs.getString('access_token');

    // Appeler le service de mise à jour du profil
    final response = await _updateProfileService.updateUserProfile(
      firstName: _prenomController.text,
      lastName: _nameController.text,
      contact: _contactController.text,
      civility: gender, // Utiliser la variable gender comme civility
    );

    if (response['success']) {
      // Sauvegarder les nouvelles données dans SharedPreferences
      await prefs.setString('last_name', _nameController.text);
      await prefs.setString('first_name', _prenomController.text);
      await prefs.setString('contact', _contactController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Données sauvegardées avec succès'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur de mise à jour: ${response['message']}'),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Ionicons.chevron_back_outline),
        ),
        leadingWidth: 80,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {
                _saveUserData();
              },
              style: IconButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                fixedSize: const Size(60, 50),
                elevation: 3,
              ),
              icon: const Icon(Ionicons.checkmark, color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Compte",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              EditItem(
                title: "Photo",
                widget: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _image == null
                          ? const AssetImage("assets/avatar.webp") as ImageProvider
                          : FileImage(_image!),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () => _pickImage(ImageSource.gallery),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.lightBlueAccent,
                          ),
                          child: const Text("Télécharger"),
                        ),
                        const SizedBox(width: 5),
                        TextButton(
                          onPressed: () => _pickImage(ImageSource.camera),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.lightBlueAccent,
                          ),
                          child: const Text("Prendre photo"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              EditItem(
                widget: TextField(controller: _nameController),
                title: "Nom",
              ),
              const SizedBox(height: 40),
              EditItem(
                widget: TextField(controller: _prenomController),
                title: "Prénoms",
              ),
              const SizedBox(height: 40),
              EditItem(
                title: "Genre",
                widget: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          gender = "Mr";
                          print(gender);
                        });
                      },
                      style: IconButton.styleFrom(
                        backgroundColor: gender == "Mr"
                            ? Colors.cyan
                            : Colors.grey.shade200,
                        fixedSize: const Size(50, 50),
                      ),
                      icon: Icon(
                        Ionicons.male,
                        color: gender == "Mr" ? Colors.white : Colors.black,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          gender = "Mdme";

                          print(gender);
                        });
                      },
                      style: IconButton.styleFrom(
                        backgroundColor: gender == "Mdme"
                            ? Colors.cyan
                            : Colors.grey.shade200,
                        fixedSize: const Size(50, 50),
                      ),
                      icon: Icon(
                        Ionicons.female,
                        color: gender == "Mdme" ? Colors.white : Colors.black,
                        size: 18,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 40),
              EditItem(
                widget: TextField(controller: _contactController),
                title: "Contact",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
