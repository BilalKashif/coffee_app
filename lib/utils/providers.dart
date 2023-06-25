import 'package:coffee_app/view_models/map_view_model.dart';
import 'package:coffee_app/view_models/profile_view_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../view_models/auth_view_model.dart';
import '../view_models/location_view_model.dart';

List<SingleChildWidget> providers = [
  ChangeNotifierProvider<AuthViewModel>(create: (context) => AuthViewModel()),
  ChangeNotifierProvider<ProfileViewModel>(
      create: (context) => ProfileViewModel()),
  ChangeNotifierProvider<MapViewModel>(create: (context) => MapViewModel()),
  ChangeNotifierProvider<LocationViewModel>(create: (context) => LocationViewModel()),
];
