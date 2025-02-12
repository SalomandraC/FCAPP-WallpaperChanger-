import 'package:fcap/main.dart';
import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  AppTheme _currentTheme = AppTheme.red;

  AppTheme get currentTheme => _currentTheme;

  void setTheme(AppTheme theme) {
    _currentTheme = theme;
    notifyListeners();
  }
}
