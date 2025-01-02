import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RoleService {
  final String baseUrl = 'http://api-equilife.daken-businesscoaching.com/api/roue/vie/role/store';

  // Fonction pour ajouter un rôle
  Future<List<dynamic>?> ajoutRoleService(String libelle, String description) async {
    // Charger le token depuis SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';

    // Construire l'URL de l'API
    final Uri url = Uri.parse(baseUrl);

    try {
      // Construire le corps de la requête avec libelle et description
      final Map<String, dynamic> body = {
        'libelle': libelle,
        'description': description,
      };

      // Envoyer la requête POST à l'API avec le body encodé en JSON
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token', // Ajout du token dans l'en-tête
          'Content-Type': 'application/json',
        },
        body: json.encode(body),  // Encodez le body en JSON
      );

      // Vérifier si la requête a réussi
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        // Vérifier si la réponse indique un succès
        if (jsonResponse['type'] == 'success') {
          print('Enregistrement effectué avec succès');

          // Sauvegarder les données dans SharedPreferences
          final data = jsonResponse['data'];
          await prefs.setString('role_data', json.encode(data));

          return data; // Retourner les données
        } else {
          print('Erreur: ${jsonResponse['message']}');
        }
      } else {
        print('Erreur lors de l\'ajout du rôle: ${response.statusCode}');
        print('Message: ${response.body}');
      }
    } catch (e) {
      // Gérer les exceptions
      print('Erreur: $e');
    }

    // Retourne null si une erreur s'est produite
    return null;
  }
}
