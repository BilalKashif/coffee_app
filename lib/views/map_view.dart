import 'dart:async';

import 'package:coffee_app/utils/app_theme_data.dart';
import 'package:coffee_app/utils/widgets/alert_dialogue.dart';
import 'package:coffee_app/utils/widgets/snack_bar.dart';
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

  static const CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(31.5204, 74.3587),
    zoom: 14.4746,
  );
  //----------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    MapViewModel mapViewModel =
        Provider.of<MapViewModel>(context, listen: false);
    if (mapViewModel.permissionStatus == PermissionStatus.denied) {
      mapViewModel.requestPermission();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Coffee shop'),
      ),
      body: Consumer<MapViewModel>(
        builder: (providerContext, provider, _) {
          return Stack(
            children: [
              GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: initialCameraPosition,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                markers: provider.mapMarkers,
              ),
              coffeeShopsInfoView(),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('My Location'),
        icon: SizedBox(
            height: 30,
            child: Image.asset(
              'assets/images/location_icon.png',
              color: Colors.white,
            )),
        onPressed: () async {
          showSnackBar(context: context, message: 'Getting current location');
          if (await mapViewModel.checkServieEnabled()) {
            mapViewModel.getCurrentLocation(
                controller: await _controller.future);
          } else {
            showAlertDialogue(
                context: context,
                title: 'Error',
                message: 'Location Services are not enabled.');
          }
        },
      ),
    );
  }

  Widget coffeeShopsInfoView() {
    return DraggableScrollableSheet(
      initialChildSize: 0.3,
      minChildSize: .2,
      maxChildSize: 0.5,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: grey.withOpacity(0.5),
                blurRadius: 5,
                spreadRadius: 2,
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 60.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: green,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
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
                      isRadio: false,
                      onSelected: (value, index, isSelected) {},
                      buttons: const [
                        "1 Km",
                        '5 Km',
                        '10 Km',
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
