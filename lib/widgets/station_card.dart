import 'package:flutter/material.dart';
import '../models/gas_station.dart';
import '../theme/app_colors.dart';

/// A card showing the key details of a [GasStation].
/// Tapping "Ver Detalles" pushes [onTap] so the parent screen handles routing.
class StationCard extends StatelessWidget {
  final GasStation station;
  final VoidCallback onTap;

  const StationCard({
    super.key,
    required this.station,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final brandColor = AppColors.forBrand(station.brand);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: brand avatar + name + distance badge
              Row(
                children: [
                  // Brand avatar
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: brandColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        station.brandInitial,
                        style: TextStyle(
                          color: brandColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hero tag enables smooth transition to detail screen
                        Hero(
                          tag: 'station_name_${station.id}',
                          child: Material(
                            color: Colors.transparent,
                            child: Text(
                              station.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(Icons.location_on,
                                size: 13, color: Colors.grey[500]),
                            const SizedBox(width: 2),
                            Expanded(
                              child: Text(
                                station.address,
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey[600]),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Distance badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      station.distanceLabel,
                      style: const TextStyle(
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Divider(height: 1),
              const SizedBox(height: 12),
              // Fuel prices row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _PriceChip(
                      label: 'G-95',
                      price: station.fuelPrices.regular,
                      color: AppColors.primaryGreen),
                  _PriceChip(
                      label: 'G-98',
                      price: station.fuelPrices.premium,
                      color: AppColors.accentBlue),
                  _PriceChip(
                      label: 'Diésel',
                      price: station.fuelPrices.diesel,
                      color: AppColors.accentOrange),
                ],
              ),
              const SizedBox(height: 14),
              // CTA button
              SizedBox(
                width: double.infinity,
                child: FilledButton.tonal(
                  onPressed: onTap,
                  style: FilledButton.styleFrom(
                    backgroundColor:
                        brandColor.withValues(alpha: 0.12),
                    foregroundColor: brandColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Ver Detalles'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Small price display chip used inside [StationCard]
class _PriceChip extends StatelessWidget {
  final String label;
  final double price;
  final Color color;

  const _PriceChip({
    required this.label,
    required this.price,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
              fontSize: 11, color: Colors.grey[600], fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 2),
        Text(
          '€${price.toStringAsFixed(3)}',
          style: TextStyle(
              fontSize: 14, color: color, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
