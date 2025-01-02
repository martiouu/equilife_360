import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class QuestionnaireService {
  final String _baseUrl = 'http://api-equilife.daken-businesscoaching.com/api/roue/questionnaire/store';

  Future<void> submitResponses(Map<String, double> responses) async {
    try {
      // Charger le token depuis SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token') ?? '';

      // Préparer les données pour le corps de la requête
      final body = <String, String>{};
      responses.forEach((uuid, note) {
        final index = body.length ~/ 2;
        body['question[$index]'] = uuid;
        body['answer[$index]'] = note.toString();
      });

      // Effectuer la requête HTTP POST avec les paramètres dans le corps
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/x-www-form-urlencoded', // Correct Content-Type
        },
        body: body,
      );

      if (response.statusCode == 200) {
        print('Réponses soumises avec succès');
        print('Réponse de l\'API : ${response.body}');
      } else {
        throw Exception('Erreur lors de la soumission des réponses : ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Une erreur est survenue : $e');
    }
  }
}
