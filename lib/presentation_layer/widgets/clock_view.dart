import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../application_layer/App_colors.dart';

class ClockView extends StatefulWidget {

  final double? size;
  const ClockView({Key? key,this.size}) : super(key: key);

  @override
  State<ClockView> createState() => _ClockViewState();
}

class _ClockViewState extends State<ClockView> {
  Timer? _timer;
  @override
  void initState() {
    _timer=Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.size,
      width: widget.size,
      child: Transform.rotate(
        angle: -pi/2,
        child: CustomPaint(
          painter: ClockPainter(),
        ),
      ),
    );
  }
}

class ClockPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    DateTime dateTime = DateTime.now();
    //for secHand 60 sec >>> each 1 sec = 6 degree   {360/60=6}
    //for minHand 60 min >>> each 1 min = 6 degree   {360/60=6}
    //for hourHand 12 hour >>> each 1 hour =30 degree   {360/30} but in this case the hourHand will change its location
    //in every hour but i need to change it every minute so 1 hour =30 degree , 1 min = 0.5 degree

    double centerX = size.width / 2;
    double centerY = size.height / 2;
    Offset center = Offset(centerX, centerY);
    double radius = min(centerX, centerY);

    Paint fillBrush = Paint()..color = AppColors.deepBlue;

    Paint outLineBrush = Paint()
      ..color = AppColors.lightGray
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width/20;
    Paint centerBrush = Paint()..color = AppColors.lightGray;


    Paint secHandBrush = Paint()
      ..shader = RadialGradient(colors: [AppColors.lightOrange, AppColors.pink])
          .createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeWidth = size.width/60
      ..strokeCap = StrokeCap.round;
    Paint minHandBrush = Paint()
      ..shader =
          RadialGradient(colors: [AppColors.skyBlue, AppColors.lightPurple])
              .createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeWidth = size.width/40
      ..strokeCap = StrokeCap.round;
    Paint hourHandBrush = Paint()
      ..shader = RadialGradient(colors: [AppColors.lightBlue, AppColors.pink])
          .createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeWidth = size.width/30
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius *0.75.r, fillBrush);
    canvas.drawCircle(center, radius *0.75.r, outLineBrush);

    double secHandX = centerX + radius*0.6 * cos(dateTime.second * 6 * pi / 180);
    double secHandY = centerY + radius*0.6 * sin(dateTime.second * 6 * pi / 180);
    canvas.drawLine(center, Offset(secHandX, secHandY), secHandBrush);

    double minHandX = centerX + radius*0.6 * cos(dateTime.minute * 6 * pi / 180);
    double minHandY = centerY + radius*0.6 * sin(dateTime.minute * 6 * pi / 180);
    canvas.drawLine(center, Offset(minHandX, minHandY), minHandBrush);

    double hourHandX = centerX + radius*0.4 * cos((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);
    double hourHandY = centerY + radius*0.4 * sin((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);
    canvas.drawLine(center, Offset(hourHandX, hourHandY), hourHandBrush);


    canvas.drawCircle(center, radius*0.12, centerBrush);


    var dashBrush = Paint()
      ..color = AppColors.lightGray
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1;
    var outerCircleRadius = radius;
    var innerCircleRadius = radius *0.9;
    for (double i = 0; i < 360; i += 12) {
      var x1 = centerX + outerCircleRadius * cos(i * pi / 180);
      var y1 = centerY + outerCircleRadius * sin(i * pi / 180);

      var x2 = centerX + innerCircleRadius * cos(i * pi / 180);
      var y2 = centerY + innerCircleRadius * sin(i * pi / 180);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashBrush);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
