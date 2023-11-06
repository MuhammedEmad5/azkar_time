import 'package:alarm_azkar/presentation_layer/screens/home_layout/home_screen_cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../alarm_screen/alarm_screen.dart';
import '../../azkar_settings_screen/azkar_settings_screen.dart';
import '../../clock_screen/clock_screen.dart';
import '../../stopWatch_screen/stopWatch_screen.dart';
import '../../timer_screen/timer_screen.dart';

class HomeScreenCubit extends Cubit<HomeScreenStates> {
  HomeScreenCubit() : super(HomeScreenInitialState());

  static HomeScreenCubit get(context) => BlocProvider.of(context);

  int index=0;
  Widget buildIconButton(String title,String icon,context, {int index = 0,double scale=1.5}){
    return TextButton(
      child: Column(
        children: [
          Image.asset(icon,scale: scale.r,),
          SizedBox(height: 10.h,),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
      onPressed: (){
        this.index=index;
        emit(HomeScreenChangeIndexState());
      },
    );
  }

  List<Widget>screens=[
    ClockScreen(),
    AlarmScreen(),
    StopWatchScreen(),
    TimerScreen(),
    AzkarSettingsScreen(),
  ];
}