import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _boxName = 'settings';
  static const String _themeKey = 'isDarkMode';
  
  bool _isDarkMode = false;
  
  bool get isDarkMode => _isDarkMode;
  
  ThemeData get themeData => _isDarkMode ? _darkTheme : _lightTheme;
  
  static final _lightTheme = ThemeData(
    primarySwatch: Colors.blue,
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.light,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
    ),
  );
  
  static final _darkTheme = ThemeData(
    primarySwatch: Colors.blue,
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.dark,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[900],
      foregroundColor: Colors.white,
    ),
  );
  
  ThemeProvider() {
    _loadTheme();
  }
  
  Future<void> _loadTheme() async {
    try {
      final box = await Hive.openBox(_boxName);
      _isDarkMode = box.get(_themeKey, defaultValue: false);
      notifyListeners();
    } catch (e) {
      // Si hay error, usar tema claro por defecto
      _isDarkMode = false;
    }
  }
  
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _saveTheme();
    notifyListeners();
  }
  
  Future<void> setDarkMode(bool isDark) async {
    if (_isDarkMode != isDark) {
      _isDarkMode = isDark;
      await _saveTheme();
      notifyListeners();
    }
  }
  
  Future<void> _saveTheme() async {
    try {
      final box = await Hive.openBox(_boxName);
      await box.put(_themeKey, _isDarkMode);
    } catch (e) {
      // Manejar error de guardado silenciosamente
    }
  }
} 