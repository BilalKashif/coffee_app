import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';

double generateRandomOffset() {
  // Generate a random number between -1 and 1
  return (Random().nextDouble() * 2) - 1;
}

LatLng generateRandomLatLng(LatLng center, double radius) {
  // Earth's mean radius in meters
  const double earthRadius = 6371000;

  // Convert the latitude and longitude to radians
  double centerLatRad = center.latitude * pi / 180;
  double centerLngRad = center.longitude * pi / 180;

  // Generate random angle for bearing
  double angle = Random().nextDouble() * 2 * pi;

  // Calculate the distance as a fraction of the Earth's circumference
  double distance = radius / earthRadius;

  // Calculate the new latitude and longitude using the Haversine formula
  double newLatRad = asin(sin(centerLatRad) * cos(distance) +
      cos(centerLatRad) * sin(distance) * cos(angle));
  double newLngRad = centerLngRad +
      atan2(sin(angle) * sin(distance) * cos(centerLatRad),
          cos(distance) - sin(centerLatRad) * sin(newLatRad));

  // Convert the new latitude and longitude back to degrees
  double newLat = newLatRad * 180 / pi;
  double newLng = newLngRad * 180 / pi;

  return LatLng(newLat, newLng);
}
