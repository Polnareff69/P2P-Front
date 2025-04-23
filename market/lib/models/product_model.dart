// lib/models/product_model.dart
class Product {
  String? Name;
  String? Price;
  String? Description;
  //String? category;
  //int? discount;
  //int? quantity;

  Product({
    this.Name,
    this.Price,
    this.Description,
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
}
