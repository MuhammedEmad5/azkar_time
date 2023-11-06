import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../application_layer/App_colors.dart';
import '../../../application_layer/app_strings.dart';
class AzkarScreen extends StatelessWidget {
  const AzkarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: AppColors.white
        ),
      ),
      body: ListView.builder(
          itemBuilder: (context,index)=>Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.h,vertical: 10),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  AppStrings.azkarList[index],
                  style: Theme.of(context).textTheme.displayMedium,
                  textDirection: TextDirection.rtl,
                ),
              ),
              color: AppColors.deepBlue,
            ),
          ),
          itemCount: AppStrings.azkarList.length
      ),
    );
  }
}
