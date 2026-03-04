import 'package:flutter/material.dart';
import '../models/user.dart';
import '../theme/app_colors.dart';

/// Displays the user's current points total, membership level badge,
/// and a linear progress bar toward the next tier.
class PointsBadge extends StatelessWidget {
  final int points;
  final String level;
  final double progress;       // 0.0 – 1.0
  final int pointsToNext;
  final String nextLevelName;

  const PointsBadge({
    super.key,
    required this.points,
    required this.level,
    required this.progress,
    required this.pointsToNext,
    required this.nextLevelName,
  });

  /// Convenience constructor that derives values straight from a [User]
  factory PointsBadge.fromUser(User user) => PointsBadge(
        points:        user.points,
        level:         user.membershipLevel,
        progress:      user.levelProgress,
        pointsToNext:  user.pointsToNextLevel,
        nextLevelName: user.nextLevelName,
      );

  Color get _levelColor {
    switch (level) {
      case MembershipLevel.gold:   return AppColors.gold;
      case MembershipLevel.silver: return AppColors.silver;
      default:                     return AppColors.bronze;
    }
  }

  IconData get _levelIcon {
    switch (level) {
      case MembershipLevel.gold:   return Icons.workspace_premium;
      case MembershipLevel.silver: return Icons.military_tech;
      default:                     return Icons.emoji_events_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Points total + level badge row
            Row(
              children: [
                Icon(_levelIcon, color: _levelColor, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$points pts',
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                      Text(
                        'Nivel $level',
                        style: textTheme.bodySmall?.copyWith(
                          color: _levelColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                // Membership pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: _levelColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _levelColor.withValues(alpha: 0.4)),
                  ),
                  child: Text(
                    level,
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
            if (level != MembershipLevel.gold) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$pointsToNext pts para $nextLevelName',
                    style: textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                  ),
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: _levelColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(_levelColor),
                ),
              ),
            ] else
              Text(
                '¡Enhorabuena! Has alcanzado el nivel máximo.',
                style: textTheme.bodySmall?.copyWith(color: AppColors.gold),
              ),
          ],
        ),
      ),
    );
  }
}
