import 'package:geocoding/geocoding.dart';

import '../../data/app_exceptions.dart';

Future<String> getLocationAddress(double latitude, double longitude) async {
  String address;
  try {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
    Placemark place = placemarks[0]; // Select the first placemark

    address =
        '${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}';
  } catch (error) {
    return 'Address Not found';
  }
  return address;
}
