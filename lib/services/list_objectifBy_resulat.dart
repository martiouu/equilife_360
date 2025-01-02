import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ListObjectifByResultat {
  final String baseUrl = 'http://api-equilife.daken-businesscoaching.com/api/roue/vie/objectif/realiser/liste';

  Future<List<Map<String, dynamic>>> fetchResultats(String objectifUuid) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';

    final url = Uri.parse('$baseUrl?objectif_uuid=$objectifUuid');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['type'] == 'success') {
          return List<Map<String, dynamic>>.from(data['data']);
        } else {
          throw Exception('Erreur de l\'API: ${data['message']}');
        }
      } else {
        throw Exception('Erreur HTTP: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la récupération des résultats: $e');
    }
  }
}
