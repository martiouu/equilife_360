import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AjoutTacheService {
  // URL de base de l'API
  static const String baseUrl = "http://api-equilife.daken-businesscoaching.com/api/taches/store";

  // Fonction pour ajouter une tâche avec un token d'authentification
  Future<Map<String, dynamic>> ajoutTache(String tache, String type, {int? duree, int? minutes, int status = 0}) async {
    try {
      // Récupération du token depuis SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token') ?? '';

      // Headers incluant le token
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      // Construction dynamique du body de la requête POST
      final body = jsonEncode({
        'tache': tache,
        'type': type,
        if (duree != null) 'duree': duree,
        if (minutes != null) 'minutes': minutes,
        'status': status,
      });

      // Exécute la requête HTTP POST avec les headers et le body
      final http.Response response = await http.post(
        Uri.parse(baseUrl),
        headers: headers,
        body: body,
      );

      // Vérifie le code de statut
      if (response.statusCode == 200) {
        // Parse la réponse JSON
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        // Retourne les données en cas de succès
        return responseData;
      } else {
        // Gère les erreurs si la réponse n'est pas 200
        return {
          "type": "error",
          "message": "Erreur lors de l'ajout de la tâche. Code: ${response.statusCode}"
        };
      }
    } catch (e) {
      // Gère les exceptions réseau ou autres erreurs
      return {
        "type": "error",
        "message": "Une erreur s'est produite : $e"
      };
    }
  }
}
