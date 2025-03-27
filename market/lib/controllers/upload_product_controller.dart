// lib/controllers/upload_product_controller.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:market/models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UploadProductController {
  Future<void> uploadProduct(
    Product product, [
    String? companyId,
  ]) async {
    // Obtener el CompanyId de SharedPreferences si no se proporciona uno
    if (companyId == null) {
      final prefs = await SharedPreferences.getInstance();
      companyId = prefs.getString('company_id');

      if (companyId == null) {
        throw Exception(
          'No se encontró un CompanyId. Crea una empresa primero.',
        );
      }
    }

    final String apiUrl =
        'http://10.0.2.2:8000/product/$companyId'; // URL del backend

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(product.toJson()),
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        print(
          "Producto subido exitosamente: ${response.body}",
        );
      } else {
        throw Exception(
          'Error al subir el producto: ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error en la conexión: $e');
    }
  }
}
