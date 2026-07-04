import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/product_item.dart';
import '../utils/app_colors.dart';
import '../utils/formatter.dart';
import 'trend_badge.dart';

/// Custom Widget 3 — Kartu Produk untuk GridView
class ProductCard extends StatelessWidget {
  final ProductItem product;
  final VoidCallback? onTap;

  const ProductCard({super.key, required this.product, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimary.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto produk
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(18)),
              child: AspectRatio(
                aspectRatio: 1.3,
                child: _buildImage(),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Row(children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(product.category,
                          style: GoogleFonts.inter(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryDark)),
                    ),
                    const SizedBox(width: 5),
                    TrendBadge(trend: product.trend, small: true),
                  ]),
                  const SizedBox(height: 6),
                  Text(
                    Formatter.currency(product.price),
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryDark),
                  ),
                  const SizedBox(height: 4),
                  Row(children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: product.stockColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text('Stok: ${product.stock}',
                          style: GoogleFonts.inter(
                              fontSize: 10,
                              color: AppColors.textSecondary),
                          overflow: TextOverflow.ellipsis),
                    ),
                    Text('${product.sold} terjual',
                        style: GoogleFonts.inter(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: product.isTrendUp
                                ? AppColors.success
                                : AppColors.error)),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Tampilkan Image.memory jika ada imageBytes, else Image.network
  Widget _buildImage() {
    if (product.hasLocalImage) {
      return Image.memory(
        product.imageBytes!,
        fit: BoxFit.cover,
        width: double.infinity,
      );
    }
    return Image.network(
      product.imageUrl,
      fit: BoxFit.cover,
      loadingBuilder: (_, child, progress) {
        if (progress == null) return child;
        return Container(
          color: AppColors.primaryLight.withValues(alpha: 0.2),
          child: const Center(
            child: CircularProgressIndicator(
                strokeWidth: 2, color: AppColors.primary),
          ),
        );
      },
      errorBuilder: (_, __, ___) => Container(
        color: AppColors.primaryLight.withValues(alpha: 0.2),
        child: Center(
          child: Text(product.categoryEmoji,
              style: const TextStyle(fontSize: 32)),
        ),
      ),
    );
  }
}