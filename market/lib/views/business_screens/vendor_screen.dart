import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market/views/business_screens/menu_navigation/store_preview_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:market/views/widgets/custom_back_button.dart';
import 'package:market/views/widgets/floating_menu_button.dart'; // menu

class VendorScreen extends StatefulWidget {
  final String businessName; // Nombre de la empresa
  final File? businessLogo; // Logo de la empresa

  const VendorScreen({
    super.key,
    required this.businessName,
    required this.businessLogo,
  });

  @override
  _VendorScreenState createState() => _VendorScreenState();
}

class _VendorScreenState extends State<VendorScreen> {
  // Variables para la personalización del header y botones
  File? headerBackgroundImage;
  File? profileImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Inicializa profileImage con businessLogo si está disponible
    if (widget.businessLogo != null) {
      profileImage = widget.businessLogo;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //fondo de color oscuro
      backgroundColor: Color(0xFF121212),
      body: Stack(
        children: [
          // Contenido principal (ScrollView)
          SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(),
                _buildUploadButton(context),
                _buildMenu(),
                // Espacio adicional en la parte inferior para evitar que el contenido
                // quede oculto detrás del FloatingMenuButton
                SizedBox(height: 80),
              ],
            ),
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: FloatingMenuButton(
                logoAssetPath:
                    'assets/images/UMarketLogoNoBackground.png',
              ),
            ),
          ),

          // FloatingMenuButton en la parte inferior
        ],
      ),
    );
  }

  // Header con foto de perfil y ganancias
  Widget _buildHeader() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Fondo del header (personalizable o gradiente por defecto)
        Container(
          height: 396,
          decoration: BoxDecoration(
            // shadow
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 5,
                offset: Offset(1, 4.5),
              ),
            ],

            // Imagen de fondo o gradiente por defecto
            image:
                headerBackgroundImage != null
                    ? DecorationImage(
                      image: FileImage(
                        headerBackgroundImage!,
                      ),
                      fit: BoxFit.cover,
                    )
                    : null,
            gradient:
                headerBackgroundImage == null
                    ? LinearGradient(
                      colors: [
                        Colors.purple.shade500,
                        Colors.purple.shade900,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                    : null,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(44),
              bottomRight: Radius.circular(44),
            ),
          ),

          // Overlay oscuro si hay imagen de fondo para mejorar la legibilidad
          child:
              headerBackgroundImage != null
                  ? Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.5),
                          Colors.black.withOpacity(0.3),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(44),
                        bottomRight: Radius.circular(44),
                      ),
                    ),
                  )
                  : null,
        ),
        // NUEVO: Botón para volver atrás usando el widget CustomBackButton
        Positioned(
          top: 42,
          left: 15,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            // Usamos el widget personalizado
            child: BackIcon(
              iconColor: Colors.black,
              size: 25,
              shadowColor: Colors.black,
            ),
          ),
        ),

        // Botón para personalizar header (en la esquina superior derecha)
        Positioned(
          top: 30,
          right: 3,
          child: Container(
            child: IconButton(
              icon: Icon(
                Icons.settings_suggest,
                color: Colors.black,
                size: 44,
                shadows: [Shadow(color: Colors.black)],
              ),
              onPressed: () {
                // Este botón se usará para otras funcionalidades en el futuro
              },
            ),
          ),
        ),

        Column(
          children: [
            const SizedBox(height: 50),
            // Contenedor de la foto de perfil
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black26,
                  width: 5,
                ),
              ),
              child: CircleAvatar(
                radius: 73,
                backgroundImage:
                    profileImage != null
                        ? FileImage(profileImage!)
                        : (widget.businessLogo != null
                            ? FileImage(
                              widget.businessLogo!,
                            )
                            : AssetImage(
                                  'assets/images/ejecutivo.jpg',
                                )
                                as ImageProvider),
              ),
            ),

            const SizedBox(height: 5),
            Text(
              widget.businessName,
              style: GoogleFonts.nunito(
                fontSize: 23,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black,
                    offset: Offset(1, 1),
                    blurRadius: 25,
                  ),
                ],
              ),
            ),
            Text(
              "By Alejo_AM ★",
              style: GoogleFonts.nunito(
                fontSize: 16,
                color: Colors.white70,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Mis Ganancias",
              style: GoogleFonts.nunito(
                fontSize: 19,
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
                shadows: [
                  Shadow(
                    color: Colors.deepPurple.withOpacity(
                      0.5,
                    ),
                    offset: const Offset(0, 2),
                    blurRadius: 10,
                  ),
                  Shadow(
                    color: Colors.black.withOpacity(0.6),
                    offset: const Offset(1, 3),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
            Text(
              "\$42.000.000",
              style: GoogleFonts.nunitoSans(
                fontSize: 33,
                fontWeight: FontWeight.w900,
                color: const Color.fromARGB(
                  255,
                  77,
                  207,
                  121,
                ),
                shadows: [
                  Shadow(
                    color: Colors.deepPurple.withOpacity(
                      0.5,
                    ),
                    offset: const Offset(0, 2),
                    blurRadius: 20,
                  ),
                  Shadow(
                    color: Colors.black.withOpacity(0.6),
                    offset: const Offset(1, 3),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ],
    );
  }

  // Botón "Subir Productos" con fondo elegante
  Widget _buildUploadButton(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 25),

        // Título con fondo transparente y borde morado
        Container(
          padding: EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 10,
          ),
          margin: EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            // Fondo transparente con efecto glaseado
            gradient: LinearGradient(
              colors: [
                Colors.purpleAccent.withOpacity(0.1),
                Colors.deepPurpleAccent.withOpacity(0.15),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            // Borde delineado en morado
            border: Border.all(
              color: Colors.purple.shade400,
              width: 1.2,
            ),
            borderRadius: BorderRadius.circular(15),
            // Efecto de brillo con sombra sutil
            boxShadow: [
              BoxShadow(
                color: Colors.purple.shade700.withOpacity(
                  0.25,
                ),
                blurRadius: 8,
                spreadRadius: 0,
                offset: Offset(0, 2),
              ),
              // Brillo interior
              BoxShadow(
                color: Colors.purple.shade300.withOpacity(
                  0.1,
                ),
                blurRadius: 6,
                spreadRadius: -1,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: Text(
            "Subir Productos",
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
              fontSize: 17,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.deepPurple.withOpacity(0.6),
                  offset: const Offset(1, 1),
                  blurRadius: 5,
                ),
                Shadow(
                  color: Colors.black.withOpacity(0.5),
                  offset: const Offset(0, 2),
                  blurRadius: 3,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 8),
        Container(
          width: 59, // Ancho del botón
          height: 47, // Alto del botón
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.purple.shade500,
                Colors.purple.shade900,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 4,
                offset: Offset(1, 2),
              ),
            ],
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(
              40,
            ), // Bordes circulares
            onTap: () {
              // Acción del botón
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => StorePreviewScreen(
                        businessName: widget.businessName,
                        businessLogo:
                            profileImage ??
                            widget.businessLogo,
                      ),
                ),
              );
            },
            child: Center(
              child: Icon(
                Icons.add,
                color: Color(0xFF121212),
                size: 35, // Tamaño del icono
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Mostrar opciones para personalizar el perfil
  void _showEditProfileOptions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Color(0xFF121212),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 54, 2, 78),
                blurRadius: 10,
                offset: Offset(1, -5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Indicador de arrastrar
              Container(
                width: 60,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(5),
                ),
                margin: EdgeInsets.only(bottom: 20),
              ),

              // Título
              Text(
                "Personalizar Perfil",
                style: GoogleFonts.nunitoSans(
                  fontWeight: FontWeight.w900,
                  fontSize: 26,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: const Color.fromARGB(
                        255,
                        54,
                        2,
                        78,
                      ),
                      offset: Offset(0, 2),
                      blurRadius: 15,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 5),
              Divider(),

              // Opción para foto de perfil
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent.shade700,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.photo_camera,
                    color: Colors.black,
                    size: 33,
                  ),
                ),
                title: Text(
                  "Cambiar foto de perfil",
                  style: GoogleFonts.nunitoSans(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ),
                subtitle: Text(
                  "Elige una imagen de tu galería",
                  style: TextStyle(color: Colors.white54),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickProfileImage();
                },
              ),
              Divider(),

              // Opción para imagen de fondo
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent.shade700,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.imagesearch_roller,
                    color: Colors.black,
                    size: 33,
                  ),
                ),
                title: Text(
                  "Cambiar imagen de fondo",
                  style: GoogleFonts.nunitoSans(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ),
                subtitle: Text(
                  "Personaliza el fondo de tu perfil",
                  style: TextStyle(color: Colors.white54),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickHeaderImage();
                },
              ),
              Divider(),

              // Opción para restaurar valores predeterminados
              ListTile(
                enabled:
                    profileImage != null ||
                    headerBackgroundImage != null,
                leading: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color:
                        (profileImage != null ||
                                headerBackgroundImage !=
                                    null)
                            ? Colors.red.withOpacity(0.1)
                            : Colors.grey.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.restore_rounded,
                    color:
                        (profileImage != null ||
                                headerBackgroundImage !=
                                    null)
                            ? Colors.red
                            : Colors.grey,
                    size: 28,
                  ),
                ),
                title: Text(
                  "Restaurar valores predeterminados",
                  style: GoogleFonts.nunitoSans(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color:
                        (profileImage != null ||
                                headerBackgroundImage !=
                                    null)
                            ? Colors.white70
                            : Colors.grey,
                  ),
                ),
                subtitle: Text(
                  "Eliminar imágenes personalizadas",
                  style: TextStyle(
                    color:
                        (profileImage != null ||
                                headerBackgroundImage !=
                                    null)
                            ? Colors.grey.shade600
                            : Colors.grey.shade400,
                  ),
                ),
                onTap:
                    (profileImage != null ||
                            headerBackgroundImage != null)
                        ? () {
                          setState(() {
                            profileImage =
                                widget
                                    .businessLogo; // Restaurar al logo original
                            headerBackgroundImage = null;
                          });
                          Navigator.pop(context);
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Perfil restaurado a valores predeterminados',
                              ),
                              backgroundColor:
                                  Colors.green.shade600,
                              behavior:
                                  SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                      10,
                                    ),
                              ),
                            ),
                          );
                        }
                        : null,
              ),
              SizedBox(height: 15),
            ],
          ),
        );
      },
    );
  }

  // Seleccionar imagen para el perfil
  Future<void> _pickProfileImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          profileImage = File(pickedFile.path);
        });

        // Muestra un mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Foto de perfil actualizada'),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      print("Error al seleccionar imagen: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al seleccionar imagen'),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  // Seleccionar imagen para el fondo del header
  Future<void> _pickHeaderImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );

      if (pickedFile != null) {
        setState(() {
          headerBackgroundImage = File(pickedFile.path);
        });

        // Muestra un mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Imagen de fondo actualizada'),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      print("Error al seleccionar imagen de fondo: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error al seleccionar imagen de fondo',
          ),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  // Menú con iconos
  Widget _buildMenu() {
    return Column(
      children: [
        // Integración del título del menú y botones en un solo contenedor
        Container(
          margin: EdgeInsets.only(top: 30),
          child: Column(
            children: [
              // Título integrado con los botones
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 20,
                ),
                margin: EdgeInsets.only(bottom: 28),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.purpleAccent.withOpacity(0.1),
                      Colors.deepPurpleAccent.withOpacity(
                        0.15,
                      ),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: Colors.purple.shade400,
                    width: 1.2,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.shade700
                          .withOpacity(0.25),
                      blurRadius: 8,
                      spreadRadius: 0,
                      offset: Offset(0, 2),
                    ),
                    // Brillo interior
                    BoxShadow(
                      color: Colors.purple.shade300
                          .withOpacity(0.1),
                      blurRadius: 6,
                      spreadRadius: -1,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),

                child: Text(
                  "Menú For Gamers ®",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(
                          0.6,
                        ),
                        offset: const Offset(1, 1),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                ),
              ),
              // Los botones inmediatamente después del título
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  crossAxisSpacing: 3,
                  mainAxisSpacing: 3,
                  padding:
                      EdgeInsets
                          .zero, // Elimina padding predeterminado
                  childAspectRatio:
                      0.9, // Ajusta para que los botones no sean tan altos
                  children: [
                    _buildMenuButton(
                      'assets/icons/sells.png',
                      "Ventas",
                      () {
                        // Acción para el botón Ventas
                      },
                    ),
                    _buildMenuButton(
                      'assets/icons/edit.png',
                      "Editar",
                      _showEditProfileOptions,
                    ),
                    _buildMenuButton(
                      'assets/icons/deliveries.png',
                      "Pedidos",
                      () {
                        // Acción para el botón Pedidos
                      },
                    ),
                    _buildMenuButton(
                      'assets/icons/star.png',
                      "Reseñas",
                      () {
                        // Acción para el botón Reseñas
                      },
                    ),
                    _buildMenuButton(
                      'assets/icons/plus.png',
                      "Plus",
                      () {
                        // Acción para el botón Plus
                      },
                    ),
                    _buildMenuButton(
                      'assets/icons/help.png',
                      "Ayuda",
                      () {
                        // Acción para el botón Ayuda
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuButton(
    String imagePath,
    String label,
    VoidCallback onTap,
  ) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 100,
            height: 92,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.purple.shade500,
                  Colors.purple.shade900,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              //color: Colors.purple, // Color de fondo
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 4,
                  offset: Offset(1, 2),
                ),
              ],
            ),
            child: Center(
              child: Image.asset(
                imagePath,
                width: 65,
                height: 65,
                //size: 72,
                color: Color(0xFF121212), // Icono en negro
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: GoogleFonts.nunito(
            fontSize: 17,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.deepPurple.withOpacity(0.5),
                offset: const Offset(0, 2),
                blurRadius: 10,
              ),
              Shadow(
                color: Colors.black.withOpacity(0.6),
                offset: const Offset(1, 3),
                blurRadius: 4,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
