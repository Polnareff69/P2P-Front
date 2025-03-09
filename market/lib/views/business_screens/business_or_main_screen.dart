import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market/views/business_screens/create_business_screen.dart';

class BusinessOrMainScreen extends StatelessWidget {
  const BusinessOrMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "   U-MARKET",
          style: GoogleFonts.lilitaOne(
            fontSize: 45,
            fontWeight: FontWeight.bold,
            color: Colors.purple,
          ),
        ),
      ),
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                // Logo
                Image.asset(
                  'assets/images/logo.png',
                  height: 180,
                ),
                //const SizedBox(height: 20),

                // Encabezado
                Center(
                  child: Column(
                    children: [
                      Text(
                        "Elige una Opción",
                        style: GoogleFonts.nunitoSans(
                          color: Colors.purpleAccent,
                          fontWeight: FontWeight.w900,
                          fontSize: 29,
                        ),
                      ),

                      Text(
                        "¡Emprende o Visita Todas Las Tiendas!",
                        style: GoogleFonts.nunitoSans(
                          fontSize: 16,
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // Pregunta
                Text(
                  "¿Qué quieres hacer?",
                  style: GoogleFonts.nunitoSans(
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 20),

                // Contenedor con botones
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 40,
                    horizontal: 30,
                  ),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(
                      86,
                      151,
                      144,
                      144,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return CreateBusinessScreen();
                              },
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.purpleAccent,
                          foregroundColor: Colors.white,
                          padding:
                              const EdgeInsets.symmetric(
                                vertical: 20,
                                horizontal: 70,
                              ),
                          textStyle: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text("Crear Empresa"),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/main',
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.purpleAccent,
                          foregroundColor: Colors.white,
                          padding:
                              const EdgeInsets.symmetric(
                                vertical: 20,
                                horizontal: 70,
                              ),
                          textStyle: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text("Ver el mercado"),
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
