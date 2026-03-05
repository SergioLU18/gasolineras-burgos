import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';
import '../theme/app_colors.dart';

/// Shows the user's personal loyalty QR code so station staff can scan it
/// to verify membership, apply discounts, or award manual points.
///
/// The QR payload is a compact JSON string that encodes the user's ID,
/// membership level, points balance, and a timestamp.  Tapping "Actualizar"
/// regenerates the payload with a fresh timestamp — simulating the
/// short-lived tokens a real back-end would issue.
class MyQrScreen extends StatefulWidget {
  const MyQrScreen({super.key});

  @override
  State<MyQrScreen> createState() => _MyQrScreenState();
}

class _MyQrScreenState extends State<MyQrScreen>
    with SingleTickerProviderStateMixin {
  late DateTime _generatedAt;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _generatedAt = DateTime.now();

    // Subtle pulsing glow around the QR card to attract attention
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  // ── QR payload ─────────────────────────────────────────────────────────────

  /// Builds the JSON string encoded inside the QR code.
  String _buildPayload(User user) {
    final data = {
      'app':   'GasRewards',
      'id':    user.id,
      'name':  user.name,
      'level': user.membershipLevel,
      'pts':   user.points,
      'ts':    _generatedAt.millisecondsSinceEpoch,
    };
    return jsonEncode(data);
  }

  void _refresh() {
    setState(() => _generatedAt = DateTime.now());
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Código QR actualizado'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: const Text('Mi Tarjeta QR'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: 'Actualizar código',
            onPressed: _refresh,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── Instruction banner ────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppColors.primaryGreen.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline,
                      color: AppColors.primaryGreen, size: 20),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Presenta este código al operador para canjear '
                      'puntos o aplicar descuentos.',
                      style: TextStyle(
                          fontSize: 12,
                          color: AppColors.primaryGreen,
                          height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // ── QR card ───────────────────────────────────────────────────
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (_, child) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryGreen
                          .withValues(alpha: 0.25 * _pulseAnimation.value),
                      blurRadius: 32,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: child,
              ),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Membership level header
                      _LevelHeader(user: user),
                      const SizedBox(height: 20),

                      // The actual QR code
                      QrImageView(
                        data: _buildPayload(user),
                        version: QrVersions.auto,
                        size: 220,
                        eyeStyle: const QrEyeStyle(
                          eyeShape: QrEyeShape.square,
                          color: Color(0xFF1B3A2D),
                        ),
                        dataModuleStyle: const QrDataModuleStyle(
                          dataModuleShape: QrDataModuleShape.square,
                          color: Color(0xFF1B3A2D),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // User name
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.email,
                        style: TextStyle(
                            color: Colors.grey[600], fontSize: 13),
                      ),
                      const SizedBox(height: 16),

                      // Points chip
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: AppColors.primaryGreen
                                  .withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.stars,
                                color: AppColors.primaryGreen, size: 18),
                            const SizedBox(width: 6),
                            Text(
                              '${user.points} puntos',
                              style: const TextStyle(
                                color: AppColors.primaryGreen,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ── Generated-at timestamp ────────────────────────────────────
            _TimestampRow(generatedAt: _generatedAt),
            const SizedBox(height: 28),

            // ── Refresh button ────────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _refresh,
                icon: const Icon(Icons.refresh),
                label: const Text('Actualizar código QR'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryGreen,
                  side: const BorderSide(
                      color: AppColors.primaryGreen, width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Security note
            Text(
              'El código es válido durante 5 minutos. Actualízalo si caduca.',
              style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Private helpers ───────────────────────────────────────────────────────────

/// Shows the membership level badge at the top of the QR card.
class _LevelHeader extends StatelessWidget {
  final User user;
  const _LevelHeader({required this.user});

  Color get _color {
    switch (user.membershipLevel) {
      case MembershipLevel.gold:   return AppColors.gold;
      case MembershipLevel.silver: return AppColors.silver;
      default:                     return AppColors.bronze;
    }
  }

  IconData get _icon {
    switch (user.membershipLevel) {
      case MembershipLevel.gold:   return Icons.workspace_premium;
      case MembershipLevel.silver: return Icons.military_tech;
      default:                     return Icons.emoji_events_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, color: _color, size: 18),
          const SizedBox(width: 6),
          Text(
            'Socio ${user.membershipLevel}',
            style: TextStyle(
              color: _color,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

/// Displays the generation timestamp with a live indicator dot.
class _TimestampRow extends StatelessWidget {
  final DateTime generatedAt;
  const _TimestampRow({required this.generatedAt});

  String _fmt(DateTime dt) {
    final h  = dt.hour.toString().padLeft(2, '0');
    final m  = dt.minute.toString().padLeft(2, '0');
    final s  = dt.second.toString().padLeft(2, '0');
    final d  = dt.day.toString().padLeft(2, '0');
    final mo = dt.month.toString().padLeft(2, '0');
    return '$d/$mo/${dt.year}  $h:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Live indicator dot
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: AppColors.primaryGreen,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          'Generado: ${_fmt(generatedAt)}',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }
}
