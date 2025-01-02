import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DeleteRoleService {
  // Mettez à jour l'URL pour correspondre à l'API de suppression
  final String _baseUrl = 'http://api-equilife.daken-businesscoaching.com/api/roue/vie/role/delete';

  Future<String> deleteRole(String uuid) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';

    // Assurez-vous que l'UUID est passé comme paramètre de requête
    final url = Uri.parse('$_baseUrl?uuid=$uuid');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['type'] == 'success') {
        return 'Suppression réussie';
      } else {
        return 'Erreur lors de la suppression: ${responseData['message']}';
      }
    } else {
      print('Erreur de suppression : ${response.statusCode} - ${response.body}');
      return 'Erreur de serveur: ${response.statusCode}';
    }
  }
}
