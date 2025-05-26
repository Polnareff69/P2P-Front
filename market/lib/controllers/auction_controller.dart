// lib/controllers/auction_controller.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:market/controllers/upload_product_controller.dart';
import 'package:market/models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:market/models/auction_model.dart';
import 'package:market/models/auction_bid_model.dart';
import 'package:market/config/app_config.dart';
//import 'package:market/services/auth_service.dart';
import 'dart:math';

class AuctionController {
  // Obtener todas las subastas
  Future<List<Auction>> getAllAuctions() async {
    try {
      final response = await http.get(
        Uri.parse(AppConfig.auctionsUrl),
        headers: await _getHeaders(),
      );

      if (kDebugMode) {
        print(
          '🔍 Respuesta de subastas: ${response.statusCode}',
        );
        print(
          '📄 Primeros 500 caracteres: ${response.body.substring(0, min(500, response.body.length))}...',
        );
      }

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(
          response.body,
        );

        if (kDebugMode) {
          print(
            '📦 Número de subastas recibidas: ${data.length}',
          );
          if (data.isNotEmpty) {
            print(
              '📦 Primera subasta (ejemplo): ${data[0]}',
            );
          }
        }

        // Convertir los datos JSON a objetos Auction
        final auctions =
            data
                .map((json) => Auction.fromJson(json))
                .toList();

        // Cargar productos para cada subasta
        return _loadProductsForAuctions(auctions);
      } else {
        throw Exception(
          'Error al obtener subastas: ${response.body}',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error al obtener subastas: $e');
      }
      rethrow;
    }
  }

  // Método para cargar productos para cada subasta
  Future<List<Auction>> _loadProductsForAuctions(
    List<Auction> auctions,
  ) async {
    final productController = UploadProductController();
    final updatedAuctions = <Auction>[];

    try {
      // 1. Obtener todos los productos con IDs
      final productsWithIds =
          await productController.getAllProductsWithIds();

      if (kDebugMode) {
        print(
          '📦 Productos con IDs obtenidos: ${productsWithIds.length}',
        );
      }

      // 2. Obtener productos con detalles (nombres e imágenes)
      final prefs = await SharedPreferences.getInstance();
      final companyId = prefs.getString('company_id');

      List<Product> productsWithDetails = [];
      if (companyId != null) {
        productsWithDetails = await productController
            .getCompanyProducts(companyId);
        if (kDebugMode) {
          print(
            '📦 Productos con detalles obtenidos: ${productsWithDetails.length}',
          );
        }
      }

      // 3. Crear un mapa de referencia de las imágenes y nombres por su nombre (si existe)
      final Map<String, String> imagesByName = {};
      for (var product in productsWithDetails) {
        if (product.Name != null &&
            product.productImg != null) {
          imagesByName[product.Name!] = product.productImg!;
          if (kDebugMode) {
            print(
              '🖼️ Imagen mapeada: ${product.Name} -> ${product.productImg}',
            );
          }
        }
      }

      // 4. Procesar cada subasta
      for (var auction in auctions) {
        // Buscar el producto por su ID
        final product = productsWithIds[auction.productId];

        if (product != null) {
          // Si encontramos el ID, usamos la información del producto
          String? productName = product.Name;
          String? productImg = product.productImg;

          // Si no tiene nombre o imagen, intentamos buscar en el otro conjunto de datos
          if (productName == null || productImg == null) {
            for (var detailedProduct
                in productsWithDetails) {
              // Intentamos hacer coincidir por algún criterio (ejemplo: precio)
              if (product.Price == detailedProduct.Price &&
                  detailedProduct.Name != null) {
                if (productName == null)
                  productName = detailedProduct.Name;
                if (productImg == null)
                  productImg = detailedProduct.productImg;
                break;
              }
            }
          }

          // Crear un mapa con la información combinada
          final productMap = {
            'productid': product.productid,
            'name':
                productName ??
                'Producto #${auction.id.substring(0, 6)}',
            'price': product.Price,
            'description': product.Description,
            'productimg': productImg,
          };

          // Crear subasta actualizada
          final updatedAuction = Auction(
            id: auction.id,
            productId: auction.productId,
            ownerId: auction.ownerId,
            startDate: auction.startDate,
            endDate: auction.endDate,
            initialPrice: auction.initialPrice,
            currentPrice: auction.currentPrice,
            product: productMap,
            owner: auction.owner,
          );

          updatedAuctions.add(updatedAuction);

          if (kDebugMode) {
            print(
              '✅ Subasta ${auction.id} actualizada con producto: ${productMap['name']}',
            );
          }
        } else {
          // Si no encontramos el producto, usar la subasta original con un nombre genérico
          final productMap =
              auction.product ??
              {
                'name':
                    'Subasta #${auction.id.substring(0, 8)}',
                'productid': auction.productId,
              };

          final updatedAuction = Auction(
            id: auction.id,
            productId: auction.productId,
            ownerId: auction.ownerId,
            startDate: auction.startDate,
            endDate: auction.endDate,
            initialPrice: auction.initialPrice,
            currentPrice: auction.currentPrice,
            product: productMap,
            owner: auction.owner,
          );

          updatedAuctions.add(updatedAuction);

          if (kDebugMode) {
            print(
              '⚠️ No se encontró producto para la subasta ${auction.id}',
            );
          }
        }
      }

      return updatedAuctions;
    } catch (e) {
      if (kDebugMode) {
        print(
          '❌ Error general al cargar productos para subastas: $e',
        );
      }
      // En caso de error, devolver las subastas originales
      return auctions;
    }
  }

