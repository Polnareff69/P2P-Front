// models/business_model.dart
class Business {
  String name;
  String phonenumber;
  String description;

  Business({
    required this.name,
    required this.phonenumber,
    required this.description,
    
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phonenumber': phonenumber,
      'description': description,
      
    };
  }
}