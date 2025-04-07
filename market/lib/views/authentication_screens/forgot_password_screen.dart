import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Definimos los colores para un esquema más coherente
    const primaryColor = Color(
      0xFF9C27B0,
    ); // Púrpura más profesional
    const accentColor = Color(
      0xFFE040FB,
    ); // Variante de púrpura más clara para acentos
    const backgroundColor = Color(
      0xFFF5F5F5,
    ); // Fondo muy claro

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: primaryColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          " Recuperar contraseña",
          style: GoogleFonts.nunitoSans(
            fontSize: 25,
            fontWeight: FontWeight.w900,
            color: accentColor,
            shadows: [
              Shadow(
                color: Colors.black,
                offset: Offset(0, 0),
                blurRadius: 1,
              ),
            ],
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icono ilustrativo
                Center(
                  child: Container(
                    width: 160,
                    height: 150,
                    margin: const EdgeInsets.only(
                      top: 10,
                      bottom: 40,
                    ),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(
                        75,
                      ),
                    ),
                    child: Icon(
                      Icons.lock_reset,
                      size: 100,
                      color: primaryColor,
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
                      color: Colors.black87,
                      shadows: [
                        Shadow(
                          color: primaryColor,
                          offset: Offset(0, 1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
                // Subrayado del "¿Olvidaste tu constraseña"
                Divider(
                  color: Colors.black,
                  thickness: 1.5,
                  height: 1,
                ),

                const SizedBox(height: 20),

                // Texto explicativo
                Text(
                  "No te preocupes, introduce tu correo electrónico y te enviaremos instrucciones para restablecerla.",
                  style: GoogleFonts.nunitoSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(height: 32),

                // Campo de correo electrónico mejorado
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Correo electrónico",
                    hintText: "tu-correo@gmail.com",
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: primaryColor,
                    ),
                    labelStyle: GoogleFonts.nunitoSans(
                      color: Colors.black54,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        12,
                      ),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        12,
                      ),
                      borderSide: const BorderSide(
                        color: primaryColor,
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        12,
                      ),
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 24),

                // Botón mejorado
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      //lógica para enviar el correo a FastAPI
                      print(
                        "Correo enviado para recuperar contraseña",
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          12,
                        ),
                      ),
                    ),
                    child: Text(
                      "ENVIAR INSTRUCCIONES",
                      style: GoogleFonts.nunitoSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Enlace para volver a iniciar sesión
                Center(
                  child: TextButton(
                    onPressed: () {
                      // Navegar de regreso a la pantalla de inicio de sesión
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Volver a iniciar sesión",
                      style: GoogleFonts.nunitoSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: primaryColor,
                      ),
                    ),
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
