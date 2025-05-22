// lib/views/auction_screens/create_auction_screen.dart
//import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market/controllers/auction_controller.dart';
import 'package:market/controllers/upload_product_controller.dart';
import 'package:market/models/auction_model.dart';
import 'package:market/models/product_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateAuctionScreen extends StatefulWidget {
  const CreateAuctionScreen({Key? key}) : super(key: key);

  @override
  _CreateAuctionScreenState createState() =>
      _CreateAuctionScreenState();
}

class _CreateAuctionScreenState
    extends State<CreateAuctionScreen> {
  final AuctionController _auctionController =
      AuctionController();
  final UploadProductController _productController =
      UploadProductController();
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();

  final TextEditingController _initialPriceController =
      TextEditingController();
  final TextEditingController _startDateController =
      TextEditingController();
  final TextEditingController _endDateController =
      TextEditingController();

  Map<String, String> _productIdMap = {};
  bool _isIdMapLoaded = false;
  bool isLoading = true;
  List<Product> products = [];
  Product? selectedProduct;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(
    const Duration(days: 7),
  );

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _loadProductIdMap();
    _startDateController.text = DateFormat(
      'yyyy-MM-dd',
    ).format(startDate);
    _endDateController.text = DateFormat(
      'yyyy-MM-dd',
    ).format(endDate);
  }

  //  método para cargar el mapa de IDs
  Future<void> _loadProductIdMap() async {
    try {
      setState(() {
        isLoading =
            true; // Mostrar loading mientras carga el mapa
      });

      _productIdMap =
          await _productController.getAllProductsIdMap();

      setState(() {
        _isIdMapLoaded = true;
        isLoading = false;
      });

      if (kDebugMode) {
        print(
          '✅ Mapa de IDs cargado con ${_productIdMap.length} productos',
        );
        // Resto del código...
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      if (kDebugMode) {
        print('❌ Error al cargar mapa de IDs: $e');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error al cargar los IDs de productos. Algunas funcionalidades podrían no estar disponibles.',
          ),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

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
        if (products.isNotEmpty) {
          selectedProduct = products.first;
        }
        isLoading = false;
      });
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

  Future<void> _selectDate(
    BuildContext context,
    bool isStartDate,
  ) async {
    final DateTime initialDate =
        isStartDate ? startDate : endDate;
    final DateTime firstDate =
        isStartDate ? DateTime.now() : startDate;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime.now().add(
        const Duration(days: 365),
      ),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: Colors.deepPurple,
              onPrimary: Colors.white,
              surface: Color(0xFF121212),
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: Color(0xFF121212),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          startDate = picked;
          _startDateController.text = DateFormat(
            'yyyy-MM-dd',
          ).format(startDate);

          // Si la fecha de fin es anterior a la nueva fecha de inicio, actualizarla
          if (endDate.isBefore(startDate)) {
            endDate = startDate.add(
              const Duration(days: 7),
            );
            _endDateController.text = DateFormat(
              'yyyy-MM-dd',
            ).format(endDate);
          }
        } else {
          endDate = picked;
          _endDateController.text = DateFormat(
            'yyyy-MM-dd',
          ).format(endDate);
        }
      });
    }
  }

  Future<void> _createAuction() async {
    if (_formKey.currentState!.validate()) {
      if (selectedProduct == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Por favor, selecciona un producto',
            ),
          ),
        );
        return;
      }

      // Buscar el ID correcto en el mapa
      String productId = '';

      // 1. Primero buscar por nombre en el mapa
      if (_productIdMap.containsKey(
        selectedProduct!.Name,
      )) {
        productId = _productIdMap[selectedProduct!.Name]!;
        if (kDebugMode) {
          print(
            '✅ ID encontrado en mapa para "${selectedProduct!.Name}": $productId',
          );
        }
      }
      // 2. Si no se encuentra en el mapa, usar el ID del producto
      else if (selectedProduct!.productid != null &&
          selectedProduct!.productid!.isNotEmpty) {
        productId = selectedProduct!.productid!;
        if (kDebugMode) {
          print(
            '⚠️ No se encontró en mapa, usando ID existente: $productId',
          );
        }
      }
      // 3. Si no hay ID válido
      else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'El producto seleccionado no tiene un ID válido',
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      try {
        // Crear objeto de subasta
        final initialPrice =
            int.tryParse(
              _initialPriceController.text.replaceAll(
                RegExp(r'[^0-9]'),
                '',
              ),
            ) ??
            0;

        final auction = Auction(
          id: '',
          productId:
              productId, // Usar el ID correcto obtenido
          ownerId: '', // El backend lo obtendrá del token
          startDate: startDate,
          endDate: endDate,
          initialPrice: initialPrice,
          currentPrice: initialPrice,
        );

        // Mostrar diálogo de carga
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Color(0xFF121212),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    color: Colors.purpleAccent,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Creando subasta...',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            );
          },
        );

        // Log para depuración
        if (kDebugMode) {
          print('📤 Enviando subasta con:');
          print('  - Producto: ${selectedProduct!.Name}');
          print('  - ID de producto: $productId');
          print('  - Precio inicial: $initialPrice');
        }

        // Usar el controlador para crear la subasta
        await _auctionController.createAuction(auction);

        // Cerrar diálogo de carga
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Subasta creada exitosamente'),
            backgroundColor: Colors.green,
          ),
        );

        // Regresar a la pantalla anterior
        Navigator.pop(context);
      } catch (e) {
        // Cerrar diálogo de carga si está abierto
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al crear subasta: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Crear Subasta",
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
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          // Fondo con gradiente
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF121212),
                    Colors.deepPurple.shade900,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                child:
                    isLoading
                        ? CircularProgressIndicator(
                          color: Colors.purpleAccent,
                        )
                        : SingleChildScrollView(
                          child: Form(
                            key: _formKey,
                            child: Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.black
                                    .withOpacity(0.5),
                                borderRadius:
                                    BorderRadius.circular(
                                      20,
                                    ),
                                border: Border.all(
                                  color: Colors.white
                                      .withOpacity(0.3),
                                  width: 3,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                children: [
                                  // Título de la sección
                                  Center(
                                    child: Text(
                                      "Información de la Subasta",
                                      style: GoogleFonts.nunito(
                                        fontSize: 20,
                                        fontWeight:
                                            FontWeight.bold,
                                        color: Colors.white,
                                        shadows: [
                                          Shadow(
                                            color: Colors
                                                .deepPurple
                                                .withOpacity(
                                                  0.5,
                                                ),
                                            offset: Offset(
                                              0,
                                              2,
                                            ),
                                            blurRadius: 4,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),

                                  // Selección de producto
                                  Text(
                                    "Producto a subastar:",
                                    style:
                                        GoogleFonts.nunito(
                                          fontSize: 16,
                                          fontWeight:
                                              FontWeight
                                                  .bold,
                                          color:
                                              Colors.white,
                                        ),
                                  ),
                                  SizedBox(height: 8),
                                  _buildProductDropdown(),
                                  SizedBox(height: 20),

                                  // Precio inicial
                                  _buildTextField(
                                    "Precio Inicial",
                                    _initialPriceController,
                                    isNumeric: true,
                                  ),

                                  // Fechas
                                  _buildDateField(
                                    "Fecha de Inicio",
                                    _startDateController,
                                    () => _selectDate(
                                      context,
                                      true,
                                    ),
                                  ),
                                  _buildDateField(
                                    "Fecha de Fin",
                                    _endDateController,
                                    () => _selectDate(
                                      context,
                                      false,
                                    ),
                                  ),

                                  // Botón de Crear Subasta
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Center(
                                    child: InkWell(
                                      onTap: _createAuction,
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
                                        child: Center(
                                          child: Text(
                                            'Crear Subasta',
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

  Widget _buildProductDropdown() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 7,
            offset: Offset(2, 3),
          ),
        ],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          textTheme: TextTheme(
            titleMedium: TextStyle(color: Colors.white),
          ),
        ),
        child: DropdownButtonFormField<Product>(
          value: selectedProduct,
          dropdownColor: Colors.grey[900],
          decoration: InputDecoration(
            labelText: 'Seleccionar Producto',
            labelStyle: GoogleFonts.nunito(
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.deepPurple.withOpacity(0.5),
                  offset: const Offset(0, 2),
                  blurRadius: 10,
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
          selectedItemBuilder: (BuildContext context) {
            return products.map<Widget>((Product product) {
              return Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  product.Name ?? 'Producto sin nombre',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList();
          },
          items:
              products.map((Product product) {
                return DropdownMenuItem(
                  value: product,
                  child: Text(
                    product.Name ?? 'Producto sin nombre',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
          onChanged: (value) {
            setState(() {
              selectedProduct = value;
            });
          },
          validator: (value) {
            if (value == null) {
              return 'Por favor, selecciona un producto';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool isNumeric = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 7,
              offset: Offset(2, 3),
            ),
          ],
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextFormField(
          controller: controller,
          keyboardType:
              isNumeric
                  ? TextInputType.number
                  : TextInputType.text,
          style: TextStyle(
            color: Colors.white,
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
            if (isNumeric &&
                int.tryParse(
                      value.replaceAll(
                        RegExp(r'[^0-9]'),
                        '',
                      ),
                    ) ==
                    null) {
              return 'Ingrese un valor numérico válido';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildDateField(
    String label,
    TextEditingController controller,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 7,
              offset: Offset(2, 3),
            ),
          ],
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextFormField(
          controller: controller,
          readOnly: true,
          onTap: onTap,
          style: TextStyle(
            color: Colors.white,
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
            suffixIcon: Icon(
              Icons.calendar_today,
              color: Colors.purpleAccent,
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
}
