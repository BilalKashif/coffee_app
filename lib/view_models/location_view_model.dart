import 'package:coffee_app/data/app_exceptions.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

import '../utils/map_utils/address_generator.dart';

enum LocationServiceState {
  enabled,
  disabled,
}

enum FetchingLocationState {
  idle,
  loading,
  completed,
}

class LocationViewModel extends ChangeNotifier {
  //-----------------------------------------------------------------------
  Location locationService = Location();
  PermissionStatus permissionStatus = PermissionStatus.denied;
  LocationServiceState locationServiceState = LocationServiceState.disabled;
  FetchingLocationState fetchingLocationState = FetchingLocationState.idle;

  LocationData? currentLocationData;
  String? locationAddress;
  //----------------------------------------------------------------------

  Future<void> requestPermission() async {
    permissionStatus = await locationService.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await locationService.requestPermission();
      notifyListeners();
      if (permissionStatus != PermissionStatus.granted) {
        return;
      }
    }
  }

  Future<void> isServieEnabled() async {
    bool isServiceEnabled = await locationService.serviceEnabled();
    if (!isServiceEnabled) {
      isServiceEnabled = await locationService.requestService();
      if (!isServiceEnabled) {
        locationServiceState = LocationServiceState.disabled;
        notifyListeners();
      } else {
        locationServiceState = LocationServiceState.enabled;
        notifyListeners();
      }
    } else {
      locationServiceState = LocationServiceState.enabled;
      notifyListeners();
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      fetchingLocationState = FetchingLocationState.loading;
      notifyListeners();
      currentLocationData = await locationService.getLocation();
      locationAddress = await getLocationAddress(
          currentLocationData!.latitude!, currentLocationData!.longitude!);
      fetchingLocationState = FetchingLocationState.completed;
      notifyListeners();
    } catch (error) {
      throw CustomException(error.toString(), 'Error while fetching locaton');
    }
  }



}
