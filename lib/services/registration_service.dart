import 'dart:convert';
import 'package:http/http.dart' as http;

class RegistrationService {
  final String baseUrl = 'http://api-equilife.daken-businesscoaching.com/api/register/submit';

  Future<Map<String, dynamic>?> registerUser({
    required String email,
    required String firstname,
    required String lastname,
    required String password,
    required String confirmPassword,
    required String contact,
    required String civility,
  }) async {
    final url = Uri.parse(baseUrl);

    final Map<String, String> body = {
      'email': email,
      'firstname': firstname,
      'lastname': lastname,
      'password': password,
      'confirm': confirmPassword,
      'contact': contact,
      'civility': civility,
    };

    try {
      final http.Response response = await http.post(url, body: body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> result = jsonDecode(response.body);
        return result;  // Retourne les données de l'API
      } else {
        print('Erreur d\'inscription: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Erreur d\'inscription: $e');
      return null;
    }
  }
}
