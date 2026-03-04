import 'package:flutter/material.dart';

/// Central palette for the GasRewards app.
/// Importing this file gives access to all brand and semantic colors.
class AppColors {
  AppColors._();

  // ── Brand ────────────────────────────────────────────────────────────────────
  static const Color primaryGreen   = Color(0xFF1B7A3D);
  static const Color primaryLight   = Color(0xFF4CAF50);
  static const Color accentBlue     = Color(0xFF0277BD);
  static const Color accentOrange   = Color(0xFFF57C00);

  // ── Background ───────────────────────────────────────────────────────────────
  static const Color scaffoldBg     = Color(0xFFF2F6F3);
  static const Color cardBg         = Colors.white;

  // ── Membership tiers ────────────────────────────────────────────────────────
  static const Color bronze         = Color(0xFFCD7F32);
  static const Color silver         = Color(0xFF9E9E9E);
  static const Color gold           = Color(0xFFFFB300);

  // ── Gas station brands ───────────────────────────────────────────────────────
  static const Map<String, Color> brandColors = {
    'Repsol': Color(0xFFFF5722),
    'BP':     Color(0xFF388E3C),
    'Cepsa':  Color(0xFFF57C00),
    'Shell':  Color(0xFFC62828),
    'Galp':   Color(0xFF1565C0),
  };

  /// Returns the brand color for [brand], defaulting to [primaryGreen].
  static Color forBrand(String brand) =>
      brandColors[brand] ?? primaryGreen;

  // ── Promotion categories ─────────────────────────────────────────────────────
  static const Map<String, Color> categoryColors = {
    'fuel':    Color(0xFF1B7A3D),
    'service': Color(0xFF0277BD),
    'food':    Color(0xFFF57C00),
    'points':  Color(0xFF7B1FA2),
  };

  static Color forCategory(String category) =>
      categoryColors[category] ?? primaryGreen;

  // ── Category icons ───────────────────────────────────────────────────────────
  static const Map<String, IconData> categoryIcons = {
    'fuel':    Icons.local_gas_station,
    'service': Icons.build_circle_outlined,
    'food':    Icons.coffee,
    'points':  Icons.stars,
  };

  static IconData iconForCategory(String category) =>
      categoryIcons[category] ?? Icons.local_offer;
}
