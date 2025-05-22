// lib/models/auction_bid_model.dart
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
      id: json['id'] ?? '',
      auctionId: json['auction_id'] ?? '',
      userId: json['user_id'] ?? '',
      bidAmount: json['bid_amount'] ?? 0,
      user: json['user'],
      auction: json['auction'],
    );
  }

  // Método para convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'auction_id': auctionId,
      'user_id': userId,
      'bid_amount': bidAmount,
    };
  }

  // Formato de precio
  String get formattedBidAmount => 
    NumberFormat.currency(locale: 'es_CO', symbol: '\$', decimalDigits: 0)
        .format(bidAmount);
}