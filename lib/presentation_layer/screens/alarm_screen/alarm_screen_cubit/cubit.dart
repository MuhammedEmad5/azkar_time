import 'dart:math';
import 'package:alarm_azkar/presentation_layer/screens/alarm_screen/alarm_screen_cubit/states.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sqflite/sqflite.dart';
import 'package:timezone/timezone.dart' as tz;
import '../../../../main.dart';



class AlarmCubit extends Cubit<AlarmStates> {
  AlarmCubit() : super(AlarmInitialState());

  static AlarmCubit get(context) => BlocProvider.of(context);

  Database? database;

  List<Map> alarms=[];

  void createDatabase() {
    openDatabase(
      'alarmDataBase.db',
      version: 1,
      onCreate: (database, version) {
        if (kDebugMode) {
          print('database created');
        }
        database
            .execute('CREATE TABLE alarm ('
                'id INTEGER PRIMARY KEY,'
                ' alarmTitle TEXT,'
                ' alarmDescription TEXT,'
                ' alarmDate TEXT,'
                ' alarmTime TEXT,'
                ' alarmId INTEGER,'
                'isActive BOOLEAN)')
            .then((value) {
          if (kDebugMode) {
            print('table created');
          }
          emit(CreateDataBaseSuccessState());
        }).catchError((error) {
          if (kDebugMode) {
            print('Error When Creating Table ${error.toString()}');
          }
        });
      },
      onOpen: (database) {
        getDataFromDatabase(database);
        if (kDebugMode) {
          print('database opened');
        }
      },
    ).then((value) {
      database = value;
      emit(OpenDataBaseSuccessState());
    });
  }

  Random random = Random();

 Future insertToDatabase({
    required String alarmTitle,
    required String alarmTime,
    required String alarmDate,
    String? alarmDescription,
  }) async {
   int randomAlarmId=random.nextInt(2000);
    await database!.transaction((txn) async {
      txn
          .rawInsert(
        'INSERT INTO alarm'
            '(alarmTitle, alarmDate, alarmTime, alarmDescription, isActive, alarmId)'
            'VALUES("$alarmTitle", "$alarmDate", "$alarmTime", "$alarmDescription", ${1}, "$randomAlarmId")',
      ).then((value) {
        scheduleAlarm(alarmTitle,
            alarmDescription!,
            convertStringToTZDateTime('$alarmDate $alarmTime', tz.local.name).subtract(const Duration(hours: 2)),randomAlarmId);
        getDataFromDatabase(database);
      }).catchError((error) {
        if (kDebugMode) {
          print('Error When Inserting New Record ${error.toString()}');
        }
        emit(InsertToDataBaseErrorState());
      });
    });
  }

  void getDataFromDatabase(database){
    alarms=[];
    emit(GetDataBaseLoadingState());
     database.rawQuery('SELECT * FROM alarm ORDER BY alarmDate ASC, alarmTime ASC').then((value) {
       value.forEach((element) {
         alarms.add(element);
       });
       emit(GetDataBaseSuccessState());
     }).catchError((error) {
       if (kDebugMode) {
         print('Error When get database ${error.toString()}');
       }
       emit(GetDataBaseErrorState());
     });
  }

  void deleteData({
    required int alarmId,
  }) async {
    database!.rawDelete('DELETE FROM alarm WHERE alarmId = ?', [alarmId]).then((value) {
      emit(DeleteFromDataBaseSuccessState());
      getDataFromDatabase(database);
      flutterLocalNotificationsPlugin.cancel(alarmId);
    });
  }



  Future<void> scheduleAlarm(String title,String description,tz.TZDateTime tZDateTime,int alarmId) async {

    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'alarm_notif',
        'alarm_notif',
        channelDescription: 'Channel for Alarm notification',
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

    await flutterLocalNotificationsPlugin.zonedSchedule(
      alarmId,
      title,
      description,
      tZDateTime,
      platformChannelSpecifics,
      payload: 'k',
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }


  tz.TZDateTime convertStringToTZDateTime(String dateTimeString, String timeZoneName) {
    // Parse the string into individual components (year, month, day, hour, minute)
    final dateTimeComponents = dateTimeString.split(' ');
    final dateComponents = dateTimeComponents[0].split('-');
    final timeComponents = dateTimeComponents[1].split(':');

    final year = int.parse(dateComponents[0]);
    final month = int.parse(dateComponents[1]);
    final day = int.parse(dateComponents[2]);
    final hour = int.parse(timeComponents[0]);
    final minute = int.parse(timeComponents[1]);

    // Create a TZDateTime object using the parsed components and the specified time zone
    final location = tz.getLocation(timeZoneName);
    final tzDateTime = tz.TZDateTime(
      location,
      year,
      month,
      day,
      hour,
      minute,
    );

    return tzDateTime;
  }


// void updateData({
//   required String isActive,
//   required int id,
// }) async {
//   database!.rawUpdate(
//     'UPDATE alarm SET isActive = ? WHERE id = ?',
//     [isActive, id],
//   ).then((value) {
//     getDataFromDatabase(database);
//     emit(UpdateDataSuccessBaseState());
//   });
// }
//
}
