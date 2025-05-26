import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market/models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:market/controllers/upload_product_controller.dart';
import 'package:market/config/app_config.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState
    extends State<ProductDetailScreen> {
  int selectedImageIndex = 0;
  int quantity = 1;

  // Controller para obtener productos
  final UploadProductController _productController =
      UploadProductController();

  // Lista para almacenar otros productos
  List<Product> otherProducts = [];
  bool loadingProducts = true;

  @override
  void initState() {
    super.initState();
    _loadOtherProducts();
  }

  // Método para cargar otros productos
  Future<void> _loadOtherProducts() async {
    setState(() {
      loadingProducts = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final companyId = prefs.getString('company_id');

      if (companyId == null) {
        throw Exception('No hay ID de empresa almacenado');
      }

      // Cargar todos los productos de la empresa
      final products = await _productController
          .getCompanyProducts(companyId);

      // Filtrar para excluir el producto actual basado en nombre y precio
      // ya que no tenemos productId
      setState(() {
        otherProducts =
            products
                .where(
                  (p) =>
                      p.Name != widget.product.Name ||
                      p.Price != widget.product.Price,
                )
                .toList();
        loadingProducts = false;
      });
    } catch (e) {
      print('Error al cargar otros productos: $e');
      setState(() {
        loadingProducts = false;
      });
    }
  }

  // Añade este método para construir la sección de productos relacionados
  Widget _buildRelatedProducts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: 7,
              horizontal: 12,
            ),
            margin: EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 15,
              top: 25,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.purpleAccent.withOpacity(0.1),
                  Colors.deepPurpleAccent.withOpacity(0.15),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: Colors.purple.shade400,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.shade700.withOpacity(
                    0.25,
                  ),
                  blurRadius: 8,
                  spreadRadius: 0,
                  offset: Offset(0, 2),
                ),
                BoxShadow(
                  color: Colors.purple.shade300.withOpacity(
                    0.1,
                  ),
                  blurRadius: 6,
                  spreadRadius: -1,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: Text(
              "Otros Productos",
              style: GoogleFonts.nunito(
                fontSize: 19,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),

        // Lista horizontal de productos
        SizedBox(
          height: 210,
          child:
              loadingProducts
                  ? Center(
                    child: CircularProgressIndicator(
                      color: Colors.purpleAccent,
                    ),
                  )
                  : otherProducts.isEmpty
                  ? Center(
                    child: Text(
                      "No hay más productos disponibles",
                      style: GoogleFonts.nunito(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                  : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: otherProducts.length,
                    padding: EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    itemBuilder: (context, index) {
                      return _buildRelatedProductItem(
                        otherProducts[index],
                      );
                    },
                  ),
        ),
      ],
    );
  }

  // Método para construir cada ítem de producto relacionado
  Widget _buildRelatedProductItem(Product product) {
    return GestureDetector(
      onTap: () {
        // Navegar a la pantalla de detalle de este producto
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (context) =>
                    ProductDetailScreen(product: product),
          ),
        );
      },
      child: Container(
        width: 170,
        margin: EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 4,
              offset: Offset(1, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Imagen del producto
            Expanded(
              flex: 6,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                child:
                    product.productImg != null
                        ? Image.network(
                          '${AppConfig.getProductImageUrl()}?fileLocation=${Uri.encodeComponent(product.productImg!)}',
                          fit: BoxFit.cover,
                          errorBuilder: (
                            context,
                            error,
                            stackTrace,
                          ) {
                            return Container(
                              color: Colors.grey[800],
                              child: Icon(
                                Icons.image_not_supported,
                                color: Colors.white70,
                                size: 30,
                              ),
                            );
                          },
                          loadingBuilder: (
                            context,
                            child,
                            loadingProgress,
                          ) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Container(
                              color: Colors.grey[800],
                              child: Center(
                                child:
                                    CircularProgressIndicator(
                                      color:
                                          Colors
                                              .purpleAccent,
                                      strokeWidth: 2.0,
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
                            size: 30,
                          ),
                        ),
              ),
            ),

            // Detalles del producto
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      product.Name ?? 'Sin nombre',
                      style: GoogleFonts.nunito(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '\$${product.Price ?? '0'}',
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Colors.greenAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: ShaderMask(
          shaderCallback:
              (bounds) => LinearGradient(
                colors: [
                  Colors.deepPurpleAccent.shade700,
                  Colors.deepPurpleAccent.shade700,

                  //Colors.white60,
                  Colors.purpleAccent,
                  Colors.deepPurpleAccent.shade700,
                  Colors.purple,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
          child: Text(
            "Detalles",
            style: GoogleFonts.lilitaOne(
              fontSize: 45,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.deepPurple.withOpacity(0.8),
                  offset: const Offset(1, 3),
                  blurRadius: 10,
                ),
                Shadow(
                  color: Colors.black,
                  offset: const Offset(2, 4),
                  blurRadius: 15,
                ),
              ],
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.deepPurpleAccent,
            size: 28,
            shadows: [
              Shadow(
                color: Colors.deepPurpleAccent,
                offset: Offset(1, 2),
                blurRadius: 15,
              ),
            ],
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.favorite_border,
              color: Colors.deepPurpleAccent.shade700,
              size: 30,
              shadows: [
                Shadow(
                  color: Colors.deepPurpleAccent,
                  offset: Offset(1, 1),
                  blurRadius: 15,
                ),
              ],
            ),
            onPressed: () {
              // Añadir a favoritos
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Añadido a favoritos'),
                  backgroundColor:
                      Colors.deepPurpleAccent.shade700,
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),

      body: Stack(
        children: [
          // Fondo con degradado
          /*Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF121212),
                  Colors.deepPurpleAccent.shade700,
                ],
              ),
            ),
          ),*/
          // Contenido principal
          SafeArea(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  // Imagen del producto con sombra y bordes redondeados
                  _buildProductImage(),

                  // Contenedor de detalles con fondo semi-transparente
                  Container(
                    margin: EdgeInsets.only(top: 25),
                    padding: EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Color(0xFF121212),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      border: Border.all(
                        color:
                            Colors
                                .deepPurpleAccent
                                .shade700,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color:
                              Colors
                                  .deepPurpleAccent
                                  .shade700,
                          blurRadius: 20,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        // Nombre y precio
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                widget.product.Name ??
                                    'Sin nombre',
                                style: GoogleFonts.nunito(
                                  fontSize: 33,
                                  fontWeight:
                                      FontWeight.w900,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      color: Colors
                                          .purpleAccent
                                          .withOpacity(0.5),
                                      offset: Offset(0, 1),
                                      blurRadius: 5,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.purpleAccent
                                        .withOpacity(0.5),
                                    Colors.deepPurpleAccent
                                        .withOpacity(0.7),
                                  ],
                                  begin: Alignment.topLeft,
                                  end:
                                      Alignment.bottomRight,
                                ),
                                borderRadius:
                                    BorderRadius.circular(
                                      15,
                                    ),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        Colors
                                            .deepPurpleAccent
                                            .shade700,
                                    blurRadius: 8,
                                    offset: Offset(1, 1),
                                  ),
                                ],
                              ),
                              child: Text(
                                '\$ ${widget.product.Price ?? '0'}',
                                style: GoogleFonts.nunito(
                                  fontSize: 21,
                                  fontWeight:
                                      FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),

                        //Divider(),
                        const SizedBox(height: 15),

                        // Selector de cantidad
                        _buildQuantitySelector(),

                        SizedBox(height: 25),

                        // Descripción
                        Text(
                          'Descripción',
                          style: GoogleFonts.nunito(
                            fontSize: 20.5,
                            fontWeight: FontWeight.w800,
                            color: Colors.purpleAccent,
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.grey[900]
                                ?.withOpacity(0.5),
                            borderRadius:
                                BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.purple.shade400
                                  .withOpacity(0.3),
                              width: 3,
                            ),
                          ),
                          child: Text(
                            widget.product.Description ??
                                'Sin descripción',
                            style: GoogleFonts.nunito(
                              fontSize: 17.5,
                              fontWeight: FontWeight.w600,
                              color: Colors.white
                                  .withOpacity(0.9),
                              height: 2,
                            ),
                          ),
                        ),

                        SizedBox(height: 30),

                        // Botón de compra
                        _buildBuyButton(),

                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                  // Sección de productos relacionados
                  _buildRelatedProducts(),

                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage() {
    return Container(
      height: 300,
      width: double.infinity,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurpleAccent.shade700,
            blurRadius: 15,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child:
            widget.product.productImg != null
                ? Image.network(
                  '${AppConfig.getProductImageUrl()}?fileLocation=${Uri.encodeComponent(widget.product.productImg!)}',
                  fit: BoxFit.cover,
                  errorBuilder: (
                    context,
                    error,
                    stackTrace,
                  ) {
                    print('Error al cargar imagen: $error');
                    return Container(
                      color: Colors.grey[800],
                      child: Center(
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.white70,
                          size: 80,
                        ),
                      ),
                    );
                  },
                  loadingBuilder: (
                    context,
                    child,
                    loadingProgress,
                  ) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return Container(
                      color: Colors.grey[800],
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
                  color: Colors.grey[800],
                  child: Center(
                    child: Icon(
                      Icons.image,
                      color: Colors.white70,
                      size: 80,
                    ),
                  ),
                ),
      ),
    );
  }

  Widget _buildQuantitySelector() {
    return Row(
      children: [
        Text(
          'Cantidad:',
          style: GoogleFonts.nunito(
            fontSize: 20.5,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        SizedBox(width: 20),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.purpleAccent.withOpacity(0.2),
                Colors.deepPurpleAccent.withOpacity(0.3),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Colors.purple.shade400.withOpacity(
                0.5,
              ),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              _buildQuantityButton(Icons.remove, () {
                setState(() {
                  if (quantity > 1) quantity--;
                });
              }),
              Container(
                width: 40,
                alignment: Alignment.center,
                child: Text(
                  quantity.toString(),
                  style: GoogleFonts.nunito(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              _buildQuantityButton(Icons.add, () {
                setState(() {
                  quantity++;
                });
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuantityButton(
    IconData icon,
    VoidCallback onPressed,
  ) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.purpleAccent.withOpacity(0.4),
              Colors.deepPurpleAccent.withOpacity(0.6),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.white, size: 23),
      ),
    );
  }

  Widget _buildBuyButton() {
    return Center(
      child: InkWell(
        onTap: () {
          // Acción de compra
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Añadido al carrito'),
              backgroundColor:
                  Colors.deepPurpleAccent.shade700,
              duration: Duration(seconds: 2),
            ),
          );
        },
        borderRadius: BorderRadius.circular(25),
        child: Container(
          width: double.infinity,
          height: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: LinearGradient(
              colors: [
                Colors.purple.shade400,
                const Color.fromARGB(255, 59, 19, 170),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.purple.shade700.withOpacity(
                  0.5,
                ),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
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
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 12,
                        color: const Color.fromARGB(
                          255,
                          38,
                          43,
                          46,
                        ),
                      ),
                      borderRadius: BorderRadius.circular(
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
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      border: Border.all(width: 3),
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(
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
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
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
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
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
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        30,
                      ),
                    ),
                  ),
                ),
              ),

              // Texto del botón con icono
              Center(
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                      size: 30,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Añadir al Carrito',
                      style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                        shadows: [
                          Shadow(
                            color: Colors.deepPurple
                                .withOpacity(0.8),
                            offset: const Offset(1, 3),
                            blurRadius: 10,
                          ),
                          Shadow(
                            color: Colors.black.withOpacity(
                              0.6,
                            ),
                            offset: const Offset(2, 4),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
