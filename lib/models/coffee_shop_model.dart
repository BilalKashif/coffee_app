import 'package:cloud_firestore/cloud_firestore.dart';

class CoffeeShopModel {
  String shopName;
  String address;
  double distance;
  GeoPoint shopLocation;

  CoffeeShopModel({
    required this.shopName,
    required this.shopLocation,
    required this.address,
    required this.distance,
  });

  Map<String, dynamic> toJson() {
    return {
      'shopName': shopName,
      'shopLocation': shopLocation,
      'address': address,
      'distance': distance,
    };
  }

  CoffeeShopModel.fromJson(Map<String, dynamic> json)
      : this(
          shopName: json['shopName'],
          shopLocation: json['shopLocation'],
          address: json['address'],
          distance: json['distance'],
        );
}
