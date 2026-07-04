import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';

/// Custom Widget — Filter Kategori Horizontal (scrollable chips)
class CategoryFilter extends StatelessWidget {
  final List<String> categories;
  final String selected;
  final Function(String) onChanged;

  const CategoryFilter({
    super.key,
    required this.categories,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (_, i) {
          final cat = categories[i];
          final isActive = cat == selected;
          return GestureDetector(
            onTap: () => onChanged(cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color:
                      isActive ? AppColors.primary : AppColors.border,
                ),
              ),
              child: Text(
                cat,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight:
                      isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive
                      ? AppColors.surface
                      : AppColors.textPrimary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}