import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

const primaryColor = Color(0xffDE90A1);

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _circularanimation;
  ValueNotifier<bool> isCircular = ValueNotifier<bool>(false);
  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..forward();
    _circularanimation =
        CurveTween(curve: Curves.easeIn).animate(_animationController);
    _animationController.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 800), () {
          isCircular.value = Random().nextBool();
          _animationController.forward(from: 0.0);
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: primaryColor,
        body: Center(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, snapshot) {
              return ValueListenableBuilder<bool>(
                valueListenable: isCircular,
                builder: (context, val, snap) {
                  return Row(
                    children: [
                      CustomPaint(
                        foregroundPainter: Eye(
                            value: _circularanimation.value, isCircular: val),
                        size: const Size(200, 200),
                      ),
                      CustomPaint(
                        foregroundPainter: Eye(
                            value: _circularanimation.value, isCircular: val),
                        size: const Size(200, 200),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class Eye extends CustomPainter {
  final double value;
  final bool isCircular;
  Eye({required this.value, this.isCircular = true});
  @override
  void paint(Canvas canvas, Size size) {
    final _center = Offset(size.width / 2, size.height / 2);
    final _circlePainter = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawOval(Rect.fromCenter(center: _center, width: 160, height: 180),
        _circlePainter);

    final angle = ((1.0 - value) * 2 * pi);

    final xPoint = _center.dx + cos(angle) * 50;
    final yPoint = isCircular ? _center.dy + sin(angle) * 60 : size.width / 2;

    canvas.drawCircle(
        Offset(xPoint, yPoint), 18, _circlePainter..color = Colors.black);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
