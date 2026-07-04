import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_item.dart';

/// ApiService — Service class untuk mengambil data produk dari REST API
/// Alur: REST API → http.get → JSON response → List<ProductItem>
class ApiService {
  ApiService._();

  static const String _baseUrl =
      'https://my-json-server.typicode.com/strawcrmlss/tanian-api';

  /// Endpoint produk pertanian
  static const String _productsEndpoint = '$_baseUrl/products';

  /// Mengambil semua data produk dari REST API
  /// Menggunakan async/await dan mengembalikan Future<List<ProductItem>>
  static Future<List<ProductItem>> fetchProducts() async {
    final uri = Uri.parse(_productsEndpoint);

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList =
          json.decode(response.body) as List<dynamic>;

      return jsonList
          .map((item) => ProductItem.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(
        'Gagal memuat data produk.\n'
        'Status: ${response.statusCode}',
      );
    }
  }
}