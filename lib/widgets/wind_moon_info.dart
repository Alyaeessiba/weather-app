import 'package:flutter/material.dart';
import 'dart:math' as math;

class WindCompass extends StatelessWidget {
  final double windDirection;
  final double windSpeed;

  const WindCompass({
    super.key,
    required this.windDirection,
    required this.windSpeed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 150,
          width: 150,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Compass circle
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).dividerColor,
                    width: 2,
                  ),
                ),
              ),
              // Direction markers
              for (var i = 0; i < 360; i += 45)
                Transform.rotate(
                  angle: i * math.pi / 180,
                  child: Align(
                    alignment: const Alignment(0, -0.9),
                    child: Text(
                      _getDirectionText(i),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
              // Wind direction arrow
              Transform.rotate(
                angle: windDirection * math.pi / 180,
                child: CustomPaint(
                  size: const Size(100, 100),
                  painter: WindArrowPainter(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              // Center speed
              Text(
                '${windSpeed.round()} km/h',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getDirectionText(int degrees) {
    const directions = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
    return directions[((degrees + 22.5) % 360) ~/ 45];
  }
}

class WindArrowPainter extends CustomPainter {
  final Color color;

  WindArrowPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width / 2 - 10, size.height / 2)
      ..lineTo(size.width / 2 + 10, size.height / 2)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class MoonPhase extends StatelessWidget {
  final double phase; // 0.0 to 1.0 representing new moon to full moon
  final String phaseName;

  const MoonPhase({
    super.key,
    required this.phase,
    required this.phaseName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 100,
          width: 100,
          child: CustomPaint(
            painter: MoonPhasePainter(
              phase: phase,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          phaseName,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }
}

class MoonPhasePainter extends CustomPainter {
  final double phase;
  final Color color;

  MoonPhasePainter({
    required this.phase,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    // Draw moon circle
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 2,
      paint,
    );

    // Draw illuminated part
    final illuminatedPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.width / 2,
    );

    if (phase <= 0.5) {
      // Waxing moon
      final path = Path()
        ..addArc(rect, -math.pi / 2, math.pi)
        ..addArc(
          rect,
          math.pi / 2,
          -math.pi,
        );
      canvas.drawPath(path, illuminatedPaint);
    } else {
      // Waning moon
      final path = Path()
        ..addArc(rect, math.pi / 2, math.pi)
        ..addArc(
          rect,
          -math.pi / 2,
          -math.pi,
        );
      canvas.drawPath(path, illuminatedPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
