import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ListeTacheService {
  final String apiUrl = 'http://api-equilife.daken-businesscoaching.com/api/taches/liste';

  Future<List<dynamic>> fetchTaches() async {
    // Récupération du token depuis SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';

    // Headers incluant le token
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.get(Uri.parse(apiUrl), headers: headers);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return jsonResponse['data']; // Retourne uniquement la partie "data"
      } else {
        throw Exception('Échec de la récupération des tâches : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la récupération des tâches : $e');
    }
  }
}
