import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UpdateProfileService {
  final String url = 'http://api-equilife.daken-businesscoaching.com/api/user/update';

  Future<Map<String, dynamic>> updateUserProfile({
    String? firstName,
    String? lastName,
    String? contact,
    String? maritalStatus,
    String? civility,
    String? address,
    String? country,
    String? city,
    String? birthDate,
    String? birthPlace,
  }) async {
    // Récupérer le token d'accès stocké dans SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');

    final Uri uri = Uri.parse(url);

    try {
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $accessToken', // Ajouter le token au header
        },
        body: jsonEncode(<String, dynamic>{
          'first_name': firstName,
          'last_name': lastName,
          'contact': contact,
          'marital_status': maritalStatus,
          'civility': civility,
          'address': address,
          'country': country,
          'city': city,
          'birth_date': birthDate,
          'birth_place': birthPlace,
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
        };
      } else {
        return {
          'success': false,
          'message': 'Erreur ${response.statusCode}',
        };
      }
    } catch (e) {
      // Gérer les exceptions
      print('Erreur de mise à jour: $e');
      return {
        'success': false,
        'message': 'Erreur de mise à jour: $e',
      };
    }
  }
}
