/// Utility class untuk mapping nama/kategori produk ke URL foto yang sesuai.
/// Menggunakan foto dari Unsplash yang relevan dengan setiap produk pertanian.
class ProductImages {
  ProductImages._();

  /// Mapping kata kunci nama produk ke URL foto spesifik
  static const Map<String, String> _nameKeywords = {
    'bayam': 'https://images.unsplash.com/photo-1576045057995-568f588f82fb?w=500',
    'wortel': 'https://images.unsplash.com/photo-1598170845058-32b9d6a5da37?w=500',
    'kentang': 'https://images.unsplash.com/photo-1518977676601-b53f82aba655?w=500',
    'tomat': 'https://images.unsplash.com/photo-1546470427-e26264be0b0d?w=500',
    'brokoli': 'https://images.unsplash.com/photo-1459411621453-7b03977f4bfc?w=500',
    'kale': 'https://images.unsplash.com/photo-1524179091875-bf99a9a6af57?w=500',
    'selada': 'https://images.unsplash.com/photo-1622206151226-18ca2c9ab4a1?w=500',
    'kangkung': 'https://images.unsplash.com/photo-1576045057995-568f588f82fb?w=500',
    'sawi': 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=500',
    'pisang': 'https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=500',
    'mangga': 'https://images.unsplash.com/photo-1605027990121-cbae9e0642df?w=500',
    'apel': 'https://images.unsplash.com/photo-1567306301408-9b74779a11af?w=500',
    'jeruk': 'https://images.unsplash.com/photo-1547514701-42782101795e?w=500',
    'alpukat': 'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?w=500',
    'pepaya': 'https://images.unsplash.com/photo-1517282009859-f000ec3b26fe?w=500',
    'semangka': 'https://images.unsplash.com/photo-1563114773-84221bd62daa?w=500',
    'melon': 'https://images.unsplash.com/photo-1571680322279-a226e6a4cc2a?w=500',
    'nanas': 'https://images.unsplash.com/photo-1550258987-190a2d41a8ba?w=500',
    'bawang merah': 'https://images.unsplash.com/photo-1618512496248-a07fe83aa8cb?w=500',
    'bawang putih': 'https://images.unsplash.com/photo-1471193945509-9ad0617afabf?w=500',
    'bawang': 'https://images.unsplash.com/photo-1618512496248-a07fe83aa8cb?w=500',
    'jahe': 'https://images.unsplash.com/photo-1599909533144-7409d04e2a09?w=500',
    'kunyit': 'https://images.unsplash.com/photo-1615485290382-441e4d049cb5?w=500',
    'lengkuas': 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=500',
    'serai': 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=500',
    'cabai': 'https://images.unsplash.com/photo-1583119022894-919a68a3d0e3?w=500',
    'cabe': 'https://images.unsplash.com/photo-1583119022894-919a68a3d0e3?w=500',
    'beras': 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=500',
    'padi': 'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=500',
    'telur': 'https://images.unsplash.com/photo-1582722872445-44dc5f7e3c8f?w=500',
    'madu': 'https://images.unsplash.com/photo-1587049352846-4a222e784d38?w=500',
    'ubi': 'https://images.unsplash.com/photo-1596097635121-14b38c5d7a27?w=500',
    'singkong': 'https://images.unsplash.com/photo-1623428187969-5da2dcea5ebf?w=500',
    'talas': 'https://images.unsplash.com/photo-1543362906-acfc16c67564?w=500',
    'jagung': 'https://images.unsplash.com/photo-1551754655-cd27e38d2076?w=500',
  };

  /// Mapping kategori produk ke URL foto generik kategori
  static const Map<String, String> _categoryFallback = {
    'Sayur': 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=500',
    'Buah': 'https://images.unsplash.com/photo-1610832958506-aa56368176cf?w=500',
    'Rempah': 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=500',
    'Beras': 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=500',
    'Organik': 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=500',
    'Telur': 'https://images.unsplash.com/photo-1582722872445-44dc5f7e3c8f?w=500',
    'Cabai': 'https://images.unsplash.com/photo-1583119022894-919a68a3d0e3?w=500',
    'Umbi': 'https://images.unsplash.com/photo-1596097635121-14b38c5d7a27?w=500',
  };

  static const String _defaultFallback =
      'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=500';

  /// Mendapatkan URL foto berdasarkan nama produk dan kategori.
  /// Pertama cari berdasarkan kata kunci nama, lalu fallback ke kategori.
  static String getUrl(String productName, String category) {
    final nameLower = productName.toLowerCase();

    // Cari kecocokan berdasarkan kata kunci dalam nama produk
    for (final entry in _nameKeywords.entries) {
      if (nameLower.contains(entry.key)) {
        return entry.value;
      }
    }

    // Fallback ke kategori
    return _categoryFallback[category] ?? _defaultFallback;
  }
}