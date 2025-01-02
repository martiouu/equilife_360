import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String _baseUrl = 'http://api-equilife.daken-businesscoaching.com/api/reset/password/token';

  Future<Map<String, dynamic>> sendResetEmail(String email) async {
    final url = Uri.parse('$_baseUrl?email=$email');

    try {
      final response = await http.post(url);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return {
          "type": responseData['type'],
          "message": responseData['message'],
          "code": responseData['code'],
          "data": responseData['data']
        };
      } else {
        return {
          "type": "error",
          "message": "Échec de l'envoi de l'email de réinitialisation.",
          "code": response.statusCode,
          "data": ""
        };
      }
    } catch (error) {
      return {
        "type": "error",
        "message": "Une erreur s'est produite.",
        "code": 500,
        "data": error.toString()
      };
    }
  }
}
