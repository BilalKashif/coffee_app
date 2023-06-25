import 'package:coffee_app/data/app_exceptions.dart';
import 'package:coffee_app/data/response/auth_status.dart';
import 'package:coffee_app/utils/app_theme_data.dart';
import 'package:coffee_app/utils/widgets/alert_dialogue.dart';
import 'package:coffee_app/utils/widgets/loading_indicator.dart';
import 'package:coffee_app/utils/widgets/text_field.dart';
import 'package:coffee_app/view_models/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../utils/app_routes.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  //----------------------------------------------------------

  TextEditingController emailFieldController = TextEditingController();
  TextEditingController passwordFieldController = TextEditingController();

  bool obscurePassword = true;

  final formKey = GlobalKey<FormState>();
  //-----------------------------------------------------------

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailFieldController.dispose();
    passwordFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 41.w),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 127.h),
                Text(
                  'Sign in',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22.sp,
                    color: black,
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  'Welcome back',
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
                SizedBox(height: 38.h),
                customTextField(
                  controller: passwordFieldController,
                  hintText: 'Password',
                  prefixIconPath: 'assets/images/lock_icon.png',
                  obscureText: obscurePassword,
                  ontapPrefixIcon: () {
                    setState(() {
                      if (obscurePassword) {
                        obscurePassword = false;
                      } else {
                        obscurePassword = true;
                      }
                    });
                  },
                ),
                SizedBox(height: 25.h),
                Center(
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, Routes.forgetPasswordScreen);
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: green,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 90.h),
                Consumer<AuthViewModel>(
                  builder: (providerContext, value, _) {
                    
                    if (value.authStatus == AuthStatus.loading) {
                      return Center(child: loadingIndicator);
                    }
                    return Padding(
                      padding: EdgeInsets.only(left: 230.w),
                      child: FloatingActionButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            //-------Send data--------------------
                            try {
                              await value.signIn(
                                email: emailFieldController.text,
                                password: passwordFieldController.text,
                              );
                              Navigator.pushNamed(context, Routes.mapScreen);
                            } on CustomException catch (error) {
                              showAlertDialogue(
                                  context: context,
                                  title: error.prefix,
                                  message: error.message);
                            }
                          }
                        },
                        child: const Center(
                          child: Icon(
                            Icons.arrow_forward,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 125.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'New Member? ',
                      style:
                          TextStyle(color: grey, fontWeight: FontWeight.w600),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, Routes.signUpScreen);
                      },
                      child: Text(
                        'Sign up',
                        style: TextStyle(
                            color: green, fontWeight: FontWeight.w600),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
