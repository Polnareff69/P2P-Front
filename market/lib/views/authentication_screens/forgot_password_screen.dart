import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Definimos los colores para un esquema más coherente
    //const primaryColor = Color(0xFF9C27B0);
    //const accentColor = Color(0xFFE040FB);

    return Scaffold(
      extendBodyBehindAppBar:
          true, // Permite que el body se extienda detrás del AppBar
      extendBody:
          true, // Extiende el cuerpo hasta el final de la pantalla
      resizeToAvoidBottomInset:
          false, // Evita que la pantalla se redimensione con el teclado

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Recuperar contraseña",
          style: GoogleFonts.nunitoSans(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black,
                offset: Offset(0, 1),
                blurRadius: 3,
              ),
            ],
          ),
        ),
      ),

      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/background8.jpg',
            ),
            fit: BoxFit.cover, // Cubre toda la pantalla
            alignment: Alignment.center,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.4),
                Colors.black.withOpacity(0.6),
              ],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    // Icono ilustrativo
                    Center(
                      child: Container(
                        width: 150,
                        height: 150,
                        margin: const EdgeInsets.only(
                          top: 10,
                          bottom: 50,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius:
                              BorderRadius.circular(80),
                        ),
                        child: Icon(
                          Icons.lock_reset,
                          size: 100,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    // Título descriptivo
                    Center(
                      child: Text(
                        "¿Olvidaste tu contraseña?",
                        style: GoogleFonts.nunitoSans(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              offset: Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Subrayado del título
                    Divider(
                      color: Colors.white,
                      thickness: 1.5,
                      height: 16,
                    ),

                    const SizedBox(height: 20),

                    // Texto explicativo
                    Text(
                      "No te preocupes, introduce tu correo electrónico y te enviaremos instrucciones para restablecerla.",
                      style: GoogleFonts.nunitoSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Campo de correo electrónico con sombra
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          20,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Correo electrónico",
                          hintText: "tu-correo@gmail.com",
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: const Color.fromARGB(
                              255,
                              97,
                              13,
                              175,
                            ),
                            size: 33,
                          ),
                          labelStyle:
                              GoogleFonts.nunitoSans(
                                color: Colors.white,
                                fontSize: 16.5,
                                fontWeight: FontWeight.bold,
                              ),
                          // Borde normal cuando no está enfocado
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: Colors.white
                                  .withOpacity(0.5),
                              width: 2.0,
                            ),
                          ),
                          // Borde cuando está enfocado
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 2.5,
                            ),
                          ),
                          // Borde cuando hay error
                          errorBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 2.0,
                            ),
                          ),
                          // Borde cuando hay error y está enfocado
                          focusedErrorBorder:
                              OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                      15,
                                    ),
                                borderSide: BorderSide(
                                  color: Colors.redAccent,
                                  width: 2.5,
                                ),
                              ),
                          filled: true,
                          fillColor: Colors.black26,
                        ),
                        keyboardType:
                            TextInputType.emailAddress,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Botón de enviar instrucciones
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          15,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(
                              0.3,
                            ),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          15,
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 5,
                            sigmaY: 5,
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              // Lógica para enviar el correo
                              print(
                                "Correo enviado para recuperar contraseña",
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(
                                    255,
                                    97,
                                    13,
                                    175,
                                  ),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                      25,
                                    ),
                              ),
                            ),
                            child: Text(
                              "ENVIAR INSTRUCCIONES",
                              style: GoogleFonts.nunitoSans(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Enlace para volver a iniciar sesión
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.white
                              .withOpacity(0.1),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "Volver a iniciar sesión",
                          style: GoogleFonts.nunitoSans(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    // Espacio extra para evitar el problema de espacio en blanco
                    SizedBox(height: 50),
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
