import 'package:coffee_app/utils/app_theme_data.dart';
import 'package:flutter/material.dart';

Widget coffeeArtWidget({required int index, required int selectedIndex}) {
  return Padding(
    padding: const EdgeInsets.all(5.0),
    child: Container(
      decoration: BoxDecoration(
        border: index == selectedIndex
            ? Border.all(
                color: green,
                width: 1,
              )
            : null,
        borderRadius: BorderRadius.circular(25),
        image: DecorationImage(
          image: AssetImage('assets/images/art_img$index.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    ),
  );
}
