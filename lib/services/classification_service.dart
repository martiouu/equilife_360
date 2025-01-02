import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ClassificationService {
  final String baseUrl = 'http://api-equilife.daken-businesscoaching.com/api/taches/statut/store';

  // Méthode pour mettre à jour le statut des tâches
  Future<bool> updateTachesStatus(List<String> taches, List<int> status) async {
    // Chargement du token depuis SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');

    // Construction du corps de la requête
    final Map<String, dynamic> body = {
      'taches': taches,
      'status': status,
    };

    try {
      // Envoi de la requête POST
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken', // Ajout du token dans les en-têtes
        },
        body: json.encode(body),
      );

      // Vérification du statut de la réponse
      if (response.statusCode == 200) {
        return true; // La mise à jour a réussi
      } else {
        print('Erreur lors de la mise à jour des tâches : ${response.statusCode}');
        return false; // La mise à jour a échoué
      }
    } catch (e) {
      print('Erreur lors de la requête : $e');
      return false; // En cas d'erreur de requête
    }
  }
}
