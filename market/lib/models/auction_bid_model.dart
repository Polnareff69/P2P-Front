// lib/models/auction_bid_model.dart
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class AuctionBid {
  final String id;
  final String auctionId;
  final String userId;
  final int bidAmount;
  final Map<String, dynamic>? user;
  final Map<String, dynamic>? auction;

  AuctionBid({
    required this.id,
    required this.auctionId,
    required this.userId,
    required this.bidAmount,
    this.user,
    this.auction,
  });

  // Método para crear una instancia desde JSON
  factory AuctionBid.fromJson(Map<String, dynamic> json) {
    if (kDebugMode) {
      print('📦 Decodificando AuctionBid: $json');
    }
    return AuctionBid(
      id: json['id']?.toString() ?? '',
      auctionId: json['auction_id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      bidAmount: json['bid_amount'] ?? 0,
      user: json['user'],
      auction: json['auction'],
    );
  }

  // El user_id lo obtiene el backend del token JWT
  Map<String, dynamic> toJson() {
    return {
      'auction_id': auctionId,
      'bid_amount': bidAmount,
      //  NO incluir user_id - backend lo obtiene del token
    };
  }

  // Formato de precio
  String get formattedBidAmount => 
    NumberFormat.currency(locale: 'es_CO', symbol: '\$', decimalDigits: 0)
        .format(bidAmount);

  // Método para obtener el nombre del usuario
  String get userName {
    if (user != null && user!['Name'] != null) {
      return user!['Name'];
    }
    return 'Usuario ${userId.substring(0, min(8, userId.length))}';
  }
}