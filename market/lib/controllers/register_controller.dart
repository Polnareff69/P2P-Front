// controllers/register_controller.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:market/models/user_register_model.dart';

class RegisterController {
  Future<void> registerUser(UserRegisterModel user) async {
    const String apiUrl =
        'http://10.0.2.2:8000/register'; // URL del backend

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200 ||
        response.statusCode == 201) {
      print("Registro exitoso: ${response.body}");
    } else {
      throw Exception(
        'Error en el registro: ${response.body}',
      );
    }
  }
}
