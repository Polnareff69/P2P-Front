// lib/views/map_screens/mapa_screen.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapaScreen extends StatefulWidget {
  const MapaScreen({super.key});

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  late GoogleMapController _controller;
  final LatLng _centro = const LatLng(4.6097, -74.0818); // Bogotá

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mapa de Domicilios")),
      body: GoogleMap(
        onMapCreated: (controller) {
          _controller = controller;
        },
        initialCameraPosition: CameraPosition(
          target: _centro,
          zoom: 14.0,
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        mapType: MapType.normal,
      ),
    );
  }
}
