import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../providers/location_provider.dart';
import '../utils/app_colors.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({super.key});

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
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
              point: LatLng(loc.latitude, loc.longitude),
              width: 60,
              height: 60,
              child: Column(
                children: [
                  const Icon(Icons.location_on, color: Colors.red, size: 36),
                  Text(
                    loc.name,
                    style: const TextStyle(
                        fontSize: 10, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lokasi UMKM'),
        backgroundColor: AppColors.background,
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(-6.2088, 106.8456), // Jakarta default
          initialZoom: 10,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            userAgentPackageName: "com.example.tanian_app",
          ),
          MarkerLayer(markers: markers),
        ],
      ),
    );
  }
}
