import 'dart:math';

/// Pure utility class for points-related calculations.
/// Stateless — no ChangeNotifier needed.
class PointsService {
  PointsService._();

  static final _rng = Random();

  /// Simulates a QR-code scan and returns a random points reward (50 – 200).
  static int simulateQRScan() => 50 + _rng.nextInt(151);

  /// Calculates points earned for a fuel purchase.
  /// Rule: 1 point per full euro spent.
  static int forFuelPurchase(double liters, double pricePerLiter) =>
      (liters * pricePerLiter).floor();

  /// Returns 2.0 on weekends (Saturday/Sunday), 1.0 otherwise.
  /// Used to apply the "double-points weekend" promotion automatically.
  static double currentMultiplier() {
    final day = DateTime.now().weekday;
    return (day == DateTime.saturday || day == DateTime.sunday) ? 2.0 : 1.0;
  }
}
