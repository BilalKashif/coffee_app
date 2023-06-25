import 'package:coffee_app/views/forgot_password_view.dart';
import 'package:coffee_app/views/map_view.dart';
import 'package:coffee_app/views/onboarding_view.dart';
import 'package:coffee_app/views/otp_verification_view.dart';
import 'package:coffee_app/views/profile_view.dart';
import 'package:coffee_app/views/set_location_view.dart';
import 'package:coffee_app/views/sign_in_view.dart';
import 'package:coffee_app/views/sign_up_view.dart';
import 'package:flutter/material.dart';

class Routes {
  //Add new route name
  static String onboardingScreen = 'OnboardingScreenRoute';
  static String signInScreen = 'SignInScreenRoute';
  static String signUpScreen = 'SignUpScreenRoute';
  static String setLocationScreen = 'SetLoacationScreenRoute';
  static String forgetPasswordScreen = 'ForgetPassrodScreenRoute';
  static String otpVerificationScreen = 'OtpVerificationScreenRoute';
  static String mapScreen = 'MapScreenRoute';
  static String profileScreen = 'ProfileScreenRoute';

  static Map<String, Widget Function(BuildContext)> generateRoutes() {
    return {
      //Add route here
      onboardingScreen: (_) => const OnboardingView(),
      signInScreen: (_) => const SignInView(),
      signUpScreen: (_) => const SignUpView(),
      setLocationScreen: (_) => const SetLocationView(),
      forgetPasswordScreen: (_) => const ForgotPasswordView(),
      otpVerificationScreen: (_) => const OtpVerificationView(),
      mapScreen: (_) => const MapView(),
      profileScreen: (_) => const ProfileView(),
    };
  }
}
