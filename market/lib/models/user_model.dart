class User {
  String name;
  String password;
  //String email;

  User({required this.name, required this.password});

  Map<String, dynamic> toJson() {
    return {'name': name, 'password': password};
  }
}