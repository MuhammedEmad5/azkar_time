import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../application_layer/App_colors.dart';

class DefaultFormKey extends StatelessWidget {
  const DefaultFormKey({Key? key,
    required this.controller,
    required this.keyboardType,
    this.validator,
    required this.labelText,
    required this.prefixIcon,
    this.onTap,
    this.readOnly=false,
  }) : super(key: key);

  final TextEditingController controller;
  final TextInputType keyboardType;
  final FormFieldValidator? validator;
  final String labelText;
  final IconData prefixIcon;
  final GestureTapCallback? onTap;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: Theme.of(context).textTheme.bodySmall,

        prefixIcon: Icon(
          prefixIcon,
          color: AppColors.white,
          size: 20.w,
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.pink)
        ),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.pink)
          ),
          focusedErrorBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.pink)
          ),
          errorStyle: Theme.of(context).textTheme.bodySmall!.copyWith(color: AppColors.pink)
      ),
      style: Theme.of(context).textTheme.titleLarge!.copyWith(
        fontWeight: FontWeight.w500,
      ),
      readOnly: readOnly,
      validator:validator,
      onTap: onTap,
      controller: controller,
      keyboardType: keyboardType,
      cursorColor: AppColors.pink,
    );
  }
}
