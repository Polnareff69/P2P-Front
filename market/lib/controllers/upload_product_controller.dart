import 'dart:io';
import 'dart:math'; // esto para min()
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:market/models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'package:market/config/app_config.dart'; // configuracion de peticiones

class UploadProductController {
  // obtener producto por id
  Future<Product> getProductById(String productId) async {
    try {
      if (kDebugMode) {
        print('🔍 Solicitando producto con ID: $productId');
      }

      final response = await http.get(
        Uri.parse(
          '${AppConfig.getApiUrl()}/product/$productId',
        ),
        headers: await _getHeaders(),
      );

      if (kDebugMode) {
        print('📊 Status Code: ${response.statusCode}');
        // Mostrar primeros 500 caracteres para no saturar la consola
        print(
          '📄 Respuesta (primeros 500 caracteres): ${response.body.substring(0, min(500, response.body.length))}...',
        );
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (kDebugMode) {
          print('📦 Producto obtenido: $data');
        }

        return Product.fromJson(data);
      } else {
        throw Exception(
          'Error al obtener producto: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error en getProductById: $e');
      }
      throw Exception('Error en la conexión: $e');
    }
  }

  //funcion para obtener productos de una empresa
  Future<List<Product>> getCompanyProducts(
    String companyId,
  ) async {
    try {
      if (kDebugMode) {
        print(
          '🔍 Solicitando productos para companyId: $companyId',
        );
      }

      final response = await http.get(
        Uri.parse(
          AppConfig.getCompanyProductsUrl(companyId),
        ),
      );

      if (kDebugMode) {
        print(
          '🌐 URL: ${AppConfig.getCompanyProductsUrl(companyId)}',
        );
        print('📊 Status Code: ${response.statusCode}');
        // Mostrar los primeros 500 caracteres para no saturar la consola
        print(
          '📄 Respuesta (primeros 500 caracteres): ${response.body.substring(0, min(500, response.body.length))}...',
        );
      }

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(
          response.body,
        );

        if (kDebugMode) {
          print(
            '📦 Número de productos recibidos: ${jsonResponse.length}',
          );
          // Imprimir el primer producto para verificar estructura
          if (jsonResponse.isNotEmpty) {
            print(
              '📦 Primer producto (ejemplo): ${jsonResponse[0]}',
            );
          }
        }

        final products =
            jsonResponse.map((data) {
              final product = Product.fromJson(data);

              // Log adicional para verificar cada producto convertido
              if (kDebugMode) {
                print('🏷️ Producto convertido:');
                print('   ID: ${product.productid}');
                print('   Nombre: ${product.Name}');
              }

              return product;
            }).toList();

        return products;
      } else {
        if (kDebugMode) {
          print(
            '❌ Error en la respuesta: ${response.body}',
          );
        }
        throw Exception(
          'Error al obtener productos: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error en getCompanyProducts: $e');
      }
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

    // pruebas en local
    /*
    final baseUrl =
        'http://10.0.2.2:8000/product/$companyId';
    */
    final uri = Uri.parse(
      AppConfig.uploadProductUrl(companyId),
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

  // Añadir este método a la clase UploadProductController
  Future<Map<String, String>> getAllProductsIdMap() async {
    try {
      if (kDebugMode) {
        print('🔍 Obteniendo mapa de IDs de productos...');
      }

      final response = await http.get(
        Uri.parse('${AppConfig.getApiUrl()}/product/all'),
        headers:
            await _getHeaders(), // Usar _getHeaders si requiere autenticación
      );

      if (response.statusCode == 200) {
        final List<dynamic> products = json.decode(
          response.body,
        );
        final Map<String, String> nameToIdMap = {};

        if (kDebugMode) {
          print(
            '📦 Obtenidos ${products.length} productos del endpoint /product/all',
          );
          if (products.isNotEmpty) {
            print(
              '📦 Ejemplo del primer producto: ${products[0]}',
            );
          }
        }

        for (var product in products) {
          if (product['name'] != null &&
              product['productid'] != null) {
            nameToIdMap[product['name']] =
                product['productid'];

            if (kDebugMode) {
              print(
                '🔗 Mapeado: ${product['name']} -> ${product['productid']}',
              );
            }
          }
        }

        return nameToIdMap;
      } else {
        if (kDebugMode) {
          print(
            '❌ Error obteniendo productos: ${response.statusCode} - ${response.body}',
          );
        }
        throw Exception(
          'Error al obtener todos los productos: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error en getAllProductsIdMap: $e');
      }
      throw Exception('Error en la conexión: $e');
    }
  }

  // Método para obtener headers de autorización (si es necesario)
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // obtener todos los productos con ID's
  Future<Map<String, Product>>
  getAllProductsWithIds() async {
    try {
      if (kDebugMode) {
        print(
          '🔍 Obteniendo todos los productos con IDs...',
        );
      }

      final response = await http.get(
        Uri.parse('${AppConfig.getApiUrl()}/product/all'),
        headers: await _getHeaders(),
      );

      if (kDebugMode) {
        print('📊 Status Code: ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(
          response.body,
        );
        final Map<String, Product> productsMap = {};

        if (kDebugMode) {
          print(
            '📦 Número de productos con IDs recibidos: ${jsonResponse.length}',
          );
        }

        for (var data in jsonResponse) {
          if (data['productid'] != null) {
            final product = Product.fromJson(data);
            productsMap[data['productid']] = product;

            if (kDebugMode) {
              print(
                '🔗 Mapeado: ${data['productid']} -> ${data['name'] ?? "Sin nombre"}',
              );
            }
          }
        }

        return productsMap;
      } else {
        throw Exception(
          'Error al obtener productos: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error en getAllProductsWithIds: $e');
      }
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
