import 'package:market/views/authentication_screens/forgot_password_screen.dart';
import 'package:market/views/authentication_screens/register_screen.dart';
import 'package:market/views/business_screens/vendor_screen.dart';
import 'package:market/views/client_screen/user_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market/views/widgets/remember_me_checkbox.dart';
//To use models and controllers
import 'package:market/controllers/login_controller.dart';
import 'package:market/models/user_model.dart';
import 'package:jwt_decoder/jwt_decoder.dart'; //JWT DECODIFICADOR

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();
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
      _token =
          await _authController.loginUser(user) ??
          "Token no recibido aun";
      print("Token recibido: $_token");

      if (_token != "Token no recibido aun") {
        //decodificamos el token JWT
        Map<String, dynamic> decodedToken =
            JwtDecoder.decode(_token);
        print("Token decodificado: $decodedToken");

        //extraemos la info del token
        String role = decodedToken['Role'] ?? '';
        String email = decodedToken['email'] ?? '';
        String username = decodedToken['sub'] ?? '';

        print("Rol del usuario: $role");
        print("Email del usuario: $email");
        print("Nombre de usuario: $username");

        // redirigimos a perfiles segun el ROL
        if (role.toLowerCase() == 'seller') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (context) => VendorScreen(
                    businessName: username,
                    businessLogo: null,
                  ),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                      UserScreen(userName: username),
            ),
          );
        }
      } else {
        throw Exception("No se recibio un token valido.");
      }
    } catch (e) {
      print("Error en el login: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al logearse: $e")),
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
              'assets/images/background7.jpg', // Usa la misma imagen o cambia a otra que prefieras
              fit: BoxFit.cover,
            ),
          ),

          // Contenido original
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
                        "Iniciar Sesión",
                        style: GoogleFonts.getFont(
                          'Nunito Sans',
                          color: Colors.purpleAccent,
                          fontWeight: FontWeight.w900,
                          //letterSpacing: 0.1,
                          fontSize: 40,
                        ),
                      ),

                      //Message below the title
                      Text(
                        'Sumergete en el Mercado Universitario',
                        style: GoogleFonts.getFont(
                          'Nunito Sans',
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          //letterSpacing: 0.1,
                          fontSize: 17.6,
                        ),
                      ),

                      //const SizedBox(height: 150),
                      //Login Image
                      Image.asset(
                        'assets/images/mano.png',
                        width: 280,
                        height: 255,
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
                        //grab the info of the user
                        onChanged: (value) {
                          name = value;
                        },
                        //validation of the user input
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty) {
                            return 'Nombre Inexistente.';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          fillColor: Colors.black87,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(15),
                          ),
                          //borders
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(15),
                            borderSide:
                                BorderSide
                                    .none, // Sin color cuando está enfocado
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(15),
                            borderSide:
                                BorderSide
                                    .none, // Sin color cuando no está enfocado
                          ),

                          hintText:
                              'Introduce tu nombre de usuario...',
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
                        //grab the info of the user
                        onChanged: (value) {
                          password = value;
                        },
                        //validate input from users
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty) {
                            return 'Contraseña Incorrecta.';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          fillColor: Colors.black87,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(15),
                          ),
                          //borders
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(15),
                            borderSide:
                                BorderSide
                                    .none, // Sin color cuando está enfocado
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(15),
                            borderSide:
                                BorderSide
                                    .none, // Sin color cuando no está enfocado
                          ),
                          hintText:
                              'Introduce tu contraseña...',
                          hintStyle: GoogleFonts.getFont(
                            'Nunito Sans',
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Colors.blueGrey,
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

                      //Remember password and Forgot Password
                      const SizedBox(height: 13),
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
                                fontSize: 15.5,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                decoration:
                                    TextDecoration
                                        .underline,
                              ),
                            ),
                          ),
                        ],
                      ),

                      //Login Bottom
                      const SizedBox(height: 65),
                      isLoading
                          ? CircularProgressIndicator()
                          : InkWell(
                            onTap: () {
                              if (_formKey.currentState!
                                  .validate()) {
                                loginUser();
                                print('userName = $name');
                                print(
                                  'password = $password',
                                );
                              } else {
                                print('Login fallido');
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
                                      'Iniciar Sesión',
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

                      //dont have an account
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          Text(
                            '¿No tienes una cuenta? ',
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w500,
                              //letterSpacing: 1,
                              color: Colors.white,
                              fontSize: 15.5,
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
