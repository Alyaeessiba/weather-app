import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Screen/weather_home.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;
  bool _useCelsius = true;
  bool _showAlerts = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _isDarkMode = prefs.getBool('dark_mode') ?? false;
        _useCelsius = prefs.getBool('use_celsius') ?? true;
        _showAlerts = prefs.getBool('show_alerts') ?? true;
      });
    } catch (e) {
      debugPrint('Error loading settings: $e');
      // Use default values if there's an error
      setState(() {
        _isDarkMode = false;
        _useCelsius = true;
        _showAlerts = true;
      });
    }
  }

  Future<void> _toggleTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _isDarkMode = !_isDarkMode;
      });
      await prefs.setBool('dark_mode', _isDarkMode);
    } catch (e) {
      debugPrint('Error saving theme setting: $e');
      // Still toggle the theme even if saving fails
      setState(() {
        _isDarkMode = !_isDarkMode;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: WeatherHome(
        isDarkMode: _isDarkMode,
        useCelsius: _useCelsius,
        showAlerts: _showAlerts,
        onThemeToggle: _toggleTheme,
        onTemperatureUnitChanged: (bool value) async {
          try {
            final prefs = await SharedPreferences.getInstance();
            setState(() {
              _useCelsius = value;
            });
            await prefs.setBool('use_celsius', value);
          } catch (e) {
            debugPrint('Error saving temperature unit setting: $e');
            setState(() {
              _useCelsius = value;
            });
          }
        },
        onAlertsToggled: (bool value) async {
          try {
            final prefs = await SharedPreferences.getInstance();
            setState(() {
              _showAlerts = value;
            });
            await prefs.setBool('show_alerts', value);
          } catch (e) {
            debugPrint('Error saving alerts setting: $e');
            setState(() {
              _showAlerts = value;
            });
          }
        },
      ),
    );
  }
}
