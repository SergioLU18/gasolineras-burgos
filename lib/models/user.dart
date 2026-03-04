/// Membership tier thresholds (points required)
class MembershipLevel {
  MembershipLevel._();

  static const int silverMin = 1000;
  static const int goldMin   = 5000;

  static const String bronze = 'Bronze';
  static const String silver = 'Silver';
  static const String gold   = 'Gold';
}

/// The authenticated user, holding loyalty points and membership info
class User {
  final String id;
  final String name;
  final String email;
  final int points;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.points,
  });

  // ── Derived membership properties ───────────────────────────────────────────

  /// Current membership level derived from points
  String get membershipLevel {
    if (points >= MembershipLevel.goldMin)   return MembershipLevel.gold;
    if (points >= MembershipLevel.silverMin) return MembershipLevel.silver;
    return MembershipLevel.bronze;
  }

  /// Points needed to advance to the next tier (0 if already Gold)
  int get pointsToNextLevel {
    if (points >= MembershipLevel.goldMin)   return 0;
    if (points >= MembershipLevel.silverMin) return MembershipLevel.goldMin - points;
    return MembershipLevel.silverMin - points;
  }

  /// Progress within the current tier band (0.0 – 1.0)
  double get levelProgress {
    if (points >= MembershipLevel.goldMin) return 1.0;
    if (points >= MembershipLevel.silverMin) {
      final band = MembershipLevel.goldMin - MembershipLevel.silverMin;
      return (points - MembershipLevel.silverMin) / band;
    }
    return points / MembershipLevel.silverMin;
  }

  /// Next tier name string (for display in progress bar label)
  String get nextLevelName {
    if (points >= MembershipLevel.goldMin)   return MembershipLevel.gold;
    if (points >= MembershipLevel.silverMin) return MembershipLevel.gold;
    return MembershipLevel.silver;
  }

  /// Immutable copy with updated fields
  User copyWith({String? id, String? name, String? email, int? points}) {
    return User(
      id:     id     ?? this.id,
      name:   name   ?? this.name,
      email:  email  ?? this.email,
      points: points ?? this.points,
    );
  }
}
