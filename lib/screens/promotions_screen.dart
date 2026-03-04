import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/promotions_provider.dart';
import '../widgets/promotion_card.dart';
import '../theme/app_colors.dart';

/// Grid of all active promotions, filterable by category tab.
class PromotionsScreen extends StatefulWidget {
  const PromotionsScreen({super.key});

  @override
  State<PromotionsScreen> createState() => _PromotionsScreenState();
}

class _PromotionsScreenState extends State<PromotionsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  static const _tabs = [
    ('Todas',     ''),
    ('Combustible','fuel'),
    ('Servicios', 'service'),
    ('Comida',    'food'),
    ('Puntos',    'points'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: const Text('Promociones'),
        backgroundColor: AppColors.accentOrange,
        foregroundColor: Colors.white,
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          tabs: _tabs
              .map((t) => Tab(text: t.$1))
              .toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _tabs.map((t) => _PromotionGrid(category: t.$2)).toList(),
      ),
    );
  }
}

/// Grid of promotions for a given [category] (empty string = all).
class _PromotionGrid extends StatelessWidget {
  final String category;

  const _PromotionGrid({required this.category});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PromotionsProvider>();
    final items = category.isEmpty
        ? provider.activePromotions
        : provider.byCategory(category);

    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.local_offer_outlined,
                size: 56, color: Colors.grey[400]),
            const SizedBox(height: 12),
            Text(
              'No hay promociones activas\nen esta categoría',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.72,
      ),
      itemCount: items.length,
      itemBuilder: (_, i) => PromotionCard(
        promotion: items[i],
        compact: false,
      ),
    );
  }
}
