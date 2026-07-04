import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/product_provider.dart';
import '../models/product_item.dart';
import '../utils/app_colors.dart';
import '../widgets/product_card.dart';
import '../widgets/category_filter.dart';
import 'product_detail_screen.dart';
import 'product_form_screen.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';
  String _selectedCategory = 'Semua';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<ProductItem> get _filtered {
    final all = ProductProvider.instance.products;
    return all.where((p) {
      final matchQ = _query.isEmpty ||
          p.name.toLowerCase().contains(_query.toLowerCase()) ||
          p.category.toLowerCase().contains(_query.toLowerCase());
      final matchCat =
          _selectedCategory == 'Semua' || p.category == _selectedCategory;
      return matchQ && matchCat;
    }).toList();
  }

  void _goToDetail(ProductItem p) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProductDetailScreen(product: p)),
    ).then((_) => setState(() {}));
  }

  void _goToAdd() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProductFormScreen()),
    ).then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final categories = ['Semua', ...ProductProvider.instance.categories];
    final filtered = _filtered;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Manajemen Produk'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${ProductProvider.instance.products.length} Produk',
                style: GoogleFonts.inter(
                    fontSize: 12, color: AppColors.textSecondary),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _query = v),
              style: GoogleFonts.inter(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Cari nama atau kategori produk...',
                hintStyle: GoogleFonts.inter(
                    fontSize: 14, color: AppColors.textSecondary),
                prefixIcon: const Icon(Icons.search,
                    color: AppColors.textSecondary, size: 20),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear,
                            size: 18, color: AppColors.textSecondary),
                        onPressed: () {
                          _searchCtrl.clear();
                          setState(() => _query = '');
                        },
                      )
                    : null,
              ),
            ),
          ),

          // Filter kategori
          CategoryFilter(
            categories: categories,
            selected: _selectedCategory,
            onChanged: (cat) => setState(() => _selectedCategory = cat),
          ),
          const SizedBox(height: 6),

          // Jumlah hasil
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(children: [
              Text(
                '${filtered.length} produk ditemukan',
                style: GoogleFonts.inter(
                    fontSize: 12, color: AppColors.textSecondary),
              ),
            ]),
          ),

          // Grid
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('🔍',
                            style: TextStyle(fontSize: 52)),
                        const SizedBox(height: 12),
                        Text('Produk tidak ditemukan',
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary)),
                        const SizedBox(height: 4),
                        Text('Coba kata kunci lain',
                            style: GoogleFonts.inter(
                                fontSize: 13,
                                color: AppColors.textSecondary)),
                      ],
                    ),
                  )
                : LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth >= 600;
                      return GridView.builder(
                        padding:
                            const EdgeInsets.fromLTRB(16, 4, 16, 96),
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isWide ? 3 : 2,
                          childAspectRatio: 0.76,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: filtered.length,
                        itemBuilder: (_, i) => ProductCard(
                          product: filtered[i],
                          onTap: () => _goToDetail(filtered[i]),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToAdd,
        backgroundColor: AppColors.primary,
        tooltip: 'Tambah Produk',
        child: const Icon(Icons.add, color: AppColors.surface),
      ),
    );
  }
}