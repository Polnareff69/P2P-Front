import 'package:flutter/foundation.dart';
import 'dart:io';

class AppConfig {
  //  **MODO DE DESARROLLO**
  static const bool _isDebugMode = kDebugMode;

  //  **CAMBIAR ESTO PARA FORZAR PRODUCCIÓN EN DEBUG**
  static const bool _forceProduction = false;

  //  **DETECTAR AUTOMÁTICAMENTE EL ENTORNO**
  static bool get _isProduction {
    // Si estamos en release mode, siempre usar producción
    if (!_isDebugMode) return true;

    // Si forzamos producción, usar producción
    if (_forceProduction) return true;

    // En debug mode, usar local por defecto
    return false;
  }

  //  **URL INTELIGENTE SEGÚN EL DISPOSITIVO**
  static String get _baseUrl {
    if (_isProduction) {
      return 'http://13.219.156.170:8000';
    } else {
      // Para desarrollo local
      if (Platform.isAndroid) {
        return kIsWeb
            ? 'http://localhost:8000'
            : 'http://10.0.2.2:8000';
      } else if (Platform.isIOS) {
        return 'http://localhost:8000';
      } else {
        return 'http://localhost:8000';
      }
    }
  }

  // 🔗 **TODAS LAS URLs**
  static String get registerUrl => '$_baseUrl/register';
  static String get loginUrl => '$_baseUrl/token';
  static String get createCompanyUrl => '$_baseUrl/company';
  static String get getAllCompaniesUrl =>
      '$_baseUrl/compnay/all';

  // ✨ NUEVO: URL para obtener empresa por ID
  static String getCompanyByIdUrl(String companyId) =>
      '$_baseUrl/company/$companyId';

  static String getCompanyProductsUrl(String companyId) =>
      '$_baseUrl/company/products/$companyId';
  static String uploadProductUrl(String companyId) =>
      '$_baseUrl/product/$companyId';
  static String getProductImageUrl() =>
      '$_baseUrl/ProductImg';

  // 🛠️ **CONFIGURACIONES**
  static const int timeoutSeconds = 10;

  // 🔍 **FUNCIONES ÚTILES**
  static void printConfig() {
    print('🚀 ===============================');
    print('🚀 CONFIGURACIÓN ACTUAL');
    print('🚀 Modo: ${_isDebugMode ? "DEBUG" : "RELEASE"}');
    print(
      '🚀 Entorno: ${_isProduction ? "PRODUCCIÓN (AWS)" : "DESARROLLO (LOCAL)"}',
    );
    print('🚀 Base URL: $_baseUrl');
    print('🚀 ===============================');
  }

  // **PARA DEBUGGING**
  static String get environmentStatus {
    return '${_isProduction ? "PROD" : "DEV"} | ${_isDebugMode ? "DEBUG" : "RELEASE"}';
  }
}

/*
¿Cómo usar esta solución?

Para desarrollo:
--- En debug mode, automáticamente usa local
--- No es necesario cambiar nada - ¡es inteligente!

Para producción [AWS]:
--- Cambiar solo esta línea cuando se quiera forzar producción en debug:
--> static const bool _forceProduction = true; <---

Para release:
--- Automáticamente usa producción - no es necesario cambiar nada
flutter build apk --release

*/
