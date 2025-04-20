import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market/controllers/register_controller.dart';
import 'package:market/models/user_register_model.dart';
import 'package:market/views/business_screens/business_or_main_screen.dart';
import 'package:market/views/authentication_screens/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() =>
      _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();
  final RegisterController _registerController =
      RegisterController();

  String name = '';
  String email = '';
  String password = '';
  //String role = 'user';
  bool isLoading = false;

  Future<void> registerUser() async {
    setState(() {
      isLoading = true;
    });

    try {
      final user = UserRegisterModel(
        name: name,
        email: email,
        password: password,
      );
      await _registerController.registerUser(user);

      // Create Business or see the Market
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BusinessOrMainScreen(),
        ),
      );
    } catch (e) {
      print("Error en el registro: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al registrarse: $e")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagen de fondo
          Positioned.fill(
            child: Image.asset(
              'assets/images/register_img.png', // Usa la misma imagen o cambia a otra que prefieras
              fit: BoxFit.cover,
            ),
          ),

          // Overlay sobre la imagen de fondo
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                // Puedes elegir entre varias opciones:

                // 1. Color sólido semitransparente
                color: Colors.black38,

                // 2. Gradiente lineal
                /*
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.7),
                  ],
                ),
                */

                // 3. Gradiente radial
                /*
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.0,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.7),
                  ],
                ),
                */
              ),
            ),
          ),

          //Contenido
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      //Login Title
                      Text(
                        "Registrarse",
                        style: GoogleFonts.getFont(
                          'Nunito Sans',
                          color: Colors.purpleAccent,
                          fontWeight: FontWeight.w900,
                          //letterSpacing: 0.1,
                          fontSize: 40,
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

                      //Message below the title
                      Text(
                        'Emprende, Compra y Vende ahora mismo',
                        style: GoogleFonts.getFont(
                          'Nunito Sans',
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          //letterSpacing: 0.1,
                          fontSize: 17.6,
                        ),
                      ),

                      //Login Image
                      Image.asset(
                        'assets/images/welcome_img.png',
                        width: 280,
                        height: 280,
                      ),
                      //user name text
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Nombre de Usuario',
                          style: GoogleFonts.getFont(
                            'Nunito Sans',
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            //letterSpacing: 0.2,
                          ),
                        ),
                      ),

                      //Input from the user_name
                      TextFormField(
                        //grab name
                        onChanged: (value) {
                          name = value;
                        },

                        //validate info is not empty
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty) {
                            return 'Aqui tu usuario.';
                          } else {
                            return null;
                          }
                        },
                        style: GoogleFonts.getFont(
                          'Nunito Sans',
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          fillColor: Colors.black
                              .withOpacity(0.5),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(15),
                          ),
                          //borders
                          // Borde cuando está enfocado
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color:
                                  Colors
                                      .purpleAccent, // Color del borde cuando está enfocado
                              width:
                                  2.0, // Grosor del borde
                            ),
                          ),
                          // Borde cuando no está enfocado
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: Colors.white.withOpacity(
                                0.5,
                              ), // Color del borde normal
                              width: 2, // Grosor del borde
                            ),
                          ),

                          hintText: 'Usuario...',
                          hintStyle: GoogleFonts.getFont(
                            'Nunito Sans',
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                          //icons
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(
                              10.0,
                            ),
                            child: Image.asset(
                              'assets/icons/user.png',
                              width: 20,
                              height: 20,
                            ),
                          ),
                        ),
                      ),

                      //user email
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Email',
                          style: GoogleFonts.getFont(
                            'Nunito Sans',
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            //letterSpacing: 0.2,
                          ),
                        ),
                      ),
                      //Input of the user email
                      TextFormField(
                        //grab the user email
                        onChanged: (value) {
                          email = value;
                        },
                        //validate the user inputs an email
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty) {
                            return 'Aquí tu correo.';
                          } else {
                            return null;
                          }
                        },
                        style: GoogleFonts.getFont(
                          'Nunito Sans',
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          fillColor: Colors.black
                              .withOpacity(0.5),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(15),
                          ),
                          // borders
                          // Borde cuando está enfocado
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color:
                                  Colors
                                      .purpleAccent, // Color del borde cuando está enfocado
                              width:
                                  2.0, // Grosor del borde
                            ),
                          ),
                          // Borde cuando no está enfocado
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: Colors.white.withOpacity(
                                0.5,
                              ), // Color del borde normal
                              width: 2, // Grosor del borde
                            ),
                          ),

                          hintText: 'Correo...',
                          hintStyle: GoogleFonts.getFont(
                            'Nunito Sans',
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                          //icons
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(
                              10.0,
                            ),
                            child: Image.asset(
                              'assets/icons/email.png',
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
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            //letterSpacing: 0.2,
                          ),
                        ),
                      ),
                      //Input of the user password
                      TextFormField(
                        obscureText: true,
                        //grab the user's password
                        onChanged: (value) {
                          password = value;
                        },
                        //validate user's password
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty) {
                            return 'Aquí tu contraseña.';
                          } else {
                            return null;
                          }
                        },
                        style: GoogleFonts.getFont(
                          'Nunito Sans',
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          fillColor: Colors.black
                              .withOpacity(0.5),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(15),
                          ),
                          //borders
                          // Borde cuando está enfocado
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color:
                                  Colors
                                      .purpleAccent, // Color del borde cuando está enfocado
                              width:
                                  2.0, // Grosor del borde
                            ),
                          ),
                          // Borde cuando no está enfocado
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: Colors.white.withOpacity(
                                0.5,
                              ), // Color del borde normal
                              width: 2, // Grosor del borde
                            ),
                          ),
                          hintText: 'Contraseña...',
                          hintStyle: GoogleFonts.getFont(
                            'Nunito Sans',
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                          //icons
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(
                              10.0,
                            ),
                            child: Image.asset(
                              'assets/icons/password.png',
                              width: 20,
                              height: 20,
                            ),
                          ),
                          suffixIcon: Icon(
                            Icons.visibility,
                          ),
                        ),
                      ),

                      //Register Bottom
                      const SizedBox(height: 30),
                      isLoading
                          ? CircularProgressIndicator()
                          : InkWell(
                            onTap: () {
                              if (_formKey.currentState!
                                  .validate()) {
                                registerUser();
                                print("Username = $name");
                                print("Email = $email");
                                print(
                                  "Password = $password",
                                );
                              } else {
                                print("Ha fallado");
                              }
                            },
                            child: Container(
                              width: 319,
                              height: 65,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(
                                      25,
                                    ),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.deepPurpleAccent
                                        .withOpacity(0.5),
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
                                  //Iniciar Sesion Text
                                  Center(
                                    child: Text(
                                      'Registrarse',
                                      style:
                                          GoogleFonts.getFont(
                                            'Nunito Sans',
                                            color:
                                                Colors
                                                    .white,
                                            fontSize: 25,
                                            fontWeight:
                                                FontWeight
                                                    .w700,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                      //already have an account
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          Text(
                            '¿Ya tienes una cuenta? ',
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w500,
                              fontSize: 15.5,
                              color: Colors.white,
                              //letterSpacing: 1,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return LoginScreen();
                                  },
                                ),
                              );
                            },
                            child: Text(
                              'Inicia Sesión',
                              style: GoogleFonts.roboto(
                                color: Colors.purpleAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
