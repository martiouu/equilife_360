import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LogoutService {
  final String url = 'http://api-equilife.daken-businesscoaching.com/api/logout';

  Future<Map<String, dynamic>> deconnexionUtilisateur() async {
    final Uri uri = Uri.parse(url);

    try {
      // Récupérer le token d'accès stocké dans SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('access_token');

      // Faire la requête de déconnexion
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'accept': 'application/json',
          'Authorization': 'Bearer $accessToken', // Ajouter le token d'accès aux headers
        },
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        // Parse la réponse JSON
        final responseData = jsonDecode(response.body);

        // Nettoyer les préférences partagées
        prefs.remove('access_token');
        prefs.remove('uuid');
        prefs.remove('first_name');
        prefs.remove('last_name');
        prefs.remove('email');
        prefs.remove('contact');
        prefs.remove('pack');

        return {
          'success': responseData['type'] == 'success',
          'message': responseData['message'],
          'code': responseData['code'],
        };
      } else {
        return {
          'success': false,
          'message': 'Erreur ${response.statusCode}',
        };
      }
    } catch (e) {
      // Gérer les exceptions
      print('Erreur de déconnexion: $e');
      return {
        'success': false,
        'message': 'Erreur de déconnexion: $e',
      };
    }
  }
}
