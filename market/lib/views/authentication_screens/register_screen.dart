import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market/controllers/register_controller.dart';
import 'package:market/models/user_register_model.dart';
import 'package:market/views/business_screens/business_or_main_screen.dart';
import 'package:market/views/authentication_screens/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final RegisterController _registerController = RegisterController();

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
        MaterialPageRoute(builder: (context) => BusinessOrMainScreen()),
      );
    } catch (e) {
      print("Error en el registro: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error al registrarse: $e")));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Login Title
                  Text(
                    "Registrarse en U-Market",
                    style: GoogleFonts.getFont(
                      'Nunito Sans',
                      color: const Color.fromARGB(255, 179, 0, 161),
                      fontWeight: FontWeight.w900,
                      //letterSpacing: 0.1,
                      fontSize: 25,
                    ),
                  ),

                  //Message below the title
                  Text(
                    'Emprende, Compra y Vende ahora mismo',
                    style: GoogleFonts.getFont(
                      'Nunito Sans',
                      color: const Color.fromARGB(255, 66, 15, 61),
                      fontWeight: FontWeight.bold,
                      //letterSpacing: 0.1,
                      fontSize: 14,
                    ),
                  ),

                  //Login Image
                  Image.asset(
                    'assets/images/user_register.png',
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
                    //grab name
                    onChanged: (value) {
                      name = value;
                    },

                    //validate info is not empty
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa un nombre.';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      fillColor: const Color.fromARGB(255, 228, 217, 217),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      //borders
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            BorderSide.none, // Sin color cuando está enfocado
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            BorderSide
                                .none, // Sin color cuando no está enfocado
                      ),

                      hintText: 'Introduce tu nombre de usuario...',
                      hintStyle: GoogleFonts.getFont(
                        'Nunito Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: const Color.fromARGB(255, 139, 96, 133),
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

                  //user email
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Email',
                      style: GoogleFonts.getFont(
                        'Nunito Sans',
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
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
                      if (value == null || value.isEmpty) {
                        return 'Ingresa un correo.';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      fillColor: const Color.fromARGB(255, 228, 217, 217),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      // borders
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            BorderSide.none, // Sin color cuando está enfocado
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            BorderSide
                                .none, // Sin color cuando no está enfocado
                      ),

                      hintText: 'Introduce tu email...',
                      hintStyle: GoogleFonts.getFont(
                        'Nunito Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: const Color.fromARGB(255, 139, 96, 133),
                      ),
                      //icons
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(10.0),
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
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
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
                      if (value == null || value.isEmpty) {
                        return 'Ingresa una contraseña.';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      fillColor: const Color.fromARGB(255, 228, 217, 217),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      //borders
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            BorderSide.none, // Sin color cuando está enfocado
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
                        color: const Color.fromARGB(255, 139, 96, 133),
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

                  //Register Bottom
                  const SizedBox(height: 30),
                  isLoading
                      ? CircularProgressIndicator()
                      : InkWell(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            registerUser();
                            print("Username = $name");
                            print("Email = $email");
                            print("Password = $password");
                          } else {
                            print("Ha fallado");
                          }
                        },
                        child: Material(
                          elevation: 10, 
                          borderRadius: BorderRadius.circular(80),
                          color: const Color.fromARGB(255, 179, 0, 161),
                          child: Container(
                            width: 319,
                            height: 57,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(80),
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
                                            38,
                                            43,
                                            46,
                                          ),
                                        ),
                                        borderRadius: BorderRadius.circular(30),
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
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(5),
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
                                        borderRadius: BorderRadius.circular(3),
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
                                        color: const Color.fromARGB(
                                          255,
                                          0,
                                          0,
                                          0,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                                //Iniciar Sesion Text
                                Center(
                                  child: Text(
                                    'Registrarse',
                                    style: GoogleFonts.nunitoSans(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w700,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withOpacity(0.6),
                                          offset: Offset(2, 2),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                  //already have an account
                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '¿Ya tienes una cuenta? ',
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
                                return LoginScreen();
                              },
                            ),
                          );
                        },
                        child: Text(
                          'Inicia Sesión',
                          style: GoogleFonts.roboto(
                            color: Colors.purple,
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
        ),
      ),
    );
  }
}
