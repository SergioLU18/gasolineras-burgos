import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/stations_provider.dart';
import '../widgets/station_card.dart';
import '../theme/app_colors.dart';
import 'station_detail_screen.dart';

/// Displays the full list of gas stations sorted by distance.
class StationsScreen extends StatelessWidget {
  const StationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stations = context.watch<StationsProvider>().stations;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: const Text('Gasolineras'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          // Distance info icon
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Tooltip(
              message: 'Ordenadas por distancia',
              child: const Icon(Icons.sort, color: Colors.white),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Subtle summary banner
          Container(
            width: double.infinity,
            color: AppColors.primaryGreen.withValues(alpha: 0.08),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                const Icon(Icons.location_on,
                    size: 16, color: AppColors.primaryGreen),
                const SizedBox(width: 6),
                Text(
                  '${stations.length} gasolineras cercanas',
                  style: const TextStyle(
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          // Station list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 16),
              itemCount: stations.length,
              itemBuilder: (context, index) {
                final station = stations[index];
                return StationCard(
                  station: station,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => StationDetailScreen(station: station),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
