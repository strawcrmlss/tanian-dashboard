import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';

/// Custom Widget 1 — Header Dashboard
class DashboardHeader extends StatelessWidget {
  final VoidCallback onRefresh;
  final bool isLoading;

  const DashboardHeader({
    super.key,
    required this.onRefresh,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.surface.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.eco_rounded,
                      color: AppColors.surface, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tanian Dashboard',
                          style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.surface)),
                      Text('UMKM Distribusi Pertanian Lokal',
                          style: GoogleFonts.inter(
                              fontSize: 11,
                              color: AppColors.surface.withValues(alpha: 0.85))),
                    ],
                  ),
                ),
                isLoading
                    ? Container(
                        width: 40,
                        height: 40,
                        padding: const EdgeInsets.all(10),
                        child: const CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(AppColors.surface),
                        ),
                      )
                    : IconButton(
                        onPressed: onRefresh,
                        style: IconButton.styleFrom(
                          backgroundColor:
                              AppColors.surface.withValues(alpha: 0.2),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.refresh_rounded,
                            color: AppColors.surface, size: 22),
                        tooltip: 'Refresh Data',
                      ),
              ]),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 9),
                decoration: BoxDecoration(
                  color: AppColors.surface.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.analytics_outlined,
                      color: AppColors.surface, size: 15),
                  const SizedBox(width: 8),
                  Text('Monitoring Produk & Penjualan UMKM',
                      style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.surface)),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}