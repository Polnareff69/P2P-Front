import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market/controllers/company_controller.dart';
import 'package:market/models/company_model.dart';
import 'package:market/views/business_screens/menu_navigation/store_preview_screen.dart';
//import 'dart:io';
import 'package:market/views/widgets/floating_menu_button.dart';
import 'package:market/config/app_config.dart'; // aca esta la peticion para ver productos

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CompanyController _companyController =
      CompanyController();
  List<Company> companies = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchCompanies();
  }

  Future<void> fetchCompanies() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final loadedCompanies =
          await _companyController.getAllCompanies();

      setState(() {
        companies = loadedCompanies;
        isLoading = false;
      });

      print('Empresas cargadas: ${companies.length}');

      // debug para ver cuántas empresas tienen imagen
      int empresasConImagen =
          companies
              .where(
                (c) =>
                    c.companyImg != null &&
                    c.companyImg!.isNotEmpty,
              )
              .length;
      print('Empresas con imagen: $empresasConImagen');
    } catch (e) {
      print('Error al obtener empresas: $e');
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      extendBodyBehindAppBar: true,

      // AppBar con fondo transparente
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Empresas',
          style: GoogleFonts.nunito(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 33,
            shadows: [
              Shadow(
                color: Colors.deepPurple.withOpacity(0.8),
                offset: const Offset(1, 3),
                blurRadius: 15,
              ),
              Shadow(
                color: Colors.black.withOpacity(0.6),
                offset: const Offset(2, 4),
                blurRadius: 5,
              ),
            ],
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Colors.white,
              size: 28,
              shadows: [
                Shadow(
                  color: Colors.deepPurpleAccent,
                  offset: Offset(0, 0),
                  blurRadius: 8,
                ),
              ],
            ),
            onPressed: fetchCompanies,
          ),
        ],
      ),

      body: Stack(
        children: [
          // Fondo con gradiente
          /*Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black, Color(0xFF121212)],
              ),
            ),
          ),*/

          // Efecto decorativo
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.purpleAccent.withOpacity(0.2),
                    Colors.deepPurple.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),

          // Efecto decorativo
          Positioned(
            bottom: -80,
            left: -80,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.purpleAccent.withOpacity(0.2),
                    Colors.deepPurple.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),

          // Contenido principal
          SafeArea(
            child:
                isLoading
                    ? _buildLoadingIndicator()
                    : errorMessage != null
                    ? _buildErrorView()
                    : _buildCompanyGrid(),
          ),

          //boton del menu
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
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Colors.deepPurpleAccent,
          ),
          SizedBox(height: 20),
          Text(
            'Cargando Tiendas...',
            style: GoogleFonts.nunito(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 60,
              color: Colors.redAccent,
            ),
            SizedBox(height: 20),
            Text(
              errorMessage ?? 'Error desconocido',
              style: GoogleFonts.nunito(
                fontSize: 16,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: fetchCompanies,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.deepPurpleAccent.shade700,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Reintentar',
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompanyGrid() {
    // Si no hay empresas, mostrar mensaje
    if (companies.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.business,
                size: 60,
                color: Colors.grey,
              ),
              SizedBox(height: 20),
              Text(
                'No hay empresas disponibles',
                style: GoogleFonts.nunito(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                'Crea tu primera empresa o actualiza la lista',
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  color: Colors.white54,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
      itemCount: companies.length,
      physics: AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final company = companies[index];
        return _buildCompanyCard(company);
      },
    );
  }

  Widget _buildCompanyCard(Company company) {
    print('Construyendo tarjeta para: ${company.name}');
    print('Ruta de imagen original: ${company.companyImg}');
    String? imageUrl;

    if (company.companyImg != null &&
        company.companyImg!.isNotEmpty) {
      // Normalizar la ruta reemplazando \\ por /
      String normalizedPath = company.companyImg!
          .replaceAll('\\\\', '/')
          .replaceAll('\\', '/');

      print('Ruta normalizada: $normalizedPath');

      // img servidas desde aws
      imageUrl =
          '${AppConfig.getProductImageUrl()}?fileLocation=${Uri.encodeComponent(normalizedPath)}';
      print('URL final: $imageUrl');
    } else {
      print('La empresa no tiene imagen asociada');
    }

    return GestureDetector(
      onTap: () => _selectCompany(company),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 4,
              offset: Offset(1, 2),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Fondo con imagen o gradiente si no hay imagen
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child:
                  imageUrl != null
                      ? Image.network(
                        imageUrl, // Usar la URL normalizada
                        fit: BoxFit.cover,
                        errorBuilder: (
                          context,
                          error,
                          stackTrace,
                        ) {
                          print(
                            'Error al cargar imagen: $error',
                          );
                          return Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.purple.shade800
                                      .withOpacity(0.7),
                                  Colors
                                      .deepPurple
                                      .shade900,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.business_rounded,
                                size: 40,
                                color: Color(0xFF121212),
                              ),
                            ),
                          );
                        },
                        loadingBuilder: (
                          context,
                          child,
                          loadingProgress,
                        ) {
                          if (loadingProgress == null)
                            return child;
                          return Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.purple.shade800
                                      .withOpacity(0.5),
                                  Colors
                                      .deepPurple
                                      .shade900,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.purpleAccent,
                                value:
                                    loadingProgress
                                                .expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress
                                                .expectedTotalBytes!
                                        : null,
                              ),
                            ),
                          );
                        },
                      )
                      : Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.purple.shade800
                                  .withOpacity(0.7),
                              Colors.deepPurple.shade900,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.business_rounded,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                      ),
            ),

            // Capa oscura degradada para mejorar la legibilidad del texto
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.5),
                  ],
                ),
              ),
            ),

            // Contenido (nombre y descripción en la parte inferior)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment:
                    CrossAxisAlignment.center,
                children: [
                  Spacer(),

                  // Nombre de la empresa
                  Text(
                    company.name ?? 'Sin nombre',
                    style: GoogleFonts.nunito(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          offset: Offset(1, 1),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),

                  // Descripción si existe
                  if (company.description != null &&
                      company.description!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 4,
                      ),
                      child: Text(
                        company.description!,
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          color: Colors.white.withOpacity(
                            0.9,
                          ),
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              offset: Offset(1, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método para seleccionar una empresa y navegar a la pantalla de detalles
  void _selectCompany(Company company) async {
    try {
      // Guardar el ID de la empresa seleccionada
      await _companyController.saveSelectedCompany(
        company.companyId,
      );

      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Empresa seleccionada: ${company.name}',
            style: GoogleFonts.nunito(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.deepPurpleAccent.shade700
              .withOpacity(0.8),
          duration: Duration(seconds: 2),
        ),
      );

      // Navegar a la pantalla StorePreviewScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => StorePreviewScreen(
                businessName: company.name ?? 'Mi Empresa',
                // No podemos convertir directamente la URL a File
                // Por lo que pasamos null y manejamos esto en StorePreviewScreen
                businessLogo: null,
              ),
        ),
      );
    } catch (e) {
      print('Error al seleccionar empresa: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error al seleccionar la empresa: $e',
            style: GoogleFonts.nunito(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.redAccent.withOpacity(
            0.8,
          ),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
