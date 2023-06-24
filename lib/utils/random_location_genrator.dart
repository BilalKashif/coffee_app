import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';


double generateRandomOffset() {
  // Generate a random number between -1 and 1
  return (Random().nextDouble() * 2) - 1;
}

LatLng generateRandomLatLng(LatLng center, double radius) {
  // Convert the latitude and longitude to radians
  double latRad = center.latitude * pi / 180;
  double lngRad = center.longitude * pi / 180;

  // Convert the radius from meters to degrees
  double radiusDeg = radius / 6378137 * 180 / pi;

  // Generate random offsets for latitude and longitude
  double latOffset = radiusDeg * generateRandomOffset();
  double lngOffset = radiusDeg * generateRandomOffset();

  // Calculate the new latitude and longitude
  double newLatRad = latRad + latOffset;
  double newLngRad = lngRad + lngOffset;

  // Convert the new latitude and longitude back to degrees
  double newLat = newLatRad * 180 / pi;
  double newLng = newLngRad * 180 / pi;

  return LatLng(newLat, newLng);
}
