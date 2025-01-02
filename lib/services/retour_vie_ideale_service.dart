import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ReturnVieIdealeService {
  final String _baseUrl = 'http://api-equilife.daken-businesscoaching.com/api/roue/derniere/vie/ideal/reponse';

  Future<Map<String, dynamic>> fetchData() async {
    // Charger le token depuis SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';

    final response = await http.get(
      Uri.parse(_baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // Si la requête est réussie, parsez les données JSON.
      return json.decode(response.body);
    } else {
      // Si la requête échoue, lancez une exception.
      throw Exception('Failed to load data');
    }
  }
}
