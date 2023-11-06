import 'dart:math';
import 'package:alarm_azkar/presentation_layer/screens/stopWatch_screen/stopWatch_cubit/cubit.dart';
import 'package:alarm_azkar/presentation_layer/screens/stopWatch_screen/stopWatch_cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../widgets/stopwatch_view.dart';

class StopWatchScreen extends StatelessWidget {
  const StopWatchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>StopWatchCubit(),
      child: BlocBuilder<StopWatchCubit,StopWatchStates>(
        builder: (BuildContext context, state) {
          StopWatchCubit cubit =StopWatchCubit.get(context);
          return Expanded(
            child: Scaffold(
              appBar: AppBar(
                title: appBarTitle(context),
              ),
              body: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Transform.rotate(
                          angle: -pi/2,
                          child: stopWatchTimerWidget(context, cubit)
                      ),
                      SizedBox(height: 30.h),
                      stopWatchTimerTextWidget(context, cubit),
                      SizedBox(height: 30.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          startStopButton(cubit),
                          SizedBox(width: 20.w),
                          resetButton(cubit),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget appBarTitle(context){
    return Text(
      'StopWatch',
      style: Theme.of(context).textTheme.displayMedium,
    );
  }

  Widget stopWatchTimerTextWidget(context,cubit){
    return Text(
      cubit.formatStopwatchTime(),
      style: Theme.of(context).textTheme.displayMedium!.copyWith(
          fontSize: 42
      ),
    );
  }

  Widget startStopButton(cubit){
    return ElevatedButton(
      onPressed: () {
        if (!cubit.isRunning) {
          cubit.startStopwatch();
        } else {
          cubit.stopStopwatch();
        }
      },
      child: Text(cubit.isRunning ? 'Stop' : 'Start'),
    );
  }

  Widget resetButton(cubit){
    return ElevatedButton(
      onPressed: () {
        cubit.resetStopwatch();
      },
      child: Text('Reset'),
    );
  }

  Widget stopWatchTimerWidget(context, cubit) {
    return CustomPaint(
      size: Size(200, 200), // Adjust the size as needed
      painter: StopwatchPainter(cubit.stopwatch.elapsed.inSeconds.toDouble()),
    );
  }

}


