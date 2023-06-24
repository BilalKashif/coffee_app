import 'package:coffee_app/utils/app_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_routes.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 180.h),
          Padding(
            padding: EdgeInsets.all(20.sp),
            child: Image.asset('assets/images/coffee_machine.png'),
          ),
          SizedBox(height: 63.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 47.w),
            child: Text(
              'Making your days with our coffee.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w500,
                color: black,
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsetsDirectional.symmetric(horizontal: 57.w),
            child: Text(
              'The best grain, the finest roast, the most powerful flavor.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.normal,
                color: grey,
              ),
            ),
          ),
          SizedBox(height: 70.h),
          Padding(
            padding: EdgeInsets.only(left: 200.w),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, Routes.signInScreen);
              },
              child: const Center(
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
