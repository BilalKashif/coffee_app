import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_app/data/app_exceptions.dart';
import 'package:coffee_app/data/current_user_data.dart';
import 'package:coffee_app/models/coffee_shop_model.dart';
import 'package:coffee_app/models/order_model.dart';
import 'package:coffee_app/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum OrderPlacementState {
  idle,
  processing,
}

class OrderViewModel extends ChangeNotifier {
  //---------Firebase Instances-------------------------
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  CollectionReference ordersCollection = FirebaseFirestore.instance
      .collection('orders')
      .doc(CurrentUserData.currentUser!.userId)
      .collection('order_items');

  CollectionReference cartCollection = FirebaseFirestore.instance
      .collection('cart')
      .doc(CurrentUserData.currentUser!.userId)
      .collection('cart_items');

  DocumentReference cartDataDocument = FirebaseFirestore.instance
      .collection('cart')
      .doc(CurrentUserData.currentUser!.userId);
  //---------------------------------------------------
  OrderModel? orderModel;
  bool isAddedToCart = false;
  OrderPlacementState orderPlacementState = OrderPlacementState.idle;

  Future<void> addOrder({
    required bool addToCart,
    required String coffeeType,
    required int numberOfShots,
    required bool isHot,
    required int size,
    required int roast,
    required String art,
    required String beanType,
    required int totalAmount,
  }) async {
    orderPlacementState = OrderPlacementState.processing;
    notifyListeners();
    //--------------------------------------------------------
    CoffeeShopModel selectedShop = CurrentUserData.selectedShop!;
    UserModel currentUserData = CurrentUserData.currentUser!;
    final now = DateTime.now();
    String currentTime = DateFormat('jm').format(now);
    String currentDate = DateFormat('yMMMMd').format(now);
    Timestamp timestamp = Timestamp.fromDate(now);
    String shopAddress = selectedShop.address;
    String shopName = selectedShop.shopName;
    GeoPoint shopLocation = GeoPoint(selectedShop.shopLocation.latitude,
        selectedShop.shopLocation.longitude);
    String userAddress = currentUserData.address;
    GeoPoint userLocation = GeoPoint(currentUserData.addressLocation.latitude,
        currentUserData.addressLocation.longitude);
    //-------------------------------------------------------

    //-------Making Order Entitiy---------------------------
    orderModel = OrderModel(
      coffeeType: coffeeType,
      numberOfShots: numberOfShots,
      isHot: isHot,
      size: size,
      roast: roast,
      artType: art,
      beantype: beanType,
      totalAmount: totalAmount,
      time: currentTime,
      date: currentDate,
      timeStamp: timestamp,
      isCompleted: false,
      shopAddress: shopAddress,
      shopLocation: shopLocation,
      shopName: shopName,
      userAddress: userAddress,
      userLocation: userLocation,
    );
    try {
      if (addToCart) {
        print('added to cart');
        await cartCollection.add(orderModel!.toJson());
      } else {
        await ordersCollection.add(orderModel!.toJson());
      }
    } on FirebaseException catch (error) {
      throw CustomException(
          'Something went wrong while add order\nDue to: ${error.message}',
          'Failed to add order');
    } catch (error) {
      print('couldt added to cart');
      throw CustomException(
          'Something went wrong while add the order', 'Failed to add order');
    }

    if (addToCart) {
      // --------------Run Transaction---------------------------------
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(cartDataDocument);
        int newCartAmount = 0;

        if (!snapshot.exists) {
          cartDataDocument.set({'cartAmount': totalAmount});
        } else {
          Map<String, dynamic> snapshotData =
              snapshot.data()! as Map<String, dynamic>;
          newCartAmount = snapshotData['cartAmount'] + totalAmount;
          transaction.update(cartDataDocument, {'cartAmount': newCartAmount});
          return;
        }
      }).catchError((error) {
        throw CustomException(error.toString(), 'Failed in add to Cart');
      });
      isAddedToCart = true;
    }
    orderPlacementState = OrderPlacementState.idle;
    notifyListeners();
  }

  Future<void> completeOrder(String docId) async {
    await ordersCollection.doc(docId).update({'isCompleted': true});
  }

  Stream<QuerySnapshot> getActiveOrders() {
    return ordersCollection
        .where('isCompleted', isEqualTo: false)
        .snapshots();
  }

  Stream<QuerySnapshot> getCompletedOrders() {
    return ordersCollection.where('isCompleted', isEqualTo: true).snapshots();
  }

   Stream<QuerySnapshot> getCartItems() {
    return cartCollection.snapshots();
  }


  Future<void> checkOutCart(List<String> orderIds) async {}
}
