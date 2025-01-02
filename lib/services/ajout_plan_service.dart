import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AjoutPlanService {
  final String baseUrl = 'http://api-equilife.daken-businesscoaching.com/api/plan/action/store';

  Future<Map<String, dynamic>> ajoutPlan({
    required String uuidRole,
    required String uuidObjectif,
    required String uuidResultat,
    required String quand,
    required String comment,
    required String livrable,
  }) async {
    // Récupérer le token depuis SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';

    final response = await http.post(
      Uri.parse('$baseUrl?uuid_role=$uuidRole&uuid_objectif=$uuidObjectif&uuid_resultat=$uuidResultat&quand=$quand&comment=$comment&livrable=$livrable'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Ajoutez le token ici
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Échec de la mise à jour du plan');
    }
  }
}
