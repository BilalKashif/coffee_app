import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_app/data/current_user_data.dart';
import 'package:coffee_app/models/coffee_shop_model.dart';
import 'package:coffee_app/utils/app_theme_data.dart';
import 'package:coffee_app/utils/map_utils/distance_detector.dart';
import 'package:coffee_app/utils/map_utils/random_location_genrator.dart';
import 'package:coffee_app/utils/widgets/map_markers.dart';
import 'package:coffee_app/view_models/location_view_model.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../utils/map_utils/address_generator.dart';

class MapViewModel extends ChangeNotifier {
  //-----------------------------------------------------------------
  LocationViewModel locationViewModel = LocationViewModel();
  /*
  As this is the demo application So,I Just add three random co-ordinates 
  400m, 600m and 1000m away from the curretn detected location. Which repersents
  as a Coffee Shops nearby my location.,
  */
  List<CoffeeShopModel> fourHmShops = [];
  List<CoffeeShopModel> sixHmShops = [];
  List<CoffeeShopModel> tenHmShops = [];

  bool randomLocationsAdded = false;

  Set<Marker> mapMarkers = {};

  Set<Circle> mapCircle = {};

  //------------------------------------------------------------------

  CameraPosition initialCamerPosition() {
    GeoPoint currentUserLocation = CurrentUserData.currentUser!.addressLocation;
    return CameraPosition(
      target:
          LatLng(currentUserLocation.latitude, currentUserLocation.longitude),
      zoom: 14,
    );
  }

  Future<void> setCameraLocation(
      {required GoogleMapController controller,
      required LatLng location,
      required double zoomLevel}) async {
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: location,
          zoom: zoomLevel, // Adjust this initial zoom level as needed
        ),
      ),
    );
  }

  Future<void> setLocationMarker({required LatLng location}) async {
    mapMarkers.add(
      await getUserMarker(location: location, markerId: 'user-location'),
    );
    notifyListeners();
  }

  Future<void> setShopMarkers(
      {required List<CoffeeShopModel> shopList, required LatLng center}) async {
    mapMarkers.clear();
    setLocationMarker(location: center);
    for (CoffeeShopModel markerData in shopList) {
      mapMarkers.add(
        await getShopMarker(
          location: LatLng(markerData.shopLocation.latitude,
              markerData.shopLocation.longitude),
          markerId: markerData.shopName,
          snippet: markerData.address,
          title: markerData.shopName,
        ),
      );
    }

    notifyListeners();
  }

  void setCircle({required double radius, required LatLng center}) {
    mapCircle.clear();
    mapCircle.add(
      Circle(
        circleId: const CircleId('radius'),
        center: center,
        radius: radius,
        fillColor: green.withOpacity(0.2),
        strokeColor: green,
        strokeWidth: 1,
      ),
    );

    notifyListeners();
  }

  Future<void> setRandomLocations(LatLng center) async {
    //-----Get three random locations according to the current location and given radius
    //-----400m
    LatLng location1 = generateRandomLatLng(center, 400);
    //-----600m
    LatLng location2 = generateRandomLatLng(center, 600);
    //-----1000m
    LatLng location3 = generateRandomLatLng(center, 1000);

    //------Making Objects of each location
    CoffeeShopModel shop1 = CoffeeShopModel(
      shopName: 'Albert Coffee Shop',
      shopLocation: GeoPoint(location1.latitude, location1.longitude),
      address:
          await getLocationAddress(location1.latitude, location1.longitude),
      distance: getDistance(center.latitude, center.longitude,
          location1.latitude, location1.longitude),
    );
    //---------------------------------------------------
    CoffeeShopModel shop2 = CoffeeShopModel(
      shopName: 'Steve Coffee Shop',
      shopLocation: GeoPoint(location2.latitude, location2.longitude),
      address:
          await getLocationAddress(location2.latitude, location2.longitude),
      distance: getDistance(center.latitude, center.longitude,
          location2.latitude, location2.longitude),
    );
    //---------------------------------------------------
    CoffeeShopModel shop3 = CoffeeShopModel(
      shopName: 'Ben Coffee Shop',
      shopLocation: GeoPoint(location3.latitude, location3.longitude),
      address:
          await getLocationAddress(location3.latitude, location3.longitude),
      distance: getDistance(center.latitude, center.longitude,
          location3.latitude, location3.longitude),
    );

    fourHmShops = [shop1];
    sixHmShops = [shop1, shop2];
    tenHmShops = [shop1, shop2, shop3];

    randomLocationsAdded = true;
    notifyListeners();
  }
}
