import 'package:flutter/material.dart';
import '../../models/university_model.dart';
import '../../services/university_service.dart';
import '../widgets/floating_menu_button.dart'; // Asegúrate de importar tu widget

class UniversityScreen extends StatefulWidget {
  const UniversityScreen({super.key});

  @override
  _UniversityScreenState createState() => _UniversityScreenState();
}

class _UniversityScreenState extends State<UniversityScreen> {
  final UniversityService _service = UniversityService();
  late Future<List<University>> _universities;

  @override
  void initState() {
    super.initState();
    _universities = _service.fetchUniversities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // fondo suave morado
      appBar: AppBar(
        title: const Text('Universidades'),
        backgroundColor: const Color(0xFF6A1B9A), // morado intenso
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: Stack(
        children: [
          FutureBuilder<List<University>>(
            future: _universities,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF6A1B9A)));
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No hay universidades.'));
              } else {
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final university = snapshot.data![index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        color: Colors.white,
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Text(
                            university.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4A148C), // tono oscuro morado
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              university.address,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          leading: const Icon(Icons.school,
                              color: Color(0xFF8E24AA)),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
          // 🔽 Botón flotante centrado
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: FloatingMenuButton(
                logoAssetPath: 'assets/images/UMarketLogoNoBackground.png',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
