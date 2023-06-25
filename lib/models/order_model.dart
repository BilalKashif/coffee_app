import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String coffeeType;
  final int numberOfShots;
  final bool isHot;
  final int size;
  final int roast;
  final String artType;
  final String beantype;
  final int totalAmount;
  final String time;
  final String date;
  final Timestamp timeStamp;
  final bool isCompleted;
  final String shopName;
  final String shopAddress;
  final GeoPoint shopLocation;
  final String userAddress;
  final GeoPoint userLocation;

  OrderModel({
    required this.coffeeType,
    required this.numberOfShots,
    required this.isHot,
    required this.size,
    required this.roast,
    required this.artType,
    required this.beantype,
    required this.totalAmount,
    required this.time,
    required this.date,
    required this.timeStamp,
    required this.isCompleted,
    required this.shopAddress,
    required this.shopLocation,
    required this.shopName,
    required this.userAddress,
    required this.userLocation,
  });

  Map<String, dynamic> toJson() {
    return {
      'coffeeType': coffeeType,
      'numberOfShots': numberOfShots,
      'isHot': isHot,
      'size': size,
      'roast': roast,
      'artType': artType,
      'beantype': beantype,
      'totalAmount': totalAmount,
      'time': time,
      'date': date,
      'timeStamp': timeStamp,
      'isCompleted': isCompleted,
      'shopAddress': shopAddress,
      'shopLocation': shopLocation,
      'shopName': shopName,
      'userAddress': userAddress,
      'userLocation': userLocation,
    };
  }

  OrderModel.fromJson(Map<String, dynamic> json)
      : this(
          coffeeType: json['coffeeType'],
          numberOfShots: json['numberOfShots'],
          isHot: json['isHot'],
          size: json['size'],
          roast: json['roast'],
          artType: json['artType'],
          beantype: json['beantype'],
          totalAmount: json['totalAmount'],
          time: json['time'],
          date: json['date'],
          timeStamp: json['timeStamp'],
          isCompleted: json['isCompleted'],
          shopAddress: json['shopAddress'],
          shopLocation: json['shopLocation'],
          shopName: json['shopName'],
          userAddress: json['userAddress'],
          userLocation: json['userLocation'],
        );
}
