import 'package:flutter/material.dart';
import 'package:market/services/auth_service.dart';
import 'package:market/helpers/navigation_helper.dart';
import 'package:flutter/foundation.dart';

/// Middleware para rutas que requieren autenticación
class AuthGuard {
  /// Verificar autenticación antes de renderizar un widget
  static Widget checkAuth({
    required Widget widget,
    required BuildContext context,
    bool requireAuth = true,
    List<String>? allowedRoles,
    Widget? fallbackWidget,
  }) {
    return FutureBuilder<bool>(
      future: _checkAccess(context, requireAuth: requireAuth, allowedRoles: allowedRoles),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingScreen();
        }

        if (snapshot.hasData && snapshot.data == true) {
          return widget;
        }

        // Retornar widget de fallback o redirigir al login
        if (fallbackWidget != null) {
          return fallbackWidget;
        }

        // Redirigir automáticamente al login si no está autenticado
        WidgetsBinding.instance.addPostFrameCallback((_) {
          NavigationHelper.navigateToLogin(context);
        });

        return _buildUnauthorizedScreen();
      },
    );
  }

  /// Verificar acceso basado en autenticación y roles
  static Future<bool> _checkAccess(
    BuildContext context, {
    bool requireAuth = true,
    List<String>? allowedRoles,
  }) async {
    try {
      if (kDebugMode) print('🔐 AuthGuard - Verificando acceso...');
      
      // Si no requiere autenticación, permitir acceso
      if (!requireAuth) {
        if (kDebugMode) print('✅ Ruta pública, acceso permitido');
        return true;
      }

      // Inicializar AuthService si no está inicializado
      if (!AuthService.instance.isInitialized) {
        if (kDebugMode) print('🔄 Inicializando AuthService...');
        await AuthService.instance.initialize();
      }

      // Verificar si está logueado
      final bool isLoggedIn = AuthService.instance.isLoggedIn;
      if (!isLoggedIn) {
        if (kDebugMode) print('❌ Usuario no autenticado');
        return false;
      }

      // Verificar roles si se especificaron
      if (allowedRoles != null && allowedRoles.isNotEmpty) {
        final String? currentRole = AuthService.instance.currentRole;
        final bool hasValidRole = allowedRoles.any(
          (role) => role.toLowerCase() == currentRole?.toLowerCase(),
        );
        
        if (!hasValidRole) {
          if (kDebugMode) {
            print('❌ Rol insuficiente. Actual: $currentRole, Requeridos: $allowedRoles');
          }
          return false;
        }
      }

      if (kDebugMode) print('✅ Acceso permitido');
      return true;
    } catch (e) {
      if (kDebugMode) print('❌ Error verificando acceso: $e');
      return false;
    }
  }

  /// Widget de carga mientras se verifica la autenticación
  static Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Colors.purple,
              strokeWidth: 3,
            ),
            SizedBox(height: 24),
            Text(
              'Verificando autenticación...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget mostrado cuando no está autorizado
  static Widget _buildUnauthorizedScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock,
              size: 80,
              color: Colors.red.shade300,
            ),
            SizedBox(height: 24),
            Text(
              'Acceso no autorizado',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Por favor, inicia sesión para continuar',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget wrapper para aplicar AuthGuard fácilmente
class AuthGuardWrapper extends StatelessWidget {
  final Widget child;
  final bool requireAuth;
  final List<String>? allowedRoles;
  final Widget? fallbackWidget;

  const AuthGuardWrapper({
    super.key,
    required this.child,
    this.requireAuth = true,
    this.allowedRoles,
    this.fallbackWidget,
  });

  @override
  Widget build(BuildContext context) {
    return AuthGuard.checkAuth(
      widget: child,
      context: context,
      requireAuth: requireAuth,
      allowedRoles: allowedRoles,
      fallbackWidget: fallbackWidget,
    );
  }
}

/// Mixin para añadir funcionalidad de verificación de auth a widgets
mixin AuthMixin<T extends StatefulWidget> on State<T> {
  /// Verificar autenticación en initState
  Future<void> checkAuthOnInit() async {
    if (!AuthService.instance.isInitialized) {
      await AuthService.instance.initialize();
    }

    if (!AuthService.instance.isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        NavigationHelper.navigateToLogin(context);
      });
    }
  }

  /// Verificar si el usuario actual tiene un rol específico
  bool hasRole(String role) {
    return AuthService.instance.hasRole(role);
  }

  /// Obtener el rol actual del usuario
  String? getCurrentRole() {
    return AuthService.instance.currentRole;
  }

  /// Mostrar diálogo si el usuario no tiene permisos
  void showInsufficientPermissionsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF121212),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.warning, color: Colors.orange, size: 24),
              SizedBox(width: 8),
              Text(
                'Permisos Insuficientes',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          content: Text(
            'No tienes permisos para realizar esta acción.',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Entendido',
                style: TextStyle(color: Colors.purple),
              ),
            ),
          ],
        );
      },
    );
  }
}