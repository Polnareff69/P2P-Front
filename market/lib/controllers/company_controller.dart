import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/company_model.dart';
import 'package:market/config/app_config.dart'; // configuracion de peticiones
import 'package:flutter/foundation.dart';

class CompanyController {
  // ✨ NUEVO: Método para obtener información del usuario actual desde el token
  Future<Map<String, dynamic>?> getCurrentUserInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) return null;

      // Decodificar el token JWT manualmente para obtener la información del usuario
      final parts = token.split('.');
      if (parts.length != 3) return null;

      // Decodificar la parte del payload (segunda parte del JWT)
      final payload = parts[1];
      // Agregar padding si es necesario
      final normalizedPayload = payload.padRight(
        (payload.length + 3) ~/ 4 * 4,
        '=',
      );

      try {
        final decoded = utf8.decode(
          base64Url.decode(normalizedPayload),
        );
        final userInfo = json.decode(decoded);

        if (kDebugMode) {
          print(
            '👤 Información del usuario actual desde token:',
          );
          print('   Username: ${userInfo['sub']}');
          print('   Email: ${userInfo['email']}');
          print('   Role: ${userInfo['Role']}');
        }

        return userInfo;
      } catch (e) {
        if (kDebugMode)
          print('❌ Error decodificando token: $e');
        return null;
      }
    } catch (e) {
      if (kDebugMode)
        print('❌ Error obteniendo info del usuario: $e');
      return null;
    }
  }

  // ✨ NUEVO: Método para obtener el UserId completo desde otro endpoint
  Future<String?> getCurrentUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) return null;

      // Intentar obtener el UserId desde un endpoint que devuelva info del usuario actual
      // Como no tenemos un endpoint específico, vamos a extraerlo del token
      final userInfo = await getCurrentUserInfo();

      // El token JWT puede contener el UserId en diferentes campos
      final userId =
          userInfo?['sub'] ??
          userInfo?['userId'] ??
          userInfo?['id'];

      if (kDebugMode)
        print('🆔 UserId desde token: $userId');

      return userId as String?;
    } catch (e) {
      if (kDebugMode)
        print('❌ Error obteniendo UserId: $e');
      return null;
    }
  }

  // Método para obtener todas las empresas
  Future<List<Company>> getAllCompanies() async {
    try {
      // Recuperar el token de SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      final response = await http.get(
        Uri.parse(AppConfig.getAllCompaniesUrl),
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
        final companies =
            data
                .map((item) => Company.fromJson(item))
                .toList();

        if (kDebugMode) {
          print(
            '📊 Total empresas obtenidas: ${companies.length}',
          );
          for (int i = 0; i < companies.length; i++) {
            final company = companies[i];
            print(
              '   [$i] ${company.name} (ID: ${company.companyId}, UserId: ${company.userId})',
            );
          }
        }

        return companies;
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

  // ✨ NUEVO: Método inteligente para filtrar empresas del usuario actual
  Future<List<Company>> getUserCompanies() async {
    try {
      final allCompanies = await getAllCompanies();
      final userInfo = await getCurrentUserInfo();

      if (userInfo == null) {
        if (kDebugMode)
          print(
            '⚠️ No se pudo obtener información del usuario, devolviendo todas las empresas',
          );
        return allCompanies;
      }

      final currentUsername = userInfo['sub'] as String?;
      final currentEmail = userInfo['email'] as String?;

      if (kDebugMode) {
        print(
          '🔍 Filtrando empresas para usuario: $currentUsername ($currentEmail)',
        );
      }

      // Estrategia 1: Si el backend ya está filtrando por usuario (ideal)
      // En este caso, getAllCompanies ya devuelve solo las empresas del usuario
      if (allCompanies.length <= 3) {
        // Asumiendo que un usuario no tiene muchas empresas
        if (kDebugMode)
          print(
            '✅ Pocas empresas detectadas, posiblemente ya filtradas por el backend',
          );
        return allCompanies;
      }

      // Estrategia 2: Filtrar por criterios inteligentes
      List<Company> userCompanies = [];

      // Intentar asociar por nombre de usuario o email
      for (final company in allCompanies) {
        // Verificar si el owner name coincide con el username o email
        bool matchesUser = false;

        // Obtener detalles de la empresa para verificar el owner
        try {
          final details = await getCompanyById(
            company.companyId,
          );
          if (details != null &&
              details.owner.name.isNotEmpty) {
            final ownerName =
                details.owner.name.toLowerCase();
            final ownerEmail =
                details.owner.email.toLowerCase();

            if (currentUsername != null &&
                ownerName.contains(
                  currentUsername.toLowerCase(),
                )) {
              matchesUser = true;
            } else if (currentEmail != null &&
                ownerEmail.contains(
                  currentEmail.toLowerCase(),
                )) {
              matchesUser = true;
            }
          }
        } catch (e) {
          if (kDebugMode)
            print(
              '❌ Error verificando owner para empresa ${company.name}: $e',
            );
        }

        if (matchesUser) {
          userCompanies.add(company);
        }
      }

      // Si no encontramos matches por owner, usar criterios alternativos
      if (userCompanies.isEmpty) {
        if (kDebugMode)
          print(
            '⚠️ No se encontraron empresas por owner, aplicando filtros alternativos...',
          );

        // Filtrar empresas que no sean de prueba
        userCompanies =
            allCompanies.where((company) {
              return company.name != null &&
                  company.name!.toLowerCase() != 'string' &&
                  company.name!.toLowerCase() != 'test' &&
                  company.name!.toLowerCase() != 'demo' &&
                  company.name!.isNotEmpty &&
                  company.name!.length > 1;
            }).toList();

        if (kDebugMode)
          print(
            '🔧 Empresas después de filtrar pruebas: ${userCompanies.length}',
          );
      }

      if (kDebugMode) {
        print(
          '✅ Empresas del usuario encontradas: ${userCompanies.length}',
        );
        for (final company in userCompanies) {
          print(
            '   - ${company.name} (ID: ${company.companyId})',
          );
        }
      }

      return userCompanies.isNotEmpty
          ? userCompanies
          : allCompanies.take(1).toList();
    } catch (e) {
      if (kDebugMode)
        print('❌ Error filtrando empresas del usuario: $e');
      return await getAllCompanies();
    }
  }

  // Método para guardar el ID de la empresa seleccionada
  Future<void> saveSelectedCompany(String companyId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('company_id', companyId);
      if (kDebugMode)
        print('✅ ID de empresa guardado: $companyId');
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

  // Método para obtener empresa por ID
  Future<CompanyDetails?> getCompanyById(
    String companyId,
  ) async {
    try {
      if (kDebugMode)
        print('🏢 Obteniendo empresa por ID: $companyId');

      // Recuperar el token de SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      final response = await http.get(
        Uri.parse(AppConfig.getCompanyByIdUrl(companyId)),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (token != null)
            'Authorization': 'Bearer $token',
        },
      );

      if (kDebugMode) {
        print('📡 Status: ${response.statusCode}');
        print('📡 Response body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(
          response.body,
        );
        return CompanyDetails.fromJson(data);
      } else {
        print(
          'Error al obtener empresa: ${response.statusCode}',
        );
        print('Respuesta: ${response.body}');
        throw Exception(
          'Error al obtener empresa: Código ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error en getCompanyById: $e');
      throw Exception('No se pudo obtener la empresa: $e');
    }
  }

  // Método más inteligente para obtener empresa actual
  Future<CompanyDetails?> getCurrentCompanyDetails() async {
    try {
      // 1. Primero intentar obtener de cache
      String? companyId = await getSelectedCompanyId();

      if (companyId != null && companyId.isNotEmpty) {
        if (kDebugMode)
          print(
            '🏢 CompanyId encontrado en cache: $companyId',
          );
        return await getCompanyById(companyId);
      }

      // 2. Si no hay en cache, obtener automáticamente
      if (kDebugMode)
        print(
          '⚠️ No se encontró CompanyId guardado, obteniendo automáticamente...',
        );
      companyId = await getCurrentSellerCompanyId();

      if (companyId != null) {
        return await getCompanyById(companyId);
      }

      return null;
    } catch (e) {
      print('Error obteniendo empresa actual: $e');
      return null;
    }
  }

  // ✨ MEJORADO: Método inteligente para obtener CompanyId del seller actual
  Future<String?> getCurrentSellerCompanyId() async {
    try {
      if (kDebugMode)
        print(
          '🔍 Obteniendo CompanyId del seller actual...',
        );

      // Obtener información del usuario actual
      final userInfo = await getCurrentUserInfo();
      if (userInfo == null) {
        throw Exception(
          'No se pudo obtener información del usuario actual',
        );
      }

      final currentRole = userInfo['Role'] as String?;
      if (currentRole != 'seller') {
        throw Exception(
          'El usuario actual no es un seller (Role: $currentRole)',
        );
      }

      // Obtener empresas filtradas del usuario
      final companies = await getUserCompanies();

      if (companies.isEmpty) {
        if (kDebugMode)
          print('⚠️ El seller no tiene empresas');
        return null;
      }

      // ✨ LÓGICA INTELIGENTE para seleccionar la empresa correcta:
      Company? bestCompany;

      // 1. Si hay solo una empresa, usarla
      if (companies.length == 1) {
        bestCompany = companies.first;
        if (kDebugMode)
          print(
            '✅ Solo una empresa disponible: ${bestCompany.name}',
          );
      } else {
        // 2. Si hay múltiples empresas, aplicar criterios

        // Primero, eliminar empresas obviamente de prueba
        final validCompanies =
            companies.where((company) {
              return company.name != null &&
                  company.name!.toLowerCase() != 'string' &&
                  company.name!.toLowerCase() != 'test' &&
                  company.name!.toLowerCase() != 'demo' &&
                  company.name!.isNotEmpty &&
                  company.name!.trim().length > 1;
            }).toList();

        if (validCompanies.isNotEmpty) {
          bestCompany = validCompanies.first;
          if (kDebugMode)
            print(
              '✅ Empresa válida seleccionada: ${bestCompany.name}',
            );
        } else {
          // Como último recurso, tomar cualquier empresa
          bestCompany = companies.first;
          if (kDebugMode)
            print(
              '⚠️ Usando empresa por defecto: ${bestCompany.name}',
            );
        }
      }

      if (bestCompany != null) {
        if (kDebugMode) {
          print(
            '✅ CompanyId seleccionado: ${bestCompany.companyId}',
          );
          print('   Nombre: ${bestCompany.name}');
          print(
            '   Total empresas consideradas: ${companies.length}',
          );
        }

        // Guardar automáticamente como empresa seleccionada
        await saveSelectedCompany(bestCompany.companyId);

        return bestCompany.companyId;
      }

      return null;
    } catch (e) {
      if (kDebugMode)
        print(
          '❌ Error obteniendo CompanyId del seller: $e',
        );
      return null;
    }
  }

  // ✨ NUEVO: Método para refresh forzado de datos de empresa
  Future<CompanyDetails?> refreshCurrentCompany() async {
    try {
      if (kDebugMode)
        print('🔄 Refrescando datos de empresa...');

      // Limpiar cache actual
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('company_id');

      // Obtener datos frescos
      return await getCurrentCompanyDetails();
    } catch (e) {
      if (kDebugMode)
        print('❌ Error refrescando empresa: $e');
      return null;
    }
  }
}
