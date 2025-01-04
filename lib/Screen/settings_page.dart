import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  final bool useCelsius;
  final bool showAlerts;
  final Function(bool) onTemperatureUnitChanged;
  final Function(bool) onAlertsToggled;
  final VoidCallback onThemeToggle;

  const SettingsPage({
    super.key,
    required this.useCelsius,
    required this.showAlerts,
    required this.onTemperatureUnitChanged,
    required this.onAlertsToggled,
    required this.onThemeToggle,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late bool _useCelsius;
  late bool _showAlerts;

  @override
  void initState() {
    super.initState();
    _useCelsius = widget.useCelsius;
    _showAlerts = widget.showAlerts;
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
                subtitle: Text(_useCelsius ? 'Currently using Celsius (°C)' : 'Currently using Fahrenheit (°F)'),
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
                    activeTrackColor: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  ),
                ),
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
                subtitle: Text(_showAlerts ? 'Get notified about weather changes' : 'Notifications are disabled'),
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
                    activeTrackColor: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildSettingCard(
              context,
              'Theme',
              ListTile(
                leading: Icon(
                  Theme.of(context).brightness == Brightness.dark ? Icons.dark_mode : Icons.light_mode,
                  color: Theme.of(context).colorScheme.primary,
                  size: 28,
                ),
                title: const Text('Dark Theme'),
                subtitle: Text(Theme.of(context).brightness == Brightness.dark
                    ? 'Dark theme is enabled'
                    : 'Light theme is enabled'),
                trailing: Transform.scale(
                  scale: 1.0,
                  child: Switch.adaptive(
                    value: Theme.of(context).brightness == Brightness.dark,
                    onChanged: (bool value) {
                      widget.onThemeToggle();
                    },
                    activeColor: Theme.of(context).colorScheme.primary,
                    activeTrackColor: Theme.of(context).colorScheme.primary.withOpacity(0.5),
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
                        fontSize: 20,
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
                      'Your Name',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
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
