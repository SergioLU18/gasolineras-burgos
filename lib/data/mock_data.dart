import '../models/gas_station.dart';
import '../models/promotion.dart';
import '../models/user.dart';

/// All static mock data used throughout the application.
/// In a real app this would be replaced by API calls.
class MockData {
  MockData._(); // non-instantiable

  // ── User ────────────────────────────────────────────────────────────────────

  static final User currentUser = User(
    id:     'user_001',
    name:   'Carlos García',
    email:  'carlos.garcia@email.com',
    points: 1250, // Silver level on first launch
  );

  // ── Promotions ──────────────────────────────────────────────────────────────

  static final List<Promotion> promotions = [
    Promotion(
      id:                 'promo_001',
      title:              '10% en Gasolina Premium',
      description:        'Disfruta de un 10% de descuento en gasolina Premium 98 '
                          'durante todo el mes. Oferta válida para socios del '
                          'programa de fidelidad GasRewards.',
      discountPercentage: 10.0,
      validUntil:         DateTime(2026, 4, 30),
      category:           'fuel',
    ),
    Promotion(
      id:                 'promo_002',
      title:              'Lavado Gratis con 50 L',
      description:        'Llena tu depósito con 50 litros o más y consigue un '
                          'lavado de coche básico completamente gratuito.',
      discountPercentage: 100.0,
      validUntil:         DateTime(2026, 3, 31),
      category:           'service',
    ),
    Promotion(
      id:                 'promo_003',
      title:              'Puntos Dobles en Fin de Semana',
      description:        'Acumula el doble de puntos en todas tus recargas durante '
                          'los sábados y domingos de marzo. Sin mínimo de compra.',
      discountPercentage: 0.0,
      validUntil:         DateTime(2026, 3, 31),
      category:           'points',
    ),
    Promotion(
      id:                 'promo_004',
      title:              '15% Descuento en Diésel',
      description:        'Ahorra un 15% en cada repostaje de diésel. Oferta '
                          'exclusiva para vehículos con matrícula impar. Presenta '
                          'tu tarjeta GasRewards en caja.',
      discountPercentage: 15.0,
      validUntil:         DateTime(2026, 5, 15),
      category:           'fuel',
    ),
    Promotion(
      id:                 'promo_005',
      title:              '5% Cashback en Gasolina 95',
      description:        'Recibe un 5% de cashback en puntos en cada repostaje de '
                          'gasolina 95. Los puntos se acreditan en un plazo de 24 h.',
      discountPercentage: 5.0,
      validUntil:         DateTime(2026, 6, 30),
      category:           'fuel',
    ),
    Promotion(
      id:                 'promo_006',
      title:              'Café + Croissant por 1,50 €',
      description:        'Desayuna en nuestra tienda con café y croissant por tan '
                          'solo 1,50 €. Disponible de 7:00 a 11:00 h. No acumulable '
                          'con otras ofertas.',
      discountPercentage: 40.0,
      validUntil:         DateTime(2026, 4, 15),
      category:           'food',
    ),
    Promotion(
      id:                 'promo_007',
      title:              '20% en Cambio de Aceite',
      description:        'Realiza el cambio de aceite de tu vehículo con un 20% de '
                          'descuento. Incluye aceite sintético 5W-30 y filtro. Pide '
                          'cita en cualquiera de nuestras estaciones.',
      discountPercentage: 20.0,
      validUntil:         DateTime(2026, 4, 30),
      category:           'service',
    ),
    Promotion(
      id:                 'promo_008',
      title:              'Revisión de Neumáticos Gratis',
      description:        'Revisión de presión e inspección visual de los cuatro '
                          'neumáticos completamente gratuita. Sin cita previa. '
                          'Válido durante todo el año.',
      discountPercentage: 100.0,
      validUntil:         DateTime(2026, 12, 31),
      category:           'service',
    ),
  ];

  // ── Gas Stations (Burgos, Spain) ─────────────────────────────────────────────
  // Coordinates are approximate real locations in/around Burgos.

  static final List<GasStation> gasStations = [
    GasStation(
      id:         'station_001',
      name:       'Repsol Burgos Centro',
      address:    'Calle Vitoria, 12, 09004 Burgos',
      latitude:   42.3453,
      longitude:  -3.6952,
      fuelPrices: const FuelPrices(regular: 1.579, premium: 1.689, diesel: 1.489),
      distance:   0.8,
      brand:      'Repsol',
      promotions: [promotions[0], promotions[2], promotions[5]],
    ),
    GasStation(
      id:         'station_002',
      name:       'BP Burgos Sur',
      address:    'Ctra. de Madrid, km 236, 09007 Burgos',
      latitude:   42.3198,
      longitude:  -3.6884,
      fuelPrices: const FuelPrices(regular: 1.559, premium: 1.659, diesel: 1.469),
      distance:   2.3,
      brand:      'BP',
      promotions: [promotions[1], promotions[3], promotions[6]],
    ),
    GasStation(
      id:         'station_003',
      name:       'Cepsa Burgos Norte',
      address:    'Avda. del Cid Campeador, 45, 09005 Burgos',
      latitude:   42.3601,
      longitude:  -3.7012,
      fuelPrices: const FuelPrices(regular: 1.569, premium: 1.679, diesel: 1.479),
      distance:   1.5,
      brand:      'Cepsa',
      promotions: [promotions[4], promotions[7]],
    ),
    GasStation(
      id:         'station_004',
      name:       'Shell Gamonal',
      address:    'Calle Vitoria-Gasteiz, 200, 09001 Burgos',
      latitude:   42.3689,
      longitude:  -3.6723,
      fuelPrices: const FuelPrices(regular: 1.589, premium: 1.699, diesel: 1.499),
      distance:   3.1,
      brand:      'Shell',
      promotions: [promotions[0], promotions[5], promotions[7]],
    ),
    GasStation(
      id:         'station_005',
      name:       'Galp Villalonquejar',
      address:    'Polígono Industrial Villalonquejar, Calle 3, 09001 Burgos',
      latitude:   42.3412,
      longitude:  -3.7234,
      fuelPrices: const FuelPrices(regular: 1.549, premium: 1.649, diesel: 1.459),
      distance:   4.7,
      brand:      'Galp',
      promotions: [promotions[2], promotions[3], promotions[6]],
    ),
  ];
}
