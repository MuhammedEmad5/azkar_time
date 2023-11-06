import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../application_layer/App_colors.dart';
import '../../widgets/clock_view.dart';
import '../../widgets/digtal_clock.dart';

class ClockScreen extends StatelessWidget {
   ClockScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

    var formattedDate = DateFormat('EEE, d MMM').format(now);
    var timezoneString = now.timeZoneOffset.toString().split('.').first;
    var offsetSign = '';
    if (!timezoneString.startsWith('-')) offsetSign = '+';
    return Expanded(
      child: Scaffold(
        appBar: AppBar(
          title: appBarTitle(context),
        ),
        body: Container(
          alignment: Alignment.center,
          color: AppColors.backGround,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 30.0.h,horizontal: 10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                digitalClockAndDate(formattedDate, context),
                clockView(context),
                timeZoneWidget(context, offsetSign, timezoneString),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget appBarTitle(context){
    return Text(
      'Clock',
      style: Theme.of(context).textTheme.displayMedium,
    );
  }

  Widget digitalClockAndDate(formattedDate,context){
    return Flexible(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const DigitalClockWidget(),
          Text(
            formattedDate,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }

  Widget clockView(context){
    return Flexible(
      flex: 4,
      fit: FlexFit.tight,
      child: Align(
        alignment: Alignment.center,
        child: ClockView(
          size: MediaQuery.of(context).size.height / 4,
        ),
      ),
    );
  }

  Widget timeZoneWidget(context,offsetSign,timezoneString){
    return Flexible(
      flex: 2,
      fit: FlexFit.tight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
              'Timezone',
              style: Theme.of(context).textTheme.headlineSmall
          ),
          SizedBox(height: 16.h),
          Row(
            children: <Widget>[
              Icon(
                Icons.language,
                color: AppColors.lightGray,
              ),
              SizedBox(width: 16.h),
              Text(
                'UTC$offsetSign$timezoneString',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
