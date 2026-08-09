import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/store_location.dart';

class LocationProvider with ChangeNotifier {
  List<StoreLocation> _locations = [];

  List<StoreLocation> get locations => _locations;

  Future<void> fetchLocations() async {
    final url = Uri.parse(
        'https://my-json-server.typicode.com/strawcrmlss/tanian-api/locations');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      _locations = data.map((json) => StoreLocation.fromJson(json)).toList();
      notifyListeners();
    } else {
      throw Exception('Gagal memuat lokasi');
    }
  }
}
