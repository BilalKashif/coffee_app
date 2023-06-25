import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_app/data/app_exceptions.dart';
import 'package:coffee_app/data/response/auth_status.dart';
import 'package:coffee_app/utils/widgets/alert_dialogue.dart';
import 'package:coffee_app/utils/widgets/loading_indicator.dart';
import 'package:coffee_app/utils/widgets/text_field.dart';
import 'package:coffee_app/view_models/auth_view_model.dart';
import 'package:coffee_app/view_models/location_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import '../utils/app_theme_data.dart';

class SetLocationView extends StatefulWidget {
  const SetLocationView({super.key});

  @override
  State<SetLocationView> createState() => _SetLocationViewState();
}

class _SetLocationViewState extends State<SetLocationView> {
  //--------------------------------------------------------------
  TextEditingController locationFieldController = TextEditingController();
  //--------------------------------------------------------------

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    locationFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //--------------------------------------------------------------------------
    LocationViewModel locationViewModel =
        Provider.of<LocationViewModel>(context);
    AuthViewModel authViewModel = Provider.of<AuthViewModel>(context);

    if (locationViewModel.permissionStatus == PermissionStatus.denied ||
        locationViewModel.locationServiceState ==
            LocationServiceState.disabled) {
      locationViewModel.requestPermission();
      locationViewModel.isServieEnabled();
    }

    Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments! as Map<String, dynamic>;
    //--------------------------------------------------------------------------
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 100.h),
            Text(
              'Set Location',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22.sp,
                color: black,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'Set your location and address',
              style: TextStyle(
                fontSize: 14.sp,
                color: grey,
              ),
            ),
            SizedBox(height: 48.h),
            customTextField(
              controller: locationFieldController,
              hintText: 'Address',
              prefixIconPath: 'assets/images/location_icon.png',
            ),
            SizedBox(height: 48.h),
            Center(
              child: Text(
                'Automatically Fill Address',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: grey,
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Center(
              child: OutlinedButton(
                onPressed: () async {
                  if (locationViewModel.locationServiceState ==
                      LocationServiceState.enabled) {
                    //---------Location is Enabled-----------------
                    try {
                      await locationViewModel.getCurrentLocation();
                      locationFieldController.text =
                          locationViewModel.locationAddress!;
                    } on CustomException catch (error) {
                      showAlertDialogue(
                        context: context,
                        title: error.prefix,
                        message: error.message,
                      );
                    }
                  } else {
                    showAlertDialogue(
                      context: context,
                      title: 'Location is not enabled',
                      message: 'Enable your location to continue',
                    );
                  }
                },
                child: const Text('Get My Location'),
              ),
            ),
            SizedBox(height: 48.h),
            Center(
              child: locationViewModel.fetchingLocationState ==
                          FetchingLocationState.loading ||
                      authViewModel.authStatus == AuthStatus.loading
                  ? loadingIndicator
                  : FloatingActionButton.extended(
                      onPressed: () async {
                        try {
                          await authViewModel.signUp(
                              email: arguments['email'],
                              password: arguments['password'],
                              phoneNumber: arguments['mobileNumber'],
                              addressLocation: GeoPoint(
                                  locationViewModel
                                      .currentLocationData!.latitude!,
                                  locationViewModel
                                      .currentLocationData!.longitude!),
                              address: locationViewModel.locationAddress!,
                              userName: arguments['userName']);
                        } on CustomException catch (error) {
                          showAlertDialogue(
                              context: context,
                              title: error.prefix,
                              message: error.message);
                        }
                      },
                      label: const Text('Submit and Sign in'),
                      icon: const Icon(Icons.arrow_forward),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
