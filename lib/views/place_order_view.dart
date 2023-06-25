import 'package:coffee_app/utils/app_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../data/app_exceptions.dart';
import '../utils/app_routes.dart';
import '../utils/coffee_beans_types.dart';
import '../utils/widgets/alert_dialogue.dart';
import '../utils/widgets/coffee_art_widget.dart';
import '../utils/widgets/coffee_bean_info_widget.dart';
import '../utils/widgets/loading_indicator.dart';
import '../view_models/order_view_model.dart';

class PlaceOrderView extends StatefulWidget {
  const PlaceOrderView({super.key});

  @override
  State<PlaceOrderView> createState() => _PlaceOrderViewState();
}

class _PlaceOrderViewState extends State<PlaceOrderView> {
  //-----------Order Credentials----------------------------
  int count = 1;
  int numberOfShots = 1;
  int isHotCoffee = 1;
  int cupSize = 1;
  int numberOfIceCubes = 1;
  int beanRoast = 1;

  //-------------Prices-------------------------------------
  int coffeePrice = 5;
  int shotsPrice = 1;
  int cupPrice = 1;
  int icePrice = 1;
  int beansPrice = 1;
  //--------------------------------------------------------
  int selectedStyle = 0;
  int selectedBean = 0;

  @override
  Widget build(BuildContext context) {
    // totalPrice = coffeePrice + shotsPrice + cupPrice + beansPrice;
    // if (isHotCoffee == 2) {
    //   totalPrice += icePrice;
    // }
    //-----------------------------------------------------------------
    Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments! as Map<String, dynamic>;
    //-----------------------------------------------------------------
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, Routes.cartScreen);
              },
              child: Image.asset('assets/images/cart_icon.png'),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 150.h,
              decoration: BoxDecoration(
                color: grey.withOpacity(0.5),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Center(
                child: SizedBox(
                  height: 120.h,
                  child: Image.asset(
                    'assets/images/${arguments['typeName']}.png',
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.h),
            //---------------Number of Coffees--------------------------
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          Text(
                            arguments['typeName'],
                            style: TextStyle(
                              color: black,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Expanded(child: SizedBox()),
                          Container(
                            width: 70.w,
                            height: 30.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              border: Border.fromBorderSide(
                                BorderSide(
                                  color: grey,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                InkWell(
                                  borderRadius: BorderRadius.circular(25),
                                  onTap: () {
                                    if (count > 1) {
                                      count--;
                                      setState(() {});
                                    }
                                  },
                                  child: const Text('-'),
                                ),
                                Text(count.toString()),
                                InkWell(
                                  borderRadius: BorderRadius.circular(25),
                                  onTap: () {
                                    count++;
                                    setState(() {});
                                  },
                                  child: const Text('+'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    //--------------------------------------------------------------
                    //------------------Number of Shots----------------------------
                    const Divider(thickness: 1),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Text(
                            'Shots',
                            style: TextStyle(
                              color: black,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Expanded(child: SizedBox()),
                          InkWell(
                            borderRadius: BorderRadius.circular(25),
                            onTap: () {
                              numberOfShots = 1;
                              shotsPrice = 1;
                              setState(() {});
                            },
                            child: Container(
                              width: 70.w,
                              height: 30.h,
                              decoration: BoxDecoration(
                                color: numberOfShots == 1
                                    ? green
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(25),
                                border: Border.fromBorderSide(
                                  BorderSide(
                                    color: grey,
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Single',
                                  style: TextStyle(
                                    color: numberOfShots == 1
                                        ? Colors.white
                                        : black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          InkWell(
                            borderRadius: BorderRadius.circular(25),
                            onTap: () {
                              numberOfShots = 2;
                              shotsPrice = 2;
                              setState(() {});
                            },
                            child: Container(
                              width: 70.w,
                              height: 30.h,
                              decoration: BoxDecoration(
                                color: numberOfShots == 2
                                    ? green
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(25),
                                border: Border.fromBorderSide(
                                  BorderSide(
                                    color: grey,
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Double',
                                  style: TextStyle(
                                    color: numberOfShots == 2
                                        ? Colors.white
                                        : black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //---------------Hot or Cold Coffee---------------------------------
                    const Divider(thickness: 1),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Text(
                            'Hot or Cold',
                            style: TextStyle(
                              color: black,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Expanded(child: SizedBox()),
                          SizedBox(
                            height: 30.h,
                            child: InkWell(
                              onTap: () {
                                isHotCoffee = 1;
                                coffeePrice = 5;
                                setState(() {});
                              },
                              child: Image.asset(
                                'assets/images/hot_coffee_icon.png',
                                color: isHotCoffee == 1 ? green : grey,
                              ),
                            ),
                          ),
                          SizedBox(width: 20.w),
                          SizedBox(
                            height: 35.h,
                            child: InkWell(
                              onTap: () {
                                isHotCoffee = 2;
                                coffeePrice = 5;
                                setState(() {});
                              },
                              child: Image.asset(
                                'assets/images/cold_coffee_icon.png',
                                color: isHotCoffee == 2 ? green : grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //---------------Size of Coffee-------------------------------
                    const Divider(thickness: 1),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Text(
                            'Size',
                            style: TextStyle(
                              color: black,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Expanded(child: SizedBox()),
                          SizedBox(
                            height: 20.h,
                            child: InkWell(
                              onTap: () {
                                cupSize = 1;
                                cupPrice = 1;
                                setState(() {});
                              },
                              child: Image.asset(
                                'assets/images/cup_icon.png',
                                color: cupSize == 1 ? green : grey,
                              ),
                            ),
                          ),
                          SizedBox(width: 20.w),
                          SizedBox(
                            height: 30.h,
                            child: InkWell(
                              onTap: () {
                                cupSize = 2;
                                cupPrice = 2;
                                setState(() {});
                              },
                              child: Image.asset(
                                'assets/images/cup_icon.png',
                                color: cupSize == 2 ? green : grey,
                              ),
                            ),
                          ),
                          SizedBox(width: 20.w),
                          SizedBox(
                            height: 40.h,
                            child: InkWell(
                              onTap: () {
                                cupSize = 3;
                                cupPrice = 3;
                                setState(() {});
                              },
                              child: Image.asset(
                                'assets/images/cup_icon.png',
                                color: cupSize == 3 ? green : grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //---------------Number of Ice cubes--------------------------
                    isHotCoffee == 1
                        ? const SizedBox()
                        : const Divider(thickness: 1),
                    isHotCoffee == 1
                        ? const SizedBox()
                        : Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              children: [
                                Text(
                                  'Ice',
                                  style: TextStyle(
                                    color: black,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                                SizedBox(
                                  height: 20.h,
                                  child: InkWell(
                                    onTap: () {
                                      numberOfIceCubes = 1;
                                      icePrice = 1;
                                      setState(() {});
                                    },
                                    child: Image.asset(
                                      'assets/images/one_ice_icon.png',
                                      color:
                                          numberOfIceCubes == 1 ? green : grey,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20.w),
                                SizedBox(
                                  height: 30.h,
                                  child: InkWell(
                                    onTap: () {
                                      numberOfIceCubes = 2;
                                      icePrice = 2;
                                      setState(() {});
                                    },
                                    child: Image.asset(
                                      'assets/images/two_ice_icon.png',
                                      color:
                                          numberOfIceCubes == 2 ? green : grey,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20.w),
                                SizedBox(
                                  height: 40.h,
                                  child: InkWell(
                                    onTap: () {
                                      numberOfIceCubes = 3;
                                      icePrice = 3;
                                      setState(() {});
                                    },
                                    child: Image.asset(
                                      'assets/images/three_ice_icon.png',
                                      color:
                                          numberOfIceCubes == 3 ? green : grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                    //-----------------Coffee Bean Roast---------------------
                    const Divider(thickness: 1),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Text(
                            'Coffee Beans Roast',
                            style: TextStyle(
                              color: black,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Expanded(child: SizedBox()),
                          SizedBox(
                            height: 40.h,
                            child: InkWell(
                              onTap: () {
                                beanRoast = 1;
                                beansPrice = 1;
                                setState(() {});
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                    height: 20,
                                    child: Image.asset(
                                      'assets/images/coffee_bean_icon.png',
                                      color: beanRoast == 1
                                          ? green.withOpacity(0.6)
                                          : grey,
                                    ),
                                  ),
                                  Text(
                                    'Light',
                                    style: TextStyle(
                                      fontSize: 8.sp,
                                      color: beanRoast == 1 ? green : grey,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 20.w),
                          SizedBox(
                            height: 40.h,
                            child: InkWell(
                              onTap: () {
                                beanRoast = 2;
                                beansPrice = 2;
                                setState(() {});
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                    height: 20,
                                    child: Image.asset(
                                      'assets/images/coffee_bean_icon.png',
                                      color: beanRoast == 2
                                          ? green.withOpacity(0.8)
                                          : grey,
                                    ),
                                  ),
                                  Text(
                                    'Medium',
                                    style: TextStyle(
                                      fontSize: 8.sp,
                                      color: beanRoast == 2 ? green : grey,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 20.w),
                          SizedBox(
                            height: 40.h,
                            child: InkWell(
                              onTap: () {
                                beanRoast = 3;
                                beansPrice = 3;
                                setState(() {});
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                    height: 20,
                                    child: Image.asset(
                                      'assets/images/coffee_bean_icon.png',
                                      color: beanRoast == 3 ? green : grey,
                                    ),
                                  ),
                                  Text(
                                    'Dark',
                                    style: TextStyle(
                                      fontSize: 8.sp,
                                      color: beanRoast == 3 ? green : grey,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    isHotCoffee == 2
                        ? const SizedBox()
                        : const Divider(thickness: 1),
                    isHotCoffee == 2
                        ? const SizedBox()
                        : const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Select Art',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                    isHotCoffee == 2
                        ? const SizedBox()
                        : SizedBox(
                            height: 250.h,
                            width: double.infinity,
                            child: GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                ),
                                itemCount: 6,
                                itemBuilder: (BuildContext context, int index) {
                                  return InkWell(
                                    borderRadius: BorderRadius.circular(25),
                                    onTap: () {
                                      selectedStyle = index;
                                      setState(() {});
                                    },
                                    child: coffeeArtWidget(
                                        selectedIndex: selectedStyle,
                                        index: index),
                                  );
                                }),
                          ),
                    //--------------Coffee Beans Types-------------------------
                    const Divider(thickness: 1),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Select Coffee Beans',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 800.h,
                      width: double.infinity,
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemCount: 8,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            borderRadius: BorderRadius.circular(25),
                            onTap: () {
                              selectedBean = index;
                              setState(() {});
                            },
                            child: coffeeBeanInfoWidget(
                                index: index, selectedIndex: selectedBean),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 5.h),
            Row(
              children: [
                Text(
                  'Total Amount',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
                const Expanded(child: SizedBox()),
                Text(
                  '${(coffeePrice + shotsPrice + cupPrice + beansPrice + (isHotCoffee == 2 ? icePrice : 0)) * count}\$',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22.sp,
                  ),
                ),
              ],
            ),
            Consumer<OrderViewModel>(builder: (context, provider, _) {
              if (provider.orderPlacementState ==
                  OrderPlacementState.processing) {
                return Center(child: loadingIndicator);
              }
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  provider.isAddedToCart
                      ? const SizedBox()
                      : OutlinedButton(
                          onPressed: () async {
                            try {
                              await provider.addOrder(
                                addToCart: true,
                                coffeeType: arguments['typeName'],
                                numberOfShots: numberOfShots,
                                isHot: isHotCoffee == 1 ? true : false,
                                size: cupSize,
                                roast: beanRoast,
                                art: coffeeArtsName[selectedStyle],
                                beanType: beanTypeName[selectedBean],
                                totalAmount: ((coffeePrice +
                                        shotsPrice +
                                        cupPrice +
                                        beansPrice +
                                        (isHotCoffee == 2 ? icePrice : 0)) *
                                    count),
                              );
                              showAlertDialogue(
                                context: context,
                                title: 'Success',
                                message: 'Added to cart successfully',
                              );
                            } on CustomException catch (error) {
                              showAlertDialogue(
                                  context: context,
                                  title: error.prefix,
                                  message: error.message);
                            }
                          },
                          child: Row(
                            children: [
                              const Text('Add to Cart'),
                              const SizedBox(width: 5),
                              SizedBox(
                                height: 20,
                                child: Image.asset(
                                  'assets/images/cart_icon.png',
                                  color: green,
                                ),
                              )
                            ],
                          ),
                        ),
                  FilledButton(
                    onPressed: () async {
                      try {
                        await provider.addOrder(
                          addToCart: false,
                          coffeeType: arguments['typeName'],
                          numberOfShots: numberOfShots,
                          isHot: isHotCoffee == 1 ? true : false,
                          size: cupSize,
                          roast: beanRoast,
                          art: coffeeArtsName[selectedStyle],
                          beanType: beanTypeName[selectedBean],
                          totalAmount: ((coffeePrice +
                                  shotsPrice +
                                  cupPrice +
                                  beansPrice +
                                  (isHotCoffee == 2 ? icePrice : 0)) *
                              count),
                        );
                        Navigator.pushReplacementNamed(
                            context, Routes.orderSuccessScreen);
                      } on CustomException catch (error) {
                        showAlertDialogue(
                            context: context,
                            title: error.prefix,
                            message: error.message);
                      }
                    },
                    child: const Text('Checkout'),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
