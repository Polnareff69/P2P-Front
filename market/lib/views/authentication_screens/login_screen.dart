import 'package:market/views/authentication_screens/forgot_password_screen.dart';
import 'package:market/views/authentication_screens/register_screen.dart';
import 'package:market/views/client_screen/user_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market/views/widgets/remember_me_checkbox.dart';
//To use models and controllers
import 'package:market/controllers/login_controller.dart';
import 'package:market/models/user_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final LoginController _authController = LoginController();
  String _token = "No recibido aún";

  String name = '';
  String password = '';
  //String email = '';
  //String role = '';
  bool isLoading = false;

  Future<void> loginUser() async {
    setState(() {
      isLoading = true;
    });

    try {
      final user = User(name: name, password: password);
      _token = await _authController.loginUser(user) ?? "No recibido aún";
      print("Token recibido: $_token");

      // redirigir al perfil del usuario
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UserScreen(userName: name)),
      );
    } catch (e) {
      print("Error en el login: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error al logearse: $e")));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Agregamos la decoración con la imagen de fondo
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/fondo.png'), // Ruta a tu imagen
            fit: BoxFit.cover, // Para que cubra toda la pantalla
          ),
        ),
        child: Padding(
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
                      "Iniciar Sesión en U-Market",
                      style: GoogleFonts.getFont(
                        'Nunito Sans',
                        color: const Color.fromARGB(255, 255, 255, 255),
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
                        color: const Color.fromARGB(255, 201, 197, 201),
                        fontWeight: FontWeight.bold,
                        //letterSpacing: 0.1,
                        fontSize: 14,
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
                          color: const Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ),
                    //Input from the user_name
                    TextFormField(
                      //grab the info of the user
                      onChanged: (value) {
                        name = value;
                      },
                      //validation of the user input
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nombre Inexistente.';
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
                          color: const Color.fromARGB(255, 255, 255, 255),
                          //letterSpacing: 0.2,
                        ),
                      ),
                    ),
                    //Input of the user password
                    TextFormField(
                      obscureText: true,
                      //grab the info of the user
                      onChanged: (value) {
                        password = value;
                      },
                      //validate input from users
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Contraseña Incorrecta.';
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

                    //Recordar y Recuperar contraseña
                    const SizedBox(height: 13),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RememberMeCheckbox(
                          onChanged: (value) {
                            print("Recordarme: $value");
                            Color.fromARGB(255, 255, 255, 255);
                          },
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ForgotPasswordScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "¿Olvidaste tu contraseña?",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(255, 255, 255, 255),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),

                    //Login Bottom
                    const SizedBox(height: 30),
                    isLoading
                        ? CircularProgressIndicator()
                        : InkWell(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              loginUser();
                              print('userName = $name');
                              print('password = $password');
                            } else {
                              print('Login fallido');
                            }
                          },
                          child: Material(
                            elevation: 10,
                            borderRadius: BorderRadius.circular(80),
                            color: const Color.fromARGB(255, 148, 0, 211),
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
                                              78,
                                              16,
                                              90,
                                            ),
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
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
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
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
                                          color: const Color.fromARGB(
                                            255,
                                            0,
                                            0,
                                            0,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            3,
                                          ),
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
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  //Iniciar Sesion Text
                                  Center(
                                    child: Text(
                                      'Iniciar Sesión',
                                      style: GoogleFonts.nunitoSans(
                                        color: const Color.fromARGB(
                                          255,
                                          255,
                                          255,
                                          255,
                                        ),
                                        fontSize: 25,
                                        fontWeight: FontWeight.w700,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black.withOpacity(
                                              0.6,
                                            ),
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

                    //dont have an account
                    SizedBox(height: 8),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '¿No tienes una cuenta? ',
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w500,
                            color: const Color.fromARGB(255, 255, 255, 255),
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
          ),
        ),
      ),
    );
  }
}
