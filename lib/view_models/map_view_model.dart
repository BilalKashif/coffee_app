import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_app/data/current_user_data.dart';
import 'package:coffee_app/models/coffee_shop_model.dart';
import 'package:coffee_app/utils/app_theme_data.dart';
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
  threeKm,
  fiveKm,
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
  WriteBatch batch = FirebaseFirestore.instance.batch();
  //--------------------------------------------------------------

  /*
  As this is the demo application So, Just add three random co-ordinates 
  1km, 5km and 10km away from the curretn detected location.
  */
  bool randomLocationsAdded = false;

  Set<Marker> mapMarkers = {};

  Set<Circle> mapCircle = {};

  ShopLocation selectedLocation = ShopLocation.oneKm;

  List<CoffeeShopModel>? selectedShopList;

  //------------------------------------------------------------------

  List<CoffeeShopModel>? oneKmShops;
  List<CoffeeShopModel>? threeKmShops;
  List<CoffeeShopModel>? fiveKmShops;

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
    currentLocation = LatLng(locationData.latitude!, locationData.longitude!);
    CurrentUserData.currentUser!.addressLocation =
        GeoPoint(locationData.latitude!, locationData.longitude!);
    if (!randomLocationsAdded) {
      //-----Get three random locations according to the current location
      LatLng center = LatLng(locationData.latitude!, locationData.longitude!);
      //-----1km => 1000m
      LatLng location1 = generateRandomLatLng(center, 1000);
      //-----5km => 5000m
      LatLng location2 = generateRandomLatLng(center, 3000);
      //-----10km => 10000m
      LatLng location3 = generateRandomLatLng(center, 5000);

      await setRandomLocations(location1, location2, location3);

      await setNearByShops();

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

    QuerySnapshot querySnapshot = await coffeeShopsCollection.get();
    for (var document in querySnapshot.docs) {
      batch.delete(document.reference);
    }
    await batch.commit();

    await coffeeShopsCollection.add(shop1.toJson());
    await coffeeShopsCollection.add(shop2.toJson());
    await coffeeShopsCollection.add(shop3.toJson());
  }

  Future<void> setNearByShops() async {
    if (oneKmShops == null || threeKmShops == null || fiveKmShops == null) {
      oneKmShops = [];
      threeKmShops = [];
      fiveKmShops = [];
      QuerySnapshot querySnapshot = await coffeeShopsCollection.get();
      for (var docs in querySnapshot.docs) {
        CoffeeShopModel shopData =
            CoffeeShopModel.fromJson(docs.data() as Map<String, dynamic>);
        var shopDistance = getDistance(
          currentLocation!.latitude,
          currentLocation!.longitude,
          shopData.shopLocation.latitude,
          shopData.shopLocation.longitude,
        );
        print('shop Distance: $shopDistance');
        if (shopDistance <= 1001) {
          oneKmShops!.add(shopData);
        }
        if (shopDistance <= 3001) {
          threeKmShops!.add(shopData);
        }
        if (shopDistance <= 5001) {
          fiveKmShops!.add(shopData);
        }
      }
    }
    notifyListeners();
  }

  Future<void> setMarkers(
      ShopLocation location, GoogleMapController controller) async {
    mapCircle.clear();
    selectedShopList = [];
    double radius = 0;
    if (location == ShopLocation.oneKm) {
      print(controller.getZoomLevel());
      radius = 1000;
      selectedShopList = oneKmShops!;
    } else if (location == ShopLocation.threeKm) {
      radius = 3000;
      selectedShopList = threeKmShops!;
    } else if (location == ShopLocation.fiveKm) {
      radius = 5000;
      selectedShopList = fiveKmShops!;
    }
    mapMarkers.clear();
    mapMarkers.add(
      await getUserMarker(
          location: currentLocation!, markerId: 'user-location'),
    );
    for (CoffeeShopModel markerData in selectedShopList!) {
      mapMarkers.add(
        await getShopMarker(
          location: LatLng(markerData.shopLocation.latitude,
              markerData.shopLocation.longitude),
          markerId: markerData.shopName,
          snippet: markerData.shopName,
        ),
      );
    }
    mapCircle.add(Circle(
        circleId: const CircleId('radius'),
        fillColor: green.withOpacity(0.2),
        strokeColor: green,
        strokeWidth: 1,
        center: currentLocation!,
        radius: radius));
    notifyListeners();
  }
}
