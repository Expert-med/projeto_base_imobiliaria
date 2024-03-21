import 'package:flutter/material.dart';

class AppThemeStateNotifier extends ChangeNotifier {
  bool _isDarkModeEnabled = false;

  bool get isDarkModeEnabled => _isDarkModeEnabled;

  void enableDarkMode(bool value) {
    _isDarkModeEnabled = value;
    notifyListeners();
  }
}
