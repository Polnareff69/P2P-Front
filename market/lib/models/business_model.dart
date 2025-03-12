// models/business_model.dart
class Business {
  String name;
  String phonenumber;
  String description;
  //String userid;

  Business({
    required this.name,
    required this.phonenumber,
    required this.description,
    //required this.userid,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phonenumber': phonenumber,
      'description': description,
      //'userid': userid,
    };
  }
}