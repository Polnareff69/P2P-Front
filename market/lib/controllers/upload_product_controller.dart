import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:market/models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:convert';

class UploadProductController {
  //funcion para obtener productos de una empresa
  Future<List<Product>> getCompanyProducts(
    String companyId,
  ) async {
    try {
      print('Solicitando productos para companyId: $companyId');
      final response = await http.get(
        Uri.parse(
          'http://10.0.2.2:8000/company/products/$companyId',
        ),
      );
      print('URL de solicitud: $response');

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(
          response.body,
        );
        return jsonResponse
            .map((data) => Product.fromJson(data))
            .toList();
      } else {
        throw Exception(
          'Error al obtener productos: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error en la conexión: $e');
    }
  }

  //funcion para subir productos
  Future<void> uploadProduct(
    Product product,
    List<File> images, [
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

    // Construir la URL con los parámetros de consulta
    final queryParams = {
      'Name': product.Name ?? '',
      'Description': product.Description ?? '',
      'Price': product.Price ?? '',
    };

    final baseUrl =
        'http://10.0.2.2:8000/product/$companyId';
    final uri = Uri.parse(
      baseUrl,
    ).replace(queryParameters: queryParams);

    try {
      // Crear un objeto multipart request
      var request = http.MultipartRequest('POST', uri);

      // Agregar la imagen si hay alguna
      if (images.isNotEmpty) {
        final file = images.first;
        final fileName = file.path.split('/').last;

        final multipartFile = await http
            .MultipartFile.fromPath(
          'ProductImg',
          file.path,
          contentType: MediaType(
            'image',
            getImageMimeType(fileName),
          ),
        );

        request.files.add(multipartFile);
      }

      // Enviar la solicitud
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(
        streamedResponse,
      );

      if (response.statusCode == 200) {
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
