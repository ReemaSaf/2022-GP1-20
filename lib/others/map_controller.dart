// ignore_for_file: prefer_final_fields, duplicate_ignore

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../helpers/stations_model.dart';

class MapStationsController extends GetxController {
  // ignore: prefer_final_fields
  Rx<Map<MarkerId, Marker>> _markers = Rx<Map<MarkerId, Marker>>({});
  Map<MarkerId, Marker> get markers => _markers.value;
  Rx<List<Stations>?> _allStations = Rx<List<Stations>>([]);
  List<Stations> get allStations => _allStations.value!;

  Stream<List<Stations>> getAllStations() {
    return FirebaseFirestore.instance
        .collection('Stations')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return Stations.fromMap(doc.data());
            }).toList());
  }

  void initMarker(Stations specify, String specifyId) async {
    var markerIdVal = specifyId;
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(specify.Location.latitude, specify.Location.longitude),
      infoWindow: InfoWindow(title: 'Metro Stations', snippet: specify.Name),
    );
    _markers.value[markerId] = marker;
  }

  @override
  // ignore: unnecessary_overrides
  void onInit() {
    super.onInit();
  }
}
