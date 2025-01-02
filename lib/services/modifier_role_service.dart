import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateRoleService {
  // Fonction pour mettre à jour un rôle via l'API avec authentification
  Future<Map<String, dynamic>?> updateRole({
    required String libelle,
    required String description,
    required String uuid,
  }) async {
    try {
      // Récupérer le token depuis SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token') ?? '';

      // Construire l'URL sans paramètres query
      final url = Uri.parse(
        'http://api-equilife.daken-businesscoaching.com/api/roue/vie/role/update',
      );

      // Créer un body JSON pour la requête PUT
      final body = jsonEncode({
        'libelle': libelle,
        'description': description,
        'uuid': uuid,
      });

      // Envoyer la requête PUT à l'API avec l'en-tête Authorization
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Ajout du token dans l'en-tête
        },
        body: body, // Passer le body JSON
      );

      // Vérifier si la requête a réussi
      if (response.statusCode == 200) {
        // Décoder la réponse JSON
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Si la mise à jour est réussie, renvoyer les données
        if (responseData['type'] == 'success') {
          return responseData;
        } else {
          print('Erreur lors de la mise à jour : ${responseData['message']}');
          return null;
        }
      } else {
        print('Erreur HTTP : ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception lors de la mise à jour du rôle : $e');
      return null;
    }
  }
}
