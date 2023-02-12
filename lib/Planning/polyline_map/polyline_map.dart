// ignore_for_file: public_member_api_docs, sort_constructors_first, avoid_print, avoid_function_literals_in_foreach_calls, duplicate_ignore
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';

import '../../Homepage/providers/locationProvider.dart';
import '../../helpers/bus_station_model.dart';
import '../../helpers/metro_station_model.dart';
import '../../others/map_controller.dart';

enum MarkersToShow { none, bus, metro, both }

class ShowPolyLineOnMap extends StatefulWidget {
  const ShowPolyLineOnMap({
    Key? key,
    required this.duration,
    required this.polylinePointOverview,
    required this.specificPolyline,
    required this.initialCameraPosition,
  }) : super(key: key);
  final List<dynamic> duration;
  final List<dynamic> polylinePointOverview;
  final String specificPolyline;
  final LatLng initialCameraPosition;

  @override
  State<ShowPolyLineOnMap> createState() => _ShowPolyLineOnMapState();
}

class _ShowPolyLineOnMapState extends State<ShowPolyLineOnMap> {
  GoogleMapController? mapController;
  // Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  // List<LatLng> markerList = [];
  // final panelController = PanelController();
  MapStationsController controller = Get.put(MapStationsController());
  BitmapDescriptor? icon;
  // bool get isAdmin =>
  // FirebaseAuth.instance.currentUser!.email == "sekkahgp@gmail.com";

  RxBool showMetro = true.obs;
  RxBool showBus = true.obs;
  final panelHeightClosed = Get.height * 0.1;
  final panelHeightOpen = Get.height * 0.7;
  Rx<MarkersToShow> markersType = MarkersToShow.both.obs;
  final provider = Get.put(LocationProvider());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await setUserMarker();
    });
    // _getPolyline();
  }

  Future<void> setUserMarker() async {
    await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), 'assets/images/rec8.png')
        .then((value) {
      icon = value;
    });
  }

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

  _addPolyLine() {
    PolylineId id = const PolylineId("poly");

    Polyline polyline = Polyline(
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        polylineId: id,
        color: Colors.red,
        points: polylineCoordinates);
    polylines[id] = polyline;
  }

  _getPolyline() async {
    if (widget.specificPolyline == '') {
      print('Maaz');
      widget.polylinePointOverview.forEach((element) {
        List<PointLatLng> result =
            polylinePoints.decodePolyline(element['points']);
        if (result.isNotEmpty) {
          // ignore: avoid_function_literals_in_foreach_calls
          result.forEach((PointLatLng point) {
            polylineCoordinates.add(
              LatLng(point.latitude, point.longitude),
            );
          });
        }
      });
    } else {
      setState(() {
        polylineCoordinates = [];
      });
      List<PointLatLng> result =
          polylinePoints.decodePolyline(widget.specificPolyline);
      if (result.isNotEmpty) {
        // ignore: avoid_function_literals_in_foreach_calls
        result.forEach((PointLatLng point) {
          polylineCoordinates.add(
            LatLng(point.latitude, point.longitude),
          );
        });
      }
    }
    _addPolyLine();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getPolyline(),
        builder: ((context, snapshot) {
          return snapshot.connectionState == ConnectionState.done
              ? mapWidget()
              : const SizedBox();
        }));
  }

  Widget mapWidget() {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder2<List<MetroStationModel>?,
                  List<BusStationModel>?>(
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

                return FutureBuilder<void>(
                    future: controller.stationMarkers.isEmpty
                        ? initMarkers()
                        : null,
                    builder: (context, markersSnapshot) {
                      if (markersSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return StreamBuilder<LocationData>(
                          stream: provider.getCurrentLoction(context),
                          builder: (context, locations) {
                            if (locations.hasData) {
                              final location = locations.data;
                              return Obx(() {
                                return GoogleMap(
                                    polylines:
                                        Set<Polyline>.of(polylines.values),
                                    markers: {
                                      Marker(
                                          markerId: const MarkerId('UserId'),
                                          icon: icon!,
                                          position: LatLng(location!.latitude!,
                                              location.longitude!)),
                                      ...markersType.value == MarkersToShow.both
                                          ? Set<Marker>.of(
                                              controller.allMarkers.values)
                                          : markersType.value ==
                                                  MarkersToShow.metro
                                              ? Set<Marker>.of(controller
                                                  .stationMarkers.values)
                                              : markersType.value ==
                                                      MarkersToShow.bus
                                                  ? Set<Marker>.of(controller
                                                      .busMarkers.values)
                                                  : Set<Marker>.of(controller
                                                      .emptyMarkers.values)
                                    },
                                    initialCameraPosition: CameraPosition(
                                      target: widget.initialCameraPosition,
                                      zoom: 11,
                                    ),
                                    zoomControlsEnabled: false,
                                    zoomGesturesEnabled: true,
                                    onMapCreated:
                                        (GoogleMapController controller) async {
                                      String style =
                                          await DefaultAssetBundle.of(context)
                                              .loadString(
                                                  'assets/mapstyle.json');
                                      //customize your map style at: https://mapstyle.withgoogle.com/
                                      controller.setMapStyle(style);
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
      ],
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
