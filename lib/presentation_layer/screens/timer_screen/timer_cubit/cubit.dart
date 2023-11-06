import 'dart:async';
import 'package:alarm_azkar/presentation_layer/screens/timer_screen/timer_cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../../../main.dart';


class TimerCubit extends Cubit<TimerStates> {
  TimerCubit() : super(TimerInitialState());

  static TimerCubit get(context) => BlocProvider.of(context);

  double selectedHours = 0;
  double selectedMinutes = 0;
  double selectedSeconds = 0;

  Duration duration =Duration();
  Duration durationRemain = Duration();
  bool isRunning = false;
  late DateTime startTime;
  Timer? timer;
  int timerDurationInMinutes = 5;


   void putHourValue(value){
     selectedHours=value;
     print(selectedHours);
     emit(PutSelectedHourState());
   }

  void putMinuteValue(value){
    selectedMinutes=value;
    print(selectedMinutes);
    emit(PutSelectedMinuteState());
  }

  void putSecondValue(value){
    selectedSeconds=value;
    emit(PutSelectedSecondState());
  }

  String formatTimerDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  void startTimer() {

    if(isRunning){
      isRunning = true;
      duration=durationRemain;
    }
    else {
      isRunning = true;

      final totalSeconds = (selectedHours.toInt() * 3600 + selectedMinutes.toInt() * 60 + selectedSeconds.toInt()+2);
      duration = Duration(seconds: totalSeconds);
      durationRemain = duration;
    }

    startTime = DateTime.now();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      final elapsedTime = DateTime.now().difference(startTime);
      final remainingTime = duration - elapsedTime;
      if (remainingTime.isNegative) {
        stopTimer();
        return;
      }
      durationRemain = remainingTime;
      emit(TimerStartTimeState());
    });
  }

  void stopTimer() {
    isRunning = false;
    endStopWatchNotification();
    timer!.cancel();
    emit(TimerStopTimeState());
  }

  void resetTimer() {
    isRunning = false;
    durationRemain = Duration(minutes: 0);
    timer!.cancel();
    emit(TimerResetTimeState());
  }

  void pauseTimer() {
    isRunning = false;
    duration=durationRemain;
    timer!.cancel();
    emit(TimerPauseTimeState());
  }

  Future<void> endStopWatchNotification() async {

    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'timer_notif',
        'timer_notif',
        channelDescription: 'Channel for Timer notification',
        icon: 'app_icon',
        sound: RawResourceAndroidNotificationSound('alarmringtone'),
        largeIcon: DrawableResourceAndroidBitmap('app_icon'),
        priority: Priority.high
    );
    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails(
      sound: 'a_long_cold_sting.wav',
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      2,
      'Timer',
      '${formatTimerDuration(duration)} minutes ran out',
      platformChannelSpecifics,
      payload: 'timer',
    );
  }

  @override
  Future<void> close() {
    timer!.cancel();
    return super.close();
  }

}