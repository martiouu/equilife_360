import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OTPService {
  final String baseUrl = 'http://api-equilife.daken-businesscoaching.com/api/connexion/otp';

  Future<bool> sendOTP(String otp) async {
    // Récupérer le token stocké dans SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');

    if (accessToken == null || accessToken.isEmpty) {
      print('Token non trouvé dans SharedPreferences');
      return false;
    }

    final url = Uri.parse('$baseUrl?otp=$otp');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        // Requête réussie
        return true;
      } else {
        // Gestion des erreurs HTTP
        print('Erreur OTP: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      // Gestion des exceptions de la requête HTTP
      print('Erreur OTP: $e');
      return false;
    }
  }
}
