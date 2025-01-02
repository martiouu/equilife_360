import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ListRoleService {
  final String _baseUrl = 'http://api-equilife.daken-businesscoaching.com/api/roue/vie/role/liste';

  Future<Map<String, dynamic>?> fetchRoles() async {
    try {
      // Récupérer le token depuis SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token') ?? '';

      // Effectuer la requête HTTP avec le token dans les en-têtes
      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      // Vérifier si la requête a réussi
      if (response.statusCode == 200) {
        // Retourner les données en tant que Map
        return json.decode(response.body);
      } else {
        // Afficher le message d'erreur et retourner null
        print('Erreur de chargement des rôles : ${response.reasonPhrase}');
        return null;
      }
    } catch (e) {
      // Gérer les exceptions
      print('Exception lors du chargement des rôles : $e');
      return null;
    }
  }
}
