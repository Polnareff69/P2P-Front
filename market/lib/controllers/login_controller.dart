import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:market/models/user_model.dart';
import 'package:market/config/app_config.dart';
import 'package:market/services/auth_service.dart';
import 'package:flutter/foundation.dart';

class LoginController {
  // LOGIN INTEGRADO CON AUTHSERVICE
  Future<bool> loginUser(User user) async {
    try {
      if (kDebugMode) print('🔄 Intentando login para: ${user.name}');
      
      final response = await http.post(
        Uri.parse(AppConfig.loginUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()),
      );

      if (kDebugMode) {
        print('📡 Response status: ${response.statusCode}');
        print('📡 Response body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['access_token'];
        
        if (token != null) {
          //  Usar AuthService para guardar el token
          await AuthService.instance.saveToken(token);
          if (kDebugMode) print('✅ Login exitoso con AuthService');
          return true;
        } else {
          if (kDebugMode) print('❌ Token no encontrado en respuesta');
          return false;
        }
      } else {
        if (kDebugMode) print('❌ Login falló: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      if (kDebugMode) print('❌ Error en login: $e');
      return false;
    }
  }
}