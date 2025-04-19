import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market/views/business_screens/create_business_screen.dart';
import 'package:market/views/main_screen/businesses.dart';

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

      // Contenido principal - Usamos SingleChildScrollView para evitar problemas de tamaño
      body: Container(
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
        child: SingleChildScrollView(
          child: Container(
            // Aseguramos que este container tenga al menos la altura de la pantalla
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            // Gradiente sutil sobre la imagen para mejorar legibilidad
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
            child: SafeArea(
              bottom: false,
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

                    // Logo con efecto de elevación
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(
                              0.2,
                            ),
                            blurRadius: 15,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: 180,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Encabezado simplificado (sin animación para evitar problemas)
                    Text(
                      "Elige una Opción",
                      style: GoogleFonts.nunitoSans(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 32,
                        shadows: [
                          Shadow(
                            color: Colors.purple
                                .withOpacity(0.8),
                            offset: const Offset(0, 2),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(
                          0.15,
                        ),
                        borderRadius: BorderRadius.circular(
                          20,
                        ),
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
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),

                    const SizedBox(height: 50),

                    // Pregunta con efecto de brillo
                    Text(
                      "¿Qué quieres hacer?",
                      style: GoogleFonts.nunitoSans(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
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

                    const SizedBox(height: 40),

                    // Botón Emprender - Usando ElevatedButton simple para máxima compatibilidad
                    ElevatedButton(
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
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.purple,
                        minimumSize: const Size(
                          double.infinity,
                          120,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(25),
                        ),
                        elevation: 10,
                        shadowColor: Colors.purple
                            .withOpacity(0.5),
                      ),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.rocket_launch_rounded,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "Emprender",
                            style: GoogleFonts.nunitoSans(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                              shadows: [
                                Shadow(
                                  color: Colors.black
                                      .withOpacity(0.5),
                                  offset: const Offset(
                                    1,
                                    1,
                                  ),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Botón Ver Mercado - Usando ElevatedButton simple para máxima compatibilidad
                    ElevatedButton(
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
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.purple,
                        minimumSize: const Size(
                          double.infinity,
                          120,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(25),
                        ),
                        elevation: 10,
                        shadowColor: Colors.purple
                            .withOpacity(0.5),
                      ),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.storefront_rounded,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "Ver Mercado",
                            style: GoogleFonts.nunitoSans(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                              shadows: [
                                Shadow(
                                  color: Colors.black
                                      .withOpacity(0.5),
                                  offset: const Offset(
                                    1,
                                    1,
                                  ),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
