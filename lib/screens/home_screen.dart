import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../providers/promotions_provider.dart';
import '../providers/stations_provider.dart';
import '../providers/navigation_provider.dart';
import '../widgets/promotion_card.dart';
import '../widgets/points_badge.dart';
import '../widgets/quick_action_button.dart';
import '../widgets/station_card.dart';
import '../theme/app_colors.dart';
import 'qr_scanner_screen.dart';
import 'station_detail_screen.dart';

/// The main landing tab — shows greeting, points summary,
/// quick-action shortcuts, nearby stations, and featured promotions.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user       = context.watch<UserProvider>().user;
    final promotions = context.watch<PromotionsProvider>().featured;
    final stations   = context.watch<StationsProvider>().nearest(3);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: CustomScrollView(
        slivers: [
          // ── Collapsing gradient header ──────────────────────────────────────
          SliverAppBar(
            expandedHeight: 160,
            pinned: true,
            elevation: 0,
            backgroundColor: AppColors.primaryGreen,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: _Header(userName: user.name.split(' ').first),
            ),
            title: const Text(
              'GasRewards',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined,
                    color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),

          // ── Main content ────────────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Points & membership badge
                PointsBadge.fromUser(user),
                const SizedBox(height: 24),

                // Quick actions
                _SectionTitle(title: 'Accesos Rápidos'),
                const SizedBox(height: 12),
                _QuickActionsRow(context),
                const SizedBox(height: 24),

                // Nearby stations carousel
                _SectionHeader(
                  title: 'Gasolineras Cercanas',
                  onSeeAll: () =>
                      context.read<NavigationProvider>().setIndex(1),
                ),
                const SizedBox(height: 8),
                _NearbyStationsCarousel(stations: stations),
                const SizedBox(height: 24),

                // Featured promotions carousel
                _SectionHeader(
                  title: 'Promociones Destacadas',
                  onSeeAll: () =>
                      context.read<NavigationProvider>().setIndex(2),
                ),
                const SizedBox(height: 8),
                _FeaturedPromotionsCarousel(promotions: promotions),
                const SizedBox(height: 16),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _QuickActionsRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        QuickActionButton(
          icon: Icons.qr_code_scanner,
          label: 'Escanear QR',
          color: AppColors.primaryGreen,
          onTap: () => Navigator.push(
            context,
            _fadeRoute(const QRScannerScreen()),
          ),
        ),
        QuickActionButton(
          icon: Icons.local_gas_station,
          label: 'Gasolineras',
          color: AppColors.accentBlue,
          onTap: () => context.read<NavigationProvider>().setIndex(1),
        ),
        QuickActionButton(
          icon: Icons.local_offer,
          label: 'Promociones',
          color: AppColors.accentOrange,
          onTap: () => context.read<NavigationProvider>().setIndex(2),
        ),
      ],
    );
  }

  Widget _NearbyStationsCarousel({required List stations}) {
    return SizedBox(
      height: 210,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemCount: stations.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final station = stations[i];
          return SizedBox(
            width: 280,
            child: Builder(
              builder: (ctx) => StationCard(
                station: station,
                onTap: () => Navigator.push(
                  ctx,
                  MaterialPageRoute(
                    builder: (_) => StationDetailScreen(station: station),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _FeaturedPromotionsCarousel({required List promotions}) {
    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemCount: promotions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) => SizedBox(
          width: 240,
          child: PromotionCard(promotion: promotions[i], compact: true),
        ),
      ),
    );
  }

  /// Simple fade page-route for pushing the QR scanner
  static PageRouteBuilder _fadeRoute(Widget page) => PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 300),
      );
}

// ── Private helper widgets ──────────────────────────────────────────────────

class _Header extends StatelessWidget {
  final String userName;
  const _Header({required this.userName});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryGreen, Color(0xFF2E7D32)],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 80, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            '¡Hola, $userName! 👋',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Revisa tus puntos y promociones de hoy',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) => Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(fontWeight: FontWeight.bold),
      );
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAll;
  const _SectionHeader({required this.title, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: onSeeAll,
          child: const Text('Ver todas'),
        ),
      ],
    );
  }
}
