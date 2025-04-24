class Company {
  final String companyId;
  final String? name;
  final String? description;
  final String? companyBackground;
  final String? companyImg;
  final String? userId;
  final String? phoneNumber;

  Company({
    required this.companyId,
    this.name,
    this.description,
    this.companyBackground,
    this.companyImg,
    this.userId,
    this.phoneNumber,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      companyId: json['CompanyId'] ?? '',
      name: json['Name'] ?? 'Sin nombre',
      description: json['description'] ?? '',
      companyBackground: json['companybackgrnd'],
      companyImg: json['companyImg'],
      userId: json['UserId'] ?? '',
      phoneNumber: json['phonenumber'],
    );
  }
}