// ignore_for_file: file_names, unused_import, unused_field, use_build_context_synchronously, avoid_function_literals_in_foreach_calls, avoid_print, prefer_final_fields, await_only_futures, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:sekkah_app/constants/app_colors.dart';
// ignore: depend_on_referenced_packages
import 'package:motion_toast/motion_toast.dart';
import 'package:sekkah_app/services/tracking.dart';
import 'package:timelines/timelines.dart';
import '../Homepage/providers/locationProvider.dart';
import '../Homepage/viewmap.dart';
import '../helpers/bus_station_model.dart';
import '../helpers/metro_station_model.dart';
import '../helpers/route_model.dart';
import '../others/map_controller.dart';
import 'dart:ui' as ui;

import 'BuyTicket.dart';
import 'core/const.dart';
import 'data/constants.dart';

class RouteMap extends StatefulWidget {
  final List<RouteModel> route;
  final String? time;
  final int routeNo;

  const RouteMap({super.key, required this.route, this.time,required this.routeNo});

  @override
  State<RouteMap> createState() => _RouteMapState();
}

class _RouteMapState extends State<RouteMap> {
  late GoogleMapController _mapController;
  BitmapDescriptor? icon;
  MapStationsController controller = Get.put(MapStationsController());
  final provider = Get.put(LocationProvider());
  RxBool showMetro = true.obs;
  RxBool showBus = true.obs;
  Rx<MarkersToShow> markersType = MarkersToShow.both.obs;
  late Set<Marker> _marker = {};
  final Set<Polyline> _polyline = {};
  int num = 1;
  List<LatLng> latlan = [];
  LocationData? currentLocation;
  BitmapDescriptor locationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor startIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor endIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor metroIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor busIcon = BitmapDescriptor.defaultMarker;
  PolylinePoints polylinePoints = PolylinePoints();
  List<LatLng> polylineCoordinates = [];
  bool isShow = false;
  bool isLoad = true;

