
// ignore_for_file: non_constant_identifier_names, file_names, duplicate_ignore

import 'package:location/location.dart';

Future<double> CurrentLocationLng() async {
  LocationData? currentLocation;
  Location location = Location();
  await location.getLocation().then((location) {
    currentLocation = location;
  });
  return currentLocation!.longitude!;
}
Future<double> CurrentLocationLat() async {
  LocationData? currentLocation;
  Location location = Location();
  await location.getLocation().then((location) {
    currentLocation = location;
  });
  return currentLocation!.latitude!;
}