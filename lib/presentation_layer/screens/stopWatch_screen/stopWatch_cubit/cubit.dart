import 'package:alarm_azkar/presentation_layer/screens/stopWatch_screen/stopWatch_cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class StopWatchCubit extends Cubit<StopWatchStates> {
  StopWatchCubit() : super(StopWatchInitialState());

  static StopWatchCubit get(context) => BlocProvider.of(context);

  Stopwatch stopwatch = Stopwatch();
  bool isRunning = false;


  String formatStopwatchTime() {
    final milliseconds = stopwatch.elapsedMilliseconds;
    final seconds = (milliseconds / 1000).floor();
    final minutes = (seconds / 60).floor();

    String formattedTime = '';

    if (minutes > 0) {
      formattedTime += '$minutes:';
    }

    formattedTime += '${seconds % 60}.${(milliseconds % 1000) ~/ 100}';

    emit(StopWatchFormatTimeState());
    return formattedTime;
  }

  void startStopwatch() {
      isRunning = true;
    stopwatch.start();
    emit(StopWatchStartTimeState());
  }

  void stopStopwatch() {
    isRunning = false;
    stopwatch.stop();
    emit(StopWatchStopTimeState());
  }

  void resetStopwatch() {
    stopwatch.stop();
    stopwatch.reset();
    isRunning=false;

    emit(StopWatchResetTimeState());
  }


}