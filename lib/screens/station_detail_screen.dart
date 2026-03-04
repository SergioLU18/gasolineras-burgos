import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/gas_station.dart';
import '../theme/app_colors.dart';
import 'qr_scanner_screen.dart';

/// Full detail view for a single [GasStation].
/// Accessed via Hero transition from [StationCard].
class StationDetailScreen extends StatelessWidget {
  final GasStation station;

  const StationDetailScreen({super.key, required this.station});

  static final _dateFormat = DateFormat('dd MMM yyyy', 'es');

  @override
  Widget build(BuildContext context) {
    final brandColor = AppColors.forBrand(station.brand);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: CustomScrollView(
        slivers: [
          // ── Gradient header with Hero-animated name ───────────────────────
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: brandColor,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: _StationHeader(
                  station: station, brandColor: brandColor),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ── Fuel prices card ──────────────────────────────────────
                _SectionCard(
                  title: 'Precios de Combustible',
                  icon: Icons.local_gas_station,
                  iconColor: brandColor,
                  child: _FuelPricesGrid(prices: station.fuelPrices),
                ),
                const SizedBox(height: 16),

                // ── Address card ──────────────────────────────────────────
                _SectionCard(
                  title: 'Ubicación',
                  icon: Icons.location_on,
                  iconColor: AppColors.accentBlue,
                  child: Text(
                    station.address,
                    style: TextStyle(color: Colors.grey[700], height: 1.5),
                  ),
                ),
                const SizedBox(height: 16),

                // ── Promotions card ───────────────────────────────────────
                if (station.promotions.isNotEmpty) ...[
                  _SectionCard(
                    title: 'Promociones en esta estación',
                    icon: Icons.local_offer,
                    iconColor: AppColors.accentOrange,
                    child: Column(
                      children: station.promotions
                          .map((p) => _PromotionTile(
                                promotion: p,
                                dateFormat: _dateFormat,
                              ))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // ── Scan CTA ──────────────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            QRScannerScreen(station: station),
                      ),
                    ),
                    icon: const Icon(Icons.qr_code_scanner),
                    label: const Text('Escanear QR en esta Estación'),
                    style: FilledButton.styleFrom(
                      backgroundColor: brandColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Private helpers ──────────────────────────────────────────────────────────

class _StationHeader extends StatelessWidget {
  final GasStation station;
  final Color brandColor;

  const _StationHeader(
      {required this.station, required this.brandColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [brandColor, brandColor.withValues(alpha: 0.75)],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 90, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Brand pill
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              station.brand,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 6),
          // Hero-animated name
          Hero(
            tag: 'station_name_${station.id}',
            child: Material(
              color: Colors.transparent,
              child: Text(
                station.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.location_on,
                  size: 14, color: Colors.white70),
              const SizedBox(width: 4),
              Text(
                station.distanceLabel,
                style: const TextStyle(
                    color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _FuelPricesGrid extends StatelessWidget {
  final FuelPrices prices;
  const _FuelPricesGrid({required this.prices});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _PriceBlock(
            label: 'Gasolina 95',
            price: prices.regular,
            color: AppColors.primaryGreen),
        _PriceBlock(
            label: 'Gasolina 98',
            price: prices.premium,
            color: AppColors.accentBlue),
        _PriceBlock(
            label: 'Diésel',
            price: prices.diesel,
            color: AppColors.accentOrange),
      ],
    );
  }
}

class _PriceBlock extends StatelessWidget {
  final String label;
  final double price;
  final Color color;

  const _PriceBlock(
      {required this.label, required this.price, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Text(
              '€${price.toStringAsFixed(3)}',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 10,
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _PromotionTile extends StatelessWidget {
  final dynamic promotion;
  final DateFormat dateFormat;

  const _PromotionTile(
      {required this.promotion, required this.dateFormat});

  @override
  Widget build(BuildContext context) {
    final color = AppColors.forCategory(promotion.category as String);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(AppColors.iconForCategory(promotion.category as String),
              color: color, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  promotion.title as String,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 13),
                ),
                const SizedBox(height: 2),
                Text(
                  'Hasta ${dateFormat.format(promotion.validUntil as DateTime)}',
                  style: TextStyle(
                      fontSize: 11, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              promotion.discountLabel as String,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
