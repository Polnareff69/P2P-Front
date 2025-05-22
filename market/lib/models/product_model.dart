// lib/models/product_model.dart
import 'package:flutter/foundation.dart';

class Product {
  String? productid; // ID del producto
  String? Name;
  String? Price;
  String? Description;
  String? productImg;
  //String? category;
  //int? discount;
  //int? quantity;

  Product({
    this.productid,
    this.Name,
    this.Price,
    this.Description,
    this.productImg,
    //this.category,
    //this.discount,
    //this.quantity,
  });

  // Convertir el modelo a JSON
  Map<String, dynamic> toJson() {
    return {
      'productid': productid,
      'Name': Name,
      'Price': Price,
      'Description': Description,
      //'category': category,
      //'discount': discount,
      //'quantity': quantity,
    };
  }

  // Crear un objeto Product desde JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productid: json['productid'],
      Name: json['name'],
      Price: json['price']?.toString(),
      Description: json['description'],
      productImg: json['productimg'],
    );
  }

  // Método para depuración
  void printDetails() {
    if (kDebugMode) {
      print('Detalles del producto:');
      print('  ID: $productid');
      print('  Nombre: $Name');
      print('  Precio: $Price');
    }
  }
}
