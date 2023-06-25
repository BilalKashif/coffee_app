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

  // Generate random distance within the given radius
  double distance = sqrt(Random().nextDouble()) * radius;

  // Generate random bearing angle
  double bearing = Random().nextDouble() * 2 * pi;

  // Calculate the new latitude and longitude using Vincenty's formulae
  double latRad = asin(sin(centerLatRad) * cos(distance / earthRadius) +
      cos(centerLatRad) * sin(distance / earthRadius) * cos(bearing));
  double lngRad = centerLngRad +
      atan2(sin(bearing) * sin(distance / earthRadius) * cos(centerLatRad),
          cos(distance / earthRadius) - sin(centerLatRad) * sin(latRad));

  // Convert the new latitude and longitude back to degrees
  double newLat = latRad * 180 / pi;
  double newLng = lngRad * 180 / pi;

  return LatLng(newLat, newLng);
}
