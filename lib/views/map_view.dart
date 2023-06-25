import 'dart:async';

import 'package:coffee_app/models/coffee_shop_model.dart';
import 'package:coffee_app/utils/app_theme_data.dart';
import 'package:coffee_app/utils/widgets/alert_dialogue.dart';
import 'package:coffee_app/utils/widgets/snack_bar.dart';
import 'package:coffee_app/view_models/location_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:group_button/group_button.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import '../view_models/map_view_model.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  //--------------Google map instences------------------------------------
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  List<CoffeeShopModel> nearByShops = [];

  @override
  Widget build(BuildContext context) {
    LocationViewModel locationViewModel =
        Provider.of<LocationViewModel>(context);
    //-------------------------------------------------------------

    if (locationViewModel.permissionStatus == PermissionStatus.denied ||
        locationViewModel.locationServiceState ==
            LocationServiceState.disabled) {
      locationViewModel.requestPermission();
      locationViewModel.isServieEnabled();
    }

    //------------------------------------------------------------

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Coffee shop'),
      ),
      body: Consumer<MapViewModel>(
        builder: (providerContext, provider, _) {
          return Column(
            children: [
              SizedBox(
                height: 450.h,
                width: double.infinity,
                child: Stack(
                  children: [
                    GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: provider.initialCamerPosition(),
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                      markers: provider.mapMarkers,
                      circles: provider.mapCircle,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20, bottom: 20),
                        child: FloatingActionButton.extended(
                          label: const Text('My Location'),
                          icon: SizedBox(
                              height: 30,
                              child: Image.asset(
                                'assets/images/location_icon.png',
                                color: Colors.white,
                              )),
                          onPressed: () async {
                            showSnackBar(
                                context: context,
                                message: 'Finding location Please wait.');
                            if (locationViewModel.locationServiceState ==
                                LocationServiceState.enabled) {
                              GoogleMapController mapController =
                                  await _controller.future;
                              await locationViewModel.getCurrentLocation();
                              LatLng currentLocation = LatLng(
                                  locationViewModel
                                      .currentLocationData!.latitude!,
                                  locationViewModel
                                      .currentLocationData!.longitude!);
                              provider.setCameraLocation(
                                controller: mapController,
                                location: currentLocation,
                                zoomLevel: 17,
                              );
                              provider.setLocationMarker(
                                  location: currentLocation);
                              if (!provider.randomLocationsAdded) {
                                await provider
                                    .setRandomLocations(currentLocation);
                              }
                            } else {
                              showAlertDialogue(
                                  context: context,
                                  title: 'Location Error',
                                  message: 'Location Service is not Enabled');
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: !provider.randomLocationsAdded
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 50,
                                color: green,
                              ),
                              const Text('Find Current Location First'),
                            ],
                          ),
                        )
                      : locationViewModel.locationServiceState ==
                              LocationServiceState.disabled
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.location_off,
                                    size: 50,
                                    color: green,
                                  ),
                                  const Text('Location is not Enabled.'),
                                ],
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  height: 60.h,
                                  color: green,
                                  child: Center(
                                    child: Text(
                                      'Nearby Shops',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Max Distance',
                                        style: TextStyle(
                                          color: black,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Expanded(child: SizedBox()),
                                      GroupButton(
                                        isRadio: true,
                                        onSelected:
                                            (value, index, isSelected) async {
                                          LatLng currentLocation = LatLng(
                                              locationViewModel
                                                  .currentLocationData!
                                                  .latitude!,
                                              locationViewModel
                                                  .currentLocationData!
                                                  .longitude!);
                                          double radius = 0;
                                          double zoomLevel = 0;
                                          GoogleMapController mapController =
                                              await _controller.future;
                                          if (index == 0) {
                                            nearByShops = provider.fourHmShops;
                                            radius = 400;
                                            zoomLevel = 15.8;
                                          } else if (index == 1) {
                                            nearByShops = provider.sixHmShops;
                                            radius = 600;
                                            zoomLevel = 15;
                                          } else {
                                            nearByShops = provider.tenHmShops;
                                            radius = 1000;
                                            zoomLevel = 14;
                                          }
                                          await provider.setCameraLocation(
                                              controller: mapController,
                                              location: currentLocation,
                                              zoomLevel: zoomLevel);
                                          await provider.setShopMarkers(
                                              shopList: nearByShops,
                                              center: currentLocation);
                                          provider.setCircle(
                                              radius: radius,
                                              center: currentLocation);
                                          setState(() {});
                                        },
                                        buttons: const [
                                          "400 m",
                                          '600 m',
                                          '1000 m',
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    itemCount: nearByShops.length,
                                    separatorBuilder: (_, __) =>
                                        const Divider(),
                                    itemBuilder: (context, int index) {
                                      return shopTiles(
                                        shopName: nearByShops[index].shopName,
                                        shopAddress: nearByShops[index].address,
                                        shopDistance: nearByShops[index]
                                            .distance
                                            .toStringAsFixed(1),
                                      );
                                    },
                                  ),
                                )
                              ],
                            ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget shopTiles({
    required String shopName,
    required String shopAddress,
    required String shopDistance,
  }) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: green,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SizedBox(
                height: 15,
                child: Image.asset(
                  'assets/images/shop_icon.png',
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$shopName $shopDistance m',
                style: TextStyle(
                  color: green,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(
                width: 220.w,
                child: Text(
                  shopAddress,
                  style: TextStyle(
                    color: grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
          const Expanded(child: SizedBox()),
          OutlinedButton(
            onPressed: () {},
            child: const Text('Select'),
          )
        ],
      ),
    );
  }
}
