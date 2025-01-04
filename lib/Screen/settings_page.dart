import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  final VoidCallback onThemeToggle;
  final bool useCelsius;
  final Function(bool) onTemperatureUnitChanged;
  final bool showAlerts;
  final Function(bool) onAlertsToggled;
  final Function(String) onThemeColorChanged;

  const SettingsPage({
    super.key,
    required this.onThemeToggle,
    required this.useCelsius,
    required this.onTemperatureUnitChanged,
    required this.showAlerts,
    required this.onAlertsToggled,
    required this.onThemeColorChanged,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _useCelsius = true;
  bool _showAlerts = true;
  bool _severWeatherAlerts = true;
  bool _rainAlerts = true;
  bool _tempAlerts = true;
  bool _autoRefresh = true;
  String _refreshInterval = '30 min';
  String _selectedColor = 'Blue';
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _loadSettings();
    _useCelsius = widget.useCelsius;
    _showAlerts = widget.showAlerts;
  }

  Future<void> _loadSettings() async {
    setState(() {
      _severWeatherAlerts = _prefs.getBool('severe_weather_alerts') ?? true;
      _rainAlerts = _prefs.getBool('rain_alerts') ?? true;
      _tempAlerts = _prefs.getBool('temp_alerts') ?? true;
      _autoRefresh = _prefs.getBool('auto_refresh') ?? true;
      _refreshInterval = _prefs.getString('refresh_interval') ?? '30 min';
      _selectedColor = _prefs.getString('app_color') ?? 'Blue';
    });
  }

  Future<void> _saveSettings() async {
    await _prefs.setBool('severe_weather_alerts', _severWeatherAlerts);
    await _prefs.setBool('rain_alerts', _rainAlerts);
    await _prefs.setBool('temp_alerts', _tempAlerts);
    await _prefs.setBool('auto_refresh', _autoRefresh);
    await _prefs.setString('refresh_interval', _refreshInterval);
    await _prefs.setString('app_color', _selectedColor);
  }

  void _updateAppColor(String? color) {
    if (color == null) return;
    setState(() {
      _selectedColor = color;
    });
    widget.onThemeColorChanged(color);
    _saveSettings();
    // Here you would typically update your app's theme
  }

  void _updateRefreshInterval(String? interval) {
    if (interval == null) return;
    setState(() {
      _refreshInterval = interval;
    });
    _saveSettings();
    // Here you would typically update your refresh timer
  }

  void _toggleAutoRefresh(bool value) {
    setState(() {
      _autoRefresh = value;
    });
    _saveSettings();
    // Here you would typically start/stop auto refresh
  }

  Future<void> _clearCache() async {
    // Clear shared preferences
    await _prefs.clear();
    
    // Reload default settings
    setState(() {
      _severWeatherAlerts = true;
      _rainAlerts = true;
      _tempAlerts = true;
      _autoRefresh = true;
      _refreshInterval = '30 min';
      _selectedColor = 'Blue';
    });

    // Restore essential settings
    await _prefs.setBool('dark_mode', Theme.of(context).brightness == Brightness.dark);
    await _prefs.setBool('use_celsius', widget.useCelsius);
    await _prefs.setBool('show_alerts', widget.showAlerts);
    
    // Update app color to default
    widget.onThemeColorChanged('Blue');

    if (!mounted) return;
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings reset successfully'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSettingCard(
              context,
              'Temperature Unit',
              ListTile(
                leading: Icon(
                  Icons.thermostat,
                  color: Theme.of(context).colorScheme.primary,
                  size: 28,
                ),
                title: const Text('Use Celsius'),
                subtitle: Text(_useCelsius
                    ? 'Currently using Celsius (°C)'
                    : 'Currently using Fahrenheit (°F)'),
                trailing: Transform.scale(
                  scale: 1.0,
                  child: Switch.adaptive(
                    value: _useCelsius,
                    onChanged: (bool value) {
                      setState(() {
                        _useCelsius = value;
                      });
                      widget.onTemperatureUnitChanged(value);
                    },
                    activeColor: Theme.of(context).colorScheme.primary,
                    activeTrackColor:
                        Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildSettingCard(
              context,
              'Notifications',
              Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.notifications,
                      color: Theme.of(context).colorScheme.primary,
                      size: 28,
                    ),
                    title: const Text('Show Weather Alerts'),
                    subtitle: Text(_showAlerts
                        ? 'Get notified about weather changes'
                        : 'Notifications are disabled'),
                    trailing: Transform.scale(
                      scale: 1.0,
                      child: Switch.adaptive(
                        value: _showAlerts,
                        onChanged: (value) {
                          setState(() {
                            _showAlerts = value;
                          });
                          widget.onAlertsToggled(value);
                        },
                        activeColor: Theme.of(context).colorScheme.primary,
                        activeTrackColor:
                            Theme.of(context).colorScheme.primary.withOpacity(0.5),
                      ),
                    ),
                  ),
                  if (_showAlerts) ...[
                    ListTile(
                      leading: const Icon(Icons.thunderstorm),
                      title: const Text('Severe Weather Alerts'),
                      trailing: Switch.adaptive(
                        value: _severWeatherAlerts,
                        onChanged: (value) {
                          setState(() {
                            _severWeatherAlerts = value;
                          });
                          _saveSettings();
                        },
                        activeColor: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.water_drop),
                      title: const Text('Rain Alerts'),
                      trailing: Switch.adaptive(
                        value: _rainAlerts,
                        onChanged: (value) {
                          setState(() {
                            _rainAlerts = value;
                          });
                          _saveSettings();
                        },
                        activeColor: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.thermostat),
                      title: const Text('Temperature Alerts'),
                      trailing: Switch.adaptive(
                        value: _tempAlerts,
                        onChanged: (value) {
                          setState(() {
                            _tempAlerts = value;
                          });
                          _saveSettings();
                        },
                        activeColor: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildSettingCard(
              context,
              'Appearance',
              Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Theme.of(context).brightness == Brightness.dark
                          ? Icons.dark_mode
                          : Icons.light_mode,
                      color: Theme.of(context).colorScheme.primary,
                      size: 28,
                    ),
                    title: const Text('Dark Mode'),
                    subtitle: Text(
                      Theme.of(context).brightness == Brightness.dark
                          ? 'Dark theme enabled'
                          : 'Light theme enabled',
                    ),
                    trailing: Transform.scale(
                      scale: 1.0,
                      child: Switch.adaptive(
                        value: Theme.of(context).brightness == Brightness.dark,
                        onChanged: (value) {
                          widget.onThemeToggle();
                        },
                        activeColor: Theme.of(context).colorScheme.primary,
                        activeTrackColor:
                            Theme.of(context).colorScheme.primary.withOpacity(0.5),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.color_lens),
                    title: const Text('App Color'),
                    trailing: Container(
                      width: 100,
                      child: DropdownButton<String>(
                        value: _selectedColor,
                        items: ['Blue', 'Purple', 'Green', 'Orange']
                            .map((color) => DropdownMenuItem(
                                  value: color,
                                  child: Text(color),
                                ))
                            .toList(),
                        onChanged: (String? color) {
                          if (color != null) {
                            setState(() {
                              _selectedColor = color;
                            });
                            widget.onThemeColorChanged(color);
                            _saveSettings();
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildSettingCard(
              context,
              'Data & Storage',
              Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.update),
                    title: const Text('Auto Refresh'),
                    subtitle: const Text('Update weather data automatically'),
                    trailing: Switch.adaptive(
                      value: _autoRefresh,
                      onChanged: _toggleAutoRefresh,
                      activeColor: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.timer),
                    title: const Text('Refresh Interval'),
                    trailing: Container(
                      width: 100,
                      child: DropdownButton<String>(
                        value: _refreshInterval,
                        items: ['15 min', '30 min', '1 hour', '3 hours']
                            .map((interval) => DropdownMenuItem(
                                  value: interval,
                                  child: Text(interval),
                                ))
                            .toList(),
                        onChanged: _updateRefreshInterval,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.storage),
                    title: const Text('Clear Cache'),
                    subtitle: const Text('0.0 MB'),
                    trailing: TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Clear Cache'),
                            content: const Text('Are you sure you want to clear the cache?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await _clearCache();
                                  Navigator.pop(context);
                                },
                                child: const Text('Clear'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: const Text('Clear'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildSettingCard(
              context,
              'Weather Alerts',
              ListTile(
                leading: Icon(
                  Icons.notifications_active,
                  color: Theme.of(context).colorScheme.primary,
                  size: 28,
                ),
                title: const Text('Show Weather Alerts'),
                subtitle: Text(_showAlerts
                    ? 'Get notified about weather changes'
                    : 'Notifications are disabled'),
                trailing: Transform.scale(
                  scale: 1.0,
                  child: Switch.adaptive(
                    value: _showAlerts,
                    onChanged: (bool value) {
                      setState(() {
                        _showAlerts = value;
                      });
                      widget.onAlertsToggled(value);
                    },
                    activeColor: Theme.of(context).colorScheme.primary,
                    activeTrackColor:
                        Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'About',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            _buildSettingCard(
              context,
              'App Information',
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.info_outline,
                      color: Theme.of(context).colorScheme.primary,
                      size: 28,
                    ),
                    title: const Text('Version'),
                    trailing: Text(
                      '1.0.0',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.code,
                      color: Theme.of(context).colorScheme.primary,
                      size: 28,
                    ),
                    title: const Text('Developer'),
                    trailing: Text(
                      'ESSIBA Alyae',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingCard(BuildContext context, String title, Widget content) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          content,
        ],
      ),
    );
  }
}
