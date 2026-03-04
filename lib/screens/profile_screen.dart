import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';
import '../theme/app_colors.dart';

/// User profile tab — shows avatar, points, membership level, progress,
/// and a mock recent-activity list.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // Static fake activity feed (replaces a real API call)
  static const List<_Activity> _recentActivity = [
    _Activity(icon: Icons.qr_code_scanner, label: 'Escaneo QR – Repsol Centro',  points: 150, date: 'Hoy'),
    _Activity(icon: Icons.qr_code_scanner, label: 'Escaneo QR – BP Sur',         points: 80,  date: 'Ayer'),
    _Activity(icon: Icons.local_offer,     label: 'Bono Puntos x2 Weekend',      points: 200, date: 'Sáb'),
    _Activity(icon: Icons.qr_code_scanner, label: 'Escaneo QR – Cepsa Norte',    points: 120, date: 'Vie'),
    _Activity(icon: Icons.qr_code_scanner, label: 'Escaneo QR – Shell Gamonal',  points: 90,  date: 'Jue'),
  ];

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          // Demo reset button
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: 'Reiniciar puntos (demo)',
            onPressed: () {
              context.read<UserProvider>().resetPoints();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Puntos reiniciados (modo demo)')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ── Avatar + basic info ─────────────────────────────────────────
            _AvatarCard(user: user),
            const SizedBox(height: 16),

            // ── Membership progress ─────────────────────────────────────────
            _MembershipCard(user: user),
            const SizedBox(height: 16),

            // ── Quick stats ─────────────────────────────────────────────────
            _StatsRow(user: user),
            const SizedBox(height: 16),

            // ── Recent activity ─────────────────────────────────────────────
            _RecentActivityCard(activities: _recentActivity),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// ── Private sub-widgets ───────────────────────────────────────────────────────

class _AvatarCard extends StatelessWidget {
  final User user;
  const _AvatarCard({required this.user});

  Color get _levelColor {
    switch (user.membershipLevel) {
      case MembershipLevel.gold:   return AppColors.gold;
      case MembershipLevel.silver: return AppColors.silver;
      default:                     return AppColors.bronze;
    }
  }

  @override
  Widget build(BuildContext context) {
    final initials = user.name
        .split(' ')
        .take(2)
        .map((w) => w.isNotEmpty ? w[0] : '')
        .join()
        .toUpperCase();

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
        child: Column(
          children: [
            // Avatar circle with initials
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 44,
                  backgroundColor:
                      AppColors.primaryGreen.withValues(alpha: 0.15),
                  child: Text(
                    initials,
                    style: const TextStyle(
                      color: AppColors.primaryGreen,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Level badge overlay
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: _levelColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(Icons.workspace_premium,
                      color: Colors.white, size: 14),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              user.name,
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              user.email,
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

class _MembershipCard extends StatelessWidget {
  final User user;
  const _MembershipCard({required this.user});

  Color get _levelColor {
    switch (user.membershipLevel) {
      case MembershipLevel.gold:   return AppColors.gold;
      case MembershipLevel.silver: return AppColors.silver;
      default:                     return AppColors.bronze;
    }
  }

  IconData get _levelIcon {
    switch (user.membershipLevel) {
      case MembershipLevel.gold:   return Icons.workspace_premium;
      case MembershipLevel.silver: return Icons.military_tech;
      default:                     return Icons.emoji_events_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMax = user.membershipLevel == MembershipLevel.gold;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Level + badge
            Row(
              children: [
                Icon(_levelIcon, color: _levelColor, size: 28),
                const SizedBox(width: 10),
                Text(
                  'Nivel ${user.membershipLevel}',
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: _levelColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border:
                        Border.all(color: _levelColor.withValues(alpha: 0.4)),
                  ),
                  child: Text(
                    user.membershipLevel,
                    style: TextStyle(
                      color: _levelColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Progress bar
            if (!isMax) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${user.points} pts',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '${user.pointsToNextLevel} pts para ${user.nextLevelName}',
                    style:
                        TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: user.levelProgress,
                  minHeight: 10,
                  backgroundColor: Colors.grey[200],
                  valueColor:
                      AlwaysStoppedAnimation<Color>(_levelColor),
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    user.membershipLevel,
                    style:
                        TextStyle(fontSize: 11, color: Colors.grey[500]),
                  ),
                  Text(
                    user.nextLevelName,
                    style:
                        TextStyle(fontSize: 11, color: Colors.grey[500]),
                  ),
                ],
              ),
            ] else
              Text(
                '🏆 ¡Nivel máximo alcanzado!',
                style: TextStyle(
                    color: AppColors.gold, fontWeight: FontWeight.w600),
              ),
          ],
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final User user;
  const _StatsRow({required this.user});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatCard(
          label: 'Puntos Totales',
          value: user.points.toString(),
          icon: Icons.stars,
          color: AppColors.primaryGreen,
        ),
        const SizedBox(width: 12),
        _StatCard(
          label: user.membershipLevel == MembershipLevel.gold
              ? 'Nivel Máximo'
              : 'Para ${user.nextLevelName}',
          value: user.membershipLevel == MembershipLevel.gold
              ? '∞'
              : user.pointsToNextLevel.toString(),
          icon: Icons.trending_up,
          color: AppColors.accentBlue,
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                    color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentActivityCard extends StatelessWidget {
  final List<_Activity> activities;
  const _RecentActivityCard({required this.activities});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              children: [
                const Icon(Icons.history,
                    color: AppColors.primaryGreen, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Actividad Reciente',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ...activities.map((a) => ListTile(
                dense: true,
                leading: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(a.icon,
                      color: AppColors.primaryGreen, size: 18),
                ),
                title: Text(a.label,
                    style: const TextStyle(fontSize: 13)),
                subtitle: Text(a.date,
                    style: TextStyle(
                        fontSize: 11, color: Colors.grey[500])),
                trailing: Text(
                  '+${a.points} pts',
                  style: const TextStyle(
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              )),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

/// Immutable data class for activity feed entries
class _Activity {
  final IconData icon;
  final String label;
  final int points;
  final String date;

  const _Activity({
    required this.icon,
    required this.label,
    required this.points,
    required this.date,
  });
}
