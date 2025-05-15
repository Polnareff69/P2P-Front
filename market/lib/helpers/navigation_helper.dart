import 'package:flutter/material.dart';
import 'package:market/services/auth_service.dart';
import 'package:market/views/business_screens/vendor_screen.dart';
import 'package:market/views/client_screen/user_screen.dart';
import 'package:market/views/authentication_screens/welcome_screen.dart';
import 'package:market/utils/constants.dart';
import 'package:flutter/foundation.dart';

/// Helper centralizado para manejar la navegación en la aplicación
class NavigationHelper {
  // Instancia singleton
  static final NavigationHelper _instance = NavigationHelper._internal();
  factory NavigationHelper() => _instance;
  NavigationHelper._internal();

  /// Navegar al perfil basado en el rol del usuario actual
  static Future<void> navigateToProfile(BuildContext context) async {
    try {
      if (kDebugMode) print('🔍 NavigationHelper - Navegando al perfil...');
      
      // Verificar autenticación
      if (!AuthService.instance.isInitialized) {
        if (kDebugMode) print('⚠️ AuthService no inicializado, esperando...');
        await AuthService.instance.initialize();
      }

      if (!AuthService.instance.isLoggedIn) {
        if (kDebugMode) print('⚠️ Usuario no autenticado');
        await _handleUserNotLoggedIn(context);
        return;
      }

      // Verificar rol y navegar
      final String? username = AuthService.instance.currentUsername;
      final String? role = AuthService.instance.currentRole;
      
      if (kDebugMode) {
        print('👤 Usuario: $username');
        print('🎭 Rol: $role');
      }

      switch (role?.toLowerCase()) {
        case AppConstants.sellerRole:
          await _navigateToVendorScreen(context);
          break;
        case AppConstants.userRole:
          await _navigateToUserScreen(context, username);
          break;
        default:
          if (kDebugMode) print('❓ Rol desconocido: $role');
          await _handleUnknownRole(context);
      }
    } catch (e) {
      if (kDebugMode) print('❌ Error en navegación al perfil: $e');
      _showNavigationError(context, 'Error al navegar al perfil');
    }
  }

  /// Navegar a VendorScreen
  static Future<void> _navigateToVendorScreen(BuildContext context) async {
    if (kDebugMode) print('🏪 Navegando a VendorScreen');
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VendorScreen(),
      ),
    );
  }

  /// Navegar a UserScreen
  static Future<void> _navigateToUserScreen(BuildContext context, String? username) async {
    if (kDebugMode) print('👤 Navegando a UserScreen');
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserScreen(
          userName: username ?? 'Usuario',
        ),
      ),
    );
  }

  /// Manejar usuario no logueado
  static Future<void> _handleUserNotLoggedIn(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF121212),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.purple.shade300, width: 2),
          ),
          title: Row(
            children: [
              Icon(Icons.login, color: Colors.purple, size: 24),
              SizedBox(width: 8),
              Text(
                'Sesión Requerida',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.account_circle_outlined,
                size: 60,
                color: Colors.purple.shade300,
              ),
              SizedBox(height: 16),
              Text(
                'Necesitas iniciar sesión para acceder a tu perfil.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancelar',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                navigateToLogin(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text('Iniciar Sesión'),
            ),
          ],
        );
      },
    );
  }

  /// Manejar rol desconocido
  static Future<void> _handleUnknownRole(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF121212),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.red.shade300, width: 2),
          ),
          title: Row(
            children: [
              Icon(Icons.error, color: Colors.red, size: 24),
              SizedBox(width: 8),
              Text(
                'Error de Rol',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.person_remove,
                size: 60,
                color: Colors.red.shade300,
              ),
              SizedBox(height: 16),
              Text(
                'Tu rol de usuario no es válido. Por favor, inicia sesión nuevamente.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await forceLogout(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text('Cerrar Sesión'),
            ),
          ],
        );
      },
    );
  }

  /// Navegar a la pantalla de login
  static void navigateToLogin(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const WelcomeScreen(),
      ),
      (route) => false,
    );
  }

  /// Forzar logout y navegar al login
  static Future<void> forceLogout(BuildContext context) async {
    try {
      if (kDebugMode) print('🚪 Forzando logout...');
      await AuthService.instance.logout();
      navigateToLogin(context);
    } catch (e) {
      if (kDebugMode) print('❌ Error en force logout: $e');
      // Navegar a login incluso si hay error
      navigateToLogin(context);
    }
  }

  /// Mostrar error de navegación
  static void _showNavigationError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error, color: Colors.white),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Reintentar',
          textColor: Colors.white,
          onPressed: () => navigateToProfile(context),
        ),
      ),
    );
  }

  /// Verificar autenticación antes de navegar a rutas protegidas
  static Future<bool> checkAuthenticationForRoute(BuildContext context, {bool showDialog = true}) async {
    if (!AuthService.instance.isInitialized) {
      await AuthService.instance.initialize();
    }

    final bool isLoggedIn = AuthService.instance.isLoggedIn;
    
    if (!isLoggedIn && showDialog) {
      _handleUserNotLoggedIn(context);
    }
    
    return isLoggedIn;
  }

  /// Navegar con verificación de autenticación
  static Future<void> navigateWithAuth(
    BuildContext context,
    Widget destination, {
    bool requireAuth = true,
  }) async {
    if (requireAuth) {
      final bool isAuthenticated = await checkAuthenticationForRoute(context);
      if (!isAuthenticated) return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => destination),
    );
  }

  /// Reemplazar la pantalla actual con una nueva
  static void replaceWith(BuildContext context, Widget destination) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => destination),
    );
  }

  /// Navegar y limpiar el stack de navegación
  static void navigateAndClearStack(BuildContext context, Widget destination) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => destination),
      (route) => false,
    );
  }

  /// Mostrar mensaje de éxito
  static void showSuccessMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text(message, style: TextStyle(color: Colors.white)),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  /// Mostrar mensaje de error
  static void showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error, color: Colors.white),
            SizedBox(width: 8),
            Expanded(
              child: Text(message, style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}