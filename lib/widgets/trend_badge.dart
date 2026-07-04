import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';

/// Custom Widget — Badge indikator tren naik/turun
class TrendBadge extends StatelessWidget {
  final String trend;
  final bool small;

  const TrendBadge({super.key, required this.trend, this.small = false});

  @override
  Widget build(BuildContext context) {
    final isUp = trend == 'up';
    final color = isUp ? AppColors.success : AppColors.error;
    final icon = isUp
        ? Icons.trending_up_rounded
        : Icons.trending_down_rounded;
    final label = isUp ? 'Naik' : 'Turun';

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 5 : 8,
        vertical: small ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: small ? 10 : 13, color: color),
          SizedBox(width: small ? 2 : 3),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: small ? 9 : 10,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}