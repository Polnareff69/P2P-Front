import 'package:flutter/material.dart';

class University {
  final String name;
  final String shortName;
  final String description;
  final String type;
  final String ranking;
  final String founded;
  final String students;
  final String imageUrl;
  final String website;
  final List<Color> colors;
  final Color accentColor;

  University({
    required this.name,
    required this.shortName,
    required this.description,
    required this.type,
    required this.ranking,
    required this.founded,
    required this.students,
    required this.imageUrl,
    required this.website,
    required this.colors,
    required this.accentColor,
  });

  // Método para convertir a JSON (opcional, para futuro)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'shortName': shortName,
      'description': description,
      'type': type,
      'ranking': ranking,
      'founded': founded,
      'students': students,
      'imageUrl': imageUrl,
      'website': website,
    };
  }

  // Factory para crear desde JSON (opcional, para futuro)
  factory University.fromJson(Map<String, dynamic> json) {
    return University(
      name: json['name'],
      shortName: json['shortName'],
      description: json['description'],
      type: json['type'],
      ranking: json['ranking'],
      founded: json['founded'],
      students: json['students'],
      imageUrl: json['imageUrl'],
      website: json['website'],
      colors: [Colors.purple.shade600, Colors.purple.shade900], // Default
      accentColor: Colors.purple.shade400, // Default
    );
  }
}