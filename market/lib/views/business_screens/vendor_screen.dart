import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VendorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            _buildUploadButton(),
            _buildMenu(),
          ],
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
                color: Colors.black26,
                blurRadius: 2,
                offset: Offset(3, 5),
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
              child: CircleAvatar(
                radius: 73,
                backgroundImage: AssetImage(
                  'assets/images/profile_photo.jpg',
                ),
              ),
            ),

            const SizedBox(height: 5),
            Text(
              " For Gamers ®",
              style: GoogleFonts.nunitoSans(
                fontSize: 23,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            Text(
              "By Alejo_AM ★",
              style: GoogleFonts.nunitoSans(
                fontSize: 16,
                color: Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Mis Ganancias",
              style: GoogleFonts.nunitoSans(
                fontSize: 19,
                color: Colors.white70,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              "\$42.000.000",
              style: GoogleFonts.nunitoSans(
                fontSize: 33,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(
                  255,
                  77,
                  207,
                  121,
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ],
    );
  }

  // Botón "Subir Productos"
  Widget _buildUploadButton() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Text(
          "Subir Productos",
          style: GoogleFonts.nunitoSans(
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 51, // Ancho del botón
          height: 39, // Alto del botón
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
                color: Colors.black26,
                blurRadius: 2,
                offset: Offset(2, 4),
              ),
            ],
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(
              40,
            ), // Bordes circulares
            onTap: () {
              // Acción del botón
            },
            child: Center(
              child: Icon(
                Icons.add,
                color: Colors.black,
                size: 30, // Tamaño del icono
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Menú con iconos
  Widget _buildMenu() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Text(
          "Menú de For Gamers ®",
          style: GoogleFonts.nunitoSans(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
          ),
        ),
        //const SizedBox(height: 15),
        GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          crossAxisSpacing: 0,
          mainAxisSpacing: 0,
          children: [
            _buildMenuButton(
              'assets/icons/sells.png',
              "Ventas",
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
              "Plus",
            ),
            _buildMenuButton(
              'assets/icons/help.png',
              "Ayuda",
            ),
          ],
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
                color: Colors.black45,
                blurRadius: 2,
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
