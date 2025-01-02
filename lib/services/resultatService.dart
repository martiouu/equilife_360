import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ResultatService {
  final String baseUrl = 'http://api-equilife.daken-businesscoaching.com/api/roue/vie/objectif/realiser/liste';

  Future<List<dynamic>> fetchObjectifs(String objectifUuid) async {
    try {
      // Récupérer le token depuis SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token') ?? '';

      final url = baseUrl;

      // Effectuer la requête HTTP POST avec le token dans les en-têtes
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token', // Passer le token dans l'en-tête d'autorisation
          'Content-Type': 'application/json',
        },
        body: json.encode({'objectif_uuid': objectifUuid}), // Passer le UUID dans le corps de la requête
      );

      // Vérifier si la requête a réussi
      if (response.statusCode == 200) {
        // Décoder la réponse JSON
        final data = json.decode(response.body);
        if (data['type'] == 'success') {
          return data['data'] ?? []; // Retourner les données si elles existent
        } else {
          print('Erreur dans la réponse API: ${data['message']}');
          return [];
        }
      } else {
        // Gérer les erreurs HTTP
        throw Exception('Erreur lors de la récupération des données: ${response.statusCode}');
      }
    } catch (e) {
      // Gérer les exceptions et afficher l'erreur
      print('Erreur: $e');
      return [];
    }
  }
}
