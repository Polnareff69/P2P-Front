import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market/controllers/business_controller.dart';
import 'package:market/models/business_model.dart';
import 'package:market/views/business_screens/menu_navigation/store_preview_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:market/services/auth_service.dart';

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
  final BusinessController _businessController =
      BusinessController();
  final ImagePicker _picker = ImagePicker();

  // user inputs
  String businessName = '';
  String businessNumber = '';
  String businessEmail = '';
  String businessUbication = '';
  String businessDescription = '';
  File? businessLogo;
  File? businessBackgroundImage;
  bool isLoading = false;

  // Funcion para escoger una imagen de logo
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (image != null) {
      setState(() {
        businessLogo = File(image.path);
      });
    }
  }

  // Función para seleccionar una imagen de fondo
  Future<void> _pickBackgroundImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (image != null) {
      setState(() {
        businessBackgroundImage = File(image.path);
      });
    }
  }

  Future<void> createBusiness() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Validar que se haya seleccionado una imagen
      if (businessLogo == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Por favor, selecciona un logo para tu empresa.",
            ),
          ),
        );
        setState(() {
          isLoading = false;
        });
        return;
      }

      // Crear una imagen de fondo por defecto si el usuario no la ha seleccionado
      // Esta imagen se utilizará como fondo de empresa
      //File backgroundImage;
      if (businessBackgroundImage == null) {
        // usar una imagen de fondo por defecto desde los assets
        // O mostrar un mensaje pidiendo al usuario que seleccione una imagen de fondo
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Por favor, selecciona una imagen de fondo para tu empresa.",
            ),
          ),
        );

        setState(() {
          isLoading = false;
        });
        return;
      }

      if (kDebugMode) {
        print('🔍 ANTES de crear empresa:');
        AuthService.instance.printCurrentState();
      }

      // Crear la empresa
      final business = Business(
        name: businessName,
        phonenumber: businessNumber,
        description: businessDescription,
      );

      // Llamada al controlador con el objeto business y los archivos de imagen
      await _businessController.createBusiness(
        business,
        businessLogo!,
        businessBackgroundImage!,
      );

      // 🔍 DEBUG: Verificar estado después de crear empresa
      if (kDebugMode) {
        print('🔍 DESPUÉS de crear empresa:');
        AuthService.instance.printCurrentState();
      }

      // 🚀 ASEGURAR que el rol esté actualizado
      if (!AuthService.instance.isSeller) {
        if (kDebugMode)
          print(
            '⚠️ Rol no actualizado, forzando actualización...',
          );

        // Esperar un momento y recargar
        await Future.delayed(Duration(milliseconds: 500));
        await AuthService.instance.reloadUserData();

        // Si aún no es seller, forzar la actualización
        if (!AuthService.instance.isSeller) {
          if (kDebugMode)
            print('🔧 Forzando rol a seller...');
          await AuthService.instance.updateUserRole(
            'seller',
          );
        }
      }

      // Verificación final
      if (kDebugMode) {
        print('🔍 VERIFICACIÓN FINAL:');
        AuthService.instance.printCurrentState();
      }

      // Obtener el company_id recién guardado
      final prefs = await SharedPreferences.getInstance();
      final companyId = prefs.getString('company_id');
      print(
        'Empresa creada exitosamente con ID: $companyId',
      );

      // Mostrar mensaje de éxito
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '¡Felicidades! Tu empresa ha sido creada exitosamente. Ahora eres un emprendedor.',
              style: GoogleFonts.nunito(
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.green.shade700,
            duration: Duration(seconds: 3),
          ),
        );
      }

      // Esperar un momento para que se vea el mensaje
      await Future.delayed(Duration(milliseconds: 1500));

      // Navegar a VendorScreen solo si la creación fue exitosa
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (context) => StorePreviewScreen(
                  businessName: businessName,
                  businessLogo: businessLogo,
                ),
          ),
        );
      }
    } catch (e) {
      // Manejar errores y mostrar un mensaje al usuario
      if (kDebugMode) print('❌ Error al crear empresa: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al crear empresa: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      // Ocultar el indicador de carga
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Aplicar configuración para pantalla inmersiva
      extendBodyBehindAppBar: true,

      // AppBar con fondo transparente
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.deepPurple,
                offset: Offset(1, 1),
                blurRadius: 15,
              ),
            ],
          ), // Cambia el icono y el color
          onPressed: () {
            Navigator.pop(
              context,
            ); // Regresar a la pantalla anterior
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Cumple tu sueño',
              style: GoogleFonts.nunitoSans(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 30,
                shadows: [
                  Shadow(
                    color: Colors.deepPurple.withOpacity(
                      0.8,
                    ),
                    offset: const Offset(1, 3),
                    blurRadius: 10,
                  ),
                  Shadow(
                    color: Colors.black.withOpacity(0.6),
                    offset: const Offset(2, 4),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
            Text(
              '¡Crea tu tienda y emprende nosotros!',
              style: GoogleFonts.nunitoSans(
                color: Colors.white,
                fontSize: 13.8,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),

      // Body con fondo de imagen
      body: Stack(
        children: [
          // Fondo con imagen
          Positioned.fill(
            child: Image.asset(
              'assets/images/background9.png',
              fit: BoxFit.cover,
            ),
          ),

          // Capa oscura para mejor legibilidad
          Positioned.fill(
            child: Container(
              color: Color(0xFF121212).withOpacity(0.6),
            ),
          ),

          // Contenido del formulario
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Color(
                          0xFF121212,
                        ).withOpacity(0.7),
                        borderRadius: BorderRadius.circular(
                          20,
                        ),
                        border: Border.all(
                          color: Colors.white.withOpacity(
                            0.3,
                          ),
                          width: 3,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.start,
                        children: [
                          // Business LOGO
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Logo de tu Negocio',
                              style: GoogleFonts.nunitoSans(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                          // Input from the business logo
                          GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              width: double.infinity,
                              height: 150,
                              decoration: BoxDecoration(
                                color: Colors.grey[800]
                                    ?.withOpacity(0.5),
                                borderRadius:
                                    BorderRadius.circular(
                                      15,
                                    ),
                              ),
                              child:
                                  businessLogo == null
                                      ? Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment
                                                  .center,
                                          children: [
                                            Icon(
                                              Icons
                                                  .add_a_photo,
                                              size: 40,
                                              color:
                                                  Colors
                                                      .purpleAccent,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              'Logo de tu Negocio',
                                              style: GoogleFonts.nunitoSans(
                                                color:
                                                    Colors
                                                        .grey[400],
                                                fontSize:
                                                    16,
                                                fontWeight:
                                                    FontWeight
                                                        .bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                      : ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(
                                              15,
                                            ),
                                        child: Image.file(
                                          businessLogo!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                            ),
                          ),

                          const SizedBox(height: 15),
                          // Background Image
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Imagen de Fondo',
                              style: GoogleFonts.nunitoSans(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                          // Input for the business background
                          GestureDetector(
                            onTap: _pickBackgroundImage,
                            child: Container(
                              width: double.infinity,
                              height: 150,
                              decoration: BoxDecoration(
                                color: Colors.grey[800]
                                    ?.withOpacity(0.5),
                                borderRadius:
                                    BorderRadius.circular(
                                      15,
                                    ),
                              ),
                              child:
                                  businessBackgroundImage ==
                                          null
                                      ? Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment
                                                  .center,
                                          children: [
                                            Icon(
                                              Icons
                                                  .imagesearch_roller_rounded,
                                              size: 42,
                                              color:
                                                  Colors
                                                      .purpleAccent,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              'Fondo de tu Negocio',
                                              style: GoogleFonts.nunitoSans(
                                                color:
                                                    Colors
                                                        .grey[400],
                                                fontSize:
                                                    16,
                                                fontWeight:
                                                    FontWeight
                                                        .bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                      : ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(
                                              15,
                                            ),
                                        child: Image.file(
                                          businessBackgroundImage!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          // Business Name
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Nombre de tu Negocio',
                              style: GoogleFonts.nunitoSans(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          TextFormField(
                            onChanged: (value) {
                              businessName = value;
                            },
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty) {
                                return 'Aquí el nombre de tu Negocio.';
                              } else {
                                return null;
                              }
                            },
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              fillColor: Colors.grey[800]
                                  ?.withOpacity(0.5),
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                      15,
                                    ),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder:
                                  OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(
                                          15,
                                        ),
                                    borderSide: BorderSide(
                                      color:
                                          Colors
                                              .purpleAccent,
                                      width: 1.5,
                                    ),
                                  ),
                              enabledBorder:
                                  OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(
                                          15,
                                        ),
                                    borderSide:
                                        BorderSide.none,
                                  ),
                              hintText:
                                  'Aquí nombre de tu Negocio...',
                              hintStyle:
                                  GoogleFonts.nunitoSans(
                                    fontSize: 14,
                                    fontWeight:
                                        FontWeight.w600,
                                    color: Colors.grey[400],
                                  ),
                              prefixIcon: Padding(
                                padding:
                                    const EdgeInsets.all(
                                      10.0,
                                    ),
                                child: Image.asset(
                                  'assets/icons/business_name.png',
                                  width: 20,
                                  height: 20,
                                  color:
                                      Colors.purpleAccent,
                                ),
                              ),
                            ),
                          ),

                          // Business Number
                          const SizedBox(height: 15),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Número de tu Negocio',
                              style: GoogleFonts.nunitoSans(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          TextFormField(
                            onChanged: (value) {
                              businessNumber = value;
                            },
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty) {
                                return 'Aqui el número.';
                              } else {
                                return null;
                              }
                            },
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              fillColor: Colors.grey[800]
                                  ?.withOpacity(0.5),
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                      15,
                                    ),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder:
                                  OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(
                                          15,
                                        ),
                                    borderSide: BorderSide(
                                      color:
                                          Colors
                                              .purpleAccent,
                                      width: 1,
                                    ),
                                  ),
                              enabledBorder:
                                  OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(
                                          15,
                                        ),
                                    borderSide:
                                        BorderSide.none,
                                  ),
                              hintText:
                                  'Aquí número de contacto...',
                              hintStyle:
                                  GoogleFonts.nunitoSans(
                                    fontSize: 14,
                                    fontWeight:
                                        FontWeight.w600,
                                    color: Colors.grey[400],
                                  ),
                              prefixIcon: Padding(
                                padding:
                                    const EdgeInsets.all(
                                      10.0,
                                    ),
                                child: Image.asset(
                                  'assets/icons/phone.png',
                                  width: 20,
                                  height: 20,
                                  color:
                                      Colors.purpleAccent,
                                ),
                              ),
                            ),
                          ),

                          // Business Email
                          const SizedBox(height: 15),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Correo',
                              style: GoogleFonts.nunitoSans(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          TextFormField(
                            onChanged: (value) {
                              businessEmail = value;
                            },
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty) {
                                return 'Aquí correo de contacto.';
                              } else {
                                return null;
                              }
                            },
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              fillColor: Colors.grey[800]
                                  ?.withOpacity(0.5),
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                      15,
                                    ),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder:
                                  OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(
                                          15,
                                        ),
                                    borderSide: BorderSide(
                                      color:
                                          Colors
                                              .purpleAccent,
                                      width: 1,
                                    ),
                                  ),
                              enabledBorder:
                                  OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(
                                          15,
                                        ),
                                    borderSide:
                                        BorderSide.none,
                                  ),
                              hintText:
                                  'Aquí correo de contacto...',
                              hintStyle:
                                  GoogleFonts.nunitoSans(
                                    fontSize: 14,
                                    fontWeight:
                                        FontWeight.w600,
                                    color: Colors.grey[400],
                                  ),
                              prefixIcon: Padding(
                                padding:
                                    const EdgeInsets.all(
                                      10.0,
                                    ),
                                child: Image.asset(
                                  'assets/icons/email.png',
                                  width: 20,
                                  height: 20,
                                  color:
                                      Colors.purpleAccent,
                                ),
                              ),
                            ),
                          ),

                          // Business Location
                          const SizedBox(height: 15),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Ubicación',
                              style: GoogleFonts.nunitoSans(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          TextFormField(
                            onChanged: (value) {
                              businessUbication = value;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Ingresa la Universidad.';
                              } else {
                                return null;
                              }
                            },
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              fillColor: Colors.grey[800]
                                  ?.withOpacity(0.5),
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                      15,
                                    ),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder:
                                  OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(
                                          15,
                                        ),
                                    borderSide: BorderSide(
                                      color:
                                          Colors
                                              .purpleAccent,
                                      width: 1,
                                    ),
                                  ),
                              enabledBorder:
                                  OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(
                                          15,
                                        ),
                                    borderSide:
                                        BorderSide.none,
                                  ),
                              hintText: 'Universidad...',
                              hintStyle:
                                  GoogleFonts.nunitoSans(
                                    fontSize: 14,
                                    fontWeight:
                                        FontWeight.w600,
                                    color: Colors.grey[400],
                                  ),
                              prefixIcon: Padding(
                                padding:
                                    const EdgeInsets.all(
                                      10.0,
                                    ),
                                child: Image.asset(
                                  'assets/icons/location.png',
                                  width: 33,
                                  height: 33,
                                  color:
                                      Colors.purpleAccent,
                                ),
                              ),
                            ),
                          ),

                          // Business Description
                          const SizedBox(height: 15),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Descripción General',
                              style: GoogleFonts.nunitoSans(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          TextFormField(
                            onChanged: (value) {
                              businessDescription = value;
                            },
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty) {
                                return 'Aquí cuentanos sobre tu Negocio.';
                              } else {
                                return null;
                              }
                            },
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            maxLines: 2,
                            decoration: InputDecoration(
                              fillColor: Colors.grey[800]
                                  ?.withOpacity(0.5),
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                      15,
                                    ),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder:
                                  OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(
                                          15,
                                        ),
                                    borderSide: BorderSide(
                                      color:
                                          Colors
                                              .purpleAccent,
                                      width: 1,
                                    ),
                                  ),
                              enabledBorder:
                                  OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(
                                          15,
                                        ),
                                    borderSide:
                                        BorderSide.none,
                                  ),
                              hintText:
                                  'Aquí cuentanos sobre tu Negocio...',
                              hintStyle:
                                  GoogleFonts.nunitoSans(
                                    fontSize: 14,
                                    fontWeight:
                                        FontWeight.w600,
                                    color: Colors.grey[400],
                                  ),
                              prefixIcon: Padding(
                                padding:
                                    const EdgeInsets.all(
                                      10.0,
                                    ),
                                child: Image.asset(
                                  'assets/icons/description.png',
                                  width: 30,
                                  height: 30,
                                  color:
                                      Colors.purpleAccent,
                                ),
                              ),
                            ),
                          ),

                          // Create Business Button
                          const SizedBox(height: 30),
                          isLoading
                              ? CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<
                                      Color
                                    >(Colors.purpleAccent),
                              )
                              : InkWell(
                                onTap: () async {
                                  if (_formKey.currentState!
                                      .validate()) {
                                    await createBusiness();
                                  }
                                },
                                child: Container(
                                  width: 319,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(
                                          25,
                                        ),
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.purpleAccent,
                                        const Color.fromARGB(
                                          255,
                                          59,
                                          19,
                                          170,
                                        ),
                                      ],
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      // Efectos decorativos (mantener igual)
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
                                        top: 60,
                                        child: Opacity(
                                          opacity: 0.3,
                                          child: Container(
                                            width: 10,
                                            height: 10,
                                            clipBehavior:
                                                Clip.antiAlias,
                                            decoration: BoxDecoration(
                                              border:
                                                  Border.all(
                                                    width:
                                                        3,
                                                  ),
                                              color:
                                                  Colors
                                                      .black,
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
                                              color:
                                                  Colors
                                                      .white,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    3,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 65,
                                        top: 10,
                                        child: Opacity(
                                          opacity: 0.3,
                                          child: Container(
                                            width: 8.5,
                                            height: 8.5,
                                            clipBehavior:
                                                Clip.antiAlias,
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors
                                                      .white,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    3,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 18,
                                        top: -18,
                                        child: Opacity(
                                          opacity: 0.3,
                                          child: Container(
                                            width: 45,
                                            height: 45,
                                            clipBehavior:
                                                Clip.antiAlias,
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors
                                                      .white,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    30,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      // Texto del botón
                                      Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment
                                                  .center,
                                          children: [
                                            Icon(
                                              Icons
                                                  .rocket_launch_rounded,
                                              color:
                                                  Colors
                                                      .white,
                                              size: 26,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              '¡Quiero Emprender!',
                                              style: GoogleFonts.nunitoSans(
                                                color:
                                                    Colors
                                                        .white,
                                                fontSize:
                                                    25,
                                                fontWeight:
                                                    FontWeight
                                                        .w800,
                                              ),
                                            ),
                                          ],
                                        ),
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
