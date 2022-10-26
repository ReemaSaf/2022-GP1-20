import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:sekkah_app/Register/signup_screen.dart';
import 'package:sekkah_app/others/auth_controller.dart';
import 'package:sekkah_app/others/constants.dart';
import '../helpers/map_locations.dart';

class ViewMap extends StatefulWidget {
  const ViewMap({Key? key}) : super(key: key);

  @override
  State<ViewMap> createState() => _ViewMap();
}

class _ViewMap extends State<ViewMap> {
  // ignore: unused_field
  late GoogleMapController _mapController;
  // ignore: prefer_final_fields
  Map<String, Marker> _marker = {};

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (user.email != null) {
            await AuthController().signOut();
          } else {
            await AuthController().signOut();
            Get.to(const SignUpScreen());
          }
        },
        backgroundColor: blueColor,
        child: const Icon(Icons.logout_rounded),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(24.71619956670347, 46.68385748947401),
          zoom: 11,
        ),
        onMapCreated: (controller) async {
          String style = await DefaultAssetBundle.of(context)
              .loadString('assets/mapstyle.json');
          //customize your map style at: https://mapstyle.withgoogle.com/
          controller.setMapStyle(style);

          _mapController = controller;

          addMarker('Khurais_Road', MapLocations.Khurais_Road);
          addMarker('Al_Hamra', MapLocations.Al_Hamra);
          addMarker('King_Saud_University', MapLocations.King_Saud_University);
          addMarker('MOE', MapLocations.MOE);
          addMarker('STC', MapLocations.STC);
          addMarker('Ar_Rabi', MapLocations.Ar_Rabi);
          addMarker('King_Abdullah_Financial_District',
              MapLocations.King_Abdullah_Financial_District);
          addMarker('Yarmuk', MapLocations.Yarmuk);
          addMarker('Qasr_AlHukm', MapLocations.Qasr_AlHukm);
          addMarker('Olaya', MapLocations.Olaya);
          addMarker('An_Nuzhah', MapLocations.An_Nuzhah);
          addMarker('Ad_Douh', MapLocations.Ad_Douh);
          addMarker('DK', MapLocations.DK);
          addMarker('DK2', MapLocations.DK2);
          addMarker('AlRajhi_Grand_Mosque', MapLocations.AlRajhi_Grand_Mosque);
          addMarker('Othman_Bin_Affan', MapLocations.Othman_Bin_Affan);
          addMarker('DK3', MapLocations.DK3);
          addMarker('Tuwaiq', MapLocations.Tuwaiq);
          addMarker('Garanada_Mall', MapLocations.Garanada_Mall);
          addMarker('King_Abdulaziz_Road', MapLocations.King_Abdulaziz_Road);
          addMarker('Harun_AlRasheed', MapLocations.Harun_AlRasheed);
          addMarker('King_Abdullah_Road', MapLocations.King_Abdullah_Road);
          addMarker('AlImam_Hospital', MapLocations.AlImam_Hospital);
          addMarker('King_Khalid_Airport_Terminal_1_2',
              MapLocations.King_Khalid_Airport_Terminal_1_2);
          addMarker('King_Khalid_Airport_Terminal_3_4',
              MapLocations.King_Khalid_Airport_Terminal_3_4);
          addMarker(
              'Hassan_Ibn_Tahit_Street', MapLocations.Hassan_Ibn_Tahit_Street);
          addMarker('West_Station', MapLocations.West_Station);
          addMarker('AlSahafah', MapLocations.AlSahafah);
          addMarker('Khalid_Ibn_AlWaleed_Road',
              MapLocations.Khalid_Ibn_AlWaleed_Road);
          addMarker('National_Museum', MapLocations.National_Museum);
          addMarker('DK4', MapLocations.DK4);
          addMarker('Passport_Department', MapLocations.Passport_Department);
          addMarker('AlNaseem', MapLocations.AlNaseem);
          addMarker('DK5', MapLocations.DK5);
          addMarker('Sultanah', MapLocations.Sultanah);
          addMarker('AlDar_AlBaidha', MapLocations.AlDar_AlBaidha);
          addMarker(
              'First_Industrial_City', MapLocations.First_Industrial_City);
          addMarker('DK6', MapLocations.DK6);
          addMarker('AlHilla', MapLocations.AlHilla);
          addMarker('Aziziyah', MapLocations.Aziziyah);
          addMarker('Officers_Club', MapLocations.Officers_Club);
          addMarker('AlKhaleej', MapLocations.AlKhaleej);
          addMarker('SAPTCO', MapLocations.SAPTCO);
          addMarker('Southern_Ring_Road', MapLocations.Southern_Ring_Road);
          addMarker('Jarir', MapLocations.Jarir);
          addMarker('DK8', MapLocations.DK8);
          addMarker('Skirinah', MapLocations.Skirinah);
          addMarker('Manfouhah', MapLocations.Manfouhah);
          addMarker('AlMargab', MapLocations.AlMargab);
          addMarker('AlJaradiyah', MapLocations.AlJaradiyah); //51
        },
        markers: _marker.values.toSet(),
      ),
    );
  }

  addMarker(String id, LatLng location) async {
    var markerIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      'assets/images/metroIcon.png',
    );
    var marker = Marker(
      markerId: MarkerId(id),
      position: location,
      infoWindow: InfoWindow(
        title: id,
        //snippet: id,
      ),
      icon: markerIcon,
    );
    _marker[id] = marker;
    setState(() {});
  }
}
