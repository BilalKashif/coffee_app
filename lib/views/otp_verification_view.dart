import 'package:flutter/material.dart';
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_theme_data.dart';

class OtpVerificationView extends StatefulWidget {
  const OtpVerificationView({super.key});

  @override
  State<OtpVerificationView> createState() => _OtpVerificationViewState();
}

class _OtpVerificationViewState extends State<OtpVerificationView> {
  //-----------------------------------------------------------------
  TextEditingController otpFieldController = TextEditingController();
  FocusNode otpFieldFocusNode = FocusNode();
  //-----------------------------------------------------------------

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 41.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50.h),
              Text(
                'Verification',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22.sp,
                  color: black,
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                'Enter the OTP code we sent you',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: grey,
                ),
              ),
              SizedBox(height: 48.h),
              PinCodeFields(
                length: 4,
                controller: otpFieldController,
                focusNode: otpFieldFocusNode,
                fieldBorderStyle: FieldBorderStyle.square,
                borderColor: grey.withOpacity(0.2),
                responsive: false,
                fieldHeight: 65.h,
                fieldWidth: 48.w,
                activeBorderColor: green,
                activeBackgroundColor: green.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10.0),
                keyboardType: TextInputType.number,
                autoHideKeyboard: false,
                fieldBackgroundColor: grey.withOpacity(0.2),
                onComplete: (result) {
                  // Your logic with code
                  print(result);
                },
              ),
              SizedBox(height: 43.h),
              Center(
                child: Text(
                  'Resend in 00:30',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                    color: grey,
                  ),
                ),
              ),
              SizedBox(height: 54.h),
              Padding(
                padding: EdgeInsets.only(left: 220.w),
                child: FloatingActionButton(
                  onPressed: () {},
                  child: const Center(
                    child: Icon(
                      Icons.arrow_forward,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
