import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:market/controllers/upload_product_controller.dart';
import 'package:market/models/product_model.dart';

class UploadProductScreen extends StatefulWidget {
  const UploadProductScreen({super.key});

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
  List<File> _selectedImages =
      []; // Lista para almacenar las imágenes seleccionadas

  String? userId = '4bbb8690-3546-4c2b-b3a1-a07fb7fbf70e';

  String? selectedCategory;
  final List<String> _sizeList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Subir Producto')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Campo para seleccionar imágenes
              const Text(
                'Imágenes del Producto',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              GridView.builder(
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                itemCount: _selectedImages.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return GestureDetector(
                      onTap: _pickImages,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius:
                              BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.add,
                            size: 40,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    );
                  } else {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(
                        8,
                      ),
                      child: Image.file(
                        _selectedImages[index - 1],
                        fit: BoxFit.cover,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 16),

              // Campo para el nombre del producto
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del Producto',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el nombre del producto';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Campo para el precio del producto
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Precio',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el precio';
                  }
                  if (int.tryParse(value) == null) {
                    return 'El precio debe ser un número entero válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Campo para la categoría del producto
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Categoría',
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Electrónica',
                    child: Text('Electrónica'),
                  ),
                  DropdownMenuItem(
                    value: 'Ropa',
                    child: Text('Ropa'),
                  ),
                  DropdownMenuItem(
                    value: 'Hogar',
                    child: Text('Hogar'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor selecciona una categoría';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Campo para el descuento
              TextFormField(
                controller: _discountController,
                decoration: const InputDecoration(
                  labelText: 'Descuento',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              // Campo para la cantidad
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(
                  labelText: 'Cantidad',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              // Campo para la descripción
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // Botón para subir el producto
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final price = _priceController.text;

                    if (int.tryParse(price) == null) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'El precio debe ser un número entero válido.',
                          ),
                        ),
                      );
                      return;
                    }

                    final product = Product(
                      Name: _nameController.text,
                      Price:
                          price, // Envía el precio como String
                      Description:
                          _descriptionController.text,
                      UserId: userId,
                    );

                    try {
                      await _controller.uploadProduct(
                        product,
                      );
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Producto subido exitosamente',
                          ),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Error al subir el producto: $e',
                          ),
                        ),
                      );
                    }
                  }
                },
                child: const Text('Subir Producto'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Función para seleccionar imágenes
  Future<void> _pickImages() async {
    final List<XFile>? pickedFiles =
        await _picker.pickMultiImage();

    if (pickedFiles != null) {
      setState(() {
        _selectedImages.addAll(
          pickedFiles
              .map((file) => File(file.path))
              .toList(),
        );
      });
    }
  }
}
