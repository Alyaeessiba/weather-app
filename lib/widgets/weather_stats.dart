import 'package:flutter/material.dart';
import 'dart:math' as math;

class WeatherStats extends StatelessWidget {
  final List<double> temperatures;
  final List<DateTime> dates;
  final double minTemp;
  final double maxTemp;
  final double precipitation;

  const WeatherStats({
    super.key,
    required this.temperatures,
    required this.dates,
    required this.minTemp,
    required this.maxTemp,
    required this.precipitation,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Temperature Trend',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: CustomPaint(
            size: const Size(double.infinity, 200),
            painter: TemperatureGraphPainter(
              temperatures: temperatures,
              dates: dates,
              minTemp: minTemp,
              maxTemp: maxTemp,
              lineColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                'Min Temperature',
                '$minTemp°C',
                Icons.arrow_downward,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                context,
                'Max Temperature',
                '$maxTemp°C',
                Icons.arrow_upward,
                Colors.red,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildPrecipitationBar(context),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrecipitationBar(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Precipitation Probability',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Container(
          height: 24,
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Flexible(
                flex: (precipitation * 100).round(),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue.shade300,
                        Colors.blue.shade600,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              Flexible(
                flex: (100 - precipitation * 100).round(),
                child: Container(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${(precipitation * 100).round()}%',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class TemperatureGraphPainter extends CustomPainter {
  final List<double> temperatures;
  final List<DateTime> dates;
  final double minTemp;
  final double maxTemp;
  final Color lineColor;
  final Color textColor;

  TemperatureGraphPainter({
    required this.temperatures,
    required this.dates,
    required this.minTemp,
    required this.maxTemp,
    required this.lineColor,
    required this.textColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    final width = size.width - 40;
    final height = size.height - 40;
    final xStep = width / (temperatures.length - 1);
    final yRange = maxTemp - minTemp;

    for (var i = 0; i < temperatures.length; i++) {
      final x = 20 + (i * xStep);
      final y = 20 + height - ((temperatures[i] - minTemp) / yRange * height);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }

      // Draw temperature point
      canvas.drawCircle(
        Offset(x, y),
        4,
        Paint()..color = lineColor,
      );

      // Draw date label
      final textPainter = TextPainter(
        text: TextSpan(
          text: '${dates[i].day}/${dates[i].month}',
          style: TextStyle(
            color: textColor,
            fontSize: 10,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, size.height - 20),
      );
    }

    // Draw the temperature line
    canvas.drawPath(path, paint);

    // Draw grid lines
    final gridPaint = Paint()
      ..color = textColor.withOpacity(0.1)
      ..strokeWidth = 1;

    for (var i = 0; i <= 4; i++) {
      final y = 20 + (i * height / 4);
      canvas.drawLine(
        Offset(20, y),
        Offset(size.width - 20, y),
        gridPaint,
      );

      // Draw temperature labels
      final temp = maxTemp - (i * yRange / 4);
      final textPainter = TextPainter(
        text: TextSpan(
          text: '${temp.round()}°',
          style: TextStyle(
            color: textColor,
            fontSize: 10,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(0, y - textPainter.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
