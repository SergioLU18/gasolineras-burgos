import 'package:flutter/material.dart';
import '../models/promotion.dart';
import '../data/mock_data.dart';

/// Provides access to all promotions with convenience filters.
class PromotionsProvider extends ChangeNotifier {
  final List<Promotion> _promotions = MockData.promotions;

  /// All promotions (including expired ones)
  List<Promotion> get promotions => List.unmodifiable(_promotions);

  /// Only promotions that have not yet expired
  List<Promotion> get activePromotions =>
      _promotions.where((p) => p.isValid).toList();

  /// First three active promotions shown on the Home screen carousel
  List<Promotion> get featured => activePromotions.take(3).toList();

  /// Active promotions filtered by [category]
  List<Promotion> byCategory(String category) =>
      activePromotions.where((p) => p.category == category).toList();
}
