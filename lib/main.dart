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
  Color _primaryColor = Colors.blue; // Default color

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('dark_mode') ?? false;
      _useCelsius = prefs.getBool('use_celsius') ?? true;
      _showAlerts = prefs.getBool('show_alerts') ?? true;
      _primaryColor = _getColorFromString(prefs.getString('app_color') ?? 'Blue');
    });
  }

  Color _getColorFromString(String colorName) {
    switch (colorName) {
      case 'Purple':
        return Colors.purple;
      case 'Green':
        return Colors.green;
      case 'Orange':
        return Colors.orange;
      case 'Blue':
      default:
        return Colors.blue;
    }
  }

  void _updateThemeColor(String colorName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_color', colorName);
    setState(() {
      _primaryColor = _getColorFromString(colorName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _primaryColor,
          brightness: _isDarkMode ? Brightness.dark : Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: WeatherHome(
        isDarkMode: _isDarkMode,
        useCelsius: _useCelsius,
        showAlerts: _showAlerts,
        onThemeToggle: () async {
          final prefs = await SharedPreferences.getInstance();
          setState(() {
            _isDarkMode = !_isDarkMode;
          });
          await prefs.setBool('dark_mode', _isDarkMode);
        },
        onTemperatureUnitChanged: (bool value) async {
          final prefs = await SharedPreferences.getInstance();
          setState(() {
            _useCelsius = value;
          });
          await prefs.setBool('use_celsius', value);
        },
        onAlertsToggled: (bool value) async {
          final prefs = await SharedPreferences.getInstance();
          setState(() {
            _showAlerts = value;
          });
          await prefs.setBool('show_alerts', value);
        },
        onThemeColorChanged: _updateThemeColor,
      ),
    );
  }
}
