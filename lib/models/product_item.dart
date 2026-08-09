import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/product_images.dart';

/// Model OOP produk pertanian UMKM Tanian
/// imageBytes: gambar yang dipilih lokal dari device (Uint8List)
/// customImageUrl: URL gambar dari input manual
class ProductItem {
  final String id;
  final String name;
  final String category;
  final int price;
  final int stock;
  final int sold;
  final String trend;
  final String description;
  final String? customImageUrl;
  final Uint8List? imageBytes; // gambar lokal dari file picker

  // Tambahan field lokasi
  final double latitude;
  final double longitude;

  const ProductItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
    required this.sold,
    required this.trend,
    this.description = '',
    this.customImageUrl,
    this.imageBytes,
    this.latitude = 0.0,
    this.longitude = 0.0,
  });

  /// Mengubah Map JSON dari REST API menjadi objek ProductItem
  factory ProductItem.fromJson(Map<String, dynamic> json) {
    final name = json['name'] as String? ?? '';
    final category = json['category'] as String? ?? 'Produk Tani';
    return ProductItem(
      id: json['id'].toString(),
      name: name,
      category: category,
      price: (json['price'] as num).toInt(),
      stock: (json['stock'] as num).toInt(),
      sold: (json['sold'] as num).toInt(),
      trend: json['trend'] as String? ?? 'up',
      description: json['description'] as String? ??
          '$name adalah produk unggulan kategori $category dari UMKM Tanian Agro. '
          'Dipanen segar langsung dari petani lokal Indonesia dengan standar kualitas terjamin.',
      customImageUrl: json['imageUrl'] as String?,
      imageBytes: null,
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
    );
  }

  ProductItem copyWith({
    String? id,
    String? name,
    String? category,
    int? price,
    int? stock,
    int? sold,
    String? trend,
    String? description,
    String? customImageUrl,
    bool clearCustomUrl = false,
    Uint8List? imageBytes,
    bool clearImageBytes = false,
    double? latitude,
    double? longitude,
  }) {
    return ProductItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      sold: sold ?? this.sold,
      trend: trend ?? this.trend,
      description: description ?? this.description,
      customImageUrl: clearCustomUrl ? null : (customImageUrl ?? this.customImageUrl),
      imageBytes: clearImageBytes ? null : (imageBytes ?? this.imageBytes),
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  bool get isTrendUp => trend == 'up';
  bool get hasLocalImage => imageBytes != null;

  String get imageUrl {
    if (customImageUrl != null && customImageUrl!.isNotEmpty) {
      return customImageUrl!;
    }
    return ProductImages.getUrl(name, category);
  }

  String get stockStatus {
    if (stock >= 100) return 'Stok Aman';
    if (stock >= 30) return 'Stok Cukup';
    return 'Stok Menipis';
  }

  Color get stockColor {
    if (stock >= 100) return AppColors.success;
    if (stock >= 30) return AppColors.accent;
    return AppColors.error;
  }

  bool get isLowStock => stock < 50;

  String get categoryEmoji {
    const map = {
      'Sayur': '🥬',
      'Buah': '🍎',
      'Rempah': '🧄',
      'Beras': '🌾',
      'Organik': '🌿',
      'Telur': '🥚',
      'Cabai': '🌶️',
      'Umbi': '🍠',
    };
    return map[category] ?? '🌱';
  }
}
