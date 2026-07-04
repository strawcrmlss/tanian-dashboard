import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';

/// Data untuk satu bar pada grafik
class SimpleBarChartData {
  final String label;
  final double value;
  final Color color;

  const SimpleBarChartData({
    required this.label,
    required this.value,
    required this.color,
  });
}

/// Custom Widget — Grafik batang horizontal sederhana (tanpa package eksternal)
class SimpleBarChart extends StatelessWidget {
  final String title;
  final List<SimpleBarChartData> data;
  final String valueSuffix;

  const SimpleBarChart({
    super.key,
    required this.title,
    required this.data,
    this.valueSuffix = '',
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Text('Belum ada data',
          style: GoogleFonts.inter(
              fontSize: 13, color: AppColors.textSecondary));
    }

    final maxVal =
        data.map((d) => d.value).reduce((a, b) => a > b ? a : b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary)),
        const SizedBox(height: 14),
        ...data.map((d) {
          final ratio = maxVal > 0 ? d.value / maxVal : 0.0;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(children: [
              SizedBox(
                width: 72,
                child: Text(
                  d.label,
                  style: GoogleFonts.inter(
                      fontSize: 11, color: AppColors.textSecondary),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Stack(children: [
                      Container(
                        height: 22,
                        decoration: BoxDecoration(
                          color: AppColors.border,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeOutCubic,
                        height: 22,
                        width: constraints.maxWidth * ratio,
                        decoration: BoxDecoration(
                          color: d.color,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ]);
                  },
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 48,
                child: Text(
                  '${d.value.toInt()}$valueSuffix',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ]),
          );
        }),
      ],
    );
  }
}