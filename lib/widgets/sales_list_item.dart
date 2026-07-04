import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/product_item.dart';
import '../utils/app_colors.dart';
import '../utils/formatter.dart';

/// Custom Widget — Item daftar penjualan dengan foto produk dan ranking
class SalesListItem extends StatelessWidget {
  final ProductItem product;
  final int rank;

  const SalesListItem({
    super.key,
    required this.product,
    required this.rank,
  });

  @override
  Widget build(BuildContext context) {
    final trendColor =
        product.isTrendUp ? AppColors.success : AppColors.error;
    final trendIcon = product.isTrendUp
        ? Icons.trending_up_rounded
        : Icons.trending_down_rounded;
    final rankColor = rank <= 3 ? AppColors.accent : AppColors.border;
    final rankTextColor =
        rank <= 3 ? AppColors.textPrimary : AppColors.textSecondary;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Badge ranking
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: rankColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
              border: rank <= 3
                  ? Border.all(color: rankColor.withValues(alpha: 0.5))
                  : null,
            ),
            child: Center(
              child: Text(
                '#$rank',
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: rankTextColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Foto produk (imageBytes atau network)
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 50,
              height: 50,
              child: _buildImage(),
            ),
          ),
          const SizedBox(width: 12),

          // Info produk
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
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
                  const SizedBox(width: 6),
                  Text('Stok: ${product.stock}',
                      style: GoogleFonts.inter(
                          fontSize: 10, color: AppColors.textSecondary)),
                ]),
              ],
            ),
          ),

          // Harga & tren
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                Formatter.currency(product.price),
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryDark,
                ),
              ),
              const SizedBox(height: 4),
              Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(trendIcon, size: 13, color: trendColor),
                const SizedBox(width: 3),
                Text('${product.sold} terjual',
                    style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: trendColor)),
              ]),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    if (product.hasLocalImage) {
      return Image.memory(product.imageBytes!, fit: BoxFit.cover);
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
              style: const TextStyle(fontSize: 22)),
        ),
      ),
    );
  }
}