import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:market/models/user_model.dart';

class LoginController {
  Future<String?> loginUser(User user) async {
    const String apiUrl = 'http://10.0.2.2:8000/token';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['access_token'];
    } else {
      throw Exception(
        'Error en el login: ${response.body}',
      );
    }
  }
}
