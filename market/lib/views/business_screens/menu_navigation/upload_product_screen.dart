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

  String? userId = '4bbb8690-3546-4c2b-b3a1-a07fb7fbf70e';
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
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text(
          "Subir Producto",
          style: GoogleFonts.nunitoSans(
            fontSize: 40,
            fontWeight: FontWeight.w900,
            color: Colors.purpleAccent,
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickImages,
                  child: Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 7,
                          spreadRadius: 3,
                          offset: Offset(0, 3),
                        ),
                      ],
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(
                        15,
                      ),
                    ),
                    child:
                        _selectedImages.isEmpty
                            ? const Icon(
                              Icons.add_a_photo,
                              size: 70,
                              color: Colors.purpleAccent,
                              shadows: [
                                Shadow(
                                  color: Colors.black,
                                  offset: Offset(0, 0),
                                  blurRadius: 30,
                                ),
                              ],
                            )
                            : ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(15),
                              child: Image.file(
                                _selectedImages.first,
                                fit: BoxFit.cover,
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
              const SizedBox(height: 10),
              Center(
                child: SizedBox(
                  width: 270,
                  height: 70,
                  child: InkWell(
                    onTap: _uploadProduct,
                    borderRadius: BorderRadius.circular(10),
                    child: Ink(
                      decoration: BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          ),
                        ],
                        gradient: LinearGradient(
                          colors: [
                            Colors.purpleAccent,
                            Colors.deepPurple,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Ofertar",
                          style: GoogleFonts.nunitoSans(
                            fontSize: 29,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.deepPurple
                                    .withOpacity(0.8),
                                offset: const Offset(1, 3),
                                blurRadius: 10,
                              ),
                              Shadow(
                                color: Colors.black
                                    .withOpacity(0.6),
                                offset: const Offset(2, 4),
                                blurRadius: 4,
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
        ),
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
              color: Colors.black, // Sombra suave
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
          decoration: InputDecoration(
            labelText: label,
            labelStyle: GoogleFonts.nunitoSans(
              color: Colors.black,
              shadows: [
                Shadow(
                  color: Colors.black87,
                  offset: Offset(0, 0),
                  blurRadius: 25,
                ),
              ],
              fontWeight: FontWeight.w900,
              fontSize: 17,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            filled: true,
            fillColor: Colors.grey[400],
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
              color: Colors.black, // Sombra sutil
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
        child: DropdownButtonFormField<String>(
          value: selectedCategory,
          decoration: InputDecoration(
            labelText: 'Categoría',
            labelStyle: GoogleFonts.nunitoSans(
              color: Colors.black,
              shadows: [
                Shadow(
                  color: Colors.black87,
                  offset: Offset(0, 0),
                  blurRadius: 25,
                ),
              ],
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            filled: true,
            fillColor: Colors.grey[400],
          ),
          //Construir dinamicamente las opciones del dropdown basadas en las categorias recibidas
          items:
              widget.categories.map((String category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
          onChanged: (value) {
            setState(() {
              selectedCategory = value;
            });
          },
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
      final product = Product(
        Name: _nameController.text,
        Price: _priceController.text,
        Description: _descriptionController.text,
        UserId: userId,
      );

      try {
        await _controller.uploadProduct(product);
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
