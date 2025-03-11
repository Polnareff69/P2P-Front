// lib/models/product_model.dart
class Product {
  String? Name;
  String? Price;
  //String? category;
  //int? discount;
  //int? quantity;
  String? Description;
  //List<String> sizes = [];
  //List<String> images = []; // Cambiamos File a String para enviar URLs o base64
  String? UserId;

  Product({
    this.Name,
    this.Price,
    //this.category,
    //this.discount,
    //this.quantity,
    this.Description,
    this.UserId,
    //required this.sizes,
    //equired this.images,
  });

  // Convertir el modelo a JSON
  Map<String, dynamic> toJson() {
    return {
      'Name': Name,
      'Price': Price,
      //'category': category,
      //'discount': discount,
      //'quantity': quantity,
      'Description': Description,
      //'sizes': sizes,
      //'images': images,
      'UserId': UserId,
    };
  }
}
