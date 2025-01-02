import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DeleteTacheService {
  Future<void> deleteTache(String uuid) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    const url = 'http://api-equilife.daken-businesscoaching.com/api/taches/delete';

    // Envoie le `uuid` dans le body de la requête POST
    final body = jsonEncode({
      'uuid': uuid,
    });

    try {
      // Remplace http.delete par http.post
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['type'] == 'success') {
          print('Tâche supprimée avec succès: ${responseData['message']}');
        } else {
          print('Erreur lors de la suppression: ${responseData['message']}');
        }
      } else {
        print('Erreur serveur: ${response.statusCode}');
      }
    } catch (error) {
      print('Erreur lors de la requête: $error');
    }
  }
}
