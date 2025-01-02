import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ListQuestionService {
  final String baseUrl = 'http://api-equilife.daken-businesscoaching.com/api/roue/question/list';

  Future<Map<String, dynamic>> fetchQuestions() async {
    // Charger le token depuis SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';
    final adminUuid = prefs.getString('admin_uuid') ?? '';

    // Construire l'URL avec le paramètre admin_uuid
    final uri = Uri.parse('$baseUrl?admin_uuid=$adminUuid');

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load questions');
    }
  }

  // Fonction pour imprimer les questions retournées
  Future<void> printQuestions() async {
    try {
      final data = await fetchQuestions();

      if (data['type'] == 'success') {
        print('Liste retournée avec succès !');
        for (var question in data['data']) {
          print('ID: ${question['id']}');
          print('UUID: ${question['uuid']}');
          print('Title: ${question['title']}');
          print('Question: ${question['question']}');
          print('Status: ${question['status']}');
          print('Created At: ${question['created_at']}');
          print('Updated At: ${question['updated_at']}');
          print('--------------------------------------');
        }
      } else {
        print('Erreur: ${data['message']}');
      }
    } catch (e) {
      print('Une erreur est survenue: $e');
    }
  }
}
