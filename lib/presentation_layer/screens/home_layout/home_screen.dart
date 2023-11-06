import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../application_layer/App_colors.dart';
import 'home_screen_cubit/cubit.dart';
import 'home_screen_cubit/states.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return BlocBuilder<HomeScreenCubit,HomeScreenStates>(
      builder: (BuildContext context, state) {
        HomeScreenCubit cubit =HomeScreenCubit.get(context);
        return Scaffold(
          backgroundColor: AppColors.backGround,
          body: SafeArea(
            child: Row(
              children: [
                SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      cubit.buildIconButton('clock', 'assets/images/clock_icon.png', context,index: 0),
                      SizedBox(height: 20.h,),
                      cubit.buildIconButton('Alarm', 'assets/images/alarm_icon.png', context,index: 1),
                      SizedBox(height: 20.h,),
                      cubit.buildIconButton('Stopwatch', 'assets/images/stopwatch_icon.png', context,index: 2),
                      SizedBox(height: 20.h,),
                      cubit.buildIconButton('Timer', 'assets/images/timer_icon.png', context,index: 3),
                      SizedBox(height: 20.h,),
                      cubit.buildIconButton('تنبيهات الأذكار', 'assets/images/alarm_notifier.png', context,index: 4,scale: 10),
                    ],
                  ),
                ),
                VerticalDivider(width: 3.w,color: AppColors.lightGray.withOpacity(0.3),),
                cubit.screens[cubit.index]
              ],
            ),
          ),
        );
      },
    );
  }
}


