import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_app/models/order_model.dart';
import 'package:coffee_app/utils/app_theme_data.dart';
import 'package:coffee_app/utils/widgets/loading_indicator.dart';
import 'package:coffee_app/view_models/order_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class MyOrdersView extends StatelessWidget {
  const MyOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Orders'),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: Text(
                  'Ongoing',
                  style: TextStyle(
                    color: black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Tab(
                icon: Text(
                  'History',
                  style: TextStyle(
                    color: black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Column(
              children: [
                Expanded(
                  child: Consumer<OrderViewModel>(
                    builder: (context, provider, _) {
                      return StreamBuilder<QuerySnapshot>(
                        stream: provider.getActiveOrders(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return const Center(
                                child: Text('Something went wrong'));
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: loadingIndicator);
                          }
                          return ListView(
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                              Map<String, dynamic> data =
                                  document.data()! as Map<String, dynamic>;
                              OrderModel orderModel = OrderModel.fromJson(data);
                              return orderTile(
                                  isComplete: orderModel.isCompleted,
                                  provider: provider,
                                  docId: document.id,
                                  date: orderModel.date,
                                  time: orderModel.time,
                                  amount: orderModel.totalAmount.toString(),
                                  location: orderModel.userAddress,
                                  coffeeType: orderModel.coffeeType);
                            }).toList(),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Expanded(
                  child: Consumer<OrderViewModel>(
                    builder: (context, provider, _) {
                      return StreamBuilder<QuerySnapshot>(
                        stream: provider.getCompletedOrders(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return const Center(
                                child: Text('Something went wrong'));
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: loadingIndicator);
                          }
                          return ListView(
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                              Map<String, dynamic> data =
                                  document.data()! as Map<String, dynamic>;
                              OrderModel orderModel = OrderModel.fromJson(data);
                              return orderTile(
                                  isComplete: orderModel.isCompleted,
                                  provider: provider,
                                  docId: document.id,
                                  date: orderModel.date,
                                  time: orderModel.time,
                                  amount: orderModel.totalAmount.toString(),
                                  location: orderModel.userAddress,
                                  coffeeType: orderModel.coffeeType);
                            }).toList(),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget orderTile(
      {required bool isComplete,
      required OrderViewModel provider,
      required String date,
      required String time,
      required String amount,
      required String location,
      required String docId,
      required String coffeeType}) {
    return Padding(
      padding: EdgeInsets.all(25.sp),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$date | $time',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: grey,
                ),
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Image.asset(
                    'assets/images/coffee_cup_icon.png',
                    color: green,
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    coffeeType,
                    style: TextStyle(
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  SizedBox(
                    height: 15.h,
                    child: Image.asset(
                      'assets/images/location_icon.png',
                      color: green,
                    ),
                  ),
                  SizedBox(width: 5.w),
                  SizedBox(
                    width: 200.w,
                    child: Text(
                      location,
                      style: TextStyle(
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
          const Expanded(child: SizedBox()),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: Text(
                  '$amount\$',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              isComplete
                  ? const SizedBox()
                  : OutlinedButton(
                      onPressed: () {
                        provider.completeOrder(docId);
                      },
                      child: const Text('Complete*'),
                    )
            ],
          )
        ],
      ),
    );
  }
}
