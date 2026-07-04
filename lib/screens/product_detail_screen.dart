import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/product_item.dart';
import '../providers/product_provider.dart';
import '../utils/app_colors.dart';
import '../utils/formatter.dart';
import '../widgets/trend_badge.dart';
import 'product_form_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductItem product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late ProductItem _product;

  @override
  void initState() {
    super.initState();
    _product = widget.product;
  }

  void _goToEdit() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => ProductFormScreen(product: _product)),
    ).then((updated) {
      if (updated != null && updated is ProductItem) {
        setState(() => _product = updated);
      }
    });
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Hapus Produk?',
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700, fontSize: 16)),
        content: Text(
          'Produk "${_product.name}" akan dihapus secara permanen.',
          style: GoogleFonts.inter(
              fontSize: 13, color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal',
                style: GoogleFonts.inter(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ProductProvider.instance.deleteProduct(_product.id);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('${_product.name} berhasil dihapus'),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ));
              Navigator.pop(context);
            },
            child: Text('Hapus',
                style: GoogleFonts.inter(
                    color: AppColors.error, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Foto produk
                    Stack(
                      children: [
                        SizedBox(
                          height: 280,
                          width: double.infinity,
                          child: _buildHeroImage(),
                        ),
                        Positioned(
                          top: 12,
                          left: 12,
                          child: IconButton(
                            onPressed: () => Navigator.pop(context),
                            style: IconButton.styleFrom(
                              backgroundColor:
                                  AppColors.surface.withValues(alpha: 0.9),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            icon: const Icon(Icons.arrow_back,
                                color: AppColors.textPrimary),
                          ),
                        ),
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Row(children: [
                            IconButton(
                              onPressed: _goToEdit,
                              style: IconButton.styleFrom(
                                backgroundColor:
                                    AppColors.surface.withValues(alpha: 0.9),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              icon: const Icon(Icons.edit_outlined,
                                  color: AppColors.primary, size: 20),
                              tooltip: 'Edit Produk',
                            ),
                            const SizedBox(width: 6),
                            IconButton(
                              onPressed: _confirmDelete,
                              style: IconButton.styleFrom(
                                backgroundColor:
                                    AppColors.surface.withValues(alpha: 0.9),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              icon: const Icon(Icons.delete_outline,
                                  color: AppColors.error, size: 20),
                              tooltip: 'Hapus Produk',
                            ),
                          ]),
                        ),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight
                                    .withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(_product.category,
                                  style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primaryDark)),
                            ),
                            const SizedBox(width: 10),
                            TrendBadge(trend: _product.trend),
                          ]),
                          const SizedBox(height: 12),
                          Text(_product.name,
                              style: GoogleFonts.poppins(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary)),
                          const SizedBox(height: 8),
                          Text(
                            Formatter.currency(_product.price),
                            style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryDark),
                          ),
                          const SizedBox(height: 20),
                          const Divider(),
                          const SizedBox(height: 16),
                          Row(children: [
                            Expanded(
                              child: _statItem(
                                  Icons.inventory_2_outlined,
                                  'Stok',
                                  '${_product.stock} unit',
                                  _product.stockColor),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _statItem(
                                  Icons.shopping_bag_outlined,
                                  'Terjual',
                                  '${_product.sold} unit',
                                  AppColors.primary),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _statItem(
                                  Icons.label_outline,
                                  'Status',
                                  _product.stockStatus,
                                  _product.stockColor),
                            ),
                          ]),
                          const SizedBox(height: 20),
                          const Divider(),
                          const SizedBox(height: 16),
                          Text('Deskripsi Produk',
                              style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary)),
                          const SizedBox(height: 8),
                          Text(
                            _product.description.isNotEmpty
                                ? _product.description
                                : '${_product.name} adalah produk unggulan dari UMKM Tanian Agro.',
                            style: GoogleFonts.inter(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                                height: 1.6),
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Tombol aksi
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                boxShadow: [
                  BoxShadow(
                      color: AppColors.textPrimary.withValues(alpha: 0.06),
                      blurRadius: 12,
                      offset: const Offset(0, -4))
                ],
              ),
              child: Row(children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _confirmDelete,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                      minimumSize: const Size(0, 48),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    icon: const Icon(Icons.delete_outline, size: 18),
                    label: Text('Hapus',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: _goToEdit,
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 48)),
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: Text('Edit Produk',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600)),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroImage() {
    if (_product.hasLocalImage) {
      return Image.memory(
        _product.imageBytes!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 280,
      );
    }
    return Image.network(
      _product.imageUrl,
      fit: BoxFit.cover,
      loadingBuilder: (_, child, progress) => progress == null
          ? child
          : Container(
              color: AppColors.primaryLight.withValues(alpha: 0.2),
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            ),
      errorBuilder: (_, __, ___) => Container(
        color: AppColors.primaryLight.withValues(alpha: 0.2),
        child: Center(
          child: Text(_product.categoryEmoji,
              style: const TextStyle(fontSize: 64)),
        ),
      ),
    );
  }

  Widget _statItem(
      IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child:
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(height: 6),
        Text(label,
            style: GoogleFonts.inter(
                fontSize: 10, color: AppColors.textSecondary)),
        const SizedBox(height: 2),
        Text(value,
            style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
      ]),
    );
  }
}