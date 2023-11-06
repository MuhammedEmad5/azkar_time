import 'dart:ui';

class AppColors{
 static Color white= const Color(0xFFFFFFFF);
 static Color backGround=const Color(0xFF2D2F41);
 static Color lightOrange=const Color(0xFFFFC677);
 static Color skyBlue=const Color(0xFF77DDFF);
 static Color lightBlue=const Color(0xFF748EF6);
 static Color deepBlue=const Color(0xFF444974 );
 static Color lightGray=const Color(0xFFEAECFF);
 static Color mediumGray=const Color(0xFF707070);
 static Color lightPurple=const Color(0xFFC279F6);
 static Color pink=const Color(0xFFEA74AB);
}

// Future<void> scheduleAzkarAlarm() async {
//     AzkarSettingsCubit();
//     tz.initializeTimeZones();
//     await CashHelper.init();
//     await getStartAndEndTime();
//     if(startTimeBeforeEndTime){
//      try {
//        var now = tz.TZDateTime.now(tz.local).add(const Duration(hours: 2));
//        final startTime = convertTimeToTZDateTime(now, startTimeController.text);
//        final endTime = convertTimeToTZDateTime(now, endTimeController.text);
//
//        await checkIfTimeNowBeforeStartTime(now, startTime);
//        //await checkIfTimeNowAfterEndTime(now, endTime, startTime);
//
//        now = tz.TZDateTime.now(tz.local).add(const Duration(hours: 2)); // Update the current time after the delay.
//
//        if (now.isAfter(startTime) && now.isBefore(endTime)) {
//          showNotification();
//
//          //notificationTimer = getPeriodicNotificationBeforeEndTime(now, endTime);
//
//          azkarAlarmSettingsDone = true;
//          emit(StartAzkarPeriodSuccessState());
//
//        } else {
//          //notificationTimer?.cancel();
//          emit(EndAzkarPeriodSuccessState());
//        }
//      } catch (error) {
//        print('Error scheduling Azkar alarm: $error');
//      }
//    }
//   }


//Future<void> updateScheduleAzkarAlarm() async {
//     try {
//       // if (notificationTimer != null) {
//       //   notificationTimer!.cancel();
//       // }
//       flutterLocalNotificationsPlugin.cancel(0);
//       azkarAlarmSettingsDone = false;
//       emit(UpdateStartAzkarPeriodSuccessState());
//     } catch (error) {
//       print('Error updating Azkar alarm: $error');
//       emit(UpdateStartAzkarPeriodErrorState());
//     }
//   }