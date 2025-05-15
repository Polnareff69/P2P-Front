import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter/foundation.dart';
import 'package:market/utils/constants.dart';

class AuthService {
  // 🏗️ Singleton pattern
  static final AuthService _instance =
      AuthService._internal();
  static AuthService get instance => _instance;
  AuthService._internal();

  // 📊 Variables de estado
  String? _currentToken;
  String? _currentRole;
  String? _currentEmail;
  String? _currentUsername;
  bool _isInitialized = false;

  // 📖 Getters públicos
  String? get currentToken => _currentToken;
  String? get currentRole => _currentRole;
  String? get currentEmail => _currentEmail;
  String? get currentUsername => _currentUsername;
  bool get isLoggedIn =>
      _currentToken != null && !isTokenExpired();
  bool get isSeller =>
      _currentRole?.toLowerCase() ==
      AppConstants.sellerRole;
  bool get isUser =>
      _currentRole?.toLowerCase() == AppConstants.userRole;
  bool get isInitialized => _isInitialized;

  // 🚀 INICIALIZAR AL ABRIR LA APP
  Future<void> initialize() async {
    try {
      if (kDebugMode)
        print('🔄 Inicializando AuthService...');

      await _loadUserData();
      _isInitialized = true;

      if (kDebugMode) {
        print('✅ AuthService inicializado exitosamente');
        print('   Estado: ${getUserInfo()}');
      }
    } catch (e) {
      if (kDebugMode)
        print('❌ Error inicializando AuthService: $e');
      _isInitialized =
          true; // Marcar como inicializado aunque haya error
    }
  }

