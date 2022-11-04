//import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:sekkah_app/helpers/bus_station_model.dart';
import 'package:sekkah_app/others/map_controller.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:sekkah_app/Homepage/widget/panel_widget.dart';
import 'package:sekkah_app/others/constants.dart';
import '../helpers/metro_station_model.dart';
import '../others/auth_controller.dart';
import 'providers/locationProvier.dart';

class ViewMap extends StatefulWidget {
  const ViewMap({Key? key}) : super(key: key);

  @override
  State<ViewMap> createState() => _ViewMap();
}

class _ViewMap extends State<ViewMap> {
  final panelController = PanelController();

  late GoogleMapController _mapController;
  MapStationsController controller = Get.put(MapStationsController());
  BitmapDescriptor? icon;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await setUserMarker();
    });
  }

  RxBool showMetro = true.obs;
  RxBool showBus = true.obs;
  final panelHeightClosed = Get.height * 0.11;
  final panelHeightOpen = Get.height * 0.7;
  Rx<MarkersToShow> markersType = MarkersToShow.both.obs;
  final provider = Get.put(LocationProvider());
  void setMarkersToShow() {
    if (showMetro.value && showBus.value) {
      markersType.value = MarkersToShow.both;
    } else if (showMetro.value && !showBus.value) {
      markersType.value = MarkersToShow.metro;
    } else if (!showMetro.value && showBus.value) {
      markersType.value = MarkersToShow.bus;
    } else if (!showMetro.value && !showBus.value) {
      markersType.value = MarkersToShow.none;
    }
  }

  Future<void> setUserMarker() async {
    await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), 'assets/images/icons.png')
        .then((value) {
      icon = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FirebaseAuth.instance.currentUser!.isAnonymous
              ? const SizedBox()
              : FloatingActionButton(
                  onPressed: () async {
                    await AuthController().signOut();
                  },
                  backgroundColor: blueColor,
                  child: const Icon(Icons.logout_rounded),
                ),
          Obx(() => Container(
                padding: const EdgeInsets.all(3),
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
                    Container(
                      color: showMetro.value
                          ? Colors.grey.withOpacity(0.3)
                          : Colors.white,
                      child: InkWell(
                        onTap: () {
                          showMetro.value = !showMetro.value;
                          setMarkersToShow();
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
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Container(
                      color: showBus.value
                          ? Colors.grey.withOpacity(0.3)
                          : Colors.white,
                      child: InkWell(
                        onTap: () {
                          showBus.value = !showBus.value;
                          setMarkersToShow();
                        },
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
                    ),
                    const SizedBox(
                      width: 18,
                    ),
                  ],
                ),
              )),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
      body: SlidingUpPanel(
        isDraggable: false,
        color: Colors.grey.shade100,
        controller: panelController,
        maxHeight: panelHeightOpen,
        minHeight: panelHeightClosed,
        parallaxEnabled: false,
        parallaxOffset: .5,
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder2<List<MetroStationModel>?,
                      List<BusStationModel>?>(
                  // initialData: InitialDataTuple2<controller.allStations, controller.allBuses>,
                  streams: StreamTuple2(
                      controller.getAllStations(), controller.getAllBuses()),
                  builder: ((context, snapshots) {
                    if (snapshots.snapshot1.connectionState ==
                            ConnectionState.waiting ||
                        snapshots.snapshot2.connectionState ==
                            ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    controller.setAllStations = snapshots.snapshot1.data ?? [];
                    controller.setAllBuses = snapshots.snapshot2.data ?? [];
                    if (controller.allStations.isNotEmpty) {
                      initMarkers();
                    }

                    // print(controller.allStations);

                    return FutureBuilder<void>(
                        future: controller.stationMarkers.isEmpty
                            ? initMarkers()
                            : null,
                        builder: (context, markersSnapshot) {
                          if (markersSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          return StreamBuilder<LocationData>(
                              stream: provider.getCurrentLoction(context),
                              builder: (context, locations) {
                                if (locations.hasData) {
                                  final location = locations.data;
                                  return Obx(() {
                                    return GoogleMap(
                                        polylines: controller.polyline,
                                        //myLocationEnabled: true,
                                        markers: {
                                          Marker(
                                              markerId:
                                                  const MarkerId('UserId'),
                                              icon: icon!,
                                              position: LatLng(
                                                  location!.latitude!,
                                                  location.longitude!)),
                                          ...markersType.value ==
                                                  MarkersToShow.both
                                              ? Set<Marker>.of(
                                                  controller.allMarkers.values)
                                              : markersType.value ==
                                                      MarkersToShow.metro
                                                  ? Set<Marker>.of(controller
                                                      .stationMarkers.values)
                                                  : markersType.value ==
                                                          MarkersToShow.bus
                                                      ? Set<Marker>.of(
                                                          controller.busMarkers
                                                              .values)
                                                      : Set<Marker>.of(
                                                          controller
                                                              .emptyMarkers
                                                              .values)
                                        },
                                        initialCameraPosition:
                                            const CameraPosition(
                                          target: LatLng(24.71619956670347,
                                              46.68385748947401),
                                          zoom: 11,
                                        ),
                                        zoomControlsEnabled: false,
                                        zoomGesturesEnabled: true,
                                        // mapToolbarEnabled: ,
                                        onMapCreated: (GoogleMapController
                                            controller) async {
                                          String style =
                                              await DefaultAssetBundle.of(
                                                      context)
                                                  .loadString(
                                                      'assets/mapstyle.json');
                                          //customize your map style at: https://mapstyle.withgoogle.com/
                                          controller.setMapStyle(style);

                                          _mapController = controller;

                                          //polylines: _polyline,
                                        });
                                  });
                                } else {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
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
      controller.initStationMarkers(element, "Station_${element.Name}");
    }
    for (var element in controller.allBuses) {
      controller.initBusMarkers(element, "Bus_${element.Number}");
    }
    controller.setAllMarkers();
  }
}

enum MarkersToShow { none, bus, metro, both }
