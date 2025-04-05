import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UserScreen extends StatefulWidget {
  final String businessName; // Nombre de la empresa
  //final File? businessLogo; // Logo de la empresa

  const UserScreen({
    super.key,
    required this.businessName,
    //required this.businessLogo,
  });

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  // Variables para la personalización del header y botones
  File? headerBackgroundImage;
  File? profileImage;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_buildHeader(), _buildMenu()],
        ),
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
                blurRadius: 4,
                offset: Offset(1, 5),
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

        // Botón para personalizar header (en la esquina superior derecha)
        Positioned(
          top: 33,
          right: 3,
          child: Container(
            child: IconButton(
              icon: Icon(
                Icons.settings_suggest,
                color: Colors.black,
                size: 44,
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
                  color: Colors.black,
                  width: 4,
                ),
              ),
              child:
                  profileImage != null
                      ? ClipOval(
                        child: Image.file(
                          profileImage!,
                          fit: BoxFit.cover,
                        ),
                      )
                      : null,
            ),

            const SizedBox(height: 5),
            Text(
              widget.businessName,
              style: GoogleFonts.nunitoSans(
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
              "by: ${widget.businessName}",
              style: GoogleFonts.nunitoSans(
                fontSize: 16,
                color: Colors.white70,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 20),
          ],
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
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: Offset(0, -5),
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
                  color: Colors.black,
                  shadows: [
                    Shadow(
                      color: Colors.deepPurple,
                      offset: Offset(0, 2),
                      blurRadius: 15,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 15),
              Divider(),

              // Opción para foto de perfil
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade400,
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
                  ),
                ),
                subtitle: Text(
                  "Elige una imagen de tu galería",
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
                    color: Colors.deepPurple.shade400,
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
                  ),
                ),
                subtitle: Text(
                  "Personaliza el fondo de tu perfil",
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
                    Icons.restore,
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
                            ? Colors.black
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
                            profileImage = null;
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
        const SizedBox(height: 33),
        Text(
          "Menú",
          style: GoogleFonts.nunitoSans(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
          ),
          child: GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            //childAspectRatio: 1,
            crossAxisSpacing: 0,
            mainAxisSpacing: 10,
            children: [
              _buildMenuButton(
                'assets/icons/sells.png',
                "Compras",
                () {
                  // Acción para el botón Compras
                },
              ),
              _buildMenuButton(
                'assets/icons/edit.png',
                "Editar",
                _showEditProfileOptions, // Ahora este botón abre el modal para editar el perfil
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
                "Emprender",
                () {
                  // Acción para el botón Emprender
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
    );
  }

  // Modificado para incluir una función onTap
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
                  offset: Offset(2, 4),
                ),
              ],
            ),
            child: Center(
              child: Image.asset(
                imagePath,
                width: 65,
                height: 65,
                //size: 72,
                color: Colors.black, // Icono en negro
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: GoogleFonts.nunitoSans(
            fontSize: 17,
            fontWeight: FontWeight.w900,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
