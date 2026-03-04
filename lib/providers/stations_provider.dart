import 'package:flutter/material.dart';
import '../models/gas_station.dart';
import '../data/mock_data.dart';

/// Provides the list of gas stations, sorted by proximity.
class StationsProvider extends ChangeNotifier {
  late final List<GasStation> _stations;

  StationsProvider() {
    // Sort once at initialisation; distance is static in mock data
    _stations = List<GasStation>.from(MockData.gasStations)
      ..sort((a, b) => a.distance.compareTo(b.distance));
  }

  /// Full sorted list of stations
  List<GasStation> get stations => List.unmodifiable(_stations);

  /// Returns the N nearest stations
  List<GasStation> nearest(int count) => _stations.take(count).toList();

  /// Looks up a station by its [id]; returns null if not found
  GasStation? findById(String id) {
    try {
      return _stations.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }
}
