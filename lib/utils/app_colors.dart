import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF79A23E);
  static const Color primaryDark = Color(0xFF5F872D);
  static const Color primaryLight = Color(0xFFA9C97A);
  static const Color background = Color(0xFFF8FAF5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color accent = Color(0xFFF4B942);
  static const Color error = Color(0xFFD64545);
  static const Color success = Color(0xFF4CAF50);
  static const Color textPrimary = Color(0xFF2E3A24);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color border = Color(0xFFE3E8DD);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF79A23E), Color(0xFF4A6B20)],
  );
}