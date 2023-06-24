import 'package:cloud_firestore/cloud_firestore.dart';

class CoffeeShopModel {
  final String shopName;
  final GeoPoint shopLocation;

  CoffeeShopModel({
    required this.shopName,
    required this.shopLocation,
  });

  Map<String, dynamic> toJson() {
    return {
      'shopName': shopName,
      'shopLocation': shopLocation,
    };
  }

  CoffeeShopModel.fromJson(Map<String, dynamic> json)
      : this(
          shopName: json['shopName'],
          shopLocation: json['shopLocation'],
        );
}
