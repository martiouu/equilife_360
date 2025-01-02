import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CodeOtpService {
  final String _baseUrl = 'http://api-equilife.daken-businesscoaching.com/api/resend/otp';

  Future<bool> resendOtp() async {
    // Récupérer le token stocké dans SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');

    if (accessToken == null || accessToken.isEmpty) {
      print('Token non trouvé dans SharedPreferences');
      return false;
    }

    // Configurer l'en-tête de la requête avec le token Bearer
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: headers,
      );

      if (response.statusCode == 200) {
        // La requête a réussi
        print('OTP envoyé avec succès');
        return true;
      } else {
        // La requête a échoué
        print('Erreur lors de l\'envoi de l\'OTP : ${response.reasonPhrase}');
        return false;
      }
    } catch (e) {
      print('Exception lors de l\'envoi de l\'OTP : $e');
      return false;
    }
  }
}
