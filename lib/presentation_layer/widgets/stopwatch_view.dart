import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../application_layer/App_colors.dart';

class StopwatchPainter extends CustomPainter {
  final double seconds;
  StopwatchPainter(this.seconds);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final paint = Paint()
      ..color = AppColors.lightGray
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0;

    // Draw the stopwatch circle
    canvas.drawCircle(center, radius, paint);


    Paint fillBrush = Paint()..color = AppColors.deepBlue;
    canvas.drawCircle(center, radius, fillBrush);


    Paint secHandBrush = Paint()
      ..shader = RadialGradient(colors: [AppColors.lightOrange, AppColors.pink])
          .createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeWidth = size.width/60
      ..strokeCap = StrokeCap.round;

    // Draw the stopwatch hand (seconds)
    final radians = -seconds * (-360 / 60) * (3.14159265359 / 180);
    final handX = center.dx + radius * 0.7 * cos(radians);
    final handY = center.dy + radius * 0.7 * sin(radians);
    canvas.drawLine(center, Offset(handX, handY), secHandBrush);

    Paint centerBrush = Paint()..color = AppColors.lightGray;
    canvas.drawCircle(center, radius*0.06.r, centerBrush);


    var dashBrush = Paint()
      ..color = AppColors.lightGray
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1;
    var outerCircleRadius = radius;
    var innerCircleRadius = radius *0.9;
    for (double i = 0; i < 360; i += 12) {
      var x1 = size.width / 2 + outerCircleRadius * cos(i * pi / 180);
      var y1 = size.height / 2 + outerCircleRadius * sin(i * pi / 180);

      var x2 = size.width/ 2 + innerCircleRadius * cos(i * pi / 180);
      var y2 = size.height / 2 + innerCircleRadius * sin(i * pi / 180);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashBrush);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
