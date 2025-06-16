import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  late SharedPreferences _prefs;

  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _initTheme();
  }

  Future<void> _initTheme() async {
    _prefs = await SharedPreferences.getInstance();
    _isDarkMode = _prefs.getBool('isDarkMode') ?? false;
    notifyListeners();
  }

  ThemeData get themeData {
    return _isDarkMode ? _darkTheme : _lightTheme;
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _saveThemePreference();
    notifyListeners();
  }

  void setDarkMode(bool value) {
    _isDarkMode = value;
    _saveThemePreference();
    notifyListeners();
  }

  Future<void> _saveThemePreference() async {
    await _prefs.setBool('isDarkMode', _isDarkMode);
  }

  // Tema claro
  ThemeData get _lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primarySwatch: Colors.purple,
    primaryColor: const Color(0xFF7B68EE),
    scaffoldBackgroundColor: const Color(0xFFF8F9FA),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF7B68EE),
      secondary: Color(0xFF4C6EF5),
      surface: Colors.white,
      background: Color(0xFFF8F9FA),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Color(0xFF2D3748),
      onBackground: Color(0xFF2D3748),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF7B68EE),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardTheme: const CardThemeData(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF7B68EE),
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF7B68EE),
      foregroundColor: Colors.white,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Color(0xFF7B68EE),
      unselectedItemColor: Color(0xFF718096),
      elevation: 8,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF7B68EE), width: 2),
      ),
      filled: true,
      fillColor: const Color(0xFFF7FAFC),
    ),
  );

  // Tema oscuro
  ThemeData get _darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primarySwatch: Colors.purple,
    primaryColor: const Color(0xFF9F7AEA),
    scaffoldBackgroundColor: const Color(0xFF1A202C),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF9F7AEA),
      secondary: Color(0xFF667EEA),
      surface: Color(0xFF2D3748),
      background: Color(0xFF1A202C),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Color(0xFFF7FAFC),
      onBackground: Color(0xFFF7FAFC),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF2D3748),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardTheme: const CardThemeData(
      color: Color(0xFF2D3748),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF9F7AEA),
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF9F7AEA),
      foregroundColor: Colors.white,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF2D3748),
      selectedItemColor: Color(0xFF9F7AEA),
      unselectedItemColor: Color(0xFF718096),
      elevation: 8,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF4A5568)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF4A5568)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF9F7AEA), width: 2),
      ),
      filled: true,
      fillColor: const Color(0xFF4A5568),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: Color(0xFFF7FAFC)),
      displayMedium: TextStyle(color: Color(0xFFF7FAFC)),
      displaySmall: TextStyle(color: Color(0xFFF7FAFC)),
      headlineLarge: TextStyle(color: Color(0xFFF7FAFC)),
      headlineMedium: TextStyle(color: Color(0xFFF7FAFC)),
      headlineSmall: TextStyle(color: Color(0xFFF7FAFC)),
      titleLarge: TextStyle(color: Color(0xFFF7FAFC)),
      titleMedium: TextStyle(color: Color(0xFFF7FAFC)),
      titleSmall: TextStyle(color: Color(0xFFF7FAFC)),
      bodyLarge: TextStyle(color: Color(0xFFF7FAFC)),
      bodyMedium: TextStyle(color: Color(0xFFF7FAFC)),
      bodySmall: TextStyle(color: Color(0xFF718096)),
      labelLarge: TextStyle(color: Color(0xFFF7FAFC)),
      labelMedium: TextStyle(color: Color(0xFFF7FAFC)),
      labelSmall: TextStyle(color: Color(0xFF718096)),
    ),
  );
} 