  // 💾 GUARDAR TOKEN (usado por login y register)
  Future<void> saveToken(String token) async {
    try {
      if (kDebugMode) print('💾 Guardando token...');

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.tokenKey, token);
      _currentToken = token;

      // Decodificar y guardar información del usuario
      await _decodeAndSaveUserInfo(token);

      if (kDebugMode)
        print('✅ Token guardado exitosamente');
    } catch (e) {
      if (kDebugMode) print('❌ Error guardando token: $e');
      rethrow;
    }
  }

  // 🔍 DECODIFICAR TOKEN Y GUARDAR INFO DEL USUARIO
  Future<void> _decodeAndSaveUserInfo(String token) async {
    try {
      if (kDebugMode) print('🔍 Decodificando token...');

      final decodedToken = JwtDecoder.decode(token);
      final prefs = await SharedPreferences.getInstance();

      // Extraer información del token
      _currentRole = decodedToken['Role'] ?? '';
      _currentEmail = decodedToken['email'] ?? '';
      _currentUsername = decodedToken['sub'] ?? '';

      // Guardar en SharedPreferences
      await prefs.setString(
        AppConstants.userRoleKey,
        _currentRole!,
      );
      await prefs.setString(
        AppConstants.userEmailKey,
        _currentEmail!,
      );
      await prefs.setString(
        AppConstants.usernameKey,
        _currentUsername!,
      );

      if (kDebugMode) {
        print('📄 Token decodificado exitosamente:');
        print('   Username: $_currentUsername');
        print('   Role: $_currentRole');
        print('   Email: $_currentEmail');
      }
    } catch (e) {
      if (kDebugMode)
        print('❌ Error decodificando token: $e');
      // En caso de error, limpiar datos
      await logout();
      rethrow;
    }
  }

  // 📱 CARGAR DATOS GUARDADOS AL INICIAR
  Future<void> _loadUserData() async {
    try {
      if (kDebugMode)
        print('📱 Cargando datos guardados...');

      final prefs = await SharedPreferences.getInstance();

      _currentToken = prefs.getString(
        AppConstants.tokenKey,
      );
      _currentRole = prefs.getString(
        AppConstants.userRoleKey,
      );
      _currentEmail = prefs.getString(
        AppConstants.userEmailKey,
      );
      _currentUsername = prefs.getString(
        AppConstants.usernameKey,
      );

      // Verificar si el token existe pero está expirado
      if (_currentToken != null && isTokenExpired()) {
        if (kDebugMode)
          print('⚠️ Token expirado, limpiando datos');
        await logout();
      } else if (_currentToken != null) {
        if (kDebugMode)
          print('✅ Usuario logueado encontrado');
      } else {
        if (kDebugMode) print('ℹ️ No hay usuario logueado');
      }
    } catch (e) {
      if (kDebugMode) print('❌ Error cargando datos: $e');
      // En caso de error, limpiar todo
      await _clearLocalData();
    }
  }

  // ⏰ VERIFICAR SI EL TOKEN EXPIRÓ
  bool isTokenExpired() {
    if (_currentToken == null) return true;

    try {
      return JwtDecoder.isExpired(_currentToken!);
    } catch (e) {
      if (kDebugMode)
        print('❌ Error verificando expiración: $e');
      return true;
    }
  }

  // 🚪 LOGOUT COMPLETO Y SEGURO
  Future<void> logout() async {
    try {
      if (kDebugMode) print('🚪 Cerrando sesión...');

      await _clearLocalData();

      if (kDebugMode) print('✅ Logout exitoso');
    } catch (e) {
      if (kDebugMode) print('❌ Error en logout: $e');
      // Intentar limpiar variables locales aunque falle SharedPreferences
      _clearVariables();
    }
  }

  // 🧹 LIMPIAR TODOS LOS DATOS
  Future<void> _clearLocalData() async {
    final prefs = await SharedPreferences.getInstance();

    // Limpiar SharedPreferences
    await prefs.remove(AppConstants.tokenKey);
    await prefs.remove(AppConstants.userRoleKey);
    await prefs.remove(AppConstants.userEmailKey);
    await prefs.remove(AppConstants.usernameKey);
    await prefs.remove(AppConstants.companyIdKey);

    // Limpiar variables locales
    _clearVariables();
  }

  // 🔄 LIMPIAR VARIABLES LOCALES
  void _clearVariables() {
    _currentToken = null;
    _currentRole = null;
    _currentEmail = null;
    _currentUsername = null;
  }

  // 📊 OBTENER INFORMACIÓN COMPLETA DEL USUARIO
  Map<String, dynamic> getUserInfo() {
    return {
      'isLoggedIn': isLoggedIn,
      'username': _currentUsername,
      'email': _currentEmail,
      'role': _currentRole,
      'isSeller': isSeller,
      'isUser': isUser,
      'tokenExists': _currentToken != null,
      'tokenExpired':
          _currentToken != null ? isTokenExpired() : null,
      'isInitialized': _isInitialized,
    };
  }

  // 🔄 REFRESCAR TOKEN (para implementar en el futuro con FastAPI)
  Future<bool> refreshToken() async {
    // TODO: Implementar refresh token con tu backend FastAPI
    if (kDebugMode)
      print('🔄 Refresh token - No implementado aún');
    return false;
  }

  // 🛡️ VALIDAR SI EL USUARIO TIENE PERMISOS
  bool hasRole(String role) {
    return _currentRole?.toLowerCase() ==
        role.toLowerCase();
  }

  /// Actualizar rol del usuario (útil cuando se crea una empresa)
  Future<void> updateUserRole(String newRole) async {
    try {
      if (kDebugMode)
        print(
          '🔄 Actualizando rol de $_currentRole a $newRole',
        );

      _currentRole = newRole;

      // Guardar en SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        AppConstants.userRoleKey,
        newRole,
      );

      if (kDebugMode) {
        print('✅ Rol actualizado exitosamente');
        print('   Nuevo rol: $_currentRole');
        print('   Es Seller? $isSeller');
        print('   Es User? $isUser');
      }
    } catch (e) {
      if (kDebugMode) print('❌ Error actualizando rol: $e');
      rethrow;
    }
  }

  /// Recargar datos del usuario desde SharedPreferences
  Future<void> reloadUserData() async {
    try {
      if (kDebugMode)
        print('🔄 Recargando datos del usuario...');
      await _loadUserData();
      if (kDebugMode) {
        print('✅ Datos del usuario recargados');
        printCurrentState();
      }
    } catch (e) {
      if (kDebugMode) print('❌ Error recargando datos: $e');
    }
  }

  // 📞 MÉTODOS AUXILIARES PARA DEBUGGING
  void printCurrentState() {
    if (kDebugMode) {
      print(
        '\n📊 ========== ESTADO ACTUAL DE AUTH ==========',
      );
      print(
        '🔐 Token: ${_currentToken != null ? "✅ Existe" : "❌ No existe"}',
      );
      print('👤 Usuario: $_currentUsername');
      print('📧 Email: $_currentEmail');
      print('🎭 Rol: $_currentRole');
      print('✅ Logueado: $isLoggedIn');
      print(
        '⏰ Token expirado: ${_currentToken != null ? isTokenExpired() : "N/A"}',
      );
      print('=========================================\n');
    }
  }
}
