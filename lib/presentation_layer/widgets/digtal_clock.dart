import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DigitalClockWidget extends StatefulWidget {
  const DigitalClockWidget({
    Key? key,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return DigitalClockWidgetState();
  }
}

class DigitalClockWidgetState extends State<DigitalClockWidget> {
  var formattedTime = DateFormat('HH:mm').format(DateTime.now());
  late Timer timer;

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      var previousMinute = DateTime.now().add(const Duration(seconds: -1)).minute;
      var currentMinute = DateTime.now().minute;
      if (previousMinute != currentMinute) {
        setState(() {
          formattedTime = DateFormat('HH:mm').format(DateTime.now());
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      formattedTime,
      style: Theme.of(context).textTheme.displayLarge!.copyWith(
        fontSize: 46,
        fontWeight: FontWeight.w400
      ),
    );
  }
}