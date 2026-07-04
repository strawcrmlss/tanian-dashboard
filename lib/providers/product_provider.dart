import '../models/product_item.dart';
import '../services/api_service.dart';

/// ProductProvider — Singleton untuk state produk.
/// GET menggunakan REST API. CRUD dilakukan secara in-memory (lokal).
class ProductProvider {
  ProductProvider._internal();
  static final ProductProvider instance = ProductProvider._internal();

  List<ProductItem> _products = [];
  bool isLoading = false;
  String? errorMessage;
  bool _initialized = false;

  bool get isInitialized => _initialized;
  bool get hasData => _products.isNotEmpty;
  bool get hasError => errorMessage != null;
  List<ProductItem> get products => List.unmodifiable(_products);

  // ─── LOAD ─────────────────────────────────────────────────────────
  Future<void> loadProducts() async {
    if (_initialized && _products.isNotEmpty) return;
    isLoading = true;
    errorMessage = null;
    try {
      _products = await ApiService.fetchProducts();
      _initialized = true;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }

  Future<void> refreshProducts() async {
    isLoading = true;
    errorMessage = null;
    try {
      _products = await ApiService.fetchProducts();
      _initialized = true;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }

  // ─── CRUD IN-MEMORY ───────────────────────────────────────────────
  void addProduct(ProductItem product) {
    _products = [product, ..._products];
  }

  void updateProduct(ProductItem updated) {
    _products =
        _products.map((p) => p.id == updated.id ? updated : p).toList();
  }

  void deleteProduct(String id) {
    _products = _products.where((p) => p.id != id).toList();
  }

  // ─── ANALYTICS ────────────────────────────────────────────────────
  int get totalSold =>
      _products.fold(0, (s, p) => s + p.sold);

  /// Total pendapatan (omzet) = harga × jumlah terjual semua produk
  int get totalRevenue =>
      _products.fold(0, (s, p) => s + (p.price * p.sold));

  double get avgPrice => _products.isEmpty
      ? 0.0
      : _products.fold<int>(0, (s, p) => s + p.price) / _products.length;

  int get trendUpCount => _products.where((p) => p.isTrendUp).length;
  int get trendDownCount => _products.where((p) => !p.isTrendUp).length;

  int get lowStockCount =>
      _products.where((p) => p.isLowStock).length;

  double get safeStockPercentage {
    if (_products.isEmpty) return 0;
    return _products.where((p) => p.stock >= 30).length /
        _products.length *
        100;
  }

  double get trendUpPercentage {
    if (_products.isEmpty) return 0;
    return trendUpCount / _products.length * 100;
  }

  // ─── SORTED LISTS ─────────────────────────────────────────────────
  List<ProductItem> get sortedBySold => (List<ProductItem>.from(_products)
    ..sort((a, b) => b.sold.compareTo(a.sold)));

  List<ProductItem> get sortedByPriceDesc =>
      (List<ProductItem>.from(_products)
        ..sort((a, b) => b.price.compareTo(a.price)));

  List<ProductItem> get sortedByPriceAsc =>
      (List<ProductItem>.from(_products)
        ..sort((a, b) => a.price.compareTo(b.price)));

  List<ProductItem> get sortedByStockAsc =>
      (List<ProductItem>.from(_products)
        ..sort((a, b) => a.stock.compareTo(b.stock)));

  List<ProductItem> get sortedByStockDesc =>
      (List<ProductItem>.from(_products)
        ..sort((a, b) => b.stock.compareTo(a.stock)));

  List<ProductItem> get lowStock =>
      (List<ProductItem>.from(_products.where((p) => p.isLowStock).toList())
        ..sort((a, b) => a.stock.compareTo(b.stock)));

  // ─── CATEGORY ANALYSIS ────────────────────────────────────────────
  List<String> get categories {
    final cats = _products.map((p) => p.category).toSet().toList();
    cats.sort();
    return cats;
  }

  Map<String, int> get salesByCategory {
    final map = <String, int>{};
    for (final p in _products) {
      map[p.category] = (map[p.category] ?? 0) + p.sold;
    }
    return map;
  }

  Map<String, int> get countByCategory {
    final map = <String, int>{};
    for (final p in _products) {
      map[p.category] = (map[p.category] ?? 0) + 1;
    }
    return map;
  }

  String get topCategory {
    final cats = salesByCategory;
    if (cats.isEmpty) return '-';
    return cats.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  String get mostPopularProduct {
    if (_products.isEmpty) return '-';
    return sortedBySold.first.name;
  }

  String get newId => 'P${DateTime.now().millisecondsSinceEpoch}';
}