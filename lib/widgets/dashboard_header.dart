import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';

class DashboardHeader extends StatelessWidget {
  final VoidCallback onRefresh;
  final bool isLoading;

  const DashboardHeader({
    super.key,
    required this.onRefresh,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tanian Dashboard',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.surface,
              )),
          const SizedBox(height: 4),
          Text('UMKM Distribusi Pertanian Lokal',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.surface,
              )),
          const SizedBox(height: 2),
          Text('Monitoring Produk & Penjualan UMKM',
              style: GoogleFonts.inter(
                fontSize: 11,
                color: AppColors.surface.withOpacity(0.9),
              )),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: onRefresh,
              icon: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.surface,
                      ),
                    )
                  : const Icon(Icons.refresh, color: AppColors.surface),
            ),
          ),
        ],
      ),
    );
  }
}
