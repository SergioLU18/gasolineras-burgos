import 'promotion.dart';

/// Fuel prices in euros per liter for a single station
class FuelPrices {
  final double regular; // 95 octane
  final double premium; // 98 octane
  final double diesel;  // Diesel A

  const FuelPrices({
    required this.regular,
    required this.premium,
    required this.diesel,
  });
}

/// Represents a gas station with location, prices, and available promotions
class GasStation {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final FuelPrices fuelPrices;
  final double distance; // km from user's location
  final List<Promotion> promotions;
  final String brand; // e.g. "Repsol", "BP", "Cepsa"

  const GasStation({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.fuelPrices,
    required this.distance,
    required this.promotions,
    required this.brand,
  });

  /// First letter of the station name, used as an avatar fallback
  String get brandInitial =>
      name.isNotEmpty ? name[0].toUpperCase() : 'G';

  /// Returns a display-friendly distance string
  String get distanceLabel =>
      distance < 1 ? '${(distance * 1000).round()} m' : '${distance.toStringAsFixed(1)} km';
}
