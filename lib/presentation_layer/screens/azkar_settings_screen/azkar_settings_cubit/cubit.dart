import 'dart:async';
import 'dart:math';
import 'package:alarm_azkar/presentation_layer/screens/azkar_settings_screen/azkar_settings_cubit/states.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../../../../application_layer/App_colors.dart';
import '../../../../application_layer/app_strings.dart';
import '../../../../application_layer/shared_preferences/shared_preferences.dart';
import '../../../../main.dart';

class AzkarSettingsCubit extends Cubit<AzkarSettingsStates> {
  AzkarSettingsCubit() : super(AzkarSettingsInitialState());

  static AzkarSettingsCubit get(context) => BlocProvider.of(context);

  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  final Random random = Random();
  bool azkarAlarmSettingsDone = true;
  bool startTimeBeforeEndTime = true;
  Timer? notificationTimer;



  Future showDefaultDialog(context,String title,String content){
    emit(ShowDefaultDialogState());
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.deepBlue,
          title: Text(title,style: Theme.of(context).textTheme.displayMedium),
          content: Text(content,style: Theme.of(context).textTheme.titleLarge),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel',style: Theme.of(context).textTheme.titleLarge),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('OK',style: Theme.of(context).textTheme.titleLarge),
              onPressed: () {
                // Perform an action here
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void checkIfStartTimeBeforeEndTime(value,endTimeController,context){
    startTimeBeforeEndTime=true;
    final enteredStartTime =
    TimeOfDay.fromDateTime(
      DateTime.parse(
          '2023-10-04 $value'), // Assuming the date is today
    );
    if (endTimeController.text.isNotEmpty) {
      final enteredEndTime =
      TimeOfDay.fromDateTime(
        DateTime.parse(
            '2023-10-04 ${endTimeController.text}'), // Assuming the date is today
      );
      if (enteredStartTime.hour >
          enteredEndTime.hour ||
          (enteredStartTime.hour ==
              enteredEndTime.hour &&
              enteredStartTime.minute >
                  enteredEndTime.minute)) {
        startTimeBeforeEndTime=false;
        showDefaultDialog(context, 'warning', 'تأكد ان يكون وقت البدايه قبل وقت النهاية');
      }
    }
    emit(CheckIfStartTimeBeforeEndTimeState());
  }

  tz.TZDateTime convertTimeToTZDateTime(now,timeText){
   return tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      timeInHour(timeText),
      timeInMinute(timeText),
    );
  }

  Future<void> saveStartAndEndTime(startTime,endTime)async {
    CashHelper.putStringData(key: 'startTime', value: startTime);
    CashHelper.putStringData(key: 'endTime', value: endTime);
    startTimeController.text = startTime;
    endTimeController.text = endTime;
    print(startTimeController.text);
    print(endTimeController.text);

  }

  Future<void> getStartAndEndTime()async {
   startTimeController.text= await CashHelper.getStringData(key: 'startTime')??'9:00';
   endTimeController.text= await CashHelper.getStringData(key: 'endTime')??'21:00';
   emit(GetStartAndEndTimeState());
  }

  Future<void> checkIfTimeNowBeforeStartTime(now,startTime)async {
    if (now.isBefore(startTime)) {
      azkarAlarmSettingsDone = true;
      // If the current time is before the start time, wait for the specified delay.
      final delay = startTime.difference(now);
      await Future.delayed(delay);
      emit(CheckIfTimeNowBeforeStartTimeState());
    }
  }

  Future<void> checkIfTimeNowAfterEndTime(now,endTime,startTime)async {
    if (now.isAfter(endTime)) {
      azkarAlarmSettingsDone = true;
      // If the current time is before the start time, wait for the specified delay.
      final delay = startTime.difference(now)+Duration(days: 1);
      print(delay);
      await Future.delayed(delay);
      emit(CheckIfTimeNowAfterEndTimeState());
    }
  }

  Timer getPeriodicNotificationBeforeEndTime(now,endTime){
    return Timer.periodic(
      Duration(seconds: 20), // Adjust this interval as needed
          (timer) {
        if (now.isBefore(endTime)) {
          showNotification();
          now = tz.TZDateTime.now(tz.local).add(const Duration(hours: 2));
        }
        else {
          timer.cancel();
          flutterLocalNotificationsPlugin.cancel(0);
          emit(EndAzkarPeriodSuccessState());
        }
      },
    );
  }

  @pragma('vm:entry-point')
  Future<void> scheduleAzkarAlarm() async {
    tz.initializeTimeZones();
    await CashHelper.init();
    await getStartAndEndTime();
    if(startTimeBeforeEndTime){
     try {
       var now = tz.TZDateTime.now(tz.local).add(const Duration(hours: 2));
       final startTime = convertTimeToTZDateTime(now, startTimeController.text);
       final endTime = convertTimeToTZDateTime(now, endTimeController.text);

       if (now.isAfter(startTime) && now.isBefore(endTime)) {
         showNotification();
         azkarAlarmSettingsDone = true;
         emit(StartAzkarPeriodSuccessState());

       } else {
         emit(EndAzkarPeriodSuccessState());
       }
     } catch (error) {
       print('Error scheduling Azkar alarm: $error');
     }
   }
  }


  Future<void> updateScheduleAzkarAlarm() async {
    try {
      flutterLocalNotificationsPlugin.cancel(0);
      azkarAlarmSettingsDone = false;
      emit(UpdateStartAzkarPeriodSuccessState());
    } catch (error) {
      print('Error updating Azkar alarm: $error');
      emit(UpdateStartAzkarPeriodErrorState());
    }
  }

  int timeInHour(String timeText) {
    int timeInHour = 0;

    final timeParts = timeText.split(':');
    if (timeParts.length == 2) {
      timeInHour = int.parse(timeParts[0]);
    }
    return timeInHour;
  }

  int timeInMinute(String timeText) {
    int timeInMinute = 0;

    final timeParts = timeText.split(':');
    if (timeParts.length == 2) {
      timeInMinute = int.parse(timeParts[1]);
    }
    return timeInMinute;
  }

  Future<void> showNotification() async {
    try {
      await flutterLocalNotificationsPlugin.show(
        0,
        'Azkar Alarm',
        AppStrings.azkarList[random.nextInt(AppStrings.azkarList.length)],
        notificationDetails(),
        payload: 'AzkarAlarm',
      );

      azkarAlarmSettingsDone = true;
      emit(StartAzkarPeriodSuccessState());
    } catch (error) {
      print('Error showing notification: $error');
      emit(StartAzkarPeriodErrorState());
    }
  }

  NotificationDetails notificationDetails(){
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'Azkar_notification',
        'Azkar_notification',
        channelDescription: 'Channel for Azkar notification',
        icon: 'app_icon',
        sound: RawResourceAndroidNotificationSound('alarmringtone'),
        largeIcon: DrawableResourceAndroidBitmap('app_icon'),
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }

}
