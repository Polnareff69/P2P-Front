// lib/controllers/upload_product_controller.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:market/models/product_model.dart';

class UploadProductController {
  Future<void> uploadProduct(Product product) async {
    const String apiUrl = 'http://10.0.2.2:8000/product'; // URL del backend

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(product.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Producto subido exitosamente: ${response.body}");
      } else {
        throw Exception('Error al subir el producto: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error en la conexión: $e');
    }
  }
}