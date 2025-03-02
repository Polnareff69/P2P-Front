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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),

          // Logo
          Image.asset(
            'assets/images/logo.png',
            height: 180,
          ),

          // Title 'U-Market' -> "Lilita One"
          Text(
            "U-MARKET",
            style: GoogleFonts.lilitaOne(
              fontSize: 55,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
          ),

          const SizedBox(height: 20),

          // Logo image (u_market)
          Image.asset(
            'assets/images/login_register.png',
            height: 333,
          ),

          const SizedBox(height: 30),

          // Login Bottom
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
            ),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.purple, // purple background
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: const Size(
                  double.infinity,
                  60,
                ),
              ),
              icon: Image.asset(
                'assets/icons/login.png',
                width: 30,
              ),
              label: Text(
                "Iniciar Sesión",
                style: GoogleFonts.nunitoSans(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => const LoginScreen(),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 15),

          // Register Bottom
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
            ),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.blue, //  blue background
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: const Size(
                  double.infinity,
                  60,
                ),
              ),
              icon: Image.asset(
                'assets/icons/register.png',
                width: 30,
              ),
              label: Text(
                "Registrarse",
                style: GoogleFonts.nunitoSans(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => const RegisterScreen(),
                  ),
                );
              },
            ),
          ),

          const Spacer(),
        ],
      ),
    );
  }
}
