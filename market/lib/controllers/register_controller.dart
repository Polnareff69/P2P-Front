// controllers/register_controller.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:market/models/user_register_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:market/config/app_config.dart'; // configuracion de peticiones

class RegisterController {
  Future<void> registerUser(UserRegisterModel user) async {
    // prueba en local
    /*
    const String apiUrl =
        'http://10.0.2.2:8000/register'; // URL del backend
    */

    final response = await http.post(
      Uri.parse(AppConfig.registerUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200 ||
        response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      final token =
          responseData['Token']; // Extraer el token de la respuesta
      
      // Guardar el token en SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);

      print("Registro exitoso: ${response.body}");
      return token;
      
    } else {
      throw Exception(
        'Error en el registro: ${response.body}',
      );
    }
  }
}
