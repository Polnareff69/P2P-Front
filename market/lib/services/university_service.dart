import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/university_model.dart';

class UniversityService {
  static const String baseUrl = 'http://10.0.2.2:8000';

  Future<List<University>> fetchUniversities() async {
    final response = await http.get(Uri.parse('$baseUrl/universities'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => University.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load universities');
    }
  }
}
