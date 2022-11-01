// ignore_for_file: unused_local_variable

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sekkah_app/others/map_controller.dart';
import 'package:sekkah_app/helpers/stations_model.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
// ignore: unused_import
import '../others/auth_controller.dart';
import '../others/constants.dart';
import 'widget/panel_widget.dart';

class ViewMap extends StatefulWidget {
  const ViewMap({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ViewMap createState() => _ViewMap();
}

class _ViewMap extends State<ViewMap> {
  final panelController = PanelController();

  // ignore: unused_field
  late GoogleMapController _mapController;
  MapStationsController controller = Get.put(MapStationsController());
  @override
  void initState() {
    super.initState();
  }

  RxBool showMarkers = true.obs;
  final panelHeightClosed = Get.height * 0.1;
  final panelHeightOpen = Get.height * 0.7;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await AuthController().signOut();
          // showMarkers.value = !showMarkers.value;

          // log(controller.route1Stations.length.toString());
          // log(controller.route2Stations.length.toString());
          // log(controller.route3Stations.length.toString());
          // log(controller.route4Stations.length.toString());
          // log(controller.route5Stations.length.toString());
          // log(controller.route6Stations.length.toString());
        },
        backgroundColor: blueColor,
        child: const Icon(Icons.login_rounded),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
      body: SlidingUpPanel(
        controller: panelController,
        maxHeight: panelHeightOpen,
        minHeight: panelHeightClosed,
        parallaxEnabled: true,
        parallaxOffset: .5,
        body: StreamBuilder<List<Stations>?>(
            initialData: controller.allStations,
            stream: controller.getAllStations(),
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              controller.setAllStations = snapshot.data ?? [];
              if (controller.allStations.isNotEmpty) {
                initMarkers();
              }
              // ignore: avoid_print
              // print(controller.allStations);

              return FutureBuilder<void>(
                  future: controller.markers.isEmpty ? initMarkers() : null,
                  builder: (context, markersSnapshot) {
                    if (markersSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return Obx(() {
                      return GoogleMap(
                          polylines: controller.polyline,
                          markers: showMarkers.value
                              ? Set<Marker>.of(controller.markers.values)
                              : Set<Marker>.of(controller.emptyMarkers.values),
                          initialCameraPosition: const CameraPosition(
                            target:
                                LatLng(24.71619956670347, 46.68385748947401),
                            zoom: 11,
                          ),
                          // polylines: ,
                          onMapCreated: (GoogleMapController controller) async {
                            String style = await DefaultAssetBundle.of(context)
                                .loadString('assets/mapstyle.json');
                            //customize your map style at: https://mapstyle.withgoogle.com/
                            controller.setMapStyle(style);

                            _mapController = controller;

                            //polylines: _polyline,
                          });
                    });
                  });
            })),
        panelBuilder: (controller) => PanelWidget(
          controller: controller,
          panelController: panelController,
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
      ),
    );
  }

  Future<void> initMarkers() async {
    controller.allStations.isEmpty ? null : await 2.seconds.delay();
    await controller.getAllContains();
    await controller.getAllLines();
    controller.setPolyLineData();
    for (var element in controller.allStations) {
      controller.initMarker(element, "Station_${element.ID}");
    }
  }
}
