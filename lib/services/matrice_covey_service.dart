import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MatriceCoveyService {
  final String baseUrl = 'http://api-equilife.daken-businesscoaching.com/api/taches';

  // Méthode pour mettre à jour la matrice de Covey des tâches
  Future<bool> updateTachesMatrice(List<String> taches, List<String> statusCovey) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('access_token');

      if (accessToken == null) {
        print('Token non disponible.');
        return false;
      }

      final Map<String, dynamic> body = {
        'taches': taches,
        'status': statusCovey,
      };

      final response = await http.post(
        Uri.parse('$baseUrl/statut_covey/store'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['type'] == 'success') {
          print('Mise à jour réussie : ${responseData['message']}');
          return true;
        } else {
          print('Erreur de mise à jour : ${responseData['message']}');
          return false;
        }
      } else {
        print('Erreur lors de la mise à jour des tâches : ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Erreur lors de la requête : $e');
      return false;
    }
  }
}
