import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_routes.dart';
import '../utils/app_theme_data.dart';
import '../utils/widgets/text_field.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  //-------------------------------------------------------------------------
  TextEditingController emailFieldController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  //-------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Scaffold(
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
                  'Forgot Password',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22.sp,
                    color: black,
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  'Enter your email address',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: grey,
                  ),
                ),
                SizedBox(height: 48.h),
                customTextField(
                  controller: emailFieldController,
                  hintText: 'Email Address',
                  prefixIconPath: 'assets/images/message_icon.png',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email can\'t be empty';
                    }
                    bool isValidEmail = RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value);
                    if (!isValidEmail) {
                      return 'Email format is not correct';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 150.h),
                Padding(
                  padding: EdgeInsets.only(left: 220.w),
                  child: FloatingActionButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        //-------Send data--------------------
                        Navigator.pushNamed(
                            context, Routes.otpVerificationScreen);
                      }
                    },
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
      ),
    );
  }
}
