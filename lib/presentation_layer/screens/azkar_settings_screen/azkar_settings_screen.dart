import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../application_layer/App_colors.dart';
import '../../widgets/default_form_key.dart';
import 'azkar_settings_cubit/cubit.dart';
import 'azkar_settings_cubit/states.dart';

class AzkarSettingsScreen extends StatelessWidget {
  AzkarSettingsScreen({Key? key}) : super(key: key);

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AzkarSettingsCubit, AzkarSettingsStates>(
      builder: (BuildContext context, state) {
        AzkarSettingsCubit cubit = AzkarSettingsCubit.get(context);
        return Expanded(
          child: Scaffold(
            appBar: appBar(context),
            body: Padding(
              padding: EdgeInsets.symmetric(vertical: 15.0.h, horizontal: 5.w),
              child: Form(
                key: formKey,
                child: cubit.azkarAlarmSettingsDone
                    ? Card(
                        color: AppColors.deepBlue,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0.h, horizontal: 10.w),
                          child: allWidgets(cubit, context),
                        ),
                      )
                    : allWidgets(cubit, context),
              ),
            ),
          ),
        );
      },
    );
  }

  AppBar appBar(context){
    return AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: Text(
              'تنبيهات الأذكار',
              style: Theme.of(context).textTheme.displayMedium,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
            ),
          ),
        ]
    );
  }


  Widget beforeTextIcon(){
    return Transform(
      transform: Matrix4.rotationY(pi),
      alignment: Alignment.center,
      child: Icon(
        Icons.label_important_outline,
        color: AppColors.white,
        size: 30.w,
      ),
    );
  }

  Widget textWidget(context){
    return Expanded(
      child: Text(
        'اختر الفترة التى تريد أن يتم فيها تنبيهك بالاذكار .',
        style: Theme.of(context).textTheme.headlineMedium,
        textDirection: TextDirection.rtl,
        // Set text direction to right-to-left
        textAlign:
        TextAlign.right, // Set text alignment to right
      ),
    );
  }

  Widget startTextWidget(context){
    return Text(
      'البداية  ⦿ ',
      style:
      Theme.of(context).textTheme.headlineMedium,
    );
  }

  Widget startFormFieldWidget(context,AzkarSettingsCubit cubit){
    return DefaultFormKey(
      controller: cubit.startTimeController,
      keyboardType: TextInputType.datetime,
      readOnly: true,
      onTap: () {
        !cubit.azkarAlarmSettingsDone
            ? showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              ).then((value) {
                cubit.startTimeController.text = value!.format(context).toString();
              })
            : null;
      },
      validator: (value) {
        if (value.isEmpty) {
          cubit.showDefaultDialog(context, 'warning', 'يرجى ادخال وقت البداية');
        }
        cubit.checkIfStartTimeBeforeEndTime(value, cubit.endTimeController, context);
        return null;
      },
      labelText: 'البدايه',
      prefixIcon: Icons.watch_later_outlined,
    );
  }

  Widget endTextWidget(context){
    return Text(
      ' النهاية  ⦿',
      style:
      Theme.of(context).textTheme.headlineMedium,
    );
  }

  Widget endFormFieldWidget(context,AzkarSettingsCubit cubit){
    return DefaultFormKey(
      controller: cubit.endTimeController,
      keyboardType: TextInputType.datetime,
      readOnly: true,
      onTap: () {
        !cubit.azkarAlarmSettingsDone
            ? showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              ).then((value) {
                cubit.endTimeController.text = value!.format(context).toString();
              })
            : null;
      },
      validator: (value) {
        if (value.isEmpty) {
          return 'يرجى ادخال وقت النهاية';
        }
        return null;
      },
      labelText: 'النهاية',
      prefixIcon: Icons.watch_later_outlined,
    );
  }

  Widget saveButton(AzkarSettingsCubit cubit,context){
    return
      cubit.azkarAlarmSettingsDone
        ? FloatingActionButton(
            child: Text(
              'تعديل',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            onPressed: () {
              cubit.updateScheduleAzkarAlarm();
            },
            backgroundColor: AppColors.deepBlue,
          )
        : FloatingActionButton(
            child: Text(
              'حفظ',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                cubit.saveStartAndEndTime(cubit.startTimeController.text, cubit.endTimeController.text).then((value) {
                  cubit.scheduleAzkarAlarm();
                });
              }
            },
            backgroundColor: AppColors.deepBlue,
          );
  }


  Widget allWidgets(cubit,context){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          textDirection: TextDirection.rtl,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            beforeTextIcon(),
            SizedBox(width: 5.w),
            textWidget(context),
          ],
        ),
        SizedBox(height: 30.h),
        Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  startTextWidget(context),
                  SizedBox(height: 8.h),
                  startFormFieldWidget(context,cubit),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  endTextWidget(context),
                  SizedBox(height: 8.h),
                  endFormFieldWidget(context,cubit),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 30.h),
        saveButton(cubit,context),
      ],
    );
  }
}
