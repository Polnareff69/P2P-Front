import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/company_model.dart';

class CompanyController {
  // URL base de la API
  final String baseUrl = 'http://10.0.2.2:8000';

  // Método para obtener todas las empresas
  Future<List<Company>> getAllCompanies() async {
    try {
      // Recuperar el token de SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      final response = await http.get(
        Uri.parse('$baseUrl/compnay/all'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (token != null)
            'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(
          response.body,
        );
        return data
            .map((item) => Company.fromJson(item))
            .toList();
      } else {
        print(
          'Error al cargar empresas: ${response.statusCode}',
        );
        print('Respuesta: ${response.body}');
        throw Exception(
          'Error al cargar empresas: Código ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error en el controlador de empresas: $e');
      throw Exception(
        'No se pudieron cargar las empresas: $e',
      );
    }
  }

  // Método para guardar el ID de la empresa seleccionada
  Future<void> saveSelectedCompany(String companyId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('company_id', companyId);
      print('ID de empresa guardado: $companyId');
    } catch (e) {
      print('Error al guardar la empresa seleccionada: $e');
      throw Exception(
        'Error al guardar la empresa seleccionada: $e',
      );
    }
  }

  // Método para obtener la empresa seleccionada actualmente
  Future<String?> getSelectedCompanyId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('company_id');
    } catch (e) {
      print('Error al obtener la empresa seleccionada: $e');
      return null;
    }
  }
}
