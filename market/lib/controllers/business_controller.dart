// controllers/business_controller.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:market/models/business_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BusinessController {
  Future<void> createBusiness(Business business) async {
    const String apiUrl =
        'http://10.0.2.2:8000/company'; // URL del backend

    // Recuperar el token de SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(business.toJson()),
    );

    if (response.statusCode == 200 ||
        response.statusCode == 201) {
      print("Empresa creada: ${response.body}");

      // Parsear la respuesta JSON
      final responseData = jsonDecode(response.body);

      // Extraer el CompanyId
      final companyId =
          responseData['Company']['CompanyId'];

      // Guardar el CompanyId en SharedPreferences para uso futuro
      await prefs.setString('company_id', companyId);

      //return companyId;
    } else {
      throw Exception(
        'Error al crear empresa: ${response.body}',
      );
    }
  }
}
