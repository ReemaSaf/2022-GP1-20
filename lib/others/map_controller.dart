import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../helpers/stations_model.dart';

class MapStationsController extends GetxController {
  Rx<Map<MarkerId, Marker>> _markers = Rx<Map<MarkerId, Marker>>({});
  Map<MarkerId, Marker> get markers => _markers.value;
  Rx<List<Stations>> _allStations = Rx<List<Stations>>([]);
  List<Stations> get allStations => _allStations.value;
  set setAllStations(List<Stations> value) => _allStations.value = value;

  Stream<List<Stations>> getAllStations() {
    return FirebaseFirestore.instance
        .collection('Stations')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return Stations.fromMap(doc.data());
            }).toList());
  }

  void initMarker(Stations specify, String specifyId) async {
    var markerIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      'assets/images/Itemmetro.png',
    );
    var markerIdVal = specifyId;
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(specify.Location.latitude, specify.Location.longitude),
      infoWindow: InfoWindow(title: 'Metro Station', snippet: specify.Name),
      icon: markerIcon,
    );
    _markers.value[markerId] = marker;
  }

  @override
  void onReady() {
    // it alwasy runs after on init
    ever<List<Stations>?>(_allStations, (val) {
      // whenever the _allStations will get any value, this method will trigger
      for (var element in val!) {
        initMarker(element, "Station_${element.ID}");
      }
    });
    super.onReady();
  }
}
