/// A promotional offer available at one or all gas stations
class Promotion {
  final String id;
  final String title;
  final String description;
  final double discountPercentage; // 0 means points-based, not a price discount
  final DateTime validUntil;
  final String category; // 'fuel' | 'service' | 'food' | 'points'
  final String stationId;  // empty = global promotion

  const Promotion({
    required this.id,
    required this.title,
    required this.description,
    required this.discountPercentage,
    required this.validUntil,
    required this.category,
    this.stationId = '',
  });

  /// True if the promotion has not yet expired
  bool get isValid => validUntil.isAfter(DateTime.now());

  /// Calendar days remaining until expiration (0 if expired)
  int get daysRemaining {
    final diff = validUntil.difference(DateTime.now()).inDays;
    return diff < 0 ? 0 : diff;
  }

  /// Human-readable discount label
  String get discountLabel =>
      discountPercentage == 0 ? '2x Puntos' : '${discountPercentage.toInt()}% OFF';
}
