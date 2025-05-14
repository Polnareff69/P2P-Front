import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market/views/widgets/logout_button.dart';
import 'package:flutter/foundation.dart';
import 'package:market/services/auth_service.dart';
import 'package:market/views/authentication_screens/welcome_screen.dart';

class SettingsMenu extends StatelessWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey; // ✨ NUEVO PARÁMETRO
  final VoidCallback? onLogoutStart;
  final VoidCallback? onLogoutComplete;
  final VoidCallback? onEditProfile;
  final VoidCallback? onChangeTheme;
  final VoidCallback? onNotifications;

  const SettingsMenu({
    Key? key,
    this.scaffoldKey, // ✨ NUEVO PARÁMETRO
    this.onLogoutStart,
    this.onLogoutComplete,
    this.onEditProfile,
    this.onChangeTheme,
    this.onNotifications,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 320,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xFF1A1A1A),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            bottomLeft: Radius.circular(25),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.7),
              blurRadius: 15,
              offset: Offset(-5, 0),
            ),
            BoxShadow(
              color: Colors.purple.withOpacity(0.3),
              blurRadius: 20,
              offset: Offset(-10, 0),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header del menú con diseño mejorado
              _buildHeader(context),
              
              // Línea decorativa
              Container(
                height: 2,
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.purple.shade400,
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              
              // Menú items
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  children: [
                    _buildCustomMenuItem(
                      icon: Icons.edit_rounded,
                      title: 'Editar Perfil',
                      subtitle: 'Personalizar información',
                      color: Colors.purple,
                      onTap: onEditProfile,
                    ),
                    _buildCustomMenuItem(
                      icon: Icons.palette_rounded,
                      title: 'Cambiar Tema',
                      subtitle: 'Personalizar apariencia',
                      color: Colors.blue,
                      onTap: onChangeTheme,
                    ),
                    _buildCustomMenuItem(
                      icon: Icons.notifications_rounded,
                      title: 'Notificaciones',
                      subtitle: 'Configurar alertas',
                      color: Colors.orange,
                      onTap: onNotifications,
                    ),
                    _buildCustomMenuItem(
                      icon: Icons.security_rounded,
                      title: 'Privacidad',
                      subtitle: 'Configurar privacidad',
                      color: Colors.green,
                      onTap: () {
                        if (kDebugMode) print('Privacidad presionado');
                      },
                    ),
                    _buildCustomMenuItem(
                      icon: Icons.help_rounded,
                      title: 'Ayuda',
                      subtitle: 'Centro de ayuda',
                      color: Colors.teal,
                      onTap: () {
                        if (kDebugMode) print('Ayuda presionado');
                      },
                    ),
                    _buildCustomMenuItem(
                      icon: Icons.info_rounded,
                      title: 'Acerca de',
                      subtitle: 'Información de la app',
                      color: Colors.indigo,
                      onTap: () {
                        if (kDebugMode) print('Acerca de presionado');
                      },
                    ),
                    
                    // Separador decorativo
                    _buildSeparator(),
                    
                    // Botón de logout
                    _buildLogoutMenuItem(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 15, 15, 15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.shade700,
            Colors.purple.shade900,
            Colors.black,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.settings_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Configuración',
                  style: GoogleFonts.nunito(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.5),
                        offset: Offset(1, 1),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                ),
                Text(
                  'Personaliza tu experiencia',
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    color: Colors.white70,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(25),
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: EdgeInsets.all(8),
                child: Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      color.withOpacity(0.7),
                      color.withOpacity(0.9),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.nunito(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        color: Colors.white60,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white30,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSeparator() {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 15, 20, 5),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.red.withOpacity(0.5),
                        Colors.red,
                        Colors.red,
                        Colors.red.withOpacity(0.5),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            '• • •',
            style: TextStyle(
              color: Colors.red.withOpacity(0.7),
              letterSpacing: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutMenuItem(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          if (kDebugMode) print('🚪 Logout iniciado desde SettingsMenu');
          
          // ✨ USAR EL CONTEXT DEL SCAFFOLD SI ESTÁ DISPONIBLE
          final BuildContext contextToUse = scaffoldKey?.currentContext ?? context;
          
          // Obtener NavigatorState y ScaffoldMessenger ANTES de cerrar el menú
          final navigator = Navigator.of(contextToUse, rootNavigator: true);
          final scaffold = ScaffoldMessenger.of(contextToUse);
          
          // Cerrar el menú
          Navigator.pop(context);
          
          // Mostrar diálogo de confirmación
          bool shouldLogout = await showDialog<bool>(
            context: contextToUse, // ✨ USAR EL CONTEXT VÁLIDO
            builder: (BuildContext dialogContext) {
              return AlertDialog(
                title: const Text('Confirmar Logout'),
                content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(false),
                    child: const Text('Cancelar'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(dialogContext).pop(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Cerrar Sesión'),
                  ),
                ],
              );
            },
          ) ?? false;

          if (shouldLogout) {
            // Ejecutar callback antes del logout
            onLogoutStart?.call();
            
            // Obtener información del usuario ANTES del logout
            final username = AuthService.instance.currentUsername;
            final wasLoggedIn = AuthService.instance.isLoggedIn;
            
            if (kDebugMode) {
              print('🔍 Estado antes del logout:');
              AuthService.instance.printCurrentState();
            }
            
            // Mostrar loading
            showDialog(
              context: contextToUse, // ✨ USAR EL CONTEXT VÁLIDO
              barrierDismissible: false,
              builder: (loadingContext) => const Center(
                child: CircularProgressIndicator(),
              ),
            );
            
            try {
              // Hacer logout solo si está logueado
              if (wasLoggedIn) {
                await AuthService.instance.logout();
                
                if (kDebugMode) {
                  print('🔍 Estado después del logout:');
                  AuthService.instance.printCurrentState();
                }
              }
              
              // Cerrar loading
              Navigator.of(contextToUse).pop();
              
              // Mostrar mensaje de éxito
              scaffold.showSnackBar(
                SnackBar(
                  content: Text('¡Adiós ${username ?? 'Usuario'}! Has cerrado sesión exitosamente.'),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 2),
                ),
              );
              
              // NAVEGACIÓN CON EL NAVIGATOR OBTENIDO ANTES
              if (kDebugMode) print('🔍 Navegando a WelcomeScreen...');
              
              // Usar el navigator que obtuvimos
              navigator.pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                (route) => false,
              );
              
              if (kDebugMode) print('✅ Navegación completada');
              
              // Callback final
              onLogoutComplete?.call();
              
            } catch (e) {
              // Cerrar loading en caso de error
              Navigator.of(contextToUse).pop();
              
              if (kDebugMode) print('❌ Error en logout: $e');
              
              scaffold.showSnackBar(
                SnackBar(
                  content: Text('Error al cerrar sesión: $e'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
        borderRadius: BorderRadius.circular(15),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.red.withOpacity(0.15),
                Colors.red.withOpacity(0.25),
              ],
            ),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Colors.red.withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.2),
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.red.shade600,
                      Colors.red.shade700,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.4),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.logout_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cerrar Sesión',
                      style: GoogleFonts.nunito(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Colors.red.shade300,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Salir de tu cuenta',
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        color: Colors.red.shade200,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.exit_to_app_rounded,
                  color: Colors.red.shade300,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Función helper mejorada para mostrar el menú
void showSettingsMenu(
  BuildContext context, {
  GlobalKey<ScaffoldState>? scaffoldKey, // ✨ PARÁMETRO PARA EL KEY
  VoidCallback? onLogoutStart,
  VoidCallback? onLogoutComplete,
  VoidCallback? onEditProfile,
}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Settings',
    barrierColor: Colors.black.withOpacity(0.6),
    pageBuilder: (context, animation, secondaryAnimation) {
      // Crear animaciones curvadas correctamente
      final slideAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOutCubic,
      );

      final scaleAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutQuart,
      );

      final fadeAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      );

      return Align(
        alignment: Alignment.centerRight,
        child: SlideTransition(
          position: slideAnimation.drive(
            Tween(begin: const Offset(1, 0), end: Offset.zero),
          ),
          child: ScaleTransition(
            scale: scaleAnimation.drive(
              Tween(begin: 0.95, end: 1.0),
            ),
            child: FadeTransition(
              opacity: fadeAnimation.drive(
                Tween(begin: 0.0, end: 1.0),
              ),
              child: SettingsMenu(
                scaffoldKey: scaffoldKey, // ✨ PASAR EL KEY AL WIDGET
                onLogoutStart: onLogoutStart,
                onLogoutComplete: onLogoutComplete,
                onEditProfile: onEditProfile,
              ),
            ),
          ),
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 350),
  );
}