  Future<void> getCurrentLocation() async {
    Location location = Location();
    await location.getLocation().then((location) {
      currentLocation = location;
    });
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void setMarkerIcon() {
     BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, 'assets/images/rec8.png')
        .then((value) {
      locationIcon = value;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, 'assets/images/start.png')
        .then((value) {
      startIcon = value;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, 'assets/images/end.png')
        .then((value) {
      endIcon = value;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, 'assets/images/metro.png')
        .then((value) {
      metroIcon = value;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, 'assets/images/bus.png')
        .then((value) {
      busIcon = value;
    });
  }

  @override
  void initState() {
    super.initState();
    setMarkerIcon();
    getPoline();
  }

  getPoline() async {
    List newRoute = widget.route;
    for (var element in newRoute) {
      RouteModel e = element;
      latlan.add(LatLng(e.lat!, e.lng!));
    }
    for (int i = 0; i < latlan.length; i++) {
      if (i == 0 || i == latlan.length - 1) {
        _marker.add(Marker(
            markerId: MarkerId(i.toString()),
            visible: false,
            icon: metroIcon,
            position: latlan[i]));
      } else {
        _marker.add(Marker(
            markerId: MarkerId(i.toString()),
            visible: true,
            infoWindow:
                InfoWindow(title: widget.route[i].type=='Bus'?'Bus Station':'Metro Station', snippet: widget.route[i].name),
            icon:widget.route[i].type=="Bus"?busIcon: metroIcon,
            position: latlan[i]));
      }
      if (i == 0) {
        await getDisPolyLine(
          startLat:latlan[0].latitude,
          startLng:latlan[0].longitude,
          endLng:latlan[1].longitude,
          endLat:latlan[1].latitude,
        );
      } else if (i == latlan.length - 1) {
        await getDisPolyLine(
          startLat:latlan[latlan.length - 2].latitude,
          startLng:latlan[latlan.length - 2].longitude,
          endLat:latlan[latlan.length - 1].latitude,
          endLng: latlan[latlan.length - 1].longitude,
        );

      } else {
        await _polyline.add(Polyline(
            color: const Color(0xff4CA7C3),
            width: 6,
            polylineId: const PolylineId('1'),
            points: latlan.getRange(1, latlan.length - 1).toList()));
      }
      setState(() {});
    }
    await getCurrentLocation();
    setState(() {
      isLoad = false;
    });
  }

  getDisPolyLine({double? startLat,double? startLng,double? endLat,double? endLng}) async {
    polylineCoordinates=[];
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      Const.apiKey,
      PointLatLng(startLat!, startLng!),
      PointLatLng(endLat!, endLng!),
      travelMode: TravelMode.walking,
    );
    if (result.points.isNotEmpty) {
      // ignore: avoid_function_literals_in_foreach_calls
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }

  _addPolyLine() {
    _polyline.add(Polyline(
      width: 3,
      polylineId: const PolylineId("poly"),
      color: const Color(0xff4CA7C3),
              patterns: [
                PatternItem.dash(8),
                PatternItem.gap(15)
              ],
      points: polylineCoordinates,
    ));

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          mapWidget(),
          bottomDetailsSheet(),
          Positioned(
            top: (MediaQuery.of(context).viewPadding.top)+10,
            left: 16,
            child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6)),
                    child: const Icon(Icons.arrow_back, color: Colors.black))),
          )
        ],
      ),
    );
  }

  Widget mapWidget() {
    return Column(
      children: [
        SizedBox(
            height: (MediaQuery.of(context).size.height) * 0.8,
            child: isLoad == true
                ? const Center(child: CircularProgressIndicator())
                : Padding(
              padding: const EdgeInsets.only(bottom: 16),
                  child: GoogleMap(
                      polylines: _polyline,
                      markers: {
                        ..._marker,
                        Marker(
                          markerId: const MarkerId('location'),
                          position: LatLng(currentLocation!.latitude!,
                              currentLocation!.longitude!),
                          icon: locationIcon,
                        ),
                        Marker(
                            markerId: MarkerId(0.toString()),
                            infoWindow: InfoWindow(
                                title: 'Start', snippet: widget.route[0].name),
                            icon: startIcon,
                            position: latlan[0]),
                        Marker(
                            markerId: MarkerId(0.toString()),
                            icon: endIcon,
                            infoWindow: InfoWindow(
                                title: 'End',
                                snippet:
                                    widget.route[widget.route.length - 1].name),
                            position: latlan[latlan.length - 1])
                      },
                      initialCameraPosition: CameraPosition(
                        target: LatLng(latlan[0].latitude, latlan[0].longitude),
                        zoom: 13,
                      ),
                      zoomControlsEnabled: false,
                      zoomGesturesEnabled: true,
                      onMapCreated: (GoogleMapController controller) async {
                        String style = await DefaultAssetBundle.of(context)
                            .loadString('assets/mapstyle.json');
                        //customize your map style at: https://mapstyle.withgoogle.com/
                        controller.setMapStyle(style);

                        _mapController = controller;
                      },
            ),
                )),
      ],
    );
  }

  Widget bottomDetailsSheet() {
    return DraggableScrollableSheet(
      initialChildSize: .225,
      minChildSize: .225,
      maxChildSize: .9,
      builder: (BuildContext context, ScrollController scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.9,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40))),
              child: SingleChildScrollView(
                controller:scrollController,
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 8,
                        width: 60,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(6)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Route details",
                        style: TextStyle(
                            color: AppColors.blueDarkColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 26),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 22),
                      margin: const EdgeInsets.only(left: 16, right: 16),
                      decoration: BoxDecoration(
                          color: const Color(0xffF2F2F2),
                          borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const SizedBox(width: 16),
                                  Text(
                                    widget.time!,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.skyColor,
                                        fontSize: 28),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const SizedBox(width: 16),
                                  Text(
                                    "${widget.route.length - 2}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.blueDarkColor,
                                        fontSize: 28),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text("Stops",
                                      style: TextStyle(
                                          color: AppColors.blueDarkColor,
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              GestureDetector(
                              onTap: () {
                                Get.to(() => BuyTicket(
                                      stops: widget.route.length - 2,
                                      startLocation: widget.route[0].name!,
                                      endLocation: widget
                                          .route[widget.route.length - 1].name!,
                                      allRoutes: widget.route,
                                      routeTime: widget.time!,
                                  routeNo: widget.routeNo!,
                                  timeTaken: widget.time!,
                                    ));
                              },
                              child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 12),
                                  decoration: BoxDecoration(
                                      color: const Color(0xff50B2CC),
                                      borderRadius: BorderRadius.circular(12)),
                                  child: const Text("PURCHASE TICKET",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,overflow: TextOverflow.ellipsis)),
                                ),
                            ),
                              const SizedBox(width: 6),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Image.asset('assets/images/start.png',
                                  width: 30, height: 30),
                              const SizedBox(width: 8),
                              Text(widget.route[0].name!,
                                  style: const TextStyle(
                                      color: AppColors.blueDarkColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 14),
                            child: Row(
                              children: [
                                const SizedBox(
                                  height: 50.0,
                                  child: SolidLineConnector(color: Colors.grey),
                                ),
                                const SizedBox(width: 16),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      isShow = !isShow;
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      isShow == false?Text(
                                          "${widget.route.length - 2} Stops Before",
                                          style: const TextStyle(
                                              color: AppColors.skyColor,
                                              fontSize: 16)): const Text(""),
                                      isShow == false
                                          ? const Icon(Icons.arrow_drop_down,
                                              color: AppColors.skyColor)
                                          : const Icon(Icons.arrow_drop_up,
                                              color: AppColors.skyColor,size: 22)
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          isShow == true
                              ? SizedBox(
                                  child: Wrap(
                                    children: List.generate(
                                        widget.route.length - 2, (index) {
                                      return Padding(
                                        padding: const EdgeInsets.only(left: 0),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                widget.route[index + 1].type ==
                                                        'Bus'
                                                    ? Image.asset(
                                                        "assets/images/bus.png",
                                                        width: 30,
                                                        height: 30,
                                                      )
                                                    : Image.asset(
                                                        "assets/images/metro.png",
                                                        width: 30,
                                                        height: 30,
                                                      ),
                                                const SizedBox(width: 8),
                                                Text(
                                                    widget.route[index + 1].name!,
                                                    style: const TextStyle(
                                                        color: AppColors
                                                            .blueDarkColor,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold))
                                              ],
                                            ),
                                            Row(
                                              children: const [
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 14.0),
                                                  child: SizedBox(
                                                    height: 20.0,
                                                    child: SolidLineConnector(
                                                        color: Colors.grey),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                  ),
                                )
                              : const SizedBox(),
                          Row(
                            children: [
                              Image.asset('assets/images/end.png',
                                  width: 30, height: 30),
                              const SizedBox(width: 8),
                              Text(widget.route[widget.route.length - 1].name!,
                                  style: const TextStyle(
                                      color: AppColors.blueDarkColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        );
      },
    );
  }
}

