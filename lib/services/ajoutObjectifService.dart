import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AjoutObjectifService {
  Future<Map<String, dynamic>?> ajoutObjectifService({
    required String roleUuid,
    required String libelle,
  }) async {
    // Récupérer le token depuis SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';

    // Préparer les paramètres et l'URL
    final url = Uri.parse(
        'http://api-equilife.daken-businesscoaching.com/api/roue/vie/objectif/store');
    final body = {
      'role_uuid': roleUuid,
      'libelle': libelle,
      // Ajoute d'autres paramètres ici si nécessaire
    };

    // Envoyer la requête POST
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      // Assurez-vous que la réponse est bien une Map
      return jsonDecode(response.body) as Map<String, dynamic>?;
    } else {
      print('Erreur lors de l\'ajout de l\'objectif: ${response.statusCode}');
      return null;
    }
  }
}
