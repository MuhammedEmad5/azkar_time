import 'package:alarm_azkar/presentation_layer/screens/timer_screen/timer_cubit/cubit.dart';
import 'package:alarm_azkar/presentation_layer/screens/timer_screen/timer_cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../widgets/timer_view.dart';

class TimerScreen extends StatelessWidget {
  const TimerScreen({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => TimerCubit(),
      child: BlocBuilder<TimerCubit, TimerStates>(
        builder: (BuildContext context, state) {
          TimerCubit cubit = TimerCubit.get(context);
          return Expanded(
            child: Scaffold(
              appBar: appBar(context),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: [
                        Expanded(
                            child: Column(
                              children: [
                                TimerView(
                                  timeType: 'Hours',
                                  onValueChanged: (value ) {
                                    cubit.putHourValue(value);
                                  },
                                ),
                              ],
                            )
                        ),
                        Expanded(
                            child: Column(
                              children: [
                                TimerView(
                                  timeType: 'Minutes',
                                  onValueChanged: (value ) {
                                    cubit.putMinuteValue(value);
                                  },
                                ),
                              ],
                            )
                        ),
                        Expanded(
                            child: Column(
                              children: [
                                TimerView(
                                  timeType: 'Seconds',
                                  onValueChanged: (value ) {
                                    cubit.putSecondValue(value);
                                  },
                                ),
                              ],
                            )
                        ),
                      ],
                    ),
                    SizedBox(height: 30.h),
                    timerTextWidget(context, cubit),
                    SizedBox(height: 30.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        startPauseButton(cubit),
                        SizedBox(width: 20.w),
                        resetButton(cubit),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  AppBar appBar (context){
    return AppBar(
      title: Text(
        'Timer',
        style: Theme.of(context).textTheme.displayMedium,
      )
    );
  }

  Widget timerTextWidget(context, cubit) {
    return Text(
      cubit.formatTimerDuration(cubit.durationRemain),
      style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontSize: 42),
    );
  }

  Widget startPauseButton(cubit) {
    return ElevatedButton(
      onPressed: () {
        if (!cubit.isRunning) {
          cubit.startTimer();
        } else {
          cubit.pauseTimer();
        }
      },
      child: Text(cubit.isRunning ? 'Pause' : 'Start'),
    );
  }

  Widget resetButton(cubit) {
    return ElevatedButton(
      onPressed: () {
        cubit.resetTimer();
      },
      child: Text('Reset'),
    );
  }

}




