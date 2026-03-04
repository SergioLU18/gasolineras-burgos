import 'package:flutter/material.dart';

/// Manages the selected bottom-navigation tab index.
/// Any screen can call [setIndex] to switch tabs programmatically.
class NavigationProvider extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void setIndex(int index) {
    if (_selectedIndex == index) return;
    _selectedIndex = index;
    notifyListeners();
  }
}
