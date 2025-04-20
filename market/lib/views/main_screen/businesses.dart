import 'package:flutter/material.dart';
import 'package:market/data/businesses_dummy_data.dart';
import 'package:market/views/widgets/businesses_grid_item.dart';
import 'package:google_fonts/google_fonts.dart';

class BusinessesScreen extends StatelessWidget {
  const BusinessesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(
        255,
        34,
        34,
        34,
      ),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(
          255,
          34,
          34,
          34,
        ),
        title: Text(
          "Negocios",
          style: GoogleFonts.lilitaOne(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.purpleAccent,
            shadows: [
              Shadow(
                color: Colors.deepPurple,
                offset: Offset(1, 1),
                blurRadius: 25,
              ),
            ],
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.deepPurpleAccent,
            shadows: [
              Shadow(
                color: Colors.deepPurpleAccent,
                offset: Offset(1, 1),
                blurRadius: 20,
              ),
            ],
          ), // Cambia el icono y el color
          onPressed: () {
            Navigator.pop(
              context,
            ); // Regresar a la pantalla anterior
          },
        ),
      ),

      body: GridView(
        padding: EdgeInsets.all(22),
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
        children: [
          for (final businesses in availableBusinesses)
            BusinessesGridItem(business: businesses),
        ],
      ),
    );
  }
}
