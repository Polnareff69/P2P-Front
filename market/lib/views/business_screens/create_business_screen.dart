import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market/views/business_screens/business_or_main_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:market/views/business_screens/vendor_screen.dart';

class CreateBusinessScreen extends StatefulWidget {
  const CreateBusinessScreen({super.key});

  @override
  _CreateBusinessScreenState createState() =>
      _CreateBusinessScreenState();
}

class _CreateBusinessScreenState
    extends State<CreateBusinessScreen> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();

  //user inputs
  String businessName = '';
  String businessNumber = '';
  String businessEmail = '';
  String businessUbication = '';
  String businessDescription = '';
  String businessLogo = '';
  String userId = ''; // primary key from user
  bool isLoading = false;

  Future<void> createBusiness() async {
    setState(() {
      isLoading = true;
    });

    const String apiUrl =
        'http://10.0.2.2:8000/company'; // URL backend FastAPI

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': businessName,
        'phonenumber': businessNumber,
        'description': businessDescription,
        'userid': '9a6f9d95-ded5-4192-8b4c-96269e661d76',
      }),
    );

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 200) {
      print("Empresa Creada: ${response.body}");
      //navegar a perfil de emprendedor
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BusinessOrMainScreen(),
        ),
      );
    } else {
      print("Error al crear Empresa: ${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Error al crear Empresa: ${jsonDecode(response.body)['detail']}",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Crea Tu Propia Empresa',
              style: GoogleFonts.nunitoSans(
                color: Colors.purple,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            Text(
              'Para Hacer Tu Empresa Más Grande',
              style: GoogleFonts.nunitoSans(
                color: const Color.fromARGB(
                  255,
                  28,
                  113,
                  156,
                ),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //user business name
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Nombre de Tu Empresa',
                      style: GoogleFonts.getFont(
                        'Nunito Sans',
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        //letterSpacing: 0.2,
                      ),
                    ),
                  ),

                  //Input from the business name
                  TextFormField(
                    //grab name
                    onChanged: (value) {
                      businessName = value;
                    },

                    //validate info is not empty
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa el nombre de La Empresa.';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          15,
                        ),
                      ),
                      //borders
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          15,
                        ),
                        borderSide:
                            BorderSide
                                .none, // Sin color cuando está enfocado
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          15,
                        ),
                        borderSide:
                            BorderSide
                                .none, // Sin color cuando no está enfocado
                      ),

                      hintText:
                          'Introduce el nombre de tu Empresa...',
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
                          'assets/icons/business_name.png',
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ),
                  ),

                  //Business Number
                  const SizedBox(height: 25),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Número de Tu Empresa',
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
                      businessNumber = value;
                    },
                    //validate the user inputs an email
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa un Numero.';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          15,
                        ),
                      ),
                      // borders
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          15,
                        ),
                        borderSide:
                            BorderSide
                                .none, // Sin color cuando está enfocado
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          15,
                        ),
                        borderSide:
                            BorderSide
                                .none, // Sin color cuando no está enfocado
                      ),

                      hintText:
                          'Introduce el numero de tu Empresa...',
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
                          'assets/icons/phone.png',
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ),
                  ),
                  //Business Number
                  const SizedBox(height: 25),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Correo Empresarial',
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
                      businessEmail = value;
                    },
                    //validate the user inputs an email
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa el Correo de la Empresa.';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          15,
                        ),
                      ),
                      // borders
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          15,
                        ),
                        borderSide:
                            BorderSide
                                .none, // Sin color cuando está enfocado
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          15,
                        ),
                        borderSide:
                            BorderSide
                                .none, // Sin color cuando no está enfocado
                      ),

                      hintText:
                          'Introduce el correo de tu Empresa...',
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
                          'assets/icons/email.png',
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ),
                  ),

                  //business Ubication
                  const SizedBox(height: 25),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Ubicación',
                      style: GoogleFonts.getFont(
                        'Nunito Sans',
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        //letterSpacing: 0.2,
                      ),
                    ),
                  ),
                  //Input of the user university
                  TextFormField(
                    //grab the user's university
                    onChanged: (value) {
                      businessUbication = value;
                    },
                    //validate user's password
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Ingresa la Universidad.';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          15,
                        ),
                      ),
                      //borders
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          15,
                        ),
                        borderSide:
                            BorderSide
                                .none, // Sin color cuando está enfocado
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          15,
                        ),
                        borderSide:
                            BorderSide
                                .none, // Sin color cuando no está enfocado
                      ),
                      hintText: 'Universidad...',
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
                          'assets/icons/location.png',
                          width: 33,
                          height: 33,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),
                  //Business Description
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Descripción General',
                      style: GoogleFonts.getFont(
                        'Nunito Sans',
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        //letterSpacing: 0.2,
                      ),
                    ),
                  ),

                  //Input from the business name
                  TextFormField(
                    //grab name
                    onChanged: (value) {
                      businessDescription = value;
                    },

                    //validate info is not empty
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa una Descripción.';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          15,
                        ),
                      ),
                      //borders
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          15,
                        ),
                        borderSide:
                            BorderSide
                                .none, // Sin color cuando está enfocado
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          15,
                        ),
                        borderSide:
                            BorderSide
                                .none, // Sin color cuando no está enfocado
                      ),

                      hintText:
                          'Describe que hace tu Empresa...',
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
                          'assets/icons/description.png',
                          width: 30,
                          height: 30,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),
                  //Business LOGO
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Logo de Tu Empresa',
                      style: GoogleFonts.getFont(
                        'Nunito Sans',
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        //letterSpacing: 0.2,
                      ),
                    ),
                  ),

                  //Input from the business name
                  TextFormField(
                    //grab name
                    onChanged: (value) {
                      businessLogo = value;
                    },

                    //validate info is not empty
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa un Logo.';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          15,
                        ),
                      ),
                      //borders
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          15,
                        ),
                        borderSide:
                            BorderSide
                                .none, // Sin color cuando está enfocado
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          15,
                        ),
                        borderSide:
                            BorderSide
                                .none, // Sin color cuando no está enfocado
                      ),

                      hintText:
                          'Selecciona el Logo/Foto...',
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
                          'assets/icons/upload_image.png',
                          width: 30,
                          height: 30,
                        ),
                      ),
                    ),
                  ),

                  //Create Business Bottom
                  const SizedBox(height: 30),
                  isLoading
                      ? CircularProgressIndicator()
                      : InkWell(
                        onTap: () async {
                          if (_formKey.currentState!
                              .validate()) {
                            setState(() {
                              isLoading = true;
                            });

                            try {
                              print(
                                "BusinessName = $businessName",
                              );
                              print(
                                "BusinessNumber = $businessNumber",
                              );
                              print(
                                "BusinessDescription = $businessDescription",
                              );
                              print(
                                "BusinessEmail = $businessEmail",
                              );
                              print(
                                "BusinessLogo = $businessLogo",
                              );
                              print(
                                "BusinessUniversity = $businessUbication",
                              );
                              print(
                                "redirigiendo a vendor_screen",
                              );
                              await createBusiness();

                              if (mounted) {
                                // Asegurar que el widget sigue montado antes de navegar
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) =>
                                            VendorScreen(),
                                  ),
                                );
                              }
                            } catch (e) {
                              print(
                                "Error al crear negocio: $e",
                              );
                            } finally {
                              if (mounted) {
                                setState(() {
                                  isLoading =
                                      false; // Ocultar el loading aunque falle
                                });
                              }
                            }
                          } else {
                            print("Ha fallado");
                          }
                        },

                        child: Container(
                          width: 319,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(10),
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
                                top: 40,
                                child: Opacity(
                                  opacity: 0.5,
                                  child: Container(
                                    width: 60,
                                    height: 60,
                                    clipBehavior:
                                        Clip.antiAlias,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 12,
                                        color:
                                            const Color.fromARGB(
                                              255,
                                              38,
                                              43,
                                              46,
                                            ),
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(
                                            30,
                                          ),
                                    ),
                                  ),
                                ),
                              ),

                              Positioned(
                                left: 262,
                                top: 50,
                                child: Opacity(
                                  opacity: 0.3,
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    clipBehavior:
                                        Clip.antiAlias,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 3,
                                      ),
                                      color: Colors.black,
                                      borderRadius:
                                          BorderRadius.circular(
                                            5,
                                          ),
                                    ),
                                  ),
                                ),
                              ),

                              Positioned(
                                left: 300,
                                top: 60,
                                child: Opacity(
                                  opacity: 0.3,
                                  child: Container(
                                    width: 6.5,
                                    height: 6.5,
                                    clipBehavior:
                                        Clip.antiAlias,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(
                                            3,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 258,
                                top: 10,
                                child: Opacity(
                                  opacity: 0.3,
                                  child: Container(
                                    width: 8.5,
                                    height: 8.5,
                                    clipBehavior:
                                        Clip.antiAlias,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(
                                            3,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 275,
                                top: -18,
                                child: Opacity(
                                  opacity: 0.3,
                                  child: Container(
                                    width: 45,
                                    height: 45,
                                    clipBehavior:
                                        Clip.antiAlias,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(
                                            30,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                              //Iniciar Sesion Text
                              Center(
                                child: Text(
                                  '¡Crear Empresa!',
                                  style:
                                      GoogleFonts.getFont(
                                        'Nunito Sans',
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight:
                                            FontWeight.w700,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
