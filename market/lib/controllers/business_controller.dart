import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:market/models/business_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'package:market/config/app_config.dart';
import 'package:market/services/auth_service.dart'; 
import 'package:flutter/foundation.dart'; 

class BusinessController {
  Future<void> createBusiness(
    Business business,
    File businessLogo,
    File businessBackground,
  ) async {
    // Recuperar el token de SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      throw Exception('No authentication token found');
    }

    // 🔍 DEBUG: Estado antes de crear empresa
    if (kDebugMode) {
      print('🔍 ANTES de crear empresa:');
      AuthService.instance.printCurrentState();
    }

    // Construir los parámetros de consulta
    final queryParams = {
      'name': business.name,
      'description': business.description,
      'phonenumber': business.phonenumber,
    };

    // Crear la URI con los parámetros de consulta
    final uri = Uri.parse(AppConfig.createCompanyUrl).replace(queryParameters: queryParams);

    try {
      // Crear un objeto multipart request
      var request = http.MultipartRequest('POST', uri);

      // Agregar el token de autenticación
      request.headers['Authorization'] = 'Bearer $token';

      // Agregar los archivos
      final logoFile = await http.MultipartFile.fromPath(
        'companyimg',
        businessLogo.path,
        contentType: MediaType(
          'image',
          getImageMimeType(businessLogo.path.split('/').last),
        ),
      );
      request.files.add(logoFile);

      final bgFile = await http.MultipartFile.fromPath(
        'companybackgrnd',
        businessBackground.path,
        contentType: MediaType(
          'image',
          getImageMimeType(businessBackground.path.split('/').last),
        ),
      );
      request.files.add(bgFile);

      if (kDebugMode) {
        print("URI con parámetros: $uri");
      }

      // Enviar la solicitud
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (kDebugMode) {
        print("Código de respuesta: ${response.statusCode}");
        print("Cuerpo de respuesta completo: ${response.body}");
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        
        // 🔍 DEBUG: Analizar lo que devuelve el backend
        if (kDebugMode) {
          print('📡 Respuesta del backend:');
          print('   Keys disponibles: ${responseData.keys}');
          print('   Respuesta completa: $responseData');
        }
        
        // Guardar company_id como siempre
        final companyId = responseData['Company']['CompanyId'];
        await prefs.setString('company_id', companyId);
        
        //  Manejar actualización de rol
        await _handleRoleUpdate(responseData, prefs);
        
        if (kDebugMode) {
          print('✅ Empresa creada exitosamente');
          print('🔍 DESPUÉS de crear empresa:');
          AuthService.instance.printCurrentState();
        }
      } else {
        throw Exception('Error al crear empresa: ${response.body}');
      }
    } catch (e) {
      if (kDebugMode) print("❌ Error detallado: $e");
      throw Exception('Error en la conexión: $e');
    }
  }

  //  Manejar actualización de rol después de crear empresa
  Future<void> _handleRoleUpdate(Map<String, dynamic> responseData, SharedPreferences prefs) async {
    try {
      if (kDebugMode) print('🔄 Verificando actualización de rol...');
      
      // Opción 1: El backend devuelve un nuevo token
      if (responseData.containsKey('token')) {
        final newToken = responseData['token'];
        if (kDebugMode) print('✅ Nuevo token recibido del backend');
        await AuthService.instance.saveToken(newToken);
      }
      // Opción 2: El backend devuelve el nuevo rol explícitamente
      else if (responseData.containsKey('role')) {
        final newRole = responseData['role'];
        if (kDebugMode) print('✅ Nuevo rol recibido: $newRole');
        await AuthService.instance.updateUserRole(newRole);
      }
      // Opción 3: El backend devuelve información del usuario actualizada
      else if (responseData.containsKey('user')) {
        final userData = responseData['user'];
        if (userData.containsKey('role')) {
          final newRole = userData['role'];
          if (kDebugMode) print('✅ Rol en user data: $newRole');
          await AuthService.instance.updateUserRole(newRole);
        }
      }
      // Opción 4: Forzar actualización a seller (workaround)
      else {
        if (kDebugMode) print('⚠️ No se encontró info de rol, forzando a seller...');
        await AuthService.instance.updateUserRole('seller');
      }
      
      // Verificar el resultado
      if (kDebugMode) {
        print('🔍 Verificación final del rol:');
        print('   Rol actual: ${AuthService.instance.currentRole}');
        print('   Es seller?: ${AuthService.instance.isSeller}');
      }
    } catch (e) {
      if (kDebugMode) print('❌ Error actualizando rol: $e');
      // En caso de error, forzar rol a seller como fallback
      await AuthService.instance.updateUserRole('seller');
    }
  }

  // Función auxiliar para determinar el tipo MIME de la imagen
  String getImageMimeType(String fileName) {
    if (fileName.endsWith('.jpg') || fileName.endsWith('.jpeg')) {
      return 'jpeg';
    } else if (fileName.endsWith('.png')) {
      return 'png';
    } else if (fileName.endsWith('.gif')) {
      return 'gif';
    }
    return 'jpeg'; // Valor predeterminado
  }
}