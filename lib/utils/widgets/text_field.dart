import 'package:coffee_app/utils/app_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget customTextField({
  required TextEditingController controller,
  required String hintText,
  required String prefixIconPath,
  FocusNode? focusNode,
  String? Function(String?)? validator,
  Function()? ontapPrefixIcon,
  bool? obscureText,
  TextInputType? keyBoardType,
  bool? isEnabled,
}) {
  return TextFormField(
    enabled: isEnabled ?? true,
    controller: controller,
    obscureText: obscureText ?? false,
    keyboardType: keyBoardType,
    validator: validator ??
        (value) {
          if (value == null || value.isEmpty) {
            return 'This field can\'t be empty';
          }
          return null;
        },
    decoration: InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: grey, fontSize: 12.sp),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: black),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: grey),
      ),
      prefixIcon: SizedBox(
        width: 50,
        child: Row(
          children: [
            SizedBox(
              height: 20.h,
              child: Image.asset(prefixIconPath),
            ),
            SizedBox(width: 10.w),
            Container(
              height: 30,
              width: 2,
              color: grey,
            )
          ],
        ),
      ),
      suffixIcon: obscureText == null
          ? null
          : obscureText
              ? InkWell(
                  onTap: ontapPrefixIcon,
                  child: const Icon(Icons.visibility_off),
                )
              : InkWell(
                  onTap: ontapPrefixIcon,
                  child: const Icon(Icons.visibility),
                ),
    ),
  );
}
