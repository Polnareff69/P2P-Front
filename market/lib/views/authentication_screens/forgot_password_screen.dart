import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "   Recuperar contraseña",
          style: GoogleFonts.nunitoSans(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: Colors.purpleAccent,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Ingresa tu correo electrónico para restablecer tu contraseña:",
              style: GoogleFonts.nunitoSans(
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                labelText: "Correo electrónico",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 17),
            ElevatedButton(
              onPressed: () {
                // Aquí podemos agregar la lógica para enviar el correo a FastAPI
                print(
                  "Correo enviado para recuperar contraseña",
                );
              },
              
              child: Text(
                "Enviar correo",
                style: GoogleFonts.nunitoSans(
                  color: Colors.purpleAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
