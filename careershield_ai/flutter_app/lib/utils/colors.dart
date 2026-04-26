import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF1A73E8);
  static const Color primaryLight = Color(0xFF4285F4);
  static const Color primaryDark = Color(0xFF0D47A1);

  static const Color success = Color(0xFF34A853);
  static const Color warning = Color(0xFFFBBC04);
  static const Color danger = Color(0xFFEA4335);

  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF202124);
  static const Color textSecondary = Color(0xFF5F6368);
  static const Color divider = Color(0xFFE0E0E0);

  static Color getRiskColor(double riskScore) {
    if (riskScore <= 30) return success;
    if (riskScore <= 65) return warning;
    return danger;
  }

  static Color getVerdictColor(String verdict) {
    switch (verdict.toUpperCase()) {
      case 'SAFE':
        return success;
      case 'SUSPICIOUS':
        return warning;
      case 'HIGH RISK':
        return danger;
      default:
        return textSecondary;
    }
  }
}
