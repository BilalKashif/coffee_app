import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../models/order_model.dart';
import '../utils/app_theme_data.dart';
import '../utils/widgets/loading_indicator.dart';
import '../view_models/order_view_model.dart';

Map<int, String> size = {
  1: 'Small',
  2: 'Medium',
  3: 'Large',
};

Map<int, String> iced = {
  1: 'Low Ice',
  2: 'Medium Ice',
  3: 'Full Ice',
};

Map<int, String> shots = {
  1: 'Single',
  2: 'Double',
};

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<OrderViewModel>(
              builder: (context, provider, _) {
                return StreamBuilder<QuerySnapshot>(
                  stream: provider.getCartItems(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Center(child: Text('Something went wrong'));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: loadingIndicator);
                    }
                    return ListView(
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        OrderModel orderModel = OrderModel.fromJson(data);
                        return cartTile(
                            amount: orderModel.totalAmount.toString(),
                            coffeeType: orderModel.coffeeType,
                            numberOfShots: orderModel.numberOfShots,
                            isHot: orderModel.isHot,
                            cupSize: orderModel.size);
                      }).toList(),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget cartTile(
      {required String amount,
      required String coffeeType,
      required int numberOfShots,
      required bool isHot,
      required int cupSize}) {
    return Padding(
      padding: EdgeInsets.all(10.sp),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: grey,
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 60.h,
                child: Image.asset('assets/images/$coffeeType.png'),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(height: 15.h),
                Text(
                  coffeeType,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${shots[numberOfShots]} | ${isHot ? 'Hot' : 'Iced'} | ${size[cupSize]}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: grey,
                  ),
                ),
              ],
            ),
            const Expanded(child: SizedBox()),
            Padding(
              padding: EdgeInsets.only(top: 20.h, right: 20.w),
              child: Text(
                '$amount\$',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
