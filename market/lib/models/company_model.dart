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
      companyImg: json['companyimg'],
      userId: json['UserId'] ?? '',
      phoneNumber: json['phonenumber'],
    );
  }
}

// Modelo más completo para los detalles de la empresa
class CompanyDetails extends Company {
  final Owner owner;

  CompanyDetails({
    required super.companyId,
    super.name,
    super.description,
    super.companyBackground,
    super.companyImg,
    super.userId,
    super.phoneNumber,
    required this.owner,
  });

  factory CompanyDetails.fromJson(Map<String, dynamic> json) {
    return CompanyDetails(
      companyId: json['CompanyId'] ?? '',
      name: json['Name'] ?? 'Sin nombre',
      description: json['description'] ?? '',
      companyBackground: json['companybackgrnd'],
      companyImg: json['companyimg'],
      userId: json['UserId'] ?? '',
      phoneNumber: json['phonenumber'],
      owner: Owner.fromJson(json['owner'] ?? {}),
    );
  }
}

// ✨ NUEVO: Modelo para el dueño de la empresa
class Owner {
  final String name;
  final String email;

  Owner({
    required this.name,
    required this.email,
  });

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      name: json['Name'] ?? '',
      email: json['Email'] ?? '',
    );
  }
}