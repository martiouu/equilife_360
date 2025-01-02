import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ObjectifService {
  final String _baseUrl = 'http://api-equilife.daken-businesscoaching.com/api/roue/vie/objectif/liste';

  Future<List<dynamic>> fetchObjectifs() async {
    try {
      // Récupérer le token depuis SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token') ?? '';

      // Définir les headers de la requête
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      // Faire la requête GET à l'API
      final response = await http.get(Uri.parse(_baseUrl), headers: headers);

      // Vérifier si la requête est réussie
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Vérifier si le type de réponse est 'success'
        if (data['type'] == 'success') {
          // Retourner la liste des objectifs
          return data['data'];
        } else {
          throw Exception('Erreur API: ${data['message']}');
        }
      } else {
        throw Exception('Erreur de connexion: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }
}
