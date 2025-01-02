import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ListVieIdealeService {
  final String baseUrl = 'http://api-equilife.daken-businesscoaching.com/api/roue/question/vie/ideal/list';

  // Fonction pour récupérer les données des questions depuis l'API
  Future<Map<String, dynamic>> fetchQuestions() async {
    // Charger le token depuis SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';

    // Construire l'URL sans admin_uuid
    final uri = Uri.parse(baseUrl);

    // Envoyer la requête GET à l'API avec le token dans les headers
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    // Vérifier le statut de la réponse
    if (response.statusCode == 200) {
      // Retourner le body de la réponse décodé en JSON
      return json.decode(response.body);
    } else {
      // Lever une exception en cas d'erreur
      throw Exception('Failed to load questions');
    }
  }

  // Fonction pour lister les UUIDs des questions
  Future<List<String>> listUuids() async {
    try {
      final data = await fetchQuestions();

      if (data['code'] == 200) {
        // Extrait les UUIDs de chaque question
        return List<String>.from(data['data'].map((question) => question['uuid']));
      } else {
        throw Exception('Erreur: ${data['message']}');
      }
    } catch (e) {
      print('Une erreur est survenue: $e');
      return [];
    }
  }

  // Fonction pour lister les titles des questions
  Future<List<String>> listTitles() async {
    try {
      final data = await fetchQuestions();

      if (data['code'] == 200) {
        // Extrait les titles de chaque question
        return List<String>.from(data['data'].map((question) => question['title']));
      } else {
        throw Exception('Erreur: ${data['message']}');
      }
    } catch (e) {
      print('Une erreur est survenue: $e');
      return [];
    }
  }

  // Fonction pour lister les questions
  Future<List<String>> listQuestions() async {
    try {
      final data = await fetchQuestions();

      if (data['code'] == 200) {
        // Extrait les questions de chaque entrée
        return List<String>.from(data['data'].map((question) => question['question']));
      } else {
        throw Exception('Erreur: ${data['message']}');
      }
    } catch (e) {
      print('Une erreur est survenue: $e');
      return [];
    }
  }
}
