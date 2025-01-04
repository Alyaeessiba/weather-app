import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:intl/intl.dart';

class SunPosition extends StatelessWidget {
  final String sunrise;
  final String sunset;
  final String currentTime;

  const SunPosition({
    super.key,
    required this.sunrise,
    required this.sunset,
    required this.currentTime,
  });

  DateTime _parseTime(String time) {
    final now = DateTime.parse(currentTime);
    final format = DateFormat('hh:mm a');
    
    // Remove any 'AM' or 'PM' and trim
    String cleanTime = time.replaceAll(RegExp(r'[APM]'), '').trim();
    
    try {
      final timeComponents = cleanTime.split(':');
      int hour = int.parse(timeComponents[0]);
      int minute = int.parse(timeComponents[1]);
      
      // Adjust for PM times
      if (time.toUpperCase().contains('PM') && hour != 12) {
        hour += 12;
      }
      // Adjust for AM 12
      if (time.toUpperCase().contains('AM') && hour == 12) {
        hour = 0;
      }
      
      return DateTime(
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );
    } catch (e) {
      // Return default times if parsing fails
      return now;
    }
  }

  double _calculateProgress() {
    final now = DateTime.parse(currentTime);
    final sunriseTime = _parseTime(sunrise);
    final sunsetTime = _parseTime(sunset);

    if (now.isBefore(sunriseTime)) return 0;
    if (now.isAfter(sunsetTime)) return 1;

    final totalDuration = sunsetTime.difference(sunriseTime).inMinutes;
    final currentDuration = now.difference(sunriseTime).inMinutes;

    return currentDuration / totalDuration;
  }

  String _formatTime(String time) {
    // Remove any 'AM' or 'PM' and trim
    String cleanTime = time.replaceAll(RegExp(r'[APM]'), '').trim();
    try {
      final timeComponents = cleanTime.split(':');
      int hour = int.parse(timeComponents[0]);
      int minute = int.parse(timeComponents[1]);
      
      return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return time;
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = _calculateProgress();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
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
          Text(
            'Sunrise & Sunset',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: 20,
                ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 120,
            child: CustomPaint(
              size: const Size(double.infinity, 120),
              painter: SunPathPainter(
                progress: progress,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.wb_sunny_outlined,
                        size: 20,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Sunrise',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(sunrise),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.wb_twilight,
                        size: 20,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Sunset',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(sunset),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SunPathPainter extends CustomPainter {
  final double progress;
  final Color color;

  SunPathPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final sunPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final rect = Rect.fromLTRB(0, 0, size.width, size.height * 2);
    final path = Path()..addArc(rect, math.pi, math.pi);

    canvas.drawPath(path, paint);

    final progressPath = Path()
      ..addArc(rect, math.pi, math.pi * progress);
    canvas.drawPath(progressPath, progressPaint);

    final sunX = size.width * progress;
    final sunY = size.height - math.sin(math.pi * progress) * size.height;
    canvas.drawCircle(Offset(sunX, sunY), 6, sunPaint);
  }

  @override
  bool shouldRepaint(covariant SunPathPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
