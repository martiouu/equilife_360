import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginService {
  final String url = 'http://api-equilife.daken-businesscoaching.com/api/login';

  Future<Map<String, dynamic>> connexionUtilisateur(String email, String password) async {
    final Uri uri = Uri.parse(url);

    try {
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'accept': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        // Parse la réponse JSON
        final responseData = jsonDecode(response.body);

        return {
          'success': responseData['type'] == 'success',
          'message': responseData['message'],
          'code': responseData['code'],
          'data': responseData['data'],
          'pack': responseData['pack'],
          'token': responseData['token'],
        };
      } else {
        return {
          'success': false,
          'message': 'Erreur ${response.statusCode}',
        };
      }
    } catch (e) {
      // Gérer les exceptions
      print('Erreur de connexion: $e');
      return {
        'success': false,
        'message': 'Erreur de connexion: $e',
      };
    }
  }
}
