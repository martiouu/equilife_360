import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RoueVieService {
  final String _url = 'http://api-equilife.daken-businesscoaching.com/api/roue/derniere/reponse';

  Future<Map<String, dynamic>> fetchLatestResponses() async {
    try {
      // Charger le token depuis SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token') ?? '';

      // Effectuer la requête HTTP GET
      final response = await http.get(
        Uri.parse(_url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Décoder la réponse JSON
        final responseData = json.decode(response.body);

        // Vérifier le type de réponse
        if (responseData['type'] == 'success') {
          return responseData;
        } else {
          throw Exception('Erreur lors de la récupération des réponses : ${responseData['message']}');
        }
      } else {
        throw Exception('Erreur lors de la récupération des réponses : ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Une erreur est survenue : $e');
      rethrow;
    }
  }
}
