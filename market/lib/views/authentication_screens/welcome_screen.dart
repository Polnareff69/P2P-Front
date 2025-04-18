import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Aquí agregamos la imagen de fondo
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/fondo (1).png',
            ), // Ruta a tu imagen
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),

            // Logo
            Image.asset('assets/images/logo.png', height: 190),

            // Title 'U-Market' -> "Lilita One"
            Text(
              "U-Market",
              style: GoogleFonts.gemunuLibre(
                fontSize: 85,
                fontWeight: FontWeight.w600,
                color: const Color.fromARGB(255, 255, 255, 255),
                shadows: [
                  Shadow(
                    color: const Color.fromARGB(255, 66, 15, 61),
                    offset: Offset(5, 4),
                    blurRadius: 0,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Logo image (u_market)
            //Image.asset('assets/images/login_register.png', height: 333),

            //const SizedBox(height: 30),

            // Login Bottom
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 148, 0, 211),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80),
                  ),
                  minimumSize: const Size(double.infinity, 60),
                  elevation: 10, // Añade sombra al botón
                  shadowColor: Colors.purple, // Color de la sombra
                ),
                icon: Image.asset('assets/icons/login.png', width: 30),
                label: Text(
                  "Iniciar Sesión",
                  style: GoogleFonts.nunitoSans(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.6),
                        offset: Offset(2, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
              ),
            ),

            const SizedBox(height: 15),

            // Register Bottom
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(
                    255,
                    148,
                    0,
                    211,
                  ), //  blue background
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80),
                  ),
                  minimumSize: const Size(double.infinity, 60),
                  elevation: 10, // Añade sombra al botón
                  shadowColor: Colors.purple, // Color de la sombra
                ),
                icon: Image.asset('assets/icons/register.png', width: 30),

                label: Text(
                  "Registrarse",
                  style: GoogleFonts.nunitoSans(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.6),
                        offset: Offset(2, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
                  );
                },
              ),
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}
