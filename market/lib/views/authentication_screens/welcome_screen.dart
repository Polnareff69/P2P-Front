import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Imagen de fondo
          Positioned.fill(
            child: Image.asset(
              'assets/images/background5.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // Contenido principal
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Title 'U-Market' -> "Lilita One"
              Text(
                "U-MARKET",
                style: GoogleFonts.lilitaOne(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.deepPurple,
                      offset: Offset(0, 1),
                      blurRadius: 15,
                    ),
                  ],
                ),
              ),

              /*
              Image.asset(
                'assets/images/galaxy.png',
                width: 350,
                height: 350,
              ),
              */
              const SizedBox(height: 250),

              // Login Button - Transparente con borde
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                ),
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color:
                          Colors.black, // Color del borde
                      width: 5.0, // Grosor del borde
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        20,
                      ),
                    ),
                    minimumSize: const Size(
                      double.infinity,
                      80,
                    ),
                    backgroundColor:
                        Colors
                            .black45, // Fondo muy transparente
                  ),
                  icon: Icon(
                    Icons.login_sharp,
                    color: Colors.black,
                    size: 37,
                  ),
                  label: Text(
                    " Iniciar Sesión",
                    style: GoogleFonts.nunitoSans(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          offset: Offset(1, 2),
                          blurRadius: 15,
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Register Button - Transparente con borde
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                ),
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color:
                          Colors.black, // Color del borde
                      width: 5.0, // Grosor del borde
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        20,
                      ),
                    ),
                    minimumSize: const Size(
                      double.infinity,
                      80,
                    ),
                    backgroundColor:
                        Colors
                            .black38, // Fondo muy transparente
                  ),
                  icon: Icon(
                    Icons.person_add,
                    color: Colors.black,
                    size: 37,
                  ),
                  label: Text(
                    " Registrarse",
                    style: GoogleFonts.nunitoSans(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          offset: Offset(1, 2),
                          blurRadius: 15,
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => RegisterScreen(),
                      ),
                    );
                  },
                ),
              ),

              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}
