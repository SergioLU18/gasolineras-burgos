import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'providers/navigation_provider.dart';
import 'providers/user_provider.dart';
import 'providers/stations_provider.dart';
import 'providers/promotions_provider.dart';
import 'screens/home_screen.dart';
import 'screens/stations_screen.dart';
import 'screens/promotions_screen.dart';
import 'screens/profile_screen.dart';
import 'theme/app_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialise Spanish locale data for intl date formatting
  await initializeDateFormatting('es', null);

  // Lock to portrait orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const GasolinerasApp());
}

/// Root widget — sets up the provider tree and Material 3 theme.
class GasolinerasApp extends StatelessWidget {
  const GasolinerasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Tab-switching state (shared across the whole tree)
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        // Domain providers initialised from mock data
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => StationsProvider()),
        ChangeNotifierProvider(create: (_) => PromotionsProvider()),
      ],
      child: MaterialApp(
        title: 'GasRewards Burgos',
        debugShowCheckedModeBanner: false,
        theme: _buildTheme(),
        home: const MainNavigationScreen(),
      ),
    );
  }

  ThemeData _buildTheme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primaryGreen,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.scaffoldBg,

      // App bars
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),

      // Cards — rounded with a soft shadow
      cardTheme: CardTheme(
        elevation: 2,
        shadowColor: Colors.black12,
        color: AppColors.cardBg,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.zero,
      ),

      // Filled buttons
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: Colors.white,
          padding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
      ),

      // Bottom navigation bar
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: colorScheme.primaryContainer,
        elevation: 8,
        shadowColor: Colors.black26,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

/// Hosts the bottom navigation bar and keeps each tab alive with IndexedStack.
class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({super.key});

  static const List<Widget> _screens = [
    HomeScreen(),
    StationsScreen(),
    PromotionsScreen(),
    ProfileScreen(),
  ];

  static const List<NavigationDestination> _destinations = [
    NavigationDestination(
      icon:         Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label:        'Inicio',
    ),
    NavigationDestination(
      icon:         Icon(Icons.local_gas_station_outlined),
      selectedIcon: Icon(Icons.local_gas_station),
      label:        'Gasolineras',
    ),
    NavigationDestination(
      icon:         Icon(Icons.local_offer_outlined),
      selectedIcon: Icon(Icons.local_offer),
      label:        'Promociones',
    ),
    NavigationDestination(
      icon:         Icon(Icons.person_outlined),
      selectedIcon: Icon(Icons.person),
      label:        'Perfil',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Watch the navigation provider to react to programmatic tab changes
    final navProvider = context.watch<NavigationProvider>();

    return Scaffold(
      // IndexedStack keeps every tab's state alive while hidden
      body: IndexedStack(
        index: navProvider.selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: navProvider.selectedIndex,
        onDestinationSelected: context.read<NavigationProvider>().setIndex,
        destinations: _destinations,
      ),
    );
  }
}
