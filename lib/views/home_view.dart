import 'package:coffee_app/data/current_user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_routes.dart';
import '../utils/app_theme_data.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 50.h, left: 25.w, right: 30.w),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello',
                      style: TextStyle(
                        color: grey,
                        fontSize: 14.sp,
                      ),
                    ),
                    Text(
                      CurrentUserData.currentUser!.userName,
                      style: TextStyle(
                        color: black,
                        fontSize: 18.sp,
                      ),
                    ),
                  ],
                ),
                const Expanded(child: SizedBox()),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.cartScreen);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 30.h,
                      width: 30.w,
                      child: Image.asset('assets/images/cart_icon.png'),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.profileScreen);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 30.h,
                      width: 30.w,
                      child: Image.asset('assets/images/user_icon.png'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.only(left: 25.w),
            child: Text(
              'Welcom to',
              style: TextStyle(
                color: black,
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 25.w),
            child: Text(
              CurrentUserData.selectedShop!.shopName,
              style: TextStyle(
                color: green,
                fontSize: 18.sp,
              ),
            ),
          ),
          SizedBox(height: 30.h),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: green,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 40.h, left: 25.w),
                    child: Text(
                      'Choose your coffee',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Expanded(
                    child: GridView.count(
                      primary: false,
                      padding: const EdgeInsets.all(20),
                      crossAxisSpacing: 15.w,
                      mainAxisSpacing: 15.h,
                      crossAxisCount: 2,
                      children: [
                        coffeeType('Americano'),
                        coffeeType('Cappuccino'),
                        coffeeType('Mocha'),
                        coffeeType('Flat White'),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 40),
                    child: Container(
                      height: 65.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            iconWidget(
                              child: SizedBox(
                                height: 20,
                                child: Image.asset(
                                    'assets/images/shop_icon.png',
                                    color: green),
                              ),
                              onpressed: () {
                                Navigator.pushNamed(
                                    context, Routes.shopInformationScreen);
                              },
                            ),
                            iconWidget(
                              child: SizedBox(
                                height: 20,
                                child:
                                    Icon(Icons.explore_outlined, color: green),
                              ),
                              onpressed: () {
                                Navigator.pushNamed(
                                    context, Routes.exploreScreen);
                              },
                            ),
                            iconWidget(
                              child: SizedBox(
                                height: 20,
                                child: Image.asset(
                                  'assets/images/order_icon.png',
                                  color: green,
                                ),
                              ),
                              onpressed: () {
                                Navigator.pushNamed(
                                  context,
                                  Routes.myOrdersScreen,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget coffeeType(
    String name,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(25),
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.placeOrderScreen,
          arguments: {'typeName': name, 'imageUrl': ''},
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 85.h,
              child: Image.asset('assets/images/$name.png'),
            ),
            SizedBox(height: 10.h),
            Text(
              name,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget iconWidget({required Widget child, required Function() onpressed}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: green.withOpacity(0.5),
        borderRadius: BorderRadius.circular(50),
        onTap: onpressed,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Colors.transparent),
            child: child,
          ),
        ),
      ),
    );
  }
}
