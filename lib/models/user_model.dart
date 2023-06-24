import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userName;
  final String userEmail;
  final String userId;
  final String address;
  final String phoneNumber;
  final int loyalityPoints;
  final int loyalityCardNumber;
  final int cardCurrentCount;
  final GeoPoint addressLocation;
  final bool isAddressSetted;
  UserModel({
    required this.userName,
    required this.userEmail,
    required this.userId,
    required this.address,
    required this.phoneNumber,
    required this.loyalityPoints,
    required this.loyalityCardNumber,
    required this.cardCurrentCount,
    required this.addressLocation,
    required this.isAddressSetted,
  });

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'userEmail': userEmail,
      'userId': userId,
      'address': address,
      'phoneNumber': phoneNumber,
      'loyalityPoints': loyalityPoints,
      'loyalityCardNumber': loyalityCardNumber,
      'cardCurrentCount': cardCurrentCount,
      'addressLocation': addressLocation,
      'isAddressSetted': isAddressSetted,
    };
  }

  UserModel.fromJson(Map<String, dynamic> json)
      : this(
          userName: json['userName'] as String,
          userEmail: json['userEmail'] as String,
          userId: json['userId'] as String,
          address: json['address'],
          phoneNumber: json['phoneNumber'],
          loyalityPoints: json['loyalityPoints'],
          loyalityCardNumber: json['loyalityCardNumber'],
          cardCurrentCount: json['cardCurrentCount'],
          addressLocation: json['addressLocation'],
          isAddressSetted: json['isAddressSetted'],
        );
}
