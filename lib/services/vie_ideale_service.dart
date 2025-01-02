import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class VieIdealeService {
  // Utilisez l'URL complète pour la requête POST
  final String _fullUrl = 'http://api-equilife.daken-businesscoaching.com/api/roue/questionnaire/vie/ideal/store';

  Future<void> saveResponses(Map<String, String> responses) async {
    // Charger le token depuis SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';

    // Créer la structure des données attendue par l'API
    final Map<String, String> dataToSend = {};
    int index = 0;

    responses.forEach((uuid, response) {
      dataToSend['question[$index]'] = uuid;
      dataToSend['answer[$index]'] = response; // Assurez-vous que la clé 'answer' est correcte
      dataToSend['objectif[$index]'] = response; // Utilisez la valeur correcte pour 'objectif'
      index++;
    });

    try {
      final response = await http.post(
        Uri.parse(_fullUrl),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: dataToSend,
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody['type'] == 'success') {
          print(responseBody['message']);
        } else {
          print('Erreur : ${responseBody['message']}');
        }
      } else {
        print('Erreur lors de l\'envoi des réponses : ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur lors de la requête : $e');
    }
  }
}
