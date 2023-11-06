import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../application_layer/App_colors.dart';

class TimerView extends StatefulWidget {
  const TimerView(
      {Key? key, required this.timeType, required this.onValueChanged})
      : super(key: key);
  final String timeType;
  final Function(double) onValueChanged;

  @override
  _TimerViewState createState() => _TimerViewState();
}

class _TimerViewState extends State<TimerView> {
  double selectedValue = 0;
  List<int> numbers = [];
  late int maxNumber;

  @override
  void initState() {
    super.initState();

    if (widget.timeType == 'Hours') {
      maxNumber = 23;
    } else {
      maxNumber = 59;
    }

    numbers = List.generate(maxNumber + 1, (index) => index);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            widget.timeType,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          GestureDetector(
            onVerticalDragUpdate: (details) {
              final delta = details.primaryDelta;
              if (delta != null) {
                setState(() {
                  // Calculate the selected number based on the drag position
                  selectedValue -= delta / 10.0;
                  selectedValue = selectedValue.clamp(
                      0, 23.0); // Ensure the value stays within the range
                });
              }
            },
            child: Container(
              height: 120.h,
              margin: EdgeInsets.all(10.h),
              decoration: BoxDecoration(
                  color: AppColors.deepBlue,
                  borderRadius: BorderRadius.circular(45.r)),
              child: ListWheelScrollView(
                diameterRatio: 1.0,
                // Adjust this value to control the circle size
                perspective: 0.002,
                itemExtent: 50.h,
                children: numbers.map((number) {
                  return Center(
                    child: Text(number.toString(),
                        style: number == selectedValue.toInt()
                            ? Theme.of(context).textTheme.displayLarge!
                            : Theme.of(context).textTheme.headlineMedium),
                  );
                }).toList(),
                onSelectedItemChanged: (index) {
                  setState(() {
                    selectedValue = numbers[index].toDouble();
                    widget.onValueChanged(
                        selectedValue); // Call the callback with the selected value
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
