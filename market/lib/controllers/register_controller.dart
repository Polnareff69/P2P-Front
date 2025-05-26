import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:market/models/user_register_model.dart';
import 'package:market/config/app_config.dart';
import 'package:market/services/auth_service.dart';
import 'package:flutter/foundation.dart';

class RegisterController {
  //  REGISTER INTEGRADO CON AUTHSERVICE
  Future<bool> registerUser(UserRegisterModel user) async {
    try {
      if (kDebugMode) print('🔄 Intentando registro para: ${user.name}');
      
      final response = await http.post(
        Uri.parse(AppConfig.registerUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()),
      );

      if (kDebugMode) {
        print('📡 Response status: ${response.statusCode}');
        print('📡 Response body: ${response.body}');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        
        // 🔍 El backend puede enviar el token con diferentes nombres
        // Intentar encontrar el token con diferentes claves posibles
        final token = data['access_token'] ?? data['Token'] ?? data['token'];
        
        if (token != null) {
          //  Usar AuthService para guardar el token automáticamente
          await AuthService.instance.saveToken(token);
          if (kDebugMode) print('✅ Registro exitoso con AuthService');
          return true;
        } else {
          if (kDebugMode) {
            print('❌ Token no encontrado en respuesta de registro');
            print('   Claves disponibles: ${data.keys.toList()}');
          }
          return false;
        }
      } else {
        if (kDebugMode) print('❌ Registro falló: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      if (kDebugMode) print('❌ Error en registro: $e');
      return false;
    }
  }
}