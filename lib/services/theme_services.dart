import 'package:flutter/material.dart';

class ThemeServices extends ChangeNotifier{
  bool _isDark = false;
  bool get isDark => _isDark;

  isThemeDark(){
    _isDark = !_isDark;
  }

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  void setTheme(ThemeMode themeMode)
  {
    _themeMode = themeMode;
    notifyListeners();
  }
}