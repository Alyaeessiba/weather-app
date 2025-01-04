import 'package:flutter/material.dart';

class WeatherSettings extends StatelessWidget {
  final bool useCelsius;
  final bool showAlerts;
  final String selectedTheme;
  final Function(bool) onTemperatureUnitChanged;
  final Function(bool) onAlertsToggled;
  final Function(String) onThemeChanged;

  const WeatherSettings({
    super.key,
    required this.useCelsius,
    required this.showAlerts,
    required this.selectedTheme,
    required this.onTemperatureUnitChanged,
    required this.onAlertsToggled,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 24),
          _buildSettingItem(
            context,
            'Temperature Unit',
            Switch(
              value: useCelsius,
              onChanged: onTemperatureUnitChanged,
              activeTrackColor: Theme.of(context).colorScheme.primary.withOpacity(0.5),
              activeColor: Theme.of(context).colorScheme.primary,
            ),
            subtitle: useCelsius ? 'Using Celsius' : 'Using Fahrenheit',
          ),
          const Divider(height: 32),
          _buildSettingItem(
            context,
            'Weather Alerts',
            Switch(
              value: showAlerts,
              onChanged: onAlertsToggled,
              activeTrackColor: Theme.of(context).colorScheme.primary.withOpacity(0.5),
              activeColor: Theme.of(context).colorScheme.primary,
            ),
            subtitle: showAlerts ? 'Alerts enabled' : 'Alerts disabled',
          ),
          const Divider(height: 32),
          _buildSettingItem(
            context,
            'Theme',
            DropdownButton<String>(
              value: selectedTheme,
              items: [
                'System',
                'Light',
                'Dark',
                'Blue',
                'Green',
                'Purple',
              ].map((theme) {
                return DropdownMenuItem(
                  value: theme,
                  child: Text(theme),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  onThemeChanged(value);
                }
              },
            ),
            subtitle: 'Select app theme',
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context,
    String title,
    Widget trailing, {
    String? subtitle,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ],
          ),
        ),
        trailing,
      ],
    );
  }
}
