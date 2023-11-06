import 'package:alarm_azkar/presentation_layer/screens/alarm_screen/alarm_screen_cubit/cubit.dart';
import 'package:alarm_azkar/presentation_layer/screens/azkar_settings_screen/azkar_screen.dart';
import 'package:alarm_azkar/presentation_layer/screens/azkar_settings_screen/azkar_settings_cubit/cubit.dart';
import 'package:alarm_azkar/presentation_layer/screens/home_layout/home_screen.dart';
import 'package:alarm_azkar/presentation_layer/screens/home_layout/home_screen_cubit/cubit.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'application_layer/bloc_observer.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'application_layer/shared_preferences/shared_preferences.dart';
import 'application_layer/themes.dart';



final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
  final String? payload = notificationResponse.payload;

  if (payload =='AzkarAlarm') {
    navigatorKey.currentState!.push(MaterialPageRoute(builder: (_) => AzkarScreen()));
  }
}

void onDidReceiveBackgroundNotificationResponse(NotificationResponse notificationResponse) async {
  final String? payload = notificationResponse.payload;

  if (payload =='AzkarAlarm') {
    navigatorKey.currentState!.push(MaterialPageRoute(builder: (_) => AzkarScreen()));

  }

}
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


final azkarCubit = AzkarSettingsCubit();

@pragma('vm:entry-point')
void backGroundAzkarAlarm(){
  azkarCubit.scheduleAzkarAlarm();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();

  tz.initializeTimeZones();

  await CashHelper.init();
  Bloc.observer = MyBlocObserver();

  var initializationSettingsAndroid = const AndroidInitializationSettings('app_icon');
  var initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {});
  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    onDidReceiveBackgroundNotificationResponse: onDidReceiveBackgroundNotificationResponse
  );

  runApp(const MyApp());


  await AndroidAlarmManager.periodic(
      Duration(hours: 1),
      0,
      backGroundAzkarAlarm,
      allowWhileIdle: true,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true
  );

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) =>HomeScreenCubit(),),
        BlocProvider(create: (BuildContext context) =>AlarmCubit()..createDatabase(),),
        BlocProvider(create: (BuildContext context) =>AzkarSettingsCubit()..getStartAndEndTime(),),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (BuildContext context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            navigatorKey: navigatorKey,
            theme: lightTheme(context),
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
