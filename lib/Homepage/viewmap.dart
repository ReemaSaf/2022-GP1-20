import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sekkah_app/others/map_controller.dart';
import 'package:sekkah_app/helpers/stations_model.dart';
import 'package:sekkah_app/others/auth_controller.dart';
import '../others/constants.dart';

class ViewMap extends StatefulWidget {
  const ViewMap({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ViewMap createState() => _ViewMap();
}

class _ViewMap extends State<ViewMap> {
  // ignore: unused_field
  late GoogleMapController _mapController;
  MapStationsController controller = Get.put(MapStationsController());
  // MapStationsController mapController = Get.put(MapStationsController());
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Map'),
      //   backgroundColor: Colors.blue,
      //   elevation: 0,
      //   actions: [
      //     TextButton(
      //         onPressed: () => AuthController().signOut(),
      //         child: const Text(
      //           "Signout",
      //           style: TextStyle(color: Colors.white),
      //         ))
      //   ],
      // ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => AuthController().signOut(),
        backgroundColor: blueColor,
        child: const Icon(Icons.logout_rounded),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,

      body: StreamBuilder<List<Stations>?>(
          stream: controller.getAllStations(),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            controller.setAllStations = snapshot.data ?? [];
            // ignore: avoid_print
            print(controller.allStations);

            return GoogleMap(
                markers: Set<Marker>.of(controller.markers.values),
                initialCameraPosition: const CameraPosition(
                  target: LatLng(24.71619956670347, 46.68385748947401),
                  zoom: 12,
                ),
                onMapCreated: (GoogleMapController controller) async {
                  String style = await DefaultAssetBundle.of(context)
                      .loadString('assets/mapstyle.json');
                  //customize your map style at: https://mapstyle.withgoogle.com/
                  controller.setMapStyle(style);

                  _mapController = controller;

                  //polylines: _polyline,
                });
          })),
    );
  }
}

//    final Set<Polyline> _polyline = {};


//     List<LatLng> red_line = [];
//     List<LatLng> orange_line = [];
//      List<LatLng> purple_line = [];
//      List<LatLng> green_line = [];
//      List<LatLng> blue_line = [];
//       List<LatLng> yellow_line = [];


//        _polyline.add(
//       Polyline(
//           polylineId: PolylineId('1'), points: red_line, color: Colors.red),
//     );

//     _polyline.add(Polyline(
//         polylineId: const PolylineId('2'),
//         points: orange_line,
//         color: Colors.orange));

//     _polyline.add(Polyline(
//         polylineId: const PolylineId('3'),
//         points: purple_line,
//         color: Colors.purple));

//     _polyline.add(Polyline(
//         polylineId: const PolylineId('4'),
//         points: green_line,
//         color: Colors.green));

//     _polyline.add(Polyline(
//         polylineId: const PolylineId('5'),
//         points: blue_line,
//         color: Colors.blue));

//     _polyline.add(Polyline(
//         polylineId: PolylineId('6'),
//         points: yellow_line,
//         color: Colors.yellow));

//     _polyline.add(Polyline(
//         polylineId: PolylineId('6'),
//         points: yellow_line,
//         color: Colors.yellow));
// 
