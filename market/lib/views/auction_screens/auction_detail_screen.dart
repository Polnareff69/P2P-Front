// lib/views/auction_screens/auction_detail_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market/config/app_config.dart';
import 'package:market/controllers/auction_controller.dart';
import 'package:market/models/auction_model.dart';
import 'package:market/models/auction_bid_model.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class AuctionDetailScreen extends StatefulWidget {
  final Auction auction;

  const AuctionDetailScreen({
    Key? key,
    required this.auction,
  }) : super(key: key);

  @override
  _AuctionDetailScreenState createState() =>
      _AuctionDetailScreenState();
}

class _AuctionDetailScreenState
    extends State<AuctionDetailScreen> {
  final AuctionController _auctionController =
      AuctionController();
  final TextEditingController _bidController =
      TextEditingController();

  Auction? updatedAuction;
  List<AuctionBid> bids = [];
  bool isLoading = true;
  bool isBidLoading = false;
  Timer? _timer;
  String remainingTime = '';

  @override
  void initState() {
    super.initState();
    updatedAuction = widget.auction;
    _loadAuctionDetails();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _bidController.dispose();
    super.dispose();
  }

  // Iniciar temporizador para actualizar el tiempo restante
  void _startTimer() {
    _updateRemainingTime();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _updateRemainingTime();
    });
  }

  // Actualizar el tiempo restante
  void _updateRemainingTime() {
    if (updatedAuction == null) return;

    setState(() {
      remainingTime = updatedAuction!.timeRemaining;
    });
  }

  // Cargar detalles de la subasta y pujas
  Future<void> _loadAuctionDetails() async {
    setState(() {
      isLoading = true;
    });

    try {
      if (kDebugMode) {
        print(
          '🔄 Cargando detalles de subasta: ${widget.auction.id}',
        );
      }

      // Cargar detalles actualizados de la subasta
      final auction = await _auctionController
          .getAuctionById(widget.auction.id);

      // ✅ CORREGIDO: Cargar historial de pujas usando método corregido
      final bidHistory = await _auctionController
          .getBidsForAuction(widget.auction.id);

      setState(() {
        updatedAuction = auction;
        bids = bidHistory;
        isLoading = false;
      });

      if (kDebugMode) {
        print('✅ Detalles cargados:');
        print('   Precio actual: ${auction.currentPrice}');
        print('   Total pujas: ${bidHistory.length}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error al cargar detalles de subasta: $e');
      }

      setState(() {
        isLoading = false;
      });

      _showErrorSnackBar(
        'Error al cargar detalles: ${e.toString().replaceAll('Exception: ', '')}',
      );
    }
  }

  // ✅ NUEVOS MÉTODOS AUXILIARES para mensajes
  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: Duration(seconds: 4),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error, color: Colors.white),
            SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: Duration(seconds: 5),
      ),
    );
  }

  // Realizar una puja
  Future<void> _placeBid() async {
    // Validaciones de entrada
    if (_bidController.text.isEmpty) {
      _showErrorSnackBar(
        'Por favor, ingresa un monto para la puja',
      );
      return;
    }

    // Limpiar y convertir el monto
    final bidAmountText = _bidController.text.replaceAll(
      RegExp(r'[^0-9]'),
      '',
    );
    final bidAmount = int.tryParse(bidAmountText);

    if (bidAmount == null || bidAmount <= 0) {
      _showErrorSnackBar(
        'Por favor, ingresa un monto válido mayor a 0',
      );
      return;
    }

    // Verificar que la subasta esté activa
    if (updatedAuction == null ||
        !_auctionController.canPlaceBid(updatedAuction!)) {
      _showErrorSnackBar(
        'Esta subasta no está disponible para pujas',
      );
      return;
    }

    // Validar monto mínimo
    final currentPrice =
        updatedAuction!.currentPrice ??
        updatedAuction!.initialPrice;
    if (!_auctionController.validateBid(
      bidAmount,
      currentPrice,
    )) {
      final minimumBid = _auctionController
          .getMinimumBidAmount(currentPrice);
      _showErrorSnackBar(
        'Tu puja debe ser mayor que ${NumberFormat.currency(locale: 'es_CO', symbol: '\$', decimalDigits: 0).format(currentPrice)}.\n'
        'Monto mínimo sugerido: ${NumberFormat.currency(locale: 'es_CO', symbol: '\$', decimalDigits: 0).format(minimumBid)}',
      );
      return;
    }

    setState(() {
      isBidLoading = true;
    });

    try {
      if (kDebugMode) {
        print('🎯 Realizando puja:');
        print('   Subasta ID: ${updatedAuction!.id}');
        print('   Monto: $bidAmount');
        print('   Precio actual: $currentPrice');
      }

      // ✅ CORREGIDO: Crear puja según tu backend (sin user_id)
      final bid = AuctionBid(
        id: '', // Se genera en el backend
        auctionId: updatedAuction!.id,
        userId: '', // Se obtiene del token en el backend
        bidAmount: bidAmount,
      );

      // Enviar la puja
      final createdBid = await _auctionController.placeBid(
        bid,
      );

      if (kDebugMode) {
        print(
          '✅ Puja creada exitosamente: ${createdBid.id}',
        );
      }

      // Limpiar campo y recargar datos
      _bidController.clear();
      await _loadAuctionDetails();

      _showSuccessSnackBar(
        '¡Puja realizada con éxito por ${createdBid.formattedBidAmount}!',
      );
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error al realizar puja: $e');
      }

      String errorMessage = 'Error al realizar la puja';
      if (e.toString().contains('Exception:')) {
        errorMessage = e.toString().replaceAll(
          'Exception: ',
          '',
        );
      }

      _showErrorSnackBar(errorMessage);
    } finally {
      setState(() {
        isBidLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Detalles de Subasta",
          style: GoogleFonts.nunito(
            fontSize: 24,
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
      body:
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
                      'Cargando detalles...',
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              )
              : RefreshIndicator(
                onRefresh: _loadAuctionDetails,
                color: Colors.purpleAccent,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        _buildProductSection(),
                        SizedBox(height: 24),
                        _buildAuctionInfoSection(),
                        SizedBox(height: 24),
                        _buildBidsHistorySection(),
                        SizedBox(height: 24),
                        _buildBidSection(),
                        SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }

  // Sección de información del producto
  Widget _buildProductSection() {
    final productName =
        updatedAuction?.product != null &&
                updatedAuction!.product!.containsKey(
                  'name',
                ) &&
                updatedAuction!.product!['name'] != null
            ? updatedAuction!.product!['name']
            : 'Producto sin nombre';

    final productImg =
        updatedAuction?.product != null &&
                updatedAuction!.product!.containsKey(
                  'productimg',
                ) &&
                updatedAuction!.product!['productimg'] !=
                    null
            ? updatedAuction!.product!['productimg']
            : null;

    final productDescription =
        updatedAuction?.product != null &&
                updatedAuction!.product!.containsKey(
                  'description',
                ) &&
                updatedAuction!.product!['description'] !=
                    null
            ? updatedAuction!.product!['description']
            : 'Sin descripción';

    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen del producto con efecto de sombra
          Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
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
                            color: Colors.grey[800],
                            child: Center(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment
                                        .center,
                                children: [
                                  Icon(
                                    Icons
                                        .image_not_supported,
                                    color: Colors.white70,
                                    size: 50,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Imagen no disponible',
                                    style: TextStyle(
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
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
          ),

          // Información del producto
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nombre del producto con estilo
                Text(
                  productName,
                  style: GoogleFonts.nunito(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.deepPurple
                            .withOpacity(0.9),
                        offset: const Offset(1, 2),
                        blurRadius: 10,
                      ),
                      Shadow(
                        color: Colors.black.withOpacity(
                          0.6,
                        ),
                        offset: const Offset(2, 3),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),

                // Estado de la subasta
                _buildStatusBadge(updatedAuction!),
                SizedBox(height: 16),

                // Descripción del producto
                Text(
                  'Descripción:',
                  style: GoogleFonts.nunito(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.purpleAccent.shade700,
                    shadows: [
                      Shadow(
                        color: Colors.deepPurple
                            .withOpacity(0.8),
                        offset: const Offset(1, 2),
                        blurRadius: 10,
                      ),
                      Shadow(
                        color: Colors.black.withOpacity(
                          0.6,
                        ),
                        offset: const Offset(2, 3),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  productDescription,
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    color: Colors.white70,
                    shadows: [
                      Shadow(
                        color: Colors.deepPurple
                            .withOpacity(0.8),
                        offset: const Offset(1, 2),
                        blurRadius: 10,
                      ),
                      Shadow(
                        color: Colors.black.withOpacity(
                          0.6,
                        ),
                        offset: const Offset(2, 3),
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
    );
  }

  // Sección de información de la subasta
  Widget _buildAuctionInfoSection() {
    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 7,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título de la sección
            Text(
              'Información de la Subasta',
              style: GoogleFonts.nunito(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.deepPurple.withOpacity(
                      0.9,
                    ),
                    offset: const Offset(1, 2),
                    blurRadius: 10,
                  ),
                  Shadow(
                    color: Colors.black.withOpacity(0.6),
                    offset: const Offset(2, 3),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.white24,
              thickness: 1,
              height: 24,
            ),

            // Precios
            _buildInfoRow(
              'Precio inicial:',
              updatedAuction!.formattedInitialPrice,
              iconColor: Colors.deepPurpleAccent,
              icon: Icons.sell,
            ),
            SizedBox(height: 12),
            _buildInfoRow(
              'Precio actual:',
              updatedAuction!.formattedCurrentPrice,
              iconColor: Colors.green,
              icon: Icons.monetization_on,
              valueStyle: GoogleFonts.nunito(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.greenAccent,
                shadows: [
                  Shadow(
                    color: Colors.deepPurple.withOpacity(
                      0.8,
                    ),
                    offset: const Offset(1, 2),
                    blurRadius: 10,
                  ),
                  Shadow(
                    color: Colors.black.withOpacity(0.6),
                    offset: const Offset(2, 3),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),

            // Fechas
            _buildInfoRow(
              'Fecha de inicio:',
              DateFormat(
                'dd/MM/yyyy HH:mm',
              ).format(updatedAuction!.startDate),
              iconColor: Colors.blue,
              icon: Icons.calendar_today,
            ),
            SizedBox(height: 12),
            _buildInfoRow(
              'Fecha de fin:',
              DateFormat(
                'dd/MM/yyyy HH:mm',
              ).format(updatedAuction!.endDate),
              iconColor: Colors.red,
              icon: Icons.event_busy,
            ),
            SizedBox(height: 16),

            // Tiempo restante
            _buildTimeRemainingWidget(),
          ],
        ),
      ),
    );
  }

  // Widget para mostrar el tiempo restante con animación
  Widget _buildTimeRemainingWidget() {
    Color timeColor;

    if (updatedAuction!.hasEnded) {
      timeColor = Colors.red;
    } else if (updatedAuction!.isActive) {
      // Determinar color basado en cuánto tiempo queda
      final daysLeft =
          updatedAuction!.endDate
              .difference(DateTime.now())
              .inDays;
      if (daysLeft < 1) {
        timeColor = Colors.red; // Menos de un día
      } else if (daysLeft < 3) {
        timeColor = Colors.orange; // Menos de tres días
      } else {
        timeColor = Colors.green; // Más de tres días
      }
    } else {
      timeColor = Colors.blue;
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: timeColor.withOpacity(0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: timeColor.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.timer,
            color: timeColor,
            size: 24,
            shadows: [
              Shadow(
                color: Colors.deepPurple.withOpacity(0.8),
                offset: const Offset(1, 2),
                blurRadius: 10,
              ),
              Shadow(
                color: Colors.black.withOpacity(0.6),
                offset: const Offset(2, 3),
                blurRadius: 4,
              ),
            ],
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tiempo restante:',
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  color: Colors.white70,
                  shadows: [
                    Shadow(
                      color: Colors.deepPurple.withOpacity(
                        0.8,
                      ),
                      offset: const Offset(1, 2),
                      blurRadius: 10,
                    ),
                    Shadow(
                      color: Colors.black.withOpacity(0.6),
                      offset: const Offset(2, 3),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
              AnimatedSwitcher(
                duration: Duration(milliseconds: 500),
                child: Text(
                  remainingTime,
                  key: ValueKey<String>(remainingTime),
                  style: GoogleFonts.nunito(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: timeColor,
                    shadows: [
                      Shadow(
                        color: Colors.deepPurple
                            .withOpacity(0.8),
                        offset: const Offset(1, 2),
                        blurRadius: 10,
                      ),
                      Shadow(
                        color: Colors.black.withOpacity(
                          0.6,
                        ),
                        offset: const Offset(2, 3),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Sección de historial de pujas
  Widget _buildBidsHistorySection() {
    if (bids.isEmpty) {
      return Card(
        color: Colors.grey[900],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 7,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Historial de Pujas',
                style: GoogleFonts.nunito(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.deepPurple.withOpacity(
                        0.8,
                      ),
                      offset: const Offset(1, 2),
                      blurRadius: 10,
                    ),
                    Shadow(
                      color: Colors.black.withOpacity(0.6),
                      offset: const Offset(2, 3),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
              Divider(
                color: Colors.white24,
                thickness: 1,
                height: 24,
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Icon(
                        Icons.gavel,
                        size: 48,
                        color: Colors.grey,
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
                      SizedBox(height: 16),
                      Text(
                        'No hay pujas aún. ¡Sé el primero en pujar!',
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          color: Colors.grey,
                          shadows: [
                            Shadow(
                              color: Colors.deepPurple
                                  .withOpacity(0.8),
                              offset: const Offset(1, 2),
                              blurRadius: 10,
                            ),
                            Shadow(
                              color: Colors.black
                                  .withOpacity(0.6),
                              offset: const Offset(2, 3),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
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

    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 7,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Historial de Pujas',
                  style: GoogleFonts.nunito(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.withOpacity(
                      0.2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${bids.length} puja${bids.length != 1 ? 's' : ''}',
                    style: GoogleFonts.nunito(
                      fontSize: 12,
                      color: Colors.deepPurpleAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Divider(
              color: Colors.white24,
              thickness: 1,
              height: 24,
            ),

            //  Lista de pujas
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: bids.length,
              itemBuilder: (context, index) {
                final bid = bids[index];
                final isWinning =
                    index ==
                    0; // La primera es la puja ganadora (están ordenadas)

                return Container(
                  margin: EdgeInsets.only(bottom: 8),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color:
                        isWinning
                            ? Colors.green.withOpacity(0.1)
                            : Colors.grey[850],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          isWinning
                              ? Colors.greenAccent
                                  .withOpacity(0.5)
                              : Colors.transparent,
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(
                          0.3,
                        ),
                        blurRadius: 2,
                        offset: Offset(0, 3),
                        spreadRadius: 1,
                      ),
                      if (isWinning) // Sombra extra para puja ganadora
                        BoxShadow(
                          color: Colors.greenAccent
                              .withOpacity(0.2),
                          blurRadius: 12,
                          offset: Offset(0, 0),
                          spreadRadius: 2,
                        ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Avatar del usuario
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color:
                              isWinning
                                  ? Colors.green
                                  : Colors.deepPurpleAccent,
                          borderRadius:
                              BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withOpacity(0.3),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          isWinning
                              ? Icons.emoji_events
                              : Icons.person,
                          color: Colors.white,
                          size: 20,
                          shadows: [
                            Shadow(
                              color: Colors.deepPurple
                                  .withOpacity(0.8),
                              offset: const Offset(1, 2),
                              blurRadius: 10,
                            ),
                            Shadow(
                              color: Colors.black
                                  .withOpacity(0.6),
                              offset: const Offset(2, 2.5),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(width: 12),

                      // Información del usuario y puja
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment
                                      .spaceBetween,
                              children: [
                                Text(
                                  bid.userName,
                                  style: GoogleFonts.nunito(
                                    fontSize: 16,
                                    fontWeight:
                                        isWinning
                                            ? FontWeight
                                                .bold
                                            : FontWeight
                                                .normal,
                                    color: Colors.white,
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
                                              2,
                                            ),
                                        blurRadius: 10,
                                      ),
                                      Shadow(
                                        color: Colors.black
                                            .withOpacity(
                                              0.6,
                                            ),
                                        offset:
                                            const Offset(
                                              2,
                                              3,
                                            ),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  bid.formattedBidAmount,
                                  style: GoogleFonts.nunito(
                                    fontSize: 16,
                                    fontWeight:
                                        FontWeight.bold,
                                    color:
                                        isWinning
                                            ? Colors
                                                .greenAccent
                                            : Colors
                                                .white70,
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
                                              2,
                                            ),
                                        blurRadius: 10,
                                      ),
                                      Shadow(
                                        color: Colors.black
                                            .withOpacity(
                                              0.6,
                                            ),
                                        offset:
                                            const Offset(
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
                            if (isWinning)
                              Text(
                                '🏆 Puja ganadora actual',
                                style: GoogleFonts.nunito(
                                  fontSize: 12,
                                  color: Colors.greenAccent,
                                  fontWeight:
                                      FontWeight.w600,
                                  shadows: [
                                    Shadow(
                                      color: Colors
                                          .deepPurple
                                          .withOpacity(0.8),
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
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Sección para realizar pujas
  Widget _buildBidSection() {
    // No mostrar la sección si la subasta ha terminado o no ha comenzado
    if (updatedAuction!.hasEnded) {
      return Card(
        color: Colors.grey[900],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 7,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(
                Icons.timer_off,
                color: Colors.red,
                size: 48,
              ),
              SizedBox(height: 16),
              Text(
                'Esta subasta ha finalizado',
                style: GoogleFonts.nunito(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                bids.isNotEmpty
                    ? '¡La puja ganadora fue de ${bids.first.formattedBidAmount}!'
                    : 'No se realizaron pujas en esta subasta.',
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    } else if (!updatedAuction!.isActive) {
      return Card(
        color: Colors.grey[900],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 7,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(
                Icons.update,
                color: Colors.orange,
                size: 48,
              ),
              SizedBox(height: 16),
              Text(
                'Esta subasta aún no ha comenzado',
                style: GoogleFonts.nunito(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                'Vuelve el ${DateFormat('dd/MM/yyyy').format(updatedAuction!.startDate)} para participar.',
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // Mostrar sección para realizar pujas si la subasta está activa
    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 7,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Realizar Puja',
                style: GoogleFonts.nunito(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.deepPurple.withOpacity(
                        0.8,
                      ),
                      offset: const Offset(1, 2),
                      blurRadius: 10,
                    ),
                    Shadow(
                      color: Colors.black.withOpacity(0.6),
                      offset: const Offset(2, 3),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              color: Colors.white24,
              thickness: 1,
              height: 24,
            ),
            Text(
              'Ingresa un monto mayor a ${updatedAuction!.formattedCurrentPrice}',
              style: GoogleFonts.nunito(
                fontSize: 16,
                color: Colors.white70,
                shadows: [
                  Shadow(
                    color: Colors.deepPurple.withOpacity(
                      0.8,
                    ),
                    offset: const Offset(1, 3),
                    blurRadius: 10,
                  ),
                  Shadow(
                    color: Colors.black.withOpacity(0.6),
                    offset: const Offset(2, 3),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _bidController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[850],
                      hintText: 'Monto de tu puja',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        shadows: [
                          Shadow(
                            color: Colors.deepPurple
                                .withOpacity(0.8),
                            offset: const Offset(1, 2),
                            blurRadius: 10,
                          ),
                          Shadow(
                            color: Colors.black.withOpacity(
                              0.6,
                            ),
                            offset: const Offset(2, 3),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      prefixIcon: Icon(
                        Icons.attach_money,
                        color: Colors.greenAccent,
                        shadows: [
                          Shadow(
                            color: Colors.deepPurple
                                .withOpacity(0.8),
                            offset: const Offset(1, 2),
                            blurRadius: 10,
                          ),
                          Shadow(
                            color: Colors.black.withOpacity(
                              0.6,
                            ),
                            offset: const Offset(2, 3),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          12,
                        ),
                        borderSide: BorderSide(
                          color: Colors.deepPurple
                              .withOpacity(0.5),
                          width: 2.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          12,
                        ),
                        borderSide: BorderSide(
                          color: Colors.deepPurple,
                          width: 3,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                SizedBox(
                  height: 56,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors:
                            isBidLoading
                                ? [
                                  Colors.grey.shade600,
                                  Colors.grey.shade700,
                                  Colors.grey.shade800,
                                ]
                                : [
                                  Colors
                                      .deepPurple
                                      .shade400,
                                  Colors
                                      .deepPurple
                                      .shade600,
                                  Colors.purple.shade800,
                                ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(
                        12,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (isBidLoading
                                  ? Colors.grey
                                  : Colors.deepPurple)
                              .withOpacity(0.4),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(
                        12,
                      ),
                      child: InkWell(
                        onTap:
                            isBidLoading ? null : _placeBid,
                        borderRadius: BorderRadius.circular(
                          12,
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          child: Center(
                            child:
                                isBidLoading
                                    ? SizedBox(
                                      width: 20,
                                      height: 20,
                                      child:
                                          CircularProgressIndicator(
                                            color:
                                                Colors
                                                    .white,
                                            strokeWidth: 2,
                                          ),
                                    )
                                    : Text(
                                      'Pujar',
                                      style: GoogleFonts.nunito(
                                        fontSize: 16,
                                        fontWeight:
                                            FontWeight.bold,
                                        color: Colors.white,
                                        shadows: [
                                          Shadow(
                                            color: Colors
                                                .black
                                                .withOpacity(
                                                  0.6,
                                                ),
                                            offset:
                                                const Offset(
                                                  2,
                                                  3,
                                                ),
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
                ),
              ],
            ),
            SizedBox(height: 15),
            Text(
              'Al pujar, aceptas los términos y condiciones de la subasta.',
              style: GoogleFonts.nunito(
                fontSize: 12,
                color: Colors.white54,
                fontStyle: FontStyle.italic,
                shadows: [
                  Shadow(
                    color: Colors.deepPurple.withOpacity(
                      0.8,
                    ),
                    offset: const Offset(1, 2),
                    blurRadius: 10,
                  ),
                  Shadow(
                    color: Colors.black.withOpacity(0.6),
                    offset: const Offset(2, 3),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para mostrar filas de información
  Widget _buildInfoRow(
    String label,
    String value, {
    required IconData icon,
    required Color iconColor,
    TextStyle? valueStyle,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: iconColor,
          size: 20,
          shadows: [
            Shadow(
              color: Colors.deepPurple.withOpacity(0.8),
              offset: const Offset(1, 2),
              blurRadius: 10,
            ),
            Shadow(
              color: Colors.black.withOpacity(0.6),
              offset: const Offset(2, 3),
              blurRadius: 4,
            ),
          ],
        ),
        SizedBox(width: 12),
        Text(
          label,
          style: GoogleFonts.nunito(
            fontSize: 16,
            color: Colors.white70,
            shadows: [
              Shadow(
                color: Colors.deepPurple.withOpacity(0.7),
                offset: const Offset(1, 2),
                blurRadius: 10,
              ),
              Shadow(
                color: Colors.black.withOpacity(0.6),
                offset: const Offset(2, 3),
                blurRadius: 4,
              ),
            ],
          ),
        ),
        SizedBox(width: 8),
        Text(
          value,
          style:
              valueStyle ??
              GoogleFonts.nunito(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.deepPurple.withOpacity(
                      0.8,
                    ),
                    offset: const Offset(1, 2),
                    blurRadius: 10,
                  ),
                  Shadow(
                    color: Colors.black.withOpacity(0.6),
                    offset: const Offset(2, 3),
                    blurRadius: 4,
                  ),
                ],
              ),
        ),
      ],
    );
  }

  // Widget para mostrar el estado de la subasta
  Widget _buildStatusBadge(Auction auction) {
    Color badgeColor;
    String status;

    if (auction.hasEnded) {
      badgeColor = const Color.fromARGB(255, 130, 15, 7);
      status = "Finalizada";
    } else if (auction.isActive) {
      badgeColor = Colors.green;
      status = "Activa";
    } else {
      badgeColor = Colors.orange;
      status = "Próximamente";
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: badgeColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: badgeColor.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            auction.hasEnded
                ? Icons.timer_off
                : (auction.isActive
                    ? Icons.gavel
                    : Icons.update),
            color: badgeColor,
            size: 16,
          ),
          SizedBox(width: 8),
          Text(
            status,
            style: GoogleFonts.nunito(
              color: badgeColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.6),
                  offset: const Offset(1, 2),
                  blurRadius: 3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
}
