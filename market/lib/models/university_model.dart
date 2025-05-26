class University {
  final String id;
  final String name;
  final String address;

  University({
    required this.id,
    required this.name,
    required this.address,
  });

  factory University.fromJson(Map<String, dynamic> json) {
    return University(
      id: json['id'],
      name: json['name'],
      address: json['address'],
    );
  }
}
