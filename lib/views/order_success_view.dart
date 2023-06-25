import 'package:coffee_app/utils/app_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_routes.dart';

class OrderSuccessView extends StatelessWidget {
  const OrderSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/order_success_icon.png',
            ),
            SizedBox(height: 32.h),
            Text(
              'Order Success',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 23.sp,
              ),
            ),
            SizedBox(height: 22.h),
            Text(
              'Your order has been placed successfully.\nFor more details, go to my orders.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
                color: grey,
              ),
            ),
            SizedBox(height: 40.h),
            FilledButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, Routes.myOrdersScreen);
              },
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 100.w, vertical: 20.h),
                child: const Text('My Orders'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
