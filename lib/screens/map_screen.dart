import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/stations_provider.dart';
import '../widgets/stations_map.dart';
import '../theme/app_colors.dart';

/// Dedicated full-screen map tab showing all nearby gas stations.
class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stations = context.watch<StationsProvider>().stations;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: StationsMapView(stations: stations),
    );
  }
}
