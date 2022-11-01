//import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sekkah_app/others/map_controller.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:sekkah_app/Homepage/widget/panel_widget.dart';
import 'package:sekkah_app/others/constants.dart';
import '../helpers/stations_model.dart';
import '../others/auth_controller.dart';

class ViewMap extends StatefulWidget {
  const ViewMap({Key? key}) : super(key: key);

  @override
  State<ViewMap> createState() => _ViewMap();
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
      floatingActionButton:
          CustomFloatingActionButton(showMarkers: showMarkers),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
      body: SlidingUpPanel(
        color: Colors.grey.shade100,
        controller: panelController,
        maxHeight: panelHeightOpen,
        minHeight: panelHeightClosed,
        parallaxEnabled: false,
        parallaxOffset: .5,
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<Stations>?>(
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

                    // print(controller.allStations);

                    return FutureBuilder<void>(
                        future:
                            controller.markers.isEmpty ? initMarkers() : null,
                        builder: (context, markersSnapshot) {
                          if (markersSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          return Obx(() {
                            return GoogleMap(
                                polylines: controller.polyline,
                                markers: showMarkers.value
                                    ? Set<Marker>.of(controller.markers.values)
                                    : Set<Marker>.of(
                                        controller.emptyMarkers.values),
                                initialCameraPosition: const CameraPosition(
                                  target: LatLng(
                                      24.71619956670347, 46.68385748947401),
                                  zoom: 11,
                                ),
                                zoomControlsEnabled: false,
                                zoomGesturesEnabled: true,
                                // mapToolbarEnabled: ,
                                onMapCreated:
                                    (GoogleMapController controller) async {
                                  String style =
                                      await DefaultAssetBundle.of(context)
                                          .loadString('assets/mapstyle.json');
                                  //customize your map style at: https://mapstyle.withgoogle.com/
                                  controller.setMapStyle(style);

                                  _mapController = controller;

                                  //polylines: _polyline,
                                });
                          });
                        });
                  })),
            ),
            Container(
              color: Colors.transparent,
              height: Get.height * 0.15,
              width: Get.width,
            )
          ],
        ),
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

class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton({
    Key? key,
    required this.showMarkers,
  }) : super(key: key);

  final RxBool showMarkers;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FloatingActionButton(
          onPressed: () async {
            await AuthController().signOut();
          },
          backgroundColor: blueColor,
          child: FirebaseAuth
                  .instance.currentUser!.isAnonymous // guest = anonymous
              ? const Icon(
                  Icons.person_add_alt,
                  size: 26.0,
                )
              : const Icon(Icons.logout_rounded),
        ),
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12),
            // ignore: prefer_const_literals_to_create_immutables
            boxShadow: [
              const BoxShadow(
                  color: greyColor,
                  blurRadius: 5,
                  spreadRadius: 1,
                  offset: Offset(4, 4)),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  showMarkers.value = !showMarkers.value;
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 27,
                      width: 27,
                      child: Image.asset("assets/images/metro.png"),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    const Text("Metro\n Station",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: blueColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12.5)),
                  ],
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              InkWell(
                onTap: () {},
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 27,
                      width: 27,
                      child: Image.asset("assets/images/bus.png"),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    const Text("Bus\n Station",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: greenColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12.5)),
                  ],
                ),
              ),
              const SizedBox(
                width: 18,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
