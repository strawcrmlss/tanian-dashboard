import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/location_provider.dart';
import '../utils/app_colors.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({super.key});

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  late GoogleMapController _mapController;

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<LocationProvider>(context, listen: false).fetchLocations());
  }

  @override
  Widget build(BuildContext context) {
    final locations = Provider.of<LocationProvider>(context).locations;

    final markers = locations
        .map((loc) => Marker(
              markerId: MarkerId(loc.id),
              position: LatLng(loc.latitude, loc.longitude),
              infoWindow: InfoWindow(title: loc.name),
            ))
        .toSet();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lokasi UMKM'),
        backgroundColor: AppColors.background,
      ),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(-6.2088, 106.8456), // Jakarta default
          zoom: 10,
        ),
        markers: markers,
        onMapCreated: (controller) {
          _mapController = controller;
        },
      ),
    );
  }
}
