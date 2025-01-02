import 'dart:convert';
import 'package:http/http.dart' as http;

class ResetPasswordService {
  final String apiUrl = 'http://api-equilife.daken-businesscoaching.com/api/reset/password/token/update/password';

  Future<Map<String, dynamic>> resetPassword({
    required String token,
    required String email,
    required String newPassword,
    required String confirm,
  }) async {
    final url = Uri.parse('$apiUrl?token=$token&email=$email&confirm=$confirm&new_password=$newPassword');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Décoder la réponse JSON
        final data = json.decode(response.body) as Map<String, dynamic>;
        return data;
      } else {
        // Gestion des erreurs HTTP
        return {
          'type': 'error',
          'message': 'Erreur de serveur : ${response.statusCode}',
        };
      }
    } catch (e) {
      // Gestion des erreurs de réseau ou autres
      return {
        'type': 'error',
        'message': 'Une erreur est survenue : $e',
      };
    }
  }
}

