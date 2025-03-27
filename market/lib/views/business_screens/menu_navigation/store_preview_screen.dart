import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market/views/business_screens/menu_navigation/upload_product_screen.dart';
import 'dart:io';

class StorePreviewScreen extends StatefulWidget {
  final String businessName;
  final File? businessLogo;

  const StorePreviewScreen({
    Key? key,
    required this.businessName,
    this.businessLogo,
  }) : super(key: key);

  @override
  _StorePreviewScreenState createState() =>
      _StorePreviewScreenState();
}

class _StorePreviewScreenState
    extends State<StorePreviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 18),
            _buildCategoryButtons(),
            // Texto para subir productos
            Padding(
              padding: const EdgeInsets.only(
                top: 10.0,
                bottom: 5.0,
              ),
              child: Text(
                "Sube Tus Productos",
                style: GoogleFonts.nunitoSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            _buildProductGrid(),
          ],
        ),
      ),
    );
  }

  // Header con mismo estilo que VendorScreen
  Widget _buildHeader() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height:
              300, // Altura reducida comparada con VendorScreen
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 4,
                offset: Offset(1, 5),
              ),
            ],
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
            const SizedBox(height: 40),
            Container(
              width:
                  150, // Tamaño más pequeño que en VendorScreen
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black,
                  width: 4,
                ),
              ),
              child: CircleAvatar(
                radius: 48,
                backgroundImage:
                    widget.businessLogo != null
                        ? FileImage(widget.businessLogo!)
                        : null,
                child:
                    widget.businessLogo == null
                        ? Icon(
                          Icons.add,
                          size: 40,
                          color: Colors.white,
                        )
                        : null,
              ),
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
              "By Maria ★",
              style: GoogleFonts.nunitoSans(
                fontSize: 16,
                color: Colors.white70,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
            /*IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 28,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),*/
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryButtons() {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 15),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 10),
        children: [
          _buildCategoryButton("Todo"),
          _buildCategoryButton("Categoría 1"),
          _buildCategoryButton("Categoría 2"),
          _buildCategoryButton("Categoría 3"),
          _buildCategoryButton("Categoría 4"),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String label) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(15),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.purple.shade500,
                Colors.purple.shade900,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 4,
                offset: Offset(2, 3),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 8,
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.nunitoSans(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.5),
                    offset: Offset(1, 1),
                    blurRadius: 3,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(15),
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
          ),
      itemCount: 9, // 9 espacios para productos
      itemBuilder: (context, index) {
        return _buildProductItem();
      },
    );
  }

  Widget _buildProductItem() {
    return GestureDetector(
      onTap: () {
        // Navegar a la pantalla de subir producto
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UploadProductScreen(),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey[300]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.add,
              size: 30,
              color: Colors.black54,
            ),
          ],
        ),
      ),
    );
  }
}
