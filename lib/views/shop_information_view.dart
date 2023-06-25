import 'package:coffee_app/data/current_user_data.dart';
import 'package:flutter/material.dart';

class ShopInformationView extends StatelessWidget {
  const ShopInformationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(CurrentUserData.selectedShop!.shopName),
      ),
    );
  }
}
