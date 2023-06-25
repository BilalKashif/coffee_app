import 'package:coffee_app/utils/coffee_beans_types.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../app_theme_data.dart';

Widget coffeeBeanInfoWidget({required int index, required int selectedIndex}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      decoration: BoxDecoration(
        color: Colors.white,
        border: index == selectedIndex
            ? Border.all(
                color: green,
                width: 1,
              )
            : null,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: grey.withOpacity(0.5),
            blurRadius: 5,
            spreadRadius: 2,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/coffee_bean_icon.png',
            color: green,
          ),
          const SizedBox(height: 5),
          Text(
            beanTypeName[index],
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              beanTypeDescription[index],
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
