// lib/views/auction_screens/auctions_list_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market/config/app_config.dart';
import 'package:market/controllers/auction_controller.dart';
import 'package:market/models/auction_model.dart';
import 'package:market/views/widgets/floating_menu_button.dart';
import 'package:market/views/auction_screens/create_auction_screen.dart';
import 'package:market/views/auction_screens/auction_detail_screen.dart';

class AuctionsListScreen extends StatefulWidget {
  const AuctionsListScreen({Key? key}) : super(key: key);

  @override
  _AuctionsListScreenState createState() =>
      _AuctionsListScreenState();
}

class _AuctionsListScreenState
    extends State<AuctionsListScreen> {
  final AuctionController _auctionController =
      AuctionController();
  List<Auction> auctions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAuctions();
  }

  Future<void> _loadAuctions() async {
    setState(() {
      isLoading = true;
    });

    try {
      final loadedAuctions =
          await _auctionController.getAllAuctions();
      setState(() {
        auctions = loadedAuctions;
        isLoading = false;
      });
    } catch (e) {
      print('Error al cargar subastas: $e');
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar subastas: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Subastas",
          style: GoogleFonts.nunito(
            fontSize: 35,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.deepPurpleAccent,
                offset: const Offset(1, 3),
                blurRadius: 6,
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
          // Contenido principal
          isLoading
              ? Center(
                child: CircularProgressIndicator(
                  color: Colors.purpleAccent,
                ),
              )
              : auctions.isEmpty
              ? _buildEmptyState()
              : _buildAuctionsList(),

          // Menú flotante
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
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 8,
            right: 16,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.purple.shade900,
                    Colors.purple.shade800,
                    Colors.purple.shade800,
                    Colors.purple.shade700,
                    Colors.purple.shade700,
                    Colors.purple.shade800,
                    Colors.purple.shade900,
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 4,
                    offset: Offset(2, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                shape: CircleBorder(),
                child: InkWell(
                  customBorder: CircleBorder(),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                CreateAuctionScreen(),
                      ),
                    ).then((_) => _loadAuctions());
                  },
                  child: Center(
                    child: Icon(
                      Icons.add,
                      color: const Color(0xFF121212),
                      size: 28,
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.gavel, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            "No hay subastas disponibles",
            style: GoogleFonts.nunito(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "¡Crea una nueva subasta!",
            style: GoogleFonts.nunito(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuctionsList() {
    return RefreshIndicator(
      onRefresh: _loadAuctions,
      color: Colors.purpleAccent,
      child:
          isLoading
              ? Center(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.purpleAccent,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Cargando subastas y productos...',
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              )
              : auctions.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: auctions.length,
                itemBuilder: (context, index) {
                  final auction = auctions[index];
                  return _buildAuctionCard(auction);
                },
              ),
    );
  }

  Widget _buildAuctionCard(Auction auction) {
    // Obtener información del producto
    final productName =
        auction.product != null &&
                auction.product!.containsKey('name') &&
                auction.product!['name'] != null
            ? auction.product!['name']
            : 'Subasta #${auction.id.substring(0, 8)}';

    final productImg =
        auction.product != null &&
                auction.product!.containsKey(
                  'productimg',
                ) &&
                auction.product!['productimg'] != null
            ? auction.product!['productimg']
            : null;

    return Card(
      margin: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 4,
      ),
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 7,
      child: InkWell(
        onTap: () {
          // Navegar a la pantalla de detalle al tocar cualquier parte de la tarjeta
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                      AuctionDetailScreen(auction: auction),
            ),
          ).then((_) => _loadAuctions());
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 20,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // COLUMNA IZQUIERDA: Información de la subasta
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: 14,
                    left: 4,
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      // Nombre del producto
                      Center(
                        child: Column(
                          children: [
                            Text(
                              productName,
                              style: GoogleFonts.nunito(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color:
                                        Colors
                                            .deepPurpleAccent,
                                    offset: const Offset(
                                      1,
                                      2,
                                    ),
                                    blurRadius: 10,
                                  ),
                                  Shadow(
                                    color: Colors.black
                                        .withOpacity(0.6),
                                    offset: const Offset(
                                      2,
                                      3,
                                    ),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              maxLines: 1,
                              overflow:
                                  TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4),
                            Container(
                              height: 1,
                              width: 170,
                              decoration: BoxDecoration(
                                color: Colors.grey[700],
                                borderRadius:
                                    BorderRadius.circular(
                                      1,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 25),

                      // Precio actual
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                            ),
                          ),
                          Icon(
                            Icons.monetization_on,
                            color: Colors.greenAccent,
                            size: 20,
                            shadows: [
                              Shadow(
                                color:
                                    Colors.deepPurpleAccent,
                                offset: const Offset(1, 1),
                                blurRadius: 6,
                              ),
                              Shadow(
                                color: Colors.black
                                    .withOpacity(0.6),
                                offset: const Offset(1, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          SizedBox(width: 4),
                          Text(
                            auction.formattedCurrentPrice,
                            style: GoogleFonts.nunito(
                              color: Colors.greenAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              shadows: [
                                Shadow(
                                  color:
                                      Colors
                                          .deepPurpleAccent,
                                  offset: const Offset(
                                    1,
                                    2,
                                  ),
                                  blurRadius: 10,
                                ),
                                Shadow(
                                  color: Colors.black
                                      .withOpacity(0.6),
                                  offset: const Offset(
                                    2,
                                    3,
                                  ),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 6),

                      // Tiempo restante
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 22,
                            ),
                          ),
                          Icon(
                            Icons.access_time_rounded,
                            color: Colors.white70,
                            size: 16,
                            shadows: [
                              Shadow(
                                color: Colors.black
                                    .withOpacity(0.6),
                                offset: const Offset(1, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          SizedBox(width: 4),
                          Text(
                            auction.timeRemaining,
                            style: GoogleFonts.nunito(
                              color: Colors.white70,
                              fontSize: 14,
                              shadows: [
                                Shadow(
                                  color: Colors.black
                                      .withOpacity(0.6),
                                  offset: const Offset(
                                    2,
                                    3,
                                  ),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 29),

                      // Estadod de la subasta
                      _buildCompactStatusBadge(auction),
                    ],
                  ),
                ),
              ),

              SizedBox(width: 12),

              // COLUMNA DERECHA: Imagen del producto y botón de detalles
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    // Imagen del producto
                    Container(
                      height: 140,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          8,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 4,
                            offset: Offset(1, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          8,
                        ),
                        child:
                            productImg != null
                                ? Image.network(
                                  '${AppConfig.getProductImageUrl()}?fileLocation=${Uri.encodeComponent(productImg)}',
                                  fit: BoxFit.cover,
                                  errorBuilder: (
                                    context,
                                    error,
                                    stackTrace,
                                  ) {
                                    return Container(
                                      color:
                                          Colors.grey[800],
                                      child: Icon(
                                        Icons
                                            .image_not_supported,
                                        color:
                                            Colors.white70,
                                        size: 30,
                                      ),
                                    );
                                  },
                                  loadingBuilder: (
                                    context,
                                    child,
                                    loadingProgress,
                                  ) {
                                    if (loadingProgress ==
                                        null)
                                      return child;
                                    return Container(
                                      color:
                                          Colors.grey[800],
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color:
                                              Colors
                                                  .purpleAccent,
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
                                  child: Icon(
                                    Icons.image,
                                    color: Colors.white70,
                                    size: 40,
                                  ),
                                ),
                      ),
                    ),

                    SizedBox(height: 9),

                    // Botón de detalles
                    Container(
                      width: 170,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.purple.shade900,
                            Colors.purple.shade800,
                            Colors.purple.shade800,
                            Colors.purple.shade700,
                            Colors.purple.shade700,
                            Colors.purple.shade800,
                            Colors.purple.shade900,
                          ],
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                        ),
                        borderRadius: BorderRadius.circular(
                          8,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 2,
                            offset: Offset(1, 2),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(
                          8,
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        AuctionDetailScreen(
                                          auction: auction,
                                        ),
                              ),
                            ).then((_) => _loadAuctions());
                          },
                          borderRadius:
                              BorderRadius.circular(8),
                          child: Center(
                            child: Text(
                              "Ver Subasta",
                              style: GoogleFonts.nunito(
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                                color: const Color(
                                  0xFF121212,
                                ),
                                shadows: [
                                  Shadow(
                                    color: Colors.black
                                        .withOpacity(0.8),
                                    offset: const Offset(
                                      0,
                                      0,
                                    ),
                                    blurRadius: 25,
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
            ],
          ),
        ),
      ),
    );
  }

  //  badge de estado
  Widget _buildCompactStatusBadge(Auction auction) {
    Color badgeColor;
    String status;
    IconData statusIcon;

    if (auction.hasEnded) {
      badgeColor = Colors.red;
      status = "Finalizada";
      statusIcon = Icons.timer_off;
    } else if (auction.isActive) {
      badgeColor = Colors.green;
      status = "Activa";
      statusIcon = Icons.gavel;
    } else {
      badgeColor = Colors.orange;
      status = "Próximamente";
      statusIcon = Icons.update;
    }

    return Padding(
      padding: const EdgeInsets.only(left: 21),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: badgeColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: badgeColor, width: 1.8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(
                0.4,
              ), // Color de la sombra
              blurRadius: 2, // Difuminado de la sombra
              offset: Offset(
                1,
                2,
              ), // Desplazamiento en X y Y
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(statusIcon, size: 12, color: badgeColor),
            SizedBox(width: 4),
            Text(
              status,
              style: GoogleFonts.nunito(
                color: badgeColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
