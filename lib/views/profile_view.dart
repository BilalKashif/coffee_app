import 'package:coffee_app/data/current_user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_theme_data.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Column(
          children: [
            profileItemTile(
              title: 'Full name',
              text: CurrentUserData.currentUser!.userName,
              iconPath: 'assets/images/user_icon.png',
            ),
            profileItemTile(
              title: 'Phone number',
              text: CurrentUserData.currentUser!.phoneNumber,
              iconPath: 'assets/images/telephone_icon.png',
            ),
            profileItemTile(
              title: 'Email',
              text: CurrentUserData.currentUser!.userEmail,
              iconPath: 'assets/images/message_icon.png',
            ),
            profileItemTile(
              title: 'Address',
              text: CurrentUserData.currentUser!.address,
              iconPath: 'assets/images/location_icon.png',
            )
          ],
        ),
      ),
    );
  }

  Widget profileItemTile(
      {required String title, required String text, required String iconPath}) {
    return Padding(
      padding: EdgeInsets.all(10.sp),
      child: Row(
        children: [
          Container(
            height: 42.sp,
            width: 42.sp,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: grey,
            ),
            child: Center(
              child: SizedBox(
                height: 20.h,
                child: Image.asset(iconPath),
              ),
            ),
          ),
          SizedBox(width: 15.w),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 10.sp,
                ),
              ),
              SizedBox(
                width: 170.w,
                child: Text(
                  text,
                  style: TextStyle(
                    color: green,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ],
          ),
          const Expanded(child: SizedBox(height: 1)),
          SizedBox(
            height: 20.h,
            width: 20.w,
            child: Image.asset('assets/images/edit_icon.png'),
          ),
        ],
      ),
    );
  }
}
