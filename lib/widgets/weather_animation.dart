import 'package:flutter/material.dart';
import 'dart:math' as math;

class WeatherAnimation extends StatefulWidget {
  final String condition;

  const WeatherAnimation({
    super.key,
    required this.condition,
  });

  @override
  State<WeatherAnimation> createState() => _WeatherAnimationState();
}

class _WeatherAnimationState extends State<WeatherAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<Particle> particles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    particles = List.generate(20, (index) => Particle());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(double.infinity, 200),
          painter: WeatherPainter(
            condition: widget.condition.toLowerCase(),
            animation: _controller.value,
            particles: particles,
          ),
        );
      },
    );
  }
}

class Particle {
  late double x;
  late double y;
  late double speed;
  late double size;
  late double opacity;

  Particle() {
    reset();
  }

  void reset() {
    x = math.Random().nextDouble();
    y = math.Random().nextDouble();
    speed = 0.2 + math.Random().nextDouble() * 0.3;
    size = 2 + math.Random().nextDouble() * 3;
    opacity = 0.4 + math.Random().nextDouble() * 0.6;
  }
}

class WeatherPainter extends CustomPainter {
  final String condition;
  final double animation;
  final List<Particle> particles;

  WeatherPainter({
    required this.condition,
    required this.animation,
    required this.particles,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (condition.contains('rain')) {
      _paintRain(canvas, size);
    } else if (condition.contains('snow')) {
      _paintSnow(canvas, size);
    } else if (condition.contains('cloud')) {
      _paintClouds(canvas, size);
    } else if (condition.contains('sun') || condition.contains('clear')) {
      _paintSun(canvas, size);
    }
  }

  void _paintRain(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.1)
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;

    for (var particle in particles) {
      double currentY = (particle.y + animation * particle.speed) % 1.0;
      
      canvas.drawLine(
        Offset(particle.x * size.width, currentY * size.height),
        Offset(particle.x * size.width, (currentY + 0.05) * size.height),
        paint,
      );

      if (currentY >= 0.95) particle.reset();
    }
  }

  void _paintSnow(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.2);

    for (var particle in particles) {
      double currentY = (particle.y + animation * particle.speed * 0.3) % 1.0;
      double currentX = (particle.x + math.sin(animation * math.pi * 2) * 0.02) % 1.0;

      canvas.drawCircle(
        Offset(currentX * size.width, currentY * size.height),
        particle.size * 0.5,
        paint,
      );

      if (currentY >= 0.95) particle.reset();
    }
  }

  void _paintClouds(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.grey.withOpacity(0.1);

    double baseX = (animation * 0.05) % 1.0;
    _drawCloud(canvas, size, baseX * size.width, size.height * 0.3, paint, 0.7);
    _drawCloud(canvas, size, (baseX + 0.5) * size.width, size.height * 0.6, paint, 0.5);
  }

  void _drawCloud(Canvas canvas, Size size, double x, double y, Paint paint, double scale) {
    canvas.drawCircle(Offset(x, y), 30 * scale, paint);
    canvas.drawCircle(Offset(x + 20 * scale, y - 10 * scale), 25 * scale, paint);
    canvas.drawCircle(Offset(x + 40 * scale, y), 35 * scale, paint);
  }

  void _paintSun(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.yellow.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final center = Offset(size.width * 0.8, size.height * 0.2);
    final radius = size.width * 0.1;

    // Sun core
    canvas.drawCircle(center, radius, paint);

    // Sun rays
    paint.strokeWidth = 2;
    paint.style = PaintingStyle.stroke;

    for (int i = 0; i < 8; i++) {
      final angle = (i * math.pi / 4) + (animation * math.pi);
      final startRadius = radius * 1.2;
      final endRadius = radius * 1.5;

      canvas.drawLine(
        Offset(
          center.dx + math.cos(angle) * startRadius,
          center.dy + math.sin(angle) * startRadius,
        ),
        Offset(
          center.dx + math.cos(angle) * endRadius,
          center.dy + math.sin(angle) * endRadius,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant WeatherPainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}
