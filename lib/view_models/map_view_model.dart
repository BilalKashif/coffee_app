import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_app/models/coffee_shop_model.dart';
import 'package:coffee_app/utils/distance_detector.dart';
import 'package:coffee_app/utils/random_location_genrator.dart';
import 'package:coffee_app/utils/widgets/map_markers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

enum LocationState {
  checking,
  enabled,
  disabled,
}

enum ShopLocation {
  oneKm,
  twoKm,
  threeKm,
}

class MapViewModel extends ChangeNotifier {
  //-----------------------------------------------------------------
  Location location = Location();
  LocationState locationState = LocationState.checking;
  PermissionStatus permissionStatus = PermissionStatus.denied;
  LatLng? currentLocation;
  //----------------------------------------------------------------

  //-------------Firebase Instances--------------------------------
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  CollectionReference coffeeShopsCollection =
      FirebaseFirestore.instance.collection('coffee_shops');
  //--------------------------------------------------------------

  /*
  As this is the demo application So, Just add three random co-ordinates 
  1km, 5km and 10km away from the curretn detected location.
  */
  bool randomLocationsAdded = false;

  Set<Marker> mapMarkers = {};

  //------------------------------------------------------------------

  List<CoffeeShopModel>? oneKmShops;
  List<CoffeeShopModel>? twoKmShops;
  List<CoffeeShopModel>? threeKmShops;

  Future<void> requestPermission() async {
    permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      notifyListeners();
      if (permissionStatus != PermissionStatus.granted) {
        return;
      }
    }
  }

  Future<bool> checkServieEnabled() async {
    bool isServiceEnabled = await location.serviceEnabled();
    if (!isServiceEnabled) {
      isServiceEnabled = await location.requestService();
      if (!isServiceEnabled) {
        locationState = LocationState.disabled;
        notifyListeners();
      } else {
        locationState = LocationState.enabled;
        notifyListeners();
      }
    }
    return isServiceEnabled;
  }

  Future<void> getCurrentLocation(
      {required GoogleMapController controller}) async {
    var locationData = await location.getLocation();

    CameraPosition newCameraPosition = CameraPosition(
      target: LatLng(locationData.latitude!, locationData.longitude!),
      zoom: 15.0,
    );
    controller.animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
    currentLocation = LatLng(locationData.latitude!, locationData.longitude!);
    mapMarkers.add(
      await getUserMarker(
        location: LatLng(locationData.latitude!, locationData.longitude!),
        markerId: 'current_location',
      ),
    );
    if (!randomLocationsAdded) {
      //-----Get three random locations according to the current location
      LatLng center = LatLng(locationData.latitude!, locationData.longitude!);
      //-----1km => 1000m
      LatLng location1 = generateRandomLatLng(center, 1000);
      //-----5km => 5000m
      LatLng location2 = generateRandomLatLng(center, 5000);
      //-----10km => 10000m
      LatLng location3 = generateRandomLatLng(center, 10000);

      await setRandomLocations(location1, location2, location3);

      randomLocationsAdded = true;
    }
    notifyListeners();
  }

  Future<void> setRandomLocations(
      LatLng location1, LatLng location2, LatLng location3) async {
    CoffeeShopModel shop1 = CoffeeShopModel(
      shopName: 'Coffee shop 1',
      shopLocation: GeoPoint(location1.latitude, location1.longitude),
    );
    CoffeeShopModel shop2 = CoffeeShopModel(
      shopName: 'Coffee shop 2',
      shopLocation: GeoPoint(location2.latitude, location2.longitude),
    );
    CoffeeShopModel shop3 = CoffeeShopModel(
      shopName: 'Coffee shop 3',
      shopLocation: GeoPoint(location3.latitude, location3.longitude),
    );

    await coffeeShopsCollection.add(shop1.toJson());
    await coffeeShopsCollection.add(shop2.toJson());
    await coffeeShopsCollection.add(shop3.toJson());
  }

  Future<void> setNearByShops({required ShopLocation shopLocation}) async {
    if (oneKmShops == null || twoKmShops == null || threeKmShops == null) {
      oneKmShops = [];
      twoKmShops = [];
      threeKmShops = [];
      QuerySnapshot querySnapshot = await coffeeShopsCollection.get();
      for (var docs in querySnapshot.docs) {
        CoffeeShopModel shopData =
            CoffeeShopModel.fromJson(docs.data() as Map<String, dynamic>);
        var shopDistance = getDistance(
          currentLocation!,
          LatLng(
              shopData.shopLocation.latitude, shopData.shopLocation.longitude),
        );
        if (shopDistance <= 1000) {
          oneKmShops!.add(shopData);
        } 
        if (shopDistance <= 5000) {
          twoKmShops!.add(shopData);
        } 
        if (shopDistance <= 10000) {
          threeKmShops!.add(shopData);
        }
      }
    }
    notifyListeners();
  }

  
}
