// lib/views/auction_screens/create_auction_screen.dart
//import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market/controllers/auction_controller.dart';
import 'package:market/controllers/upload_product_controller.dart';
import 'package:market/controllers/company_controller.dart';
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
  final CompanyController _companyController =
      CompanyController(); 
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();

  final TextEditingController _initialPriceController =
      TextEditingController();
  final TextEditingController _startDateController =
      TextEditingController();
  final TextEditingController _endDateController =
      TextEditingController();

  Map<String, String> _productIdMap = {};
  bool isLoading = true;
  List<Product> products = [];
  Product? selectedProduct;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(
    const Duration(days: 7),
  );

  // VARIABLES PARA MANEJO DE EMPRESA
  String? currentCompanyId;
  String? companyError;

  @override
  void initState() {
    super.initState();
    _initializeScreen(); // MÉTODO PRINCIPAL DE INICIALIZACIÓN
    _startDateController.text = DateFormat(
      'yyyy-MM-dd',
    ).format(startDate);
    _endDateController.text = DateFormat(
      'yyyy-MM-dd',
    ).format(endDate);
  }

  // Método principal de inicialización
  Future<void> _initializeScreen() async {
    setState(() {
      isLoading = true;
      companyError = null;
    });

    try {
      // 1. PRIMERO obtener el company_id correcto del usuario actual
      await _ensureCorrectCompanyId();

      // 2. LUEGO cargar productos y mapa de IDs
      await Future.wait([
        _loadProducts(),
        _loadProductIdMap(),
      ]);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error inicializando pantalla: $e');
      }
      setState(() {
        companyError = e.toString();
        isLoading = false;
      });
    }
  }

  // Método para asegurar el company_id correcto (igual que VendorScreen)
  Future<void> _ensureCorrectCompanyId() async {
    try {
      if (kDebugMode) {
        print(
          '🏢 CreateAuctionScreen - Verificando company_id correcto...',
        );
      }

      // Obtener el company_id del usuario actual loggeado
      String? correctCompanyId =
          await _companyController
              .getCurrentSellerCompanyId();

      if (correctCompanyId == null) {
        throw Exception(
          'No se pudo obtener el ID de empresa del usuario actual',
        );
      }

      // Verificar si el company_id en SharedPreferences es diferente
      final prefs = await SharedPreferences.getInstance();
      final storedCompanyId = prefs.getString('company_id');

      if (storedCompanyId != correctCompanyId) {
        if (kDebugMode) {
          print('🔄 Company_id incorrecto detectado:');
          print('   Almacenado: $storedCompanyId');
          print('   Correcto: $correctCompanyId');
          print('   Actualizando...');
        }

        // El método getCurrentSellerCompanyId ya guarda automáticamente el correcto
      }

      setState(() {
        currentCompanyId = correctCompanyId;
      });

      if (kDebugMode) {
        print('✅ Company_id verificado: $correctCompanyId');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error verificando company_id: $e');
      }
      throw e;
    }
  }

  // Usar company_id verificado
  Future<void> _loadProducts() async {
    try {
      if (currentCompanyId == null) {
        throw Exception('No hay ID de empresa válido');
      }

      if (kDebugMode) {
        print(
          '📦 Cargando productos para empresa: $currentCompanyId',
        );
      }

      final loadedProducts = await _productController
          .getCompanyProducts(currentCompanyId!);

      setState(() {
        products = loadedProducts;
        if (products.isNotEmpty) {
          selectedProduct = products.first;
        }
      });

      if (kDebugMode) {
        print('✅ Productos cargados: ${products.length}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error cargando productos: $e');
      }
      throw Exception('Error al cargar productos: $e');
    }
  }

  // Mejor manejo de errores
  Future<void> _loadProductIdMap() async {
    try {
      if (kDebugMode) {
        print('🗂️ Cargando mapa de IDs de productos...');
      }

      _productIdMap =
          await _productController.getAllProductsIdMap();

      if (kDebugMode) {
        print(
          '✅ Mapa de IDs cargado: ${_productIdMap.length} productos',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error cargando mapa de IDs: $e');
      }

      // No fallar completamente si no se puede cargar el mapa
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Advertencia: Algunas funcionalidades de productos podrían no estar disponibles.',
          ),
          backgroundColor: Colors.orange,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Método para recargar datos
  Future<void> _refreshData() async {
    await _initializeScreen();
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

      // VERIFICACIÓN ADICIONAL: Asegurar que tenemos el company_id correcto
      if (currentCompanyId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Error: No se pudo verificar la empresa actual. Intenta nuevamente.',
            ),
            backgroundColor: Colors.red,
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
          productId: productId,
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
          print('  - Empresa: $currentCompanyId');
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
        // Botón de refresh
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.deepPurpleAccent,
                  offset: Offset(1, 1),
                  blurRadius: 15,
                ),
              ],
            ),
            onPressed: _refreshData,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Fondo con gradiente
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF0F0C29), // azul oscuro
                    Color(0xFF302B63), // púrpura elegante
                    Color(0xFF24243E), // gris profundo
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 10,
                  sigmaY: 10,
                ),
                child: Container(
                  color: Colors.black.withOpacity(0.1),
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                child:
                    // MANEJO DE ESTADOS DE CARGA Y ERROR
                    isLoading
                        ? Column(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: Colors.purpleAccent,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Verificando empresa y cargando productos...',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        )
                        : companyError != null
                        ? Column(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.business_center,
                              color: Colors.red,
                              size: 64,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Error al verificar empresa:',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              companyError!,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: _refreshData,
                              style:
                                  ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.deepPurple,
                                    foregroundColor:
                                        Colors.white,
                                    padding:
                                        EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 12,
                                        ),
                                  ),
                              child: Text('Reintentar'),
                            ),
                          ],
                        )
                        : products.isEmpty
                        ? Column(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inventory_2,
                              color: Colors.orange,
                              size: 64,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No tienes productos disponibles',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Debes crear productos antes de crear subastas',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style:
                                  ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.deepPurple,
                                    foregroundColor:
                                        Colors.white,
                                    padding:
                                        EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 12,
                                        ),
                                  ),
                              child: Text('Volver'),
                            ),
                          ],
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
                                  color:
                                      Colors
                                          .purple
                                          .shade800,
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
                                        fontSize: 24,
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

                                  // Mostrar empresa actual
                                  if (currentCompanyId !=
                                      null) ...[
                                    SizedBox(height: 15),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 8,
                                          ),
                                      decoration: BoxDecoration(
                                        color: Colors
                                            .deepPurple
                                            .withOpacity(
                                              0.2,
                                            ),
                                        borderRadius:
                                            BorderRadius.circular(
                                              8,
                                            ),
                                        border: Border.all(
                                          color: Colors
                                              .deepPurple
                                              .withOpacity(
                                                0.5,
                                              ),
                                          width: 2,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.business,
                                            color:
                                                Colors
                                                    .deepPurpleAccent,
                                            size: 16,
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            'ID de mi Negocio (dev debug): ${currentCompanyId!.substring(0, 5)}...',
                                            style: TextStyle(
                                              color:
                                                  Colors
                                                      .white70,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],

                                  SizedBox(height: 20),

                                  // Selección de producto
                                  Text(
                                    "Producto a subastar:",
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
                                  SizedBox(height: 22),
                                  _buildProductDropdown(),
                                  SizedBox(height: 22),

                                  // Precio inicial
                                  _buildTextField(
                                    "Precio Inicial",
                                    _initialPriceController,
                                    isNumeric: true,
                                  ),
                                  SizedBox(height: 10),
                                  Divider(),
                                  SizedBox(height: 22),
                                  // Selección de producto
                                  Text(
                                    "Configura el tiempo de tu subasta",
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
                                  SizedBox(height: 22),

                                  // Fechas
                                  _buildDateField(
                                    "Fecha de Inicio",
                                    _startDateController,
                                    () => _selectDate(
                                      context,
                                      true,
                                    ),
                                  ),
                                  SizedBox(height: 15),

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
                                        child: Stack(
                                          children: [
                                            // Efectos decorativos internos
                                            Positioned(
                                              left: 278,
                                              top: 40,
                                              child: Opacity(
                                                opacity:
                                                    0.5,
                                                child: Container(
                                                  width: 60,
                                                  height:
                                                      60,
                                                  clipBehavior:
                                                      Clip.antiAlias,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      width:
                                                          12,
                                                      color: const Color.fromARGB(
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
                                                opacity:
                                                    0.3,
                                                child: Container(
                                                  width: 10,
                                                  height:
                                                      10,
                                                  clipBehavior:
                                                      Clip.antiAlias,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      width:
                                                          3,
                                                    ),
                                                    color:
                                                        Colors.black,
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
                                                opacity:
                                                    0.3,
                                                child: Container(
                                                  width:
                                                      6.5,
                                                  height:
                                                      6.5,
                                                  clipBehavior:
                                                      Clip.antiAlias,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        Colors.white,
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
                                                opacity:
                                                    0.3,
                                                child: Container(
                                                  width:
                                                      8.5,
                                                  height:
                                                      8.5,
                                                  clipBehavior:
                                                      Clip.antiAlias,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        Colors.white,
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
                                                opacity:
                                                    0.3,
                                                child: Container(
                                                  width: 45,
                                                  height:
                                                      45,
                                                  clipBehavior:
                                                      Clip.antiAlias,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          30,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ),

                                            // Contenido del botón (texto + ícono)
                                            Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .center,
                                                children: [
                                                  Text(
                                                    'Crear Subasta',
                                                    style: GoogleFonts.nunito(
                                                      color:
                                                          Colors.white,
                                                      fontSize:
                                                          25,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      shadows: [
                                                        Shadow(
                                                          color: Colors.deepPurple.withOpacity(
                                                            0.8,
                                                          ),
                                                          offset: const Offset(
                                                            1,
                                                            3,
                                                          ),
                                                          blurRadius:
                                                              10,
                                                        ),
                                                        Shadow(
                                                          color: Colors.black.withOpacity(
                                                            0.6,
                                                          ),
                                                          offset: const Offset(
                                                            2,
                                                            4,
                                                          ),
                                                          blurRadius:
                                                              4,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width:
                                                        10,
                                                  ),
                                                  Icon(
                                                    Icons
                                                        .gavel,
                                                    color:
                                                        Colors.white,
                                                    size:
                                                        28,
                                                    shadows: [
                                                      Shadow(
                                                        color: Colors.deepPurple.withOpacity(
                                                          0.8,
                                                        ),
                                                        offset: const Offset(
                                                          1,
                                                          3,
                                                        ),
                                                        blurRadius:
                                                            10,
                                                      ),
                                                    ],
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
            fontSize: 15,
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
              fontSize: 18,
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