  // Obtener subasta por ID
  Future<Auction> getAuctionById(String auctionId) async {
    try {
      final response = await http.get(
        Uri.parse(AppConfig.getAuctionUrl(auctionId)),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        return Auction.fromJson(json.decode(response.body));
      } else {
        throw Exception(
          'Error al obtener subasta: ${response.body}',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error al obtener subasta: $e');
      }
      rethrow;
    }
  }

  // Método privado para obtener headers con el token de autenticación
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Crear una nueva subasta
  Future<Auction> createAuction(Auction auction) async {
    try {
      // Creamos un objeto con solo los campos que el backend espera
      final requestData = {
        'product_id': auction.productId,
        'start_date': auction.startDate.toIso8601String(),
        'end_date': auction.endDate.toIso8601String(),
        'initial_price': auction.initialPrice,
        'current_price':
            auction.currentPrice ?? auction.initialPrice,
      };

      if (kDebugMode) {
        print(
          '📤 Enviando datos de subasta al backend: $requestData',
        );
      }

      final response = await http.post(
        Uri.parse(AppConfig.createAuctionUrl),
        headers: await _getHeaders(),
        body: json.encode(requestData),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (kDebugMode) {
          print('📥 Respuesta del backend: $responseData');
        }
        return Auction.fromJson(responseData);
      } else {
        if (kDebugMode) {
          print(
            '❌ Error del servidor: ${response.statusCode} - ${response.body}',
          );
        }
        throw Exception(
          'Error al crear subasta: ${response.body}',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error al crear subasta: $e');
      }
      rethrow;
    }
  }

  // Realizar una puja en una subasta
  Future<AuctionBid> placeBid(AuctionBid bid) async {
    try {
      if (kDebugMode) {
        print('📤 Enviando puja: ${bid.toJson()}');
      }

      final response = await http.post(
        Uri.parse(AppConfig.createBidUrl),
        headers: await _getHeaders(),
        body: json.encode(bid.toJson()),
      );

      if (kDebugMode) {
        print(
          '📥 Respuesta puja - Status: ${response.statusCode}',
        );
        print('📥 Respuesta puja - Body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return AuctionBid.fromJson(responseData);
      } else {
        // ✨ MEJORADO: Manejo de errores más específico
        final errorBody = response.body;
        String errorMessage = 'Error al realizar puja';

        try {
          final errorData = json.decode(errorBody);
          if (errorData['detail'] != null) {
            if (errorData['detail'] is String) {
              errorMessage = errorData['detail'];
            } else if (errorData['detail'] is List) {
              // Manejar errores de validación
              final details = errorData['detail'] as List;
              errorMessage = details
                  .map((e) => e['msg'] ?? e.toString())
                  .join(', ');
            }
          }
        } catch (e) {
          errorMessage =
              'Error: ${response.statusCode} - $errorBody';
        }

        throw Exception(errorMessage);
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error al realizar puja: $e');
      }
      rethrow;
    }
  }

  // Obtener pujas para una subasta específica
  Future<List<AuctionBid>> getBidsForAuction(
    String auctionId,
  ) async {
    try {
      if (kDebugMode) {
        print(
          '🔍 Obteniendo pujas para subasta: $auctionId',
        );
      }

      // Según la documentación, /bids devuelve todas las pujas
      final response = await http.get(
        Uri.parse(AppConfig.bidsUrl),
        headers: await _getHeaders(),
      );

      if (kDebugMode) {
        print(
          '📥 Respuesta bids - Status: ${response.statusCode}',
        );
        print(
          '📥 Respuesta bids - Body: ${response.body.substring(0, min(500, response.body.length))}...',
        );
      }

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(
          response.body,
        );

        //  FILTRAR del lado del cliente las pujas de esta subasta específica
        final allBids =
            data
                .map((json) => AuctionBid.fromJson(json))
                .toList();
        final auctionBids =
            allBids
                .where((bid) => bid.auctionId == auctionId)
                .toList();

        //  ORDENAR por monto de puja (mayor a menor) para mostrar la puja ganadora primero
        auctionBids.sort(
          (a, b) => b.bidAmount.compareTo(a.bidAmount),
        );

        if (kDebugMode) {
          print(
            '📦 Total pujas obtenidas: ${allBids.length}',
          );
          print(
            '📦 Pujas para esta subasta: ${auctionBids.length}',
          );
        }

        return auctionBids;
      } else {
        throw Exception(
          'Error al obtener pujas: ${response.body}',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error al obtener pujas: $e');
      }
      rethrow;
    }
  }

  // Método para obtener una puja específica por ID
  Future<AuctionBid> getBidById(String bidId) async {
    try {
      if (kDebugMode) {
        print('🔍 Obteniendo puja por ID: $bidId');
      }

      final response = await http.get(
        Uri.parse(AppConfig.getBidUrl(bidId)),
        headers: await _getHeaders(),
      );

      if (kDebugMode) {
        print(
          '📥 Respuesta bid por ID - Status: ${response.statusCode}',
        );
      }

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return AuctionBid.fromJson(responseData);
      } else {
        throw Exception(
          'Error al obtener puja: ${response.body}',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error al obtener puja por ID: $e');
      }
      rethrow;
    }
  }

  //  Método para validar una puja antes de enviarla
  bool validateBid(int bidAmount, int currentPrice) {
    return bidAmount > currentPrice;
  }

  //  Método para obtener el precio mínimo de puja (precio actual + incremento mínimo)
  int getMinimumBidAmount(
    int currentPrice, {
    int minimumIncrement = 1000,
  }) {
    return currentPrice + minimumIncrement;
  }

  // Verificar si una subasta puede recibir pujas
  bool canPlaceBid(Auction auction) {
    return auction.isActive && !auction.hasEnded;
  }
}
