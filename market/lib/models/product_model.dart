// lib/models/product_model.dart
class Product {
  String? Name;
  String? Price;
  String? Description;
  String? productImg;
  //String? category;
  //int? discount;
  //int? quantity;

  Product({
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
      Name: json['name'],
      Price: json['price']?.toString(),
      Description: json['description'],
      productImg: json['productimg'],
    );
  }
}
