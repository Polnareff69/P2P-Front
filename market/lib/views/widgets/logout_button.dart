import 'package:flutter/material.dart';
import 'package:market/services/auth_service.dart';
import 'package:market/views/authentication_screens/welcome_screen.dart';
import 'package:flutter/foundation.dart';

class LogoutButton extends StatelessWidget {
  final String buttonText;
  final IconData icon;
  final Color? color;
  final bool showConfirmDialog;
  final VoidCallback? onLogoutStart;
  final VoidCallback? onLogoutComplete;

  const LogoutButton({
    Key? key,
    this.buttonText = 'Cerrar Sesión',
    this.icon = Icons.logout,
    this.color,
    this.showConfirmDialog = true,
    this.onLogoutStart,
    this.onLogoutComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _handleLogout(context),
      icon: Icon(icon),
      label: Text(buttonText),
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? Colors.red,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    bool shouldLogout = true;

    // Mostrar diálogo de confirmación si está habilitado
    if (showConfirmDialog) {
      shouldLogout = await _showLogoutDialog(context);
    }

    if (shouldLogout) {
      await _performLogout(context);
    }
  }

  Future<bool> _showLogoutDialog(
    BuildContext context,
  ) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirmar Logout'),
              content: const Text(
                '¿Estás seguro de que deseas cerrar sesión?',
              ),
              actions: [
                TextButton(
                  onPressed:
                      () =>
                          Navigator.of(context).pop(false),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed:
                      () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Cerrar Sesión'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  Future<void> _performLogout(BuildContext context) async {
    try {
      if (kDebugMode)
        print(
          '🔍 INICIO _performLogout - Context válido: ${context.mounted}',
        );

      // Callback antes del logout
      onLogoutStart?.call();

      // Mostrar indicador de carga
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        );
      }

      // Obtener información del usuario antes del logout
      final username = AuthService.instance.currentUsername;
      final isLoggedIn = AuthService.instance.isLoggedIn;

      if (kDebugMode) {
        print(
          '🚪 Iniciando logout para usuario: $username',
        );
        print('🔍 ¿Está logueado? $isLoggedIn');
        AuthService.instance.printCurrentState();
      }

      // SOLO hacer logout si realmente está logueado
      if (isLoggedIn) {
        // Realizar logout
        await AuthService.instance.logout();

        if (kDebugMode) {
          print('✅ Logout completado exitosamente');
          AuthService.instance.printCurrentState();
        }
      } else {
        if (kDebugMode)
          print(
            '⚠️ El usuario ya no está logueado, solo navegando...',
          );
      }

      // Cerrar indicador de carga
      if (context.mounted) {
        Navigator.of(context).pop();
        if (kDebugMode)
          print('🔍 Indicador de carga cerrado');
      }

      // Mostrar mensaje de éxito
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '¡Adiós ${username ?? 'Usuario'}! Has cerrado sesión exitosamente.',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
        if (kDebugMode) print('🔍 SnackBar mostrado');
      }

      // FORZAR NAVEGACIÓN AL WELCOME SCREEN
      if (kDebugMode)
        print('🔍 Intentando navegar a WelcomeScreen...');

      if (context.mounted) {
        // Usar Navigator desde el context más alto posible
        Navigator.of(
          context,
          rootNavigator: true,
        ).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const WelcomeScreen(),
          ),
          (Route<dynamic> route) => false,
        );
        if (kDebugMode)
          print('✅ Navegación a WelcomeScreen exitosa');
      } else {
        if (kDebugMode)
          print('❌ Context no mounted, no se pudo navegar');
      }

      // Callback después del logout
      onLogoutComplete?.call();
    } catch (e) {
      if (kDebugMode) print('❌ Error en logout: $e');

      // Cerrar indicador de carga si está abierto
      if (context.mounted && Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }

      // Mostrar error
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cerrar sesión: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  // 🎯 MÉTODO ESTÁTICO PÚBLICO DENTRO DE LA CLASE
  static Future<void> performLogout(
    BuildContext context, {
    bool showConfirmDialog = true,
    VoidCallback? onLogoutStart,
    VoidCallback? onLogoutComplete,
  }) async {
    final logoutButton = LogoutButton(
      showConfirmDialog: showConfirmDialog,
      onLogoutStart: onLogoutStart,
      onLogoutComplete: onLogoutComplete,
    );

    await logoutButton._handleLogout(context);
  }
}

// 🎯 VERSION SIMPLE PARA APPBAR
class LogoutIconButton extends StatelessWidget {
  final VoidCallback? onLogoutStart;
  final VoidCallback? onLogoutComplete;

  const LogoutIconButton({
    Key? key,
    this.onLogoutStart,
    this.onLogoutComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _quickLogout(context),
      icon: const Icon(Icons.logout),
      tooltip: 'Cerrar Sesión',
    );
  }

  Future<void> _quickLogout(BuildContext context) async {
    final logout = LogoutButton(
      showConfirmDialog: false,
      onLogoutStart: onLogoutStart,
      onLogoutComplete: onLogoutComplete,
    );
    await logout._performLogout(context);
  }
}
