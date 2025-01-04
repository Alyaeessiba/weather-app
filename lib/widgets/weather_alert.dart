import 'package:flutter/material.dart';

enum AlertSeverity {
  low,
  moderate,
  high,
  severe,
}

class WeatherAlert extends StatelessWidget {
  final String title;
  final String description;
  final AlertSeverity severity;
  final DateTime time;

  const WeatherAlert({
    super.key,
    required this.title,
    required this.description,
    required this.severity,
    required this.time,
  });

  Color _getSeverityColor(BuildContext context) {
    switch (severity) {
      case AlertSeverity.low:
        return Colors.blue;
      case AlertSeverity.moderate:
        return Colors.yellow.shade700;
      case AlertSeverity.high:
        return Colors.orange;
      case AlertSeverity.severe:
        return Colors.red;
    }
  }

  IconData _getSeverityIcon() {
    switch (severity) {
      case AlertSeverity.low:
        return Icons.info_outline;
      case AlertSeverity.moderate:
        return Icons.warning_amber_outlined;
      case AlertSeverity.high:
        return Icons.warning;
      case AlertSeverity.severe:
        return Icons.dangerous;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: _getSeverityColor(context).withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _getSeverityColor(context).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: ExpansionTile(
          leading: Icon(
            _getSeverityIcon(),
            color: _getSeverityColor(context),
          ),
          title: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: _getSeverityColor(context),
                  fontWeight: FontWeight.bold,
                ),
          ),
          subtitle: Text(
            'Issued: ${time.hour}:${time.minute.toString().padLeft(2, '0')}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
