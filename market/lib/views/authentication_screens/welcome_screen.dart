import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'dart:math' as math;

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

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
      body: Stack(
        children: [
          // Imagen de fondo
          Positioned.fill(
            child: Image.asset(
              'assets/images/welcome_screen.png',
              fit: BoxFit.cover,
            ),
          ),

          // Gradiente sutil para mejorar legibilidad
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.1),
                  ],
                  stops: const [0.0, 0.6, 1.0],
                ),
              ),
            ),
          ),

          // Efecto de estrellas/partículas
          Positioned.fill(
            child: CustomPaint(painter: StarFieldPainter()),
          ),

          // Contenido principal con animaciones
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),

                // Título animado
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(
                    begin: 0.8,
                    end: 1.0,
                  ),
                  duration: const Duration(seconds: 2),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: ShaderMask(
                        shaderCallback:
                            (bounds) => LinearGradient(
                              colors: [
                                Colors.purple,
                                Colors.white,

                                Colors.deepPurple,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ).createShader(bounds),
                        child: Text(
                          "U-MARKET",
                          style: GoogleFonts.lilitaOne(
                            fontSize: 65,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.deepPurple
                                    .withOpacity(0.8),
                                offset: const Offset(1, 3),
                                blurRadius: 10,
                              ),
                              Shadow(
                                color: Colors.black
                                    .withOpacity(0.6),
                                offset: const Offset(2, 4),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 50),
                const SizedBox(height: 200),

                // Botones con animación
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: 1),
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
                          50 *
                              (1 -
                                  Curves.easeOutBack
                                      .transform(value)),
                        ),
                        child: child,
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                    ),
                    child: _buildAnimatedButton(
                      label: "Iniciar Sesión",
                      icon: Icons.login_sharp,
                      context: context,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => LoginScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(
                    milliseconds: 1000,
                  ),
                  curve: Curves.easeOut,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(
                          0,
                          50 *
                              (1 -
                                  Curves.easeOutBack
                                      .transform(value)),
                        ),
                        child: child,
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                    ),
                    child: _buildAnimatedButton(
                      label: "Registrarse",
                      icon: Icons.person_add,
                      context: context,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    RegisterScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget personalizado para botones con efecto de pulsación
  Widget _buildAnimatedButton({
    required String label,
    required IconData icon,
    required BuildContext context,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.black54,
          child: InkWell(
            splashColor: Colors.deepPurple.withOpacity(0.3),
            highlightColor: Colors.deepPurple.withOpacity(
              0.1,
            ),
            onTap: onPressed,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 5.0,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: Colors.white,
                    size: 37,
                    shadows: [
                      Shadow(
                        color: Colors.deepPurpleAccent,
                        offset: Offset(1, 2),
                        blurRadius: 15,
                      ),
                    ],
                  ),
                  Text(
                    " $label",
                    style: GoogleFonts.nunitoSans(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      shadows: [
                        Shadow(
                          color: Colors.deepPurpleAccent,
                          offset: const Offset(1, 2),
                          blurRadius: 15,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Painter para crear un efecto de estrellas/brillos en el fondo
class StarFieldPainter extends CustomPainter {
  final List<Star> stars = [];

  StarFieldPainter() {
    // Generar estrellas con posiciones y tamaños aleatorios
    final random = math.Random();
    for (int i = 0; i < 80; i++) {
      stars.add(
        Star(
          x: random.nextDouble(),
          y: random.nextDouble(),
          size: random.nextDouble() * 2.0 + 0.5,
          opacity: random.nextDouble() * 0.5 + 0.1,
          pulseSpeed: random.nextDouble() * 2 + 1,
        ),
      );
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final time =
        DateTime.now().millisecondsSinceEpoch / 1000;

    // Dibuja las estrellas
    for (final star in stars) {
      // Calcular la opacidad pulsante
      final pulseOpacity =
          star.opacity *
          (0.7 + 0.3 * math.sin(time * star.pulseSpeed));

      paint.color = Colors.white.withOpacity(pulseOpacity);
      canvas.drawCircle(
        Offset(star.x * size.width, star.y * size.height),
        star.size,
        paint,
      );

      // Añadir un pequeño resplandor a las estrellas más grandes
      if (star.size > 1.2) {
        paint.color = Colors.white.withOpacity(
          pulseOpacity * 0.3,
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
      true;
}

// Clase para representar las estrellas en el fondo
class Star {
  final double x;
  final double y;
  final double size;
  final double opacity;
  final double pulseSpeed;

  Star({
    required this.x,
    required this.y,
    required this.size,
    required this.opacity,
    required this.pulseSpeed,
  });
}
