import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:market/views/business_screens/menu_navigation/upload_product_screen.dart';
import 'package:market/views/business_screens/menu_navigation/store_preview_screen.dart';
//import 'package:image_picker/image_picker.dart';
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

            //color
            gradient: LinearGradient(
              colors: [
                Colors.purple.shade500,
                Colors.purple.shade900,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(44),
              bottomRight: Radius.circular(44),
            ),
          ),
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
              onPressed: () {},
            ),
          ),
        ),

        Column(
          children: [
            const SizedBox(height: 50),
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
              /*
              child: CircleAvatar(
                radius: 73,
                backgroundImage:
                    widget.businessLogo != null
                        ? FileImage(widget.businessLogo!)
                        : AssetImage(
                          'assets/images/profile_photo.jpg',
                        ),
              ),
              */
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
              "by: $widget.businessName",
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

  // Menú con iconos
  Widget _buildMenu() {
    return Column(
      children: [
        const SizedBox(height: 33),
        Text(
          "Menú",
          style: GoogleFonts.nunitoSans(
            fontSize: 25,
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
            crossAxisCount: 2,
            //childAspectRatio: 1,
            crossAxisSpacing: 0,
            mainAxisSpacing: 6,
            children: [
              _buildMenuButton(
                'assets/icons/sells.png',
                "Compras",
              ),
              _buildMenuButton(
                'assets/icons/edit.png',
                "Editar",
              ),
              _buildMenuButton(
                'assets/icons/deliveries.png',
                "Pedidos",
              ),
              _buildMenuButton(
                'assets/icons/star.png',
                "Reseñas",
              ),
              _buildMenuButton(
                'assets/icons/plus.png',
                "Emprender",
              ),
              _buildMenuButton(
                'assets/icons/help.png',
                "Ayuda",
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuButton(String imagePath, String label) {
    return Column(
      children: [
        Container(
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
