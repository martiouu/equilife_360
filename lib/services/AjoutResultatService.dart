import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AjoutResultatService {
  final String baseUrl = 'http://api-equilife.daken-businesscoaching.com/api/roue/vie/objectif/realiser/store';

  // Méthode pour enregistrer un résultat clé pour un objectif spécifique
  Future<List<Map<String, dynamic>>?> storeResultat({
    required String objectifUuid,
    required String description,
  }) async {
    // Récupérer le token depuis SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';

    if (token.isEmpty) {
      print('Erreur : Token non disponible');
      return null; // Retourner null si le token n'est pas disponible
    }

    // Construire l'URL avec les paramètres de la requête
    final String url = '$baseUrl?objectif_uuid=$objectifUuid&description=$description';

    try {
      // Envoyer une requête POST avec le token dans les en-têtes
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Ajouter le token dans l'en-tête pour l'authentification
        },
      );

      // Vérifier le statut de la réponse HTTP
      if (response.statusCode == 200) {
        // Décoder la réponse JSON
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Vérifier si la réponse indique un succès
        if (responseData['type'] == 'success') {
          print('Enregistrement effectué avec succès : ${responseData['message']}');
          // Retourner la liste des résultats si l'enregistrement est réussi
          List<dynamic> data = responseData['data'];
          return data.map((item) => item as Map<String, dynamic>).toList();
        } else {
          // Gérer les erreurs spécifiques à l'API
          print('Erreur : ${responseData['message']}');
        }
      } else {
        // Gestion des erreurs HTTP (par exemple, erreurs 4xx ou 5xx)
        print('Erreur HTTP: ${response.statusCode}');
        print('Message: ${response.reasonPhrase}');
      }
    } catch (e) {
      // Gérer les erreurs réseau ou autres exceptions
      print('Erreur lors de la requête : $e');
    }
    return null; // Retourner null en cas d'échec de la requête
  }
}
