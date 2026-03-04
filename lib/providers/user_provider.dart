import 'package:flutter/material.dart';
import '../models/user.dart';
import '../data/mock_data.dart';

/// Manages the currently authenticated user's state.
/// Point additions automatically update the membership level
/// because [User.membershipLevel] is a computed getter.
class UserProvider extends ChangeNotifier {
  late User _user;

  UserProvider() {
    _user = MockData.currentUser;
  }

  User get user => _user;

  /// Adds [points] to the user balance and notifies listeners.
  /// Membership level is derived automatically from the new total.
  void addPoints(int points) {
    _user = _user.copyWith(points: _user.points + points);
    notifyListeners();
  }

  /// Resets points to zero (useful for demo / testing purposes).
  void resetPoints() {
    _user = _user.copyWith(points: 0);
    notifyListeners();
  }
}
