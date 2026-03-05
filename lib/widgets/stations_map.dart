import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' hide Path; // avoids shadowing dart:ui Path
import '../models/gas_station.dart';
import '../theme/app_colors.dart';
import '../screens/station_detail_screen.dart';

/// Interactive OpenStreetMap view showing all [stations] as branded pins.
/// Tapping a pin opens a bottom sheet; "Ver Detalles" pushes the detail screen.
///
/// Map tiles come from OpenStreetMap (free, no API key).
/// Station coordinates are the static mock values from [MockData].
class StationsMapView extends StatelessWidget {
  final List<GasStation> stations;

  const StationsMapView({super.key, required this.stations});

  /// Simulated user position — Burgos city centre
  static const _userPos = LatLng(42.3439, -3.6969);

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: const MapOptions(
        initialCenter: _userPos,
        initialZoom: 13.2,
        minZoom: 10,
        maxZoom: 18,
      ),
      children: [
        // ── OSM tile layer ────────────────────────────────────────────────
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.chichenIT.gasolineras_burgos',
          maxZoom: 19,
        ),

        // ── Station markers ───────────────────────────────────────────────
        MarkerLayer(
          markers: [
            // Blue dot for simulated user position
            const Marker(
              point: _userPos,
              width: 22,
              height: 22,
              child: _UserDot(),
            ),

            // One branded pin per station
            ...stations.map(
              (s) => Marker(
                point: LatLng(s.latitude, s.longitude),
                width: 44,
                height: 54,
                // bottomCenter → the triangle tip sits exactly on the coord
                alignment: Alignment.bottomCenter,
                child: _StationPin(
                  station: s,
                  onTap: () => _showSheet(context, s),
                ),
              ),
            ),
          ],
        ),

        // ── OSM attribution (required by usage policy) ────────────────────
        const SimpleAttributionWidget(
          source: Text('OpenStreetMap contributors'),
        ),
      ],
    );
  }

  void _showSheet(BuildContext context, GasStation station) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _StationSheet(station: station),
    );
  }
}

// ── Station pin marker ────────────────────────────────────────────────────────

class _StationPin extends StatelessWidget {
  final GasStation station;
  final VoidCallback onTap;

  const _StationPin({required this.station, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = AppColors.forBrand(station.brand);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Circular badge with brand initial
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2.5),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
              ],
            ),
            child: Center(
              child: Text(
                station.brandInitial,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ),
          ),
          // Triangular pointer
          CustomPaint(
            size: const Size(14, 8),
            painter: _TrianglePainter(color),
          ),
        ],
      ),
    );
  }
}

/// Paints a downward-pointing triangle in [color] (the pin's "needle").
class _TrianglePainter extends CustomPainter {
  final Color color;
  const _TrianglePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
      Path()
        ..moveTo(0, 0)
        ..lineTo(size.width, 0)
        ..lineTo(size.width / 2, size.height)
        ..close(),
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(_TrianglePainter old) => old.color != color;
}

// ── User location dot ─────────────────────────────────────────────────────────

class _UserDot extends StatelessWidget {
  const _UserDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.accentBlue,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentBlue.withValues(alpha: 0.45),
            blurRadius: 10,
            spreadRadius: 2,
          )
        ],
      ),
    );
  }
}

// ── Bottom sheet ──────────────────────────────────────────────────────────────

class _StationSheet extends StatelessWidget {
  final GasStation station;
  const _StationSheet({required this.station});

  @override
  Widget build(BuildContext context) {
    final brandColor = AppColors.forBrand(station.brand);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Station name + distance badge
            Row(
              children: [
                // Brand circle
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: brandColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      station.brandInitial,
                      style: TextStyle(
                          color: brandColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(station.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                      const SizedBox(height: 2),
                      Text(station.address,
                          style: TextStyle(
                              color: Colors.grey[600], fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                // Distance chip
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color:
                        AppColors.primaryGreen.withValues(alpha: 0.1),
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
            const SizedBox(height: 16),

            // Fuel prices row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _SheetPrice(
                    label: 'G-95',
                    price: station.fuelPrices.regular,
                    color: AppColors.primaryGreen),
                _SheetPrice(
                    label: 'G-98',
                    price: station.fuelPrices.premium,
                    color: AppColors.accentBlue),
                _SheetPrice(
                    label: 'Diésel',
                    price: station.fuelPrices.diesel,
                    color: AppColors.accentOrange),
              ],
            ),
            const SizedBox(height: 20),

            // CTA
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  Navigator.pop(context); // close sheet
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          StationDetailScreen(station: station),
                    ),
                  );
                },
                icon: const Icon(Icons.info_outline),
                label: const Text('Ver Detalles'),
                style: FilledButton.styleFrom(
                  backgroundColor: brandColor,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetPrice extends StatelessWidget {
  final String label;
  final double price;
  final Color color;
  const _SheetPrice(
      {required this.label, required this.price, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '€${price.toStringAsFixed(3)}',
          style: TextStyle(
              color: color, fontWeight: FontWeight.bold, fontSize: 15),
        ),
        const SizedBox(height: 2),
        Text(label,
            style: TextStyle(
                color: Colors.grey[600],
                fontSize: 11,
                fontWeight: FontWeight.w500)),
      ],
    );
  }
}
