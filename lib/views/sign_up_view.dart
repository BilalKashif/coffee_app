import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../data/response/auth_status.dart';
import '../utils/app_routes.dart';
import '../utils/app_theme_data.dart';
import '../utils/widgets/loading_indicator.dart';
import '../utils/widgets/text_field.dart';
import '../view_models/auth_view_model.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  //----------------------------------------------------------

  TextEditingController userNameFieldController = TextEditingController();
  TextEditingController phoneNumberFieldController = TextEditingController();
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
        appBar: AppBar(),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 41.w),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40.h),
                Text(
                  'Sign up',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22.sp,
                    color: black,
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  'Create an account here',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: grey,
                  ),
                ),
                SizedBox(height: 48.h),
                customTextField(
                  controller: userNameFieldController,
                  hintText: 'Username',
                  prefixIconPath: 'assets/images/user_icon.png',
                  keyBoardType: TextInputType.name,
                ),
                SizedBox(height: 38.h),
                customTextField(
                  controller: phoneNumberFieldController,
                  hintText: 'Mobile Number',
                  prefixIconPath: 'assets/images/phone_icon.png',
                  keyBoardType: TextInputType.number,
                ),
                SizedBox(height: 38.h),
                customTextField(
                  controller: emailFieldController,
                  hintText: 'Email address',
                  prefixIconPath: 'assets/images/message_icon.png',
                  keyBoardType: TextInputType.emailAddress,
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
                SizedBox(height: 20.h),
                Text(
                  'By signing up you agree with our Terms of Use',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: green,
                  ),
                ),
                SizedBox(height: 30.h),
                Consumer<AuthViewModel>(
                  builder: (providerContext, value, _) {
                    if (value.authStatus == AuthStatus.loading) {
                      return Center(child: loadingIndicator);
                    }
                    return Padding(
                      padding: EdgeInsets.only(left: 10.w),
                      child: FloatingActionButton.extended(
                        label: const Text('Set address and location'),
                        icon: const Icon(Icons.arrow_forward),
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            Navigator.pushNamed(
                              context,
                              Routes.setLocationScreen,
                              arguments: {
                                'userName': userNameFieldController.text,
                                'mobileNumber': phoneNumberFieldController.text,
                                'email': emailFieldController.text,
                                'password': passwordFieldController.text,
                              },
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
                SizedBox(height: 50.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Already a member? ',
                      style:
                          TextStyle(color: grey, fontWeight: FontWeight.w600),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Sign in',
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
