// lib/models/auction_model.dart
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class Auction {
  final String id;
  final String productId;
  final String ownerId;
  final DateTime startDate;
  final DateTime endDate;
  final int initialPrice;
  final int? currentPrice;
  final Map<String, dynamic>? product;
  final Map<String, dynamic>? owner;

  Auction({
    required this.id,
    required this.productId,
    required this.ownerId,
    required this.startDate,
    required this.endDate,
    required this.initialPrice,
    this.currentPrice,
    this.product,
    this.owner,
  });

  // Método para crear una instancia desde JSON
  factory Auction.fromJson(Map<String, dynamic> json) {
    if (kDebugMode) {
      print('📦 Decodificando Auction: $json');
    }
    return Auction(
      id: json['id'] ?? '',
      productId: json['product_id'] ?? '',
      ownerId: json['owner_id'] ?? '',
      startDate: json['start_date'] != null 
          ? DateTime.parse(json['start_date']) 
          : DateTime.now(),
      endDate: json['end_date'] != null 
          ? DateTime.parse(json['end_date']) 
          : DateTime.now().add(const Duration(days: 7)),
      initialPrice: json['initial_price'] ?? 0,
      currentPrice: json['current_price'],
      product: json['product'],
      owner: json['owner'],
    );
  }

  // Método para convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'owner_id': ownerId,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'initial_price': initialPrice,
      'current_price': currentPrice ?? initialPrice,
    };
  }

  // Estado de la subasta
  bool get isActive => 
    DateTime.now().isAfter(startDate) && 
    DateTime.now().isBefore(endDate);

  bool get hasEnded => DateTime.now().isAfter(endDate);

  bool get hasNotStarted => DateTime.now().isBefore(startDate);

  // Tiempo restante formateado
  String get timeRemaining {
    if (hasEnded) return 'Finalizada';
    if (hasNotStarted) return 'Comienza pronto';
    
    final remaining = endDate.difference(DateTime.now());
    
    if (remaining.inDays > 0) {
      return '${remaining.inDays} día(s)';
    } else if (remaining.inHours > 0) {
      return '${remaining.inHours} hora(s)';
    } else if (remaining.inMinutes > 0) {
      return '${remaining.inMinutes} minuto(s)';
    } else {
      return '${remaining.inSeconds} segundo(s)';
    }
  }

  // Formato de precios
  String get formattedInitialPrice => 
    NumberFormat.currency(locale: 'es_CO', symbol: '\$', decimalDigits: 0)
        .format(initialPrice);

  String get formattedCurrentPrice => 
    currentPrice != null 
    ? NumberFormat.currency(locale: 'es_CO', symbol: '\$', decimalDigits: 0)
        .format(currentPrice) 
    : formattedInitialPrice;
}