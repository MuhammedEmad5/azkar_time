import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../application_layer/App_colors.dart';
import '../../widgets/default_form_key.dart';
import 'alarm_screen_cubit/cubit.dart';
import 'alarm_screen_cubit/states.dart';

class AlarmScreen extends StatelessWidget {
  AlarmScreen({Key? key}) : super(key: key);
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AlarmCubit, AlarmStates>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, state) {
        AlarmCubit cubit = AlarmCubit.get(context);

        return Expanded(
          child: Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Row(
                children: [
                  titleAlarmAppBar(context),
                  const Spacer(),
                  addAlarmAppBarButton(context, cubit),
                ],
              ),
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  state is GetDataBaseLoadingState
                      ? const Center(child: CircularProgressIndicator())
                      : Expanded(
                          child: ListView(
                            physics: const BouncingScrollPhysics(),
                            children: cubit.alarms.map<Widget>((alarm) {
                              return Dismissible(
                                key: Key(alarm['alarmId'].toString()),
                                onDismissed: (direction){
                                  cubit.deleteData(alarmId: alarm['alarmId']);
                                },
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 10.h),
                                  padding: EdgeInsets.all(4.h),
                                  decoration: alarmInfoContainerDecoration(),
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 5.w),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            switchAlarmIconButton(),
                                            SizedBox(width: 8.w),
                                            alarmTitle(alarm, context),
                                            deleteAlarmButton(alarm, cubit),
                                          ],
                                        ),
                                        alarmDescription(alarm, context),
                                        SizedBox(height:4.h),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            alarmTime(alarm, context),
                                            alarmDate(context, alarm)
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).followedBy([
                              dottedBorder(context, cubit),
                            ]).toList(),
                          ),
                        )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget titleAlarmAppBar(context) {
    return Text(
      'Alarm',
      style: Theme.of(context).textTheme.displayMedium,
    );
  }

  Widget addAlarmAppBarButton(context, cubit) {
    return IconButton(
      onPressed: () {
        scaffoldKey.currentState!.showBottomSheet((context) {
          return bottomSheet(context, cubit);
        });
      },
      icon: Icon(
        Icons.add,
        color: AppColors.white,
        size: 30.w,
      ),
    );
  }

  Decoration alarmInfoContainerDecoration(){
    return BoxDecoration(
      image: const DecorationImage(image: AssetImage('assets/images/app_background.jpg'),fit: BoxFit.cover),
      borderRadius: BorderRadius.circular(24.r),
    );
  }

  Widget switchAlarmIconButton(){
    return const Icon(
      Icons.ac_unit_sharp,
      color: Colors.white,
    );
  }

  Widget deleteAlarmButton(alarm,cubit){
    return IconButton(
        onPressed: () {
          cubit.deleteData(
              alarmId: alarm['alarmId']);
        },
        icon: Icon(
          Icons.delete,
          size: 25.w,
          color: AppColors.white,
        ),
      padding: EdgeInsets.zero,
    );
  }

  Widget alarmTitle(alarm,context){
    return Expanded(
      child: Text(
        alarm['alarmTitle']!,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context)
            .textTheme
            .headlineMedium!.copyWith(fontWeight: FontWeight.w400),
      ),
    );
  }

  Widget alarmDescription(alarm,context){
    return Text(
      alarm['alarmDescription'],
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context)
          .textTheme
          .headlineSmall,
    );
  }

  Widget alarmDate(context,alarm){
    return Text(
      alarm['alarmDate'],
      style: Theme.of(context)
          .textTheme
          .titleLarge!.copyWith(fontWeight: FontWeight.w400),
    );
  }

  Widget alarmTime(alarm,context){
    return Text(
      alarm['alarmTime'],
      style: Theme.of(context)
          .textTheme
          .displayLarge!
          .copyWith(
          fontSize: 26.sp,
          fontWeight:
          FontWeight.w500),
    );
  }

  Widget dottedBorder(context, cubit) {
    return DottedBorder(
      strokeWidth: 3,
      dashPattern: const [5, 4],
      color: AppColors.lightGray,
      borderType: BorderType.RRect,
      radius: Radius.circular(24.r),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.deepBlue,
          borderRadius: BorderRadius.circular(20),
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.deepBlue,
            padding: EdgeInsets.all(25.w),
            alignment: Alignment.center,
          ),
          onPressed: () {
            scaffoldKey.currentState!.showBottomSheet((context) {
              return bottomSheet(context, cubit);
            });
          },
          child: Column(
            children: [
              Image.asset(
                'assets/images/add_alarm.png',
                scale: 1.5,
              ),
              Text(
                'Add Alarm',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomSheet(context, AlarmCubit cubit) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.deepBlue,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      padding: EdgeInsets.all(10.0.w),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DefaultFormKey(
              controller: titleController,
              keyboardType: TextInputType.text,
              labelText: 'Alarm Title',
              prefixIcon: Icons.title,
            ),
            SizedBox(height: 10.0.h),
            DefaultFormKey(
              controller: timeController,
              keyboardType: TextInputType.datetime,
              onTap: () {
                showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                ).then((value) {
                  timeController.text = value!.format(context).toString();
                });
              },
              validator: (value) {
                if (value.isEmpty) {
                  return 'time must not be empty';
                }

                return null;
              },
              labelText: 'Alarm Time',
              prefixIcon: Icons.watch_later_outlined,
            ),
            SizedBox(height: 10.0.h),
            DefaultFormKey(
              controller: dateController,
              keyboardType: TextInputType.datetime,
              onTap: () {
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.parse('2100-05-03'),
                ).then((value) {
                   dateController.text = DateFormat('yyyy-MM-d').format(value!);
                });
              },
              labelText: 'Alarm Date',
              prefixIcon: Icons.calendar_today,
              validator: (value) {
                if (value.isEmpty) {
                  return 'date must not be empty';
                }

                return null;
              },
            ),
            SizedBox(height: 15.0.h),
            DefaultFormKey(
              controller: descriptionController,
              keyboardType: TextInputType.text,
              labelText: 'Alarm description',
              prefixIcon: Icons.description_outlined,
            ),
            SizedBox(height: 15.0.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: 150.w),
              child: FloatingActionButton(
                  backgroundColor: AppColors.lightPurple,
                  mini: true,
                  child: Text(
                    'Save',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      cubit
                          .insertToDatabase(
                          alarmTitle: titleController.text,
                          alarmTime: timeController.text,
                          alarmDate: dateController.text,
                          alarmDescription: descriptionController.text)
                          .then((value) {
                        titleController.text = '';
                        timeController.text = '';
                        dateController.text = '';
                        descriptionController.text = '';
                        Navigator.of(context).pop();
                      });
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

}
