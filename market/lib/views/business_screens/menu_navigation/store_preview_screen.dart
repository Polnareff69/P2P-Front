import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market/views/business_screens/menu_navigation/upload_product_screen.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart'; //seleccionar imagenes
import 'package:flutter_colorpicker/flutter_colorpicker.dart'; //seleccionar colores
//obtener
import 'package:market/controllers/upload_product_controller.dart';
import 'package:market/models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


class StorePreviewScreen extends StatefulWidget {
  final String businessName;
  final File? businessLogo;

  const StorePreviewScreen({
    super.key,
    required this.businessName,
    this.businessLogo,
  });

  @override
  _StorePreviewScreenState createState() =>
      _StorePreviewScreenState();
}

class _StorePreviewScreenState
    extends State<StorePreviewScreen> {
  //Variables para trackear los productos de la empresa

  List<Product> products = [];
  bool isLoading = true;
  final UploadProductController _productController =
      UploadProductController();

  // Método initState para cargar productos al iniciar la pantalla

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  // Método para cargar los productos
  Future<void> _loadProducts() async {
    setState(() {
      isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final companyId = prefs.getString('company_id');

      if (companyId == null) {
        throw Exception('No hay ID de empresa almacenado');
      }

      final loadedProducts = await _productController
          .getCompanyProducts(companyId);

      setState(() {
        products = loadedProducts;
        isLoading = false;
      });

      print('Productos cargados: ${products.length}');
    } catch (e) {
      print('Error al cargar productos: $e');
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar productos: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Lista para almacenar las categorías dinámicas
  List<String> categories = ["Todo"];
  String selectedCategory = "Todo";

  // Variables para la personalización del header y botones
  File? headerBackgroundImage;
  bool useCustomColor = false;
  Color startColor = Colors.purple.shade500;
  Color endColor = Colors.purple.shade900;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 22),

            // Título con fondo transparente y borde morado
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 5,
                horizontal: 10,
              ),
              margin: EdgeInsets.only(bottom: 1),
              decoration: BoxDecoration(
                // Fondo transparente con efecto glaseado
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
                // Borde delineado en morado
                border: Border.all(
                  color: Colors.purple.shade400,
                  width: 1.2,
                ),
                borderRadius: BorderRadius.circular(15),
                // Efecto de brillo con sombra sutil
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
                "Categorías",
                style: GoogleFonts.nunito(
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 7),
            _buildCategoryButtons(),
            const SizedBox(height: 13),

            // Título con fondo transparente y borde morado
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 7,
                horizontal: 12,
              ),
              margin: EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                // Fondo transparente con efecto glaseado
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
                // Borde delineado en morado
                border: Border.all(
                  color: Colors.purple.shade400,
                  width: 1.2,
                ),
                borderRadius: BorderRadius.circular(15),
                // Efecto de brillo con sombra sutil
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
                "Mis Productos",
                style: GoogleFonts.nunito(
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            _buildProductGrid(),
          ],
        ),
      ),
      /*
      floatingActionButton: FloatingActionButton(
        onPressed: _showCustomizeHeaderOptions,
        backgroundColor: const Color.fromARGB(
          193,
          74,
          20,
          140,
        ),
        //child: Icon(Icons.edit, color: Colors.white),
        tooltip: "Personalizar tema",
        child: Image.asset(
          'assets/icons/edit.png',
          width: 35,
          height: 35,
          color: Color(0xFF121212),
        ),
      ),*/
    );
  }

  // Header con estilo personalizable
  Widget _buildHeader() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Contenedor del fondo
        Container(
          height: 320,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 4,
                offset: Offset(1, 5),
              ),
            ],
            // Determinar el fondo basado en si usa imagen o gradiente de color
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
                      colors: [startColor, endColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                    : null,
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
                Icons.settings_suggest_outlined,
                color: Color(0xFF121212),
                size: 44,
              ),
              onPressed: _showCustomizeHeaderOptions,
            ),
          ),
        ),

        // Contenido principal del header
        Column(
          children: [
            const SizedBox(height: 40),
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
              "By Alejo_AM ★",
              style: GoogleFonts.nunitoSans(
                fontSize: 16,
                color: Colors.white70,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Mostrar opciones para personalizar el header y botones
  void _showCustomizeHeaderOptions() {
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
              // Título
              Text(
                "Personalizar Catálogo",
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
              SizedBox(height: 10),
              Divider(),

              // Opciones
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8),
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
                  "Elegir imagen de fondo",
                  style: GoogleFonts.nunitoSans(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                subtitle: Text(
                  "Se mantienen los colores para los botones",
                  style: TextStyle(color: Colors.white54),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickHeaderImage();
                },
              ),
              Divider(),

              // Opción de color de gradiente
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8),
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
                  "Elegir colores del tema",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                subtitle: Text(
                  "Color del fondo y botones de categorías",
                  style: TextStyle(color: Colors.white54),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showColorPickerDialog();
                },
              ),
              Divider(),

              // Opción para eliminar imagen personalizada
              ListTile(
                leading: Icon(
                  Icons.restore,
                  size: 25,
                  color:
                      headerBackgroundImage != null ||
                              startColor !=
                                  Colors.purple.shade500 ||
                              endColor !=
                                  Colors.purple.shade900
                          ? Colors.red
                          : Colors.grey,
                ),
                title: Text(
                  "Restaurar valores predeterminados",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color:
                        headerBackgroundImage != null ||
                                startColor !=
                                    Colors
                                        .purple
                                        .shade500 ||
                                endColor !=
                                    Colors.purple.shade900
                            ? Colors.white
                            : Colors.grey,
                  ),
                ),
                onTap:
                    (headerBackgroundImage != null ||
                            startColor !=
                                Colors.purple.shade500 ||
                            endColor !=
                                Colors.purple.shade900)
                        ? () {
                          setState(() {
                            headerBackgroundImage = null;
                            startColor =
                                Colors.purple.shade500;
                            endColor =
                                Colors.purple.shade900;
                          });
                          Navigator.pop(context);
                        }
                        : null,
              ),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  // Seleccionar imagen para el fondo del header
  Future<void> _pickHeaderImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      setState(() {
        headerBackgroundImage = File(image.path);
      });
    }
  }

  // Mostrar selector de colores
  void _showColorPickerDialog() {
    Color pickerStartColor = startColor;
    Color pickerEndColor = endColor;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              "Elige 2 Colores",
              style: GoogleFonts.nunitoSans(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Primer Color",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ColorPicker(
                  pickerColor: pickerStartColor,
                  onColorChanged: (color) {
                    pickerStartColor = color;
                  },
                  portraitOnly: true,
                  pickerAreaHeightPercent: 0.3,
                  labelTypes: [],
                ),
                SizedBox(height: 20),
                Text(
                  "Segundo Color",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ColorPicker(
                  pickerColor: pickerEndColor,
                  onColorChanged: (color) {
                    pickerEndColor = color;
                  },
                  portraitOnly: true,
                  pickerAreaHeightPercent: 0.3,
                  labelTypes: [],
                ),
                SizedBox(height: 10),
                Text(
                  "Los colores elegidos se aplicarán al fondo del header y a los botones de categorías",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancelar",
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  startColor = pickerStartColor;
                  endColor = pickerEndColor;
                });
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple.shade800,
              ),
              child: Text(
                "Aplicar",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
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
          // Construir todos los botones de categorías existentes
          ...categories.map(
            (category) => _buildCategoryButton(
              category,
              isSelected: selectedCategory == category,
              onLongPress:
                  category != "Todo"
                      ? () => _showDeleteCategoryDialog(
                        category,
                      )
                      : null,
            ),
          ),
          // Botón para añadir nueva categoría
          _buildAddCategoryButton(),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(
    String label, {
    bool isSelected = false,
    VoidCallback? onLongPress,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: InkWell(
        onTap: () {
          setState(() {
            selectedCategory = label;
          });
        },
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(15),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors:
                  isSelected
                      ? [
                        startColor.withOpacity(0.9),
                        endColor,
                      ]
                      : [
                        startColor.withOpacity(0.7),
                        endColor.withOpacity(0.8),
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

  Widget _buildAddCategoryButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: InkWell(
        onTap: _showAddCategoryDialog,
        borderRadius: BorderRadius.circular(15),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                startColor.withOpacity(0.7),
                endColor.withOpacity(0.8),
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
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  // Función para mostrar el diálogo de añadir categoría con diseño mejorado
  void _showAddCategoryDialog() {
    final TextEditingController categoryController =
        TextEditingController();

    // Usamos Dialog en lugar de AlertDialog para tener más control sobre el diseño
    showDialog(
      context: context,
      // Permite que el diálogo se cierre al tocar fuera
      barrierDismissible: true,
      // Hace que el fondo sea más oscuro para mejor contraste
      barrierColor: Colors.black.withOpacity(0.6),
      builder:
          (context) => Dialog(
            // Hacemos el fondo transparente para usar nuestro propio contenedor con gradiente
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Container(
              // Ajustamos el ancho al 85% del ancho de la pantalla
              width:
                  MediaQuery.of(context).size.width * 0.85,
              padding: EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 24,
              ),
              // Aquí agregamos un gradiente como fondo
              decoration: BoxDecoration(
                color: Color(0xFF121212),
                // Bordes redondeados para un aspecto más moderno
                borderRadius: BorderRadius.circular(30),
                // Agregamos sombra para dar profundidad
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(
                      255,
                      54,
                      2,
                      78,
                    ),
                    blurRadius: 15,
                    spreadRadius: 1,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                // Asegura que el diálogo ocupe solo el espacio necesario
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Título con icono para mejor comunicación visual
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 12),
                      Text(
                        "Añadir Categoría",
                        style: GoogleFonts.nunitoSans(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.deepPurpleAccent
                                  .withOpacity(0.5),
                              offset: Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 25),
                  // Campo de texto con diseño mejorado
                  Container(
                    decoration: BoxDecoration(
                      // Fondo semi-transparente
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(
                        12,
                      ),
                      // Borde sutil para definir mejor el campo
                      border: Border.all(
                        color: Colors.white.withOpacity(
                          0.2,
                        ),
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      controller: categoryController,
                      style: TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      textCapitalization:
                          TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: "Nombre de la categoría",
                        hintStyle: TextStyle(
                          color: Colors.white70,
                        ),
                        prefixIcon: Icon(
                          Icons.edit,
                          color: Colors.white70,
                        ),
                        // Quitamos el borde predeterminado
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 16,
                            ),
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                  // Botones con mejor alineación y diseño
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed:
                            () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                        child: Text(
                          "Cancelar",
                          style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () {
                          if (categoryController
                              .text
                              .isNotEmpty) {
                            setState(() {
                              categories.add(
                                categoryController.text,
                              );
                              print(
                                "Categorias de la Empresa: $categories",
                              );
                            });
                            Navigator.pop(context);

                            // Opcional: Añadir mensaje de confirmación
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '¡Categoría añadida exitosamente!',
                                  style: GoogleFonts.nunito(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                                backgroundColor: Colors
                                    .deepPurpleAccent
                                    .shade700
                                    .withOpacity(0.5),
                                duration: Duration(
                                  seconds: 2,
                                ),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          // Color invertido para contrastar con el fondo
                          backgroundColor:
                              Colors
                                  .deepPurpleAccent
                                  .shade700,
                          foregroundColor:
                              Colors.purple.shade800,
                          elevation: 5,
                          shadowColor: Colors.black
                              .withOpacity(0.5),
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Añadir",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }

  // Función para mostrar el diálogo de eliminar categoría con diseño mejorado
  void _showDeleteCategoryDialog(String category) {
    showDialog(
      context: context,
      // Permite que el diálogo se cierre al tocar fuera
      barrierDismissible: true,
      // Hace que el fondo sea más oscuro para mejor contraste
      barrierColor: Colors.black.withOpacity(0.6),
      builder:
          (context) => Dialog(
            // Hacemos el fondo transparente para usar nuestro propio contenedor con fondo personalizado
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Container(
              // Ajustamos el ancho al 85% del ancho de la pantalla
              width:
                  MediaQuery.of(context).size.width * 0.85,
              padding: EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 24,
              ),
              // Usamos el mismo estilo que en el diálogo de añadir categoría
              decoration: BoxDecoration(
                color: Color(0xFF121212),
                // Bordes redondeados para un aspecto más moderno
                borderRadius: BorderRadius.circular(30),
                // Agregamos sombra para dar profundidad
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(
                      255,
                      54,
                      2,
                      78,
                    ),
                    blurRadius: 15,
                    spreadRadius: 1,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                // Asegura que el diálogo ocupe solo el espacio necesario
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Título con el mismo estilo que el diálogo de añadir
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 12),
                      Text(
                        "Eliminar Categoría",
                        style: GoogleFonts.nunitoSans(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.deepPurpleAccent
                                  .withOpacity(0.5),
                              offset: Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  SizedBox(height: 15),
                  // Contenedor para el mensaje de confirmación con el mismo estilo
                  Text(
                    "¿Quieres eliminar la categoría '$category'?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      height: 1.5,
                    ),
                  ),

                  SizedBox(height: 25),
                  // Botones con mejor alineación y diseño, igual que en añadir categoría
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed:
                            () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                        child: Text(
                          "Cancelar",
                          style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            categories.remove(category);
                            if (selectedCategory ==
                                category) {
                              selectedCategory = "Todo";
                            }
                            // También actualizamos los productos que tengan esta categoría
                            // Por ahora no tenemos la categoría en el modelo, pero cuando lo tengamos
                            // deberíamos actualizar los productos aquí
                          });
                          Navigator.pop(context);
                          print(
                            "Categorias de la Empresa: $categories",
                          );

                          // Mensaje de confirmación similar al de añadir
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Categoría eliminada exitosamente',
                                style: GoogleFonts.nunito(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                              backgroundColor:
                                  Colors.black87,
                              duration: Duration(
                                seconds: 2,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          // Usamos un color rojo para indicar eliminación
                          backgroundColor:
                              Colors
                                  .deepPurpleAccent
                                  .shade700,
                          foregroundColor: Colors.white,
                          elevation: 5,
                          shadowColor: Colors.black
                              .withOpacity(0.5),
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Eliminar",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildProductGrid() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: Colors.purpleAccent,
        ),
      );
    }

    // Si no hay productos, mostrar mensaje y botón para añadir
    if (products.isEmpty) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "No tienes productos aún",
              style: GoogleFonts.nunito(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white70,
              ),
            ),
          ),
          _buildProductItem(), // Botón para añadir producto
        ],
      );
    }

    // Filtrar productos por categoría si no es "Todo"
    List<Product> filteredProducts = products;
    if (selectedCategory != "Todo") {
      // Si tienes la propiedad 'category' habilitada en tu modelo, usar:
      // filteredProducts = products.where((product) => product.category == selectedCategory).toList();
      // Como no está habilitada aún, solo filtraremos en el futuro
    }

    // Lista de productos + botón para añadir
    final displayItems = [...filteredProducts, null];

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(15),
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
          ),
      itemCount: displayItems.length,
      itemBuilder: (context, index) {
        // El último item es para añadir nuevo producto
        if (index == displayItems.length - 1) {
          return _buildProductItem();
        }

        // Mostrar producto real
        return _buildRealProductItem(displayItems[index]!);
      },
    );
  }

  Widget _buildRealProductItem(Product product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 4,
            offset: Offset(1, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Imagen del producto
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child:
                  product.productImg != null
                      ? Image.network(
                        'http://10.0.2.2:8000/ProductImg?fileLocation=${Uri.encodeComponent(product.productImg!)}',
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
                            color: Colors.grey[800],
                            child: Icon(
                              Icons.image_not_supported,
                              color: Colors.white70,
                              size: 50,
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
                            color: Colors.grey[800],
                            child: Center(
                              child:
                                  CircularProgressIndicator(
                                    color:
                                        Colors.purpleAccent,
                                  ),
                            ),
                          );
                        },
                      )
                      : Container(
                        color: Colors.grey[800],
                        child: Icon(
                          Icons.image,
                          color: Colors.white70,
                          size: 50,
                        ),
                      ),
            ),
          ),

          // Detalles del producto
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    product.Name ?? 'Sin nombre',
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    '\$${product.Price ?? '0'}',
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Colors.greenAccent,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    product.Description ??
                        'Sin descripción',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductItem() {
    return GestureDetector(
      onTap: () {
        // Navegar a la pantalla de subir producto
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => UploadProductScreen(
                  // Pasamos todas las categorías excepto "Todo" que es solo para filtrar
                  categories:
                      categories
                          .where(
                            (category) =>
                                category != "Todo",
                          )
                          .toList(),
                ),
          ),
        ).then((_) {
          // Al regresar, recargamos los productos
          _loadProducts();
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey[300]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 4,
              offset: Offset(1, 2),
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
