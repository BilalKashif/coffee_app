import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';

double rad(double x) {
  return x * pi / 180;
}

double getDistance(LatLng p1, LatLng p2) {
  const double R = 6378137; // Earth’s mean radius in meters
  double dLat = rad(p2.latitude - p1.latitude);
  double dLong = rad(p2.longitude - p1.longitude);
  double a = sin(dLat / 2) * sin(dLat / 2) +
      cos(rad(p1.latitude)) * cos(rad(p2.latitude)) * sin(dLong / 2) * sin(dLong / 2);
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));
  double d = R * c;
  return d; // returns the distance in meters
}