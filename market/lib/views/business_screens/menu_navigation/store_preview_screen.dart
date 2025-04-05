import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market/views/business_screens/menu_navigation/upload_product_screen.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart'; //seleccionar imagenes
import 'package:flutter_colorpicker/flutter_colorpicker.dart'; //seleccionar colores

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
        ),
      ),
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
                color: Colors.black,
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
              // Título
              Text(
                "Personalizar Tema",
                style: GoogleFonts.nunitoSans(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
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
              SizedBox(height: 20),

              // Opciones
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade400,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.image_search_sharp,
                    color: Colors.deepPurpleAccent,
                    size: 33,
                  ),
                ),
                title: Text(
                  "Elegir imagen de fondo",
                  style: GoogleFonts.nunitoSans(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  "Se mantienen los colores para los botones",
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
                    color: Colors.deepPurple.shade400,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.imagesearch_roller,
                    color: Colors.deepPurpleAccent,
                    size: 33,
                  ),
                ),
                title: Text(
                  "Elegir colores del tema",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  "Color del fondo y botones de categorías",
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
                            ? Colors.black
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

  // Función para mostrar el diálogo de añadir categoría
  void _showAddCategoryDialog() {
    final TextEditingController categoryController =
        TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              "Añadir Categoría",
              style: GoogleFonts.nunitoSans(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                shadows: [
                  Shadow(
                    color: Colors.black,
                    offset: Offset(1, 1),
                    blurRadius: 20,
                  ),
                ],
              ),
            ),
            content: TextField(
              controller: categoryController,
              decoration: InputDecoration(
                hintText: "Nombre de la categoría",
                border: OutlineInputBorder(),
              ),
              textCapitalization:
                  TextCapitalization.sentences,
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
                  if (categoryController.text.isNotEmpty) {
                    setState(() {
                      print(
                        "Categorias de la Empresa: $categories",
                      );
                      categories.add(
                        categoryController.text,
                      );
                    });
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple.shade800,
                ),
                child: Text(
                  "Añadir",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  // Función para mostrar el diálogo de eliminar categoría
  void _showDeleteCategoryDialog(String category) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              "Eliminar Categoría",
              style: GoogleFonts.nunitoSans(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                shadows: [
                  Shadow(
                    color: Colors.black,
                    offset: Offset(1, 1),
                    blurRadius: 20,
                  ),
                ],
              ),
            ),
            content: Text(
              "¿Estás seguro que deseas eliminar la categoría '$category'?",
              style: TextStyle(fontSize: 15),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Cancelar",
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    categories.remove(category);
                    if (selectedCategory == category) {
                      selectedCategory = "Todo";
                    }
                  });
                  Navigator.pop(context);
                  print(
                    "Categorias de la Empresa: $categories",
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                ),
                child: Text(
                  "Eliminar",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
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
            crossAxisCount: 2,
            childAspectRatio: 1,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
          ),
      itemCount: 7, // 7 espacios para productos
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
