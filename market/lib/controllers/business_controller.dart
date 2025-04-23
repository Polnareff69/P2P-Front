import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:market/models/business_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:convert';

class BusinessController {
  Future<void> createBusiness(
    Business business,
    File businessLogo,
    File businessBackground,
  ) async {
    const String baseUrl = 'http://10.0.2.2:8000/company';

    // Recuperar el token de SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      throw Exception('No authentication token found');
    }

    // Construir los parámetros de consulta similar a uploadProduct
    final queryParams = {
      'name': business.name,
      'description': business.description,
      'phonenumber': business.phonenumber,
    };

    // Crear la URI con los parámetros de consulta
    final uri = Uri.parse(
      baseUrl,
    ).replace(queryParameters: queryParams);

    try {
      // Crear un objeto multipart request
      var request = http.MultipartRequest('POST', uri);

      // Agregar el token de autenticación
      request.headers['Authorization'] = 'Bearer $token';

      // Agregar los archivos (sin agregar campos al formulario)
      if (businessLogo != null) {
        final logoFile = await http.MultipartFile.fromPath(
          'companyimg',
          businessLogo.path,
          contentType: MediaType(
            'image',
            getImageMimeType(
              businessLogo.path.split('/').last,
            ),
          ),
        );
        request.files.add(logoFile);
      }

      if (businessBackground != null) {
        final bgFile = await http.MultipartFile.fromPath(
          'companybackgrnd',
          businessBackground.path,
          contentType: MediaType(
            'image',
            getImageMimeType(
              businessBackground.path.split('/').last,
            ),
          ),
        );
        request.files.add(bgFile);
      }

      print("URI con parámetros: $uri");
      print(
        "Archivos adjuntos: ${request.files.map((f) => '${f.field}: ${f.filename}').join(', ')}",
      );

      // Enviar la solicitud
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(
        streamedResponse,
      );

      print("Código de respuesta: ${response.statusCode}");
      print("Cuerpo de respuesta: ${response.body}");

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        final companyId =
            responseData['Company']['CompanyId'];
        await prefs.setString('company_id', companyId);
      } else {
        throw Exception(
          'Error al crear empresa: ${response.body}',
        );
      }
    } catch (e) {
      print("Error detallado: $e");
      throw Exception('Error en la conexión: $e');
    }
  }

  // Función auxiliar para determinar el tipo MIME de la imagen
  String getImageMimeType(String fileName) {
    if (fileName.endsWith('.jpg') ||
        fileName.endsWith('.jpeg')) {
      return 'jpeg';
    } else if (fileName.endsWith('.png')) {
      return 'png';
    } else if (fileName.endsWith('.gif')) {
      return 'gif';
    }
    return 'jpeg'; // Valor predeterminado
  }
}
