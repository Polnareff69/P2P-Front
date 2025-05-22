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
      // Cargar detalles actualizados de la subasta
      final auction = await _auctionController
          .getAuctionById(widget.auction.id);

      // Cargar historial de pujas
      final bidHistory = await _auctionController
          .getBidsForAuction(widget.auction.id);

      setState(() {
        updatedAuction = auction;
        bids = bidHistory;
        isLoading = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error al cargar detalles de subasta: $e');
      }

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar detalles: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Realizar una puja
  Future<void> _placeBid() async {
    // Validar entrada
    if (_bidController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Por favor, ingresa un monto para la puja',
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Convertir y validar el monto
    final bidAmount = int.tryParse(
      _bidController.text.replaceAll(RegExp(r'[^0-9]'), ''),
    );

    if (bidAmount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Por favor, ingresa un monto válido',
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Validar que sea mayor que el precio actual
    if (bidAmount <= (updatedAuction?.currentPrice ?? 0)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Tu puja debe ser mayor que el precio actual (${updatedAuction?.formattedCurrentPrice})',
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      isBidLoading = true;
    });

    try {
      // Crear objeto de puja
      final bid = AuctionBid(
        id: '',
        auctionId: updatedAuction!.id,
        userId: '', // El backend lo obtendrá del token
        bidAmount: bidAmount,
      );

      // Enviar la puja
      await _auctionController.placeBid(bid);

      // Limpiar campo
      _bidController.clear();

      // Recargar información actualizada
      await _loadAuctionDetails();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('¡Puja realizada con éxito!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al realizar la puja: $e'),
          backgroundColor: Colors.red,
        ),
      );
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
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen del producto con efecto de sombra
          Container(
            height: 240,
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
                    color: Colors.purpleAccent,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  productDescription,
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    color: Colors.white70,
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
      elevation: 5,
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
              iconColor: Colors.orange,
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
          Icon(Icons.timer, color: timeColor, size: 24),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tiempo restante:',
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  color: Colors.white70,
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
        elevation: 5,
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
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No hay pujas aún. ¡Sé el primero en pujar!',
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          color: Colors.grey,
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
      elevation: 5,
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
              ),
            ),
            Divider(
              color: Colors.white24,
              thickness: 1,
              height: 24,
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: bids.length,
              itemBuilder: (context, index) {
                final bid = bids[index];
                final username =
                    bid.user != null &&
                            bid.user!.containsKey(
                              'username',
                            )
                        ? bid.user!['username']
                        : 'Usuario ${bid.userId.substring(0, 4)}';

                return Container(
                  margin: EdgeInsets.only(bottom: 8),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[850],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color:
                          index == 0
                              ? Colors.greenAccent
                                  .withOpacity(0.5)
                              : Colors.transparent,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor:
                                index == 0
                                    ? Colors.green
                                    : Colors.deepPurple,
                            radius: 16,
                            child: Icon(
                              index == 0
                                  ? Icons.emoji_events
                                  : Icons.person,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            username,
                            style: GoogleFonts.nunito(
                              fontSize: 16,
                              fontWeight:
                                  index == 0
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        bid.formattedBidAmount,
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color:
                              index == 0
                                  ? Colors.greenAccent
                                  : Colors.white70,
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
        elevation: 5,
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
        elevation: 5,
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
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Realizar Puja',
              style: GoogleFonts.nunito(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
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
                      ),
                      prefixIcon: Icon(
                        Icons.attach_money,
                        color: Colors.greenAccent,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          12,
                        ),
                        borderSide: BorderSide(
                          color: Colors.deepPurple
                              .withOpacity(0.5),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          12,
                        ),
                        borderSide: BorderSide(
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed:
                        isBidLoading ? null : _placeBid,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          12,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                    ),
                    child:
                        isBidLoading
                            ? SizedBox(
                              width: 20,
                              height: 20,
                              child:
                                  CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                            )
                            : Text(
                              'Pujar',
                              style: GoogleFonts.nunito(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              'Al pujar, aceptas los términos y condiciones de la subasta.',
              style: GoogleFonts.nunito(
                fontSize: 12,
                color: Colors.white54,
                fontStyle: FontStyle.italic,
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
        Icon(icon, color: iconColor, size: 20),
        SizedBox(width: 12),
        Text(
          label,
          style: GoogleFonts.nunito(
            fontSize: 16,
            color: Colors.white70,
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
      badgeColor = Colors.red;
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
            ),
          ),
        ],
      ),
    );
  }
}
