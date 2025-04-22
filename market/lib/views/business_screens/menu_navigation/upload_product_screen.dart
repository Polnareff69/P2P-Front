import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:market/controllers/upload_product_controller.dart';
import 'package:market/models/product_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market/views/main_screen/businesses.dart';

class UploadProductScreen extends StatefulWidget {
  // lista de categorías
  final List<String> categories;

  const UploadProductScreen({
    super.key,
    //si no me pasan categorías, una lista de categorias predeterminada.
    this.categories = const [
      'Electronica',
      'Ropa',
      'Vapes',
    ],
  });

  @override
  State<UploadProductScreen> createState() =>
      _UploadProductScreenState();
}

class _UploadProductScreenState
    extends State<UploadProductScreen> {
  final UploadProductController _controller =
      UploadProductController();
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();

  final TextEditingController _nameController =
      TextEditingController();
  final TextEditingController _priceController =
      TextEditingController();
  final TextEditingController _discountController =
      TextEditingController();
  final TextEditingController _quantityController =
      TextEditingController();
  final TextEditingController _descriptionController =
      TextEditingController();

  final ImagePicker _picker = ImagePicker();
  final List<File> _selectedImages = [];

  //String? userId = '4bbb8690-3546-4c2b-b3a1-a07fb7fbf70e';
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    // Inicializar la categoría seleccionada con la primera de la lista si existe
    if (widget.categories.isNotEmpty) {
      selectedCategory = widget.categories.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Configuración para pantalla inmersiva
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Subir Producto",
          style: GoogleFonts.nunito(
            fontSize: 35,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.deepPurple.withOpacity(0.8),
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

        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.deepPurpleAccent,
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
      ),
      body: Stack(
        children: [
          // Fondo con imagen
          Positioned.fill(
            child: Image.asset(
              'assets/images/upload.png', // Asegúrate de tener esta imagen en tu proyecto
              fit: BoxFit.cover,
            ),
          ),

          // Capa oscura para mejor legibilidad
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),

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
                        color: Colors.black.withOpacity(
                          0.5,
                        ),
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
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: GestureDetector(
                              onTap: _pickImages,
                              child: Container(
                                height: 150,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 7,
                                      spreadRadius: 3,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                  color: Colors.grey[800]
                                      ?.withOpacity(0.5),
                                  borderRadius:
                                      BorderRadius.circular(
                                        15,
                                      ),
                                ),
                                child:
                                    _selectedImages.isEmpty
                                        ? const Icon(
                                          Icons.add_a_photo,
                                          size: 70,
                                          color:
                                              Colors
                                                  .purpleAccent,
                                          shadows: [
                                            Shadow(
                                              color:
                                                  Colors
                                                      .black,
                                              offset:
                                                  Offset(
                                                    0,
                                                    0,
                                                  ),
                                              blurRadius:
                                                  30,
                                            ),
                                          ],
                                        )
                                        : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(
                                                15,
                                              ),
                                          child: Image.file(
                                            _selectedImages
                                                .first,
                                            fit:
                                                BoxFit
                                                    .cover,
                                          ),
                                        ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildDropdownField(),

                          _buildTextField(
                            "Nombre del Producto",
                            _nameController,
                          ),
                          _buildTextField(
                            "Precio",
                            _priceController,
                            isNumeric: true,
                          ),
                          _buildTextField(
                            "Descuento %",
                            _discountController,
                            isNumeric: true,
                          ),
                          _buildTextField(
                            "Cantidad",
                            _quantityController,
                            isNumeric: true,
                          ),
                          _buildTextField(
                            "Descripción",
                            _descriptionController,
                            maxLines: 3,
                          ),

                          // Botón de Ofertar
                          const SizedBox(height: 30),
                          Center(
                            child: InkWell(
                              onTap: _uploadProduct,
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
                                      Colors
                                          .purple
                                          .shade400,
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
                                    // Efectos decorativos
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
                                                  width: 3,
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
                                          Text(
                                            'Ofertar Producto',
                                            style: GoogleFonts.nunito(
                                              color:
                                                  Colors
                                                      .white,
                                              fontSize: 25,
                                              fontWeight:
                                                  FontWeight
                                                      .w900,
                                              shadows: [
                                                Shadow(
                                                  color: Colors
                                                      .deepPurple
                                                      .withOpacity(
                                                        0.8,
                                                      ),
                                                  offset:
                                                      const Offset(
                                                        1,
                                                        3,
                                                      ),
                                                  blurRadius:
                                                      10,
                                                ),
                                                Shadow(
                                                  color: Colors
                                                      .black
                                                      .withOpacity(
                                                        0.6,
                                                      ),
                                                  offset:
                                                      const Offset(
                                                        2,
                                                        4,
                                                      ),
                                                  blurRadius:
                                                      4,
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
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

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool isNumeric = false,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black26, // Sombra suave
              blurRadius: 7,
              offset: Offset(
                2,
                3,
              ), // Dirección de la sombra
            ),
          ],
          borderRadius: BorderRadius.circular(
            15,
          ), // Asegurar que la sombra siga el borde redondeado
        ),
        child: TextFormField(
          controller: controller,
          keyboardType:
              isNumeric
                  ? TextInputType.number
                  : TextInputType.text,
          maxLines: maxLines,
          style: TextStyle(
            color:
                Colors
                    .white, // Color del texto ingresado por el usuario
            fontSize: 14,
          ),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: GoogleFonts.nunito(
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
              fontWeight: FontWeight.w900,
              fontSize: 17,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: Colors.purpleAccent,
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.grey[800]?.withOpacity(0.5),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Este campo es obligatorio';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildDropdownField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black26, // Sombra sutil
              blurRadius: 7,
              offset: Offset(
                2,
                3,
              ), // Dirección de la sombra
            ),
          ],
          borderRadius: BorderRadius.circular(
            15,
          ), // Redondeo para que la sombra siga la forma
        ),
        child: Theme(
          // Usar un Theme  para anular el estilo predeterminado
          data: Theme.of(context).copyWith(
            textTheme: TextTheme(
              // Esto afecta al texto seleccionado
              titleMedium: TextStyle(color: Colors.white),
            ),
          ),
          child: DropdownButtonFormField<String>(
            value: selectedCategory,
            dropdownColor: Colors.white,

            decoration: InputDecoration(
              labelText: 'Categoría',
              labelStyle: GoogleFonts.nunito(
                color: Colors.white,
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
                fontSize: 17,
                fontWeight: FontWeight.w900,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: Colors.purpleAccent,
                  width: 1.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[800]?.withOpacity(0.5),
            ),

            // Esto es importante para cambiar el color del texto seleccionado visible
            selectedItemBuilder: (BuildContext context) {
              return widget.categories.map<Widget>((
                String item,
              ) {
                return Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    item,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList();
            },

            //Construir dinamicamente las opciones del dropdown basadas en las categorias recibidas
            items:
                widget.categories.map((String category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(
                      category,
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
            onChanged: (value) {
              setState(() {
                selectedCategory = value;
              });
            },
          ),
        ),
      ),
    );
  }

  Future<void> _pickImages() async {
    final List<XFile> pickedFiles =
        await _picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      setState(() {
        _selectedImages.clear();
        _selectedImages.addAll(
          pickedFiles.map((file) => File(file.path)),
        );
      });
    }
  }

  void _uploadProduct() async {
    if (_formKey.currentState!.validate()) {
      // Verificar si se ha seleccionado una imagen
      if (_selectedImages.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Por favor, selecciona una imagen para el producto',
            ),
          ),
        );
        return;
      }

      final product = Product(
        Name: _nameController.text,
        Price: _priceController.text,
        Description: _descriptionController.text,
        //UserId: userId,
      );

      try {
        // Ahora pasamos también la lista de imágenes seleccionadas
        await _controller.uploadProduct(
          product,
          _selectedImages,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Producto subido exitosamente'),
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BusinessesScreen(),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al subir el producto: $e'),
          ),
        );
      }
    }
  }
}
