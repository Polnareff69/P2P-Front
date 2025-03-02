import 'package:market/views/authentication_screens/forgot_password_screen.dart';
import 'package:market/views/authentication_screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market/views/widgets/remember_me_checkbox.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Login Title
              Text(
                "Iniciar Sesión en U-Market",
                style: GoogleFonts.getFont(
                  'Nunito Sans',
                  color: Colors.purpleAccent,
                  fontWeight: FontWeight.w900,
                  //letterSpacing: 0.1,
                  fontSize: 25,
                ),
              ),

              //Message below the title
              Text(
                'Sumergete en el Mercado Universitario',
                style: GoogleFonts.getFont(
                  'Nunito Sans',
                  color: const Color.fromARGB(
                    255,
                    28,
                    113,
                    156,
                  ),
                  fontWeight: FontWeight.bold,
                  //letterSpacing: 0.1,
                  fontSize: 13.6,
                ),
              ),

              //Login Image
              Image.asset(
                'assets/images/user_login.png',
                width: 250,
                height: 250,
              ),

              //user name text
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Nombre de Usuario',
                  style: GoogleFonts.getFont(
                    'Nunito Sans',
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    //letterSpacing: 0.2,
                  ),
                ),
              ),
              //Input from the user_name
              TextFormField(
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  //borders
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide:
                        BorderSide
                            .none, // Sin color cuando está enfocado
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide:
                        BorderSide
                            .none, // Sin color cuando no está enfocado
                  ),

                  hintText:
                      'Introduce tu nombre de usuario...',
                  hintStyle: GoogleFonts.getFont(
                    'Nunito Sans',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.blueGrey,
                  ),
                  //icons
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.asset(
                      'assets/icons/user.png',
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),
              ),

              //user password
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Contaseña',
                  style: GoogleFonts.getFont(
                    'Nunito Sans',
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    //letterSpacing: 0.2,
                  ),
                ),
              ),
              //Input of the user password
              TextFormField(
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  //borders
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide:
                        BorderSide
                            .none, // Sin color cuando está enfocado
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide:
                        BorderSide
                            .none, // Sin color cuando no está enfocado
                  ),
                  hintText: 'Introduce tu contraseña...',
                  hintStyle: GoogleFonts.getFont(
                    'Nunito Sans',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.blueGrey,
                  ),
                  //icons
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.asset(
                      'assets/icons/password.png',
                      width: 20,
                      height: 20,
                    ),
                  ),
                  suffixIcon: Icon(Icons.visibility),
                ),
              ),

              //Remember password and Forgot Password
              const SizedBox(height: 11),
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  RememberMeCheckbox(
                    onChanged: (value) {
                      print("Recordarme: $value");
                    },
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "¿Olvidaste tu contraseña?",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        decoration:
                            TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),

              //Login Bottom
              const SizedBox(height: 30),
              Container(
                width: 319,
                height: 57,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    colors: [
                      Colors.purpleAccent,
                      const Color.fromARGB(
                        255,
                        157,
                        19,
                        170,
                      ),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: 278,
                      top: 19,
                      child: Opacity(
                        opacity: 0.5,
                        child: Container(
                          width: 60,
                          height: 60,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 12,
                              color: const Color.fromARGB(
                                255,
                                78,
                                16,
                                90,
                              ),
                            ),
                            borderRadius:
                                BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),

                    Positioned(
                      left: 260,
                      top: 29,
                      child: Opacity(
                        opacity: 0.3,
                        child: Container(
                          width: 10,
                          height: 10,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            border: Border.all(width: 3),
                            color: const Color.fromARGB(
                              255,
                              78,
                              16,
                              90,
                            ),
                            borderRadius:
                                BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),

                    Positioned(
                      left: 308,
                      top: 38,
                      child: Opacity(
                        opacity: 0.3,
                        child: Container(
                          width: 5.5,
                          height: 5.5,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 281,
                      top: -10,
                      child: Opacity(
                        opacity: 0.3,
                        child: Container(
                          width: 20,
                          height: 20,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    //Iniciar Sesion Text
                    Center(
                      child: Text(
                        'Iniciar Sesión',
                        style: GoogleFonts.getFont(
                          'Nunito Sans',
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //dont have an account
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '¿No tienes una cuenta? ',
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w500,
                      //letterSpacing: 1,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return RegisterScreen();
                          },
                        ),
                      );
                    },
                    child: Text(
                      'Registrate',
                      style: GoogleFonts.roboto(
                        color: Colors.purpleAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
