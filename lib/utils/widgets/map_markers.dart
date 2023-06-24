import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<Marker> getUserMarker(
    {required LatLng location,
    required String markerId,
    String? title,
    String? snippet}) async {
  ByteData imageData =
      await rootBundle.load('assets/images/current_location_marker.png');
  Uint8List byteList = imageData.buffer.asUint8List();
  return Marker(
    markerId: MarkerId(markerId),
    position: location,
    icon: BitmapDescriptor.fromBytes(byteList, size: const Size(30, 30)),
    infoWindow: InfoWindow(
      title: title,
      snippet: snippet,
    ),
  );
}
