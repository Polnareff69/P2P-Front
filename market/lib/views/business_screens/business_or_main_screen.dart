import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market/views/business_screens/create_business_screen.dart';
import 'package:market/views/main_screen/businesses.dart';
import 'dart:math' as math;

class BusinessOrMainScreen extends StatelessWidget {
  const BusinessOrMainScreen({super.key});

  // Configuración del sistema UI para una experiencia inmersiva
  static final SystemUiOverlayStyle overlayStyle =
      SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        statusBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      );

  @override
  Widget build(BuildContext context) {
    // Aplicar configuraciones de sistema para una experiencia fullscreen
    SystemChrome.setSystemUIOverlayStyle(overlayStyle);
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: ShaderMask(
          shaderCallback:
              (bounds) => LinearGradient(
                colors: [
                  Colors.purple,
                  Colors.deepPurple.shade800,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
          child: Text(
            "U-MARKET",
            style: GoogleFonts.lilitaOne(
              fontSize: 45,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.7),
                  offset: const Offset(2, 3),
                  blurRadius: 5,
                ),
              ],
            ),
          ),
        ),
        centerTitle: true,
      ),

      // Contenido principal
      body: Stack(
        children: [
          // Fondo con imagen
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage(
                  'assets/images/background8.jpg',
                ),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.2),
                  BlendMode.darken,
                ),
              ),
            ),
          ),

          // Gradiente para mejorar legibilidad
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.7),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),

          // Efecto de partículas
          Positioned.fill(
            child: CustomPaint(painter: StarFieldPainter()),
          ),

          // Contenido principal
          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                ),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.start,
                  crossAxisAlignment:
                      CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),

                    // Logo con efecto de elevación y animación
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(
                        begin: 0.9,
                        end: 1.0,
                      ),
                      duration: const Duration(seconds: 2),
                      curve: Curves.easeInOut,
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.purple
                                      .withOpacity(0.3),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Image.asset(
                              'assets/images/logo.png',
                              height: 180,
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 30),

                    // Encabezado con animación sutil
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(
                        begin: 0,
                        end: 1,
                      ),
                      duration: const Duration(
                        milliseconds: 800,
                      ),
                      curve: Curves.easeOut,
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(
                              0,
                              20 * (1 - value),
                            ),
                            child: child,
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Text(
                            "Elige una Opción",
                            style: GoogleFonts.nunitoSans(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 32.5,
                              shadows: [
                                Shadow(
                                  color: Colors.purple
                                      .withOpacity(0.8),
                                  offset: const Offset(
                                    0,
                                    2,
                                  ),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding:
                                const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                            decoration: BoxDecoration(
                              color: Colors.blue
                                  .withOpacity(0.15),
                              borderRadius:
                                  BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.blueAccent
                                    .withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              "¡Emprende o Visita Todas Las Tiendas!",
                              style: GoogleFonts.nunitoSans(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 49),

                    // Pregunta con efecto de brillo
                    ShaderMask(
                      shaderCallback:
                          (bounds) => LinearGradient(
                            colors: [
                              Colors.white,
                              Colors.white.withOpacity(0.8),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ).createShader(bounds),
                      child: Text(
                        "¿Qué quieres hacer?",
                        style: GoogleFonts.nunitoSans(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.purple
                                  .withOpacity(0.6),
                              offset: const Offset(0, 2),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 35),

                    // Botones mejorados con animación
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(
                        begin: 0,
                        end: 1,
                      ),
                      duration: const Duration(
                        milliseconds: 600,
                      ),
                      curve: Curves.easeOut,
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(
                              0,
                              30 * (1 - value),
                            ),
                            child: child,
                          ),
                        );
                      },
                      child: _buildAnimatedButton(
                        label: "Emprender",
                        icon: Icons.rocket_launch_rounded,
                        context: context,
                        onPressed: () {
                          debugPrint(
                            "Botón Emprender presionado",
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      const CreateBusinessScreen(),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(
                        begin: 0,
                        end: 1,
                      ),
                      duration: const Duration(
                        milliseconds: 800,
                      ),
                      curve: Curves.easeOut,
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(
                              0,
                              30 * (1 - value),
                            ),
                            child: child,
                          ),
                        );
                      },
                      child: _buildAnimatedButton(
                        label: "Ver Mercado",
                        icon: Icons.storefront_rounded,
                        context: context,
                        onPressed: () {
                          debugPrint(
                            "Botón Ver Mercado presionado",
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      const BusinessesScreen(),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Método para crear botones animados con gradiente que mantienen la navegación funcional
  Widget _buildAnimatedButton({
    required String label,
    required IconData icon,
    required BuildContext context,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.5),
            blurRadius: 13,
            spreadRadius: 1,
            offset: const Offset(0, 5),
          ),
        ],
        gradient: const LinearGradient(
          colors: [Color(0xFFBF40BF), Color(0xFF800080)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.white.withOpacity(0.2),
            highlightColor: Colors.transparent,
            onTap: onPressed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 33),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: GoogleFonts.nunitoSans(
                    fontSize: 29,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 1,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(
                          0.5,
                        ),
                        offset: const Offset(1, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Painter mejorado para crear un efecto de estrellas/brillos en el fondo
class StarFieldPainter extends CustomPainter {
  final List<Star> stars = [];

  StarFieldPainter() {
    // Generar estrellas con posiciones y tamaños aleatorios
    final random = math.Random();
    for (int i = 0; i < 60; i++) {
      stars.add(
        Star(
          x: random.nextDouble(),
          y: random.nextDouble(),
          size: random.nextDouble() * 2.5 + 0.5,
          opacity: random.nextDouble() * 0.6 + 0.2,
        ),
      );
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Dibuja las estrellas
    for (final star in stars) {
      paint.color = Colors.white.withOpacity(star.opacity);
      canvas.drawCircle(
        Offset(star.x * size.width, star.y * size.height),
        star.size,
        paint,
      );

      // Añadir un pequeño resplandor a las estrellas más grandes
      if (star.size > 1.2) {
        paint.color = Colors.white.withOpacity(
          star.opacity * 0.3,
        );
        canvas.drawCircle(
          Offset(star.x * size.width, star.y * size.height),
          star.size * 2,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) =>
      false;
}

// Clase para representar las estrellas en el fondo
class Star {
  final double x;
  final double y;
  final double size;
  final double opacity;

  Star({
    required this.x,
    required this.y,
    required this.size,
    required this.opacity,
  });
}
