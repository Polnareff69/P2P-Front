// controllers/business_controller.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:market/models/business_model.dart';

class BusinessController {
  Future<void> createBusiness(Business business) async {
    const String apiUrl = 'http://10.0.2.2:8000/company'; // URL del backend

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(business.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Empresa creada: ${response.body}");
    } else {
      throw Exception('Error al crear empresa: ${response.body}');
    }
  }
}