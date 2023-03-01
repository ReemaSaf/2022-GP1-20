// ignore_for_file: file_names, unused_import, unused_field, use_build_context_synchronously, avoid_function_literals_in_foreach_calls, avoid_print, prefer_final_fields, await_only_futures

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'data/constants.dart';


class RouteMap extends StatefulWidget {
  final List<RouteModel> route;
  final String? time;

  const RouteMap({super.key, required this.route,this.time});

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
  bool isShow=false;
  bool isLoad=true;

  // [LatLng(24.69480962821743,46.67990130161707),LatLng(24.696571105638657, 46.6837677588918),LatLng(24.737262838662325,46.66339794924775),LatLng(24.740640121256355,46.67113291220544)];
  Future<void> getCurrentLocation() async {
    Location location = Location();
    await location.getLocation().then((location)  {
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
      if(i == 0 || i == latlan.length-1) {
        _marker.add(Marker(
            markerId: MarkerId(i.toString()),
            visible: false,
            icon: metroIcon,
            position: latlan[i]));
      }else{
        _marker.add(Marker(
            markerId: MarkerId(i.toString()),
            visible: true,
            infoWindow: InfoWindow(title: 'Station',snippet:widget.route[i].name),
            icon: metroIcon,
            position: latlan[i]));
      }
      if (i == 0) {
       await _polyline.add(Polyline(
            color: const Color(0xff4CA7C3),
            width: 3,
            polylineId: const PolylineId('1'),
            patterns: [
              PatternItem.dash(8),
              PatternItem.gap(15)
            ],
            points: [
              LatLng(latlan[0].latitude, latlan[0].longitude),
              LatLng(latlan[1].latitude, latlan[1].longitude)
            ]));
      } else if (i == latlan.length - 1) {
        await _polyline.add(Polyline(
            color: const Color(0xff4CA7C3),
            width: 3,
            polylineId: const PolylineId('1'),
            patterns: [
              PatternItem.dash(8),
              PatternItem.gap(15)
            ],
            points: [
              LatLng(latlan[latlan.length - 2].latitude,
                  latlan[latlan.length - 2].longitude),
              LatLng(latlan[latlan.length - 1].latitude,
                  latlan[latlan.length - 1].longitude)
            ]));
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
      isLoad=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [mapWidget(), bottomDetailsSheet()],
      ),
    );
  }

  Widget mapWidget() {
    return Column(
      children: [
        SizedBox(
          height: (MediaQuery.of(context).size.height) * 0.7,
          child:isLoad==true?const Center(child: CircularProgressIndicator()):GoogleMap(
              polylines: _polyline,
              markers: {
               ..._marker,
                // ...Set<Marker>.of(
                //     controller.allMarkers.values),
                Marker(
                  markerId: const MarkerId('location'),
                  position: LatLng(
                      currentLocation!.latitude!,
                      currentLocation!.longitude!),
                  icon: locationIcon,
                ),
                Marker(
                    markerId: MarkerId(0.toString()),
                    infoWindow: InfoWindow(title: 'Start',snippet:widget.route[0].name ),
                    icon:startIcon,
                    position: latlan[0]),
                Marker(
                    markerId: MarkerId(0.toString()),
                    icon: endIcon,
                    infoWindow: InfoWindow(title: 'End',snippet:widget.route[widget.route.length-1].name),
                    position: latlan[latlan.length-1])
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(latlan[0].latitude,
                    latlan[0].longitude),
                zoom: 13,
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

                _mapController = controller;
              })
          // child: StreamBuilder2<List<MetroStationModel>?,
          //     List<BusStationModel>?>(
          //     streams: StreamTuple2(
          //         controller.getAllStations(), controller.getAllBuses()),
          //     builder: ((context, snapshots) {
          //       if (snapshots.snapshot1.connectionState ==
          //           ConnectionState.waiting ||
          //           snapshots.snapshot2.connectionState ==
          //               ConnectionState.waiting) {
          //         return const Center(child: CircularProgressIndicator());
          //       }
          //       // controller.setAllStations = snapshots.snapshot1.data ?? [];
          //       // controller.setAllBuses = snapshots.snapshot2.data ?? [];
          //       if (controller.allStations.isNotEmpty) {
          //         initMarkers();
          //       }
          //
          //       return FutureBuilder<void>(
          //           future: controller.stationMarkers.isEmpty
          //               ? initMarkers()
          //               : null,
          //           builder: (context, markersSnapshot) {
          //             if (markersSnapshot.connectionState ==
          //                 ConnectionState.waiting) {
          //               return const Center(child: CircularProgressIndicator());
          //             }
          //
          //             return StreamBuilder<LocationData>(
          //                 stream: provider.getCurrentLoction(context),
          //                 builder: (context, locations) {
          //                   if (locations.hasData) {
          //                     return Obx(() {
          //                       return GoogleMap(
          //                           polylines: _polyline,
          //                           markers: {
          //                             ..._marker,
          //                             ...Set<Marker>.of(
          //                                 controller.allMarkers.values),
          //                             Marker(
          //                               markerId: MarkerId('location'),
          //                               position: LatLng(
          //                                   currentLocation!.latitude!,
          //                                   currentLocation!.longitude!),
          //                               icon: locationIcon,
          //                             ),
          //                             Marker(
          //                                 markerId: MarkerId(0.toString()),
          //                                 icon:startIcon,
          //                                 position: latlan[0]),
          //                             Marker(
          //                                 markerId: MarkerId(0.toString()),
          //                                 icon: endIcon,
          //                                 position: latlan[latlan.length-1])
          //                           },
          //                           initialCameraPosition: CameraPosition(
          //                             target: LatLng(latlan[0].latitude,
          //                                 latlan[0].longitude),
          //                             zoom: 13,
          //                           ),
          //                           zoomControlsEnabled: false,
          //                           zoomGesturesEnabled: true,
          //                           onMapCreated:
          //                               (GoogleMapController controller) async {
          //                             String style =
          //                             await DefaultAssetBundle.of(context)
          //                                 .loadString(
          //                                 'assets/mapstyle.json');
          //                             //customize your map style at: https://mapstyle.withgoogle.com/
          //                             controller.setMapStyle(style);
          //
          //                             _mapController = controller;
          //                           });
          //                     });
          //                   } else {
          //                     return const Center(
          //                       child: CircularProgressIndicator(),
          //                     );
          //                   }
          //                 });
          //           });
          //     })),
        ),
      ],
    );
  }

  Widget bottomDetailsSheet() {
    return DraggableScrollableSheet(
      initialChildSize: .3,
      minChildSize: .3,
      maxChildSize: .9,
      builder: (BuildContext context, ScrollController scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40))),
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
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
                    margin: const EdgeInsets.only(left: 16, right: 16),
                    decoration: BoxDecoration(
<<<<<<< HEAD
                        color: const Color(0xffF2F2F2),
                        borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
=======
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
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
                  margin: const EdgeInsets.only(left: 16, right: 16),
                  decoration: BoxDecoration(
                      color: const Color(0xffF2F2F2),
                      borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              const SizedBox(width: 16),
                              Text(
                                "${widget.route.length - 2}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                    fontSize: 30),
                              ),
                              const SizedBox(width: 8),
                              const Text("Stops",
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 16))
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          
                          GestureDetector(
                            onTap: () {
                              Get.to(() =>  BuyTicket());
                          
                            },
                            child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                            decoration: BoxDecoration(
                                color: const Color(0xff50B2CC),
                                borderRadius: BorderRadius.circular(18)),
                            child: const Text("PURCHASE TICKET",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                          ),)
                          // const SizedBox(width: 6),
                          // Container(
                          //   padding: const EdgeInsets.symmetric(
                          //       horizontal: 12, vertical: 12),
                          //   decoration: BoxDecoration(
                          //       border: Border.all(color: Color(0xff50B2CC)),
                          //       borderRadius: BorderRadius.circular(18)),
                          //   child: Row(
                          //     children: const [
                          //       Icon(Icons.near_me, color: Color(0xff50B2CC)),
                          //       SizedBox(width: 6),
                          //       Text("Start",
                          //           style: TextStyle(
                          //               color: Color(0xff50B2CC),
                          //               fontWeight: FontWeight.bold,
                          //               fontSize: 16)),
                          //     ],
                          //   ),
                          // )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Expanded(
                //   child: SizedBox(
                //     child: SingleChildScrollView(
                //         controller: scrollController,
                //         child: Wrap(
                //           children: List.generate(widget.route.length, (index) {
                //             return Padding(
                //               padding: EdgeInsets.all(8.0),
                //               child: Row(
                //                 crossAxisAlignment: CrossAxisAlignment.center,
                //                 children: [
                //                   widget.route[index].type == 'metro'
                //                       ? Container(
                //                           width: 30,
                //                           height: 30,
                //                           margin:
                //                               const EdgeInsets.only(right: 6),
                //                           padding: const EdgeInsets.all(6),
                //                           alignment: Alignment.center,
                //                           decoration: BoxDecoration(
                //                               borderRadius:
                //                                   BorderRadius.circular(6),
                //                               color: CustomColor.kprimaryblue),
                //                           child: Image.asset(
                //                               "assets/icons/metro.png"),
                //                         )
                //                       : widget.route[index].type == 'bus'
                //                           ? Container(
                //                               width: 30,
                //                               height: 30,
                //                               margin: const EdgeInsets.only(
                //                                   right: 6),
                //                               padding: const EdgeInsets.all(6),
                //                               alignment: Alignment.center,
                //                               decoration: BoxDecoration(
                //                                   borderRadius:
                //                                       BorderRadius.circular(6),
                //                                   color:
                //                                       CustomColor.kprimaryblue),
                //                               child: Image.asset(
                //                                   "assets/icons/bus.png"),
                //                             )
                //                           : Container(
                //                               width: 30,
                //                               height: 30,
                //                               margin: const EdgeInsets.only(
                //                                   right: 6),
                //                               padding: const EdgeInsets.all(6),
                //                               alignment: Alignment.center,
                //                               decoration: BoxDecoration(
                //                                   borderRadius:
                //                                       BorderRadius.circular(6),
                //                                   color:
                //                                       CustomColor.kprimaryblue),
                //                               child: Image.asset(
                //                                   "assets/icons/walk.png"),
                //                             ),
                //                   Text('==>'),
                //                   SizedBox(
                //                       width: MediaQuery.of(context).size.width -
                //                           75,
                //                       child: Text(widget.route[index].name!,
                //                           style: TextStyle(
                //                               fontWeight: FontWeight.bold),
                //                           overflow: TextOverflow.ellipsis))
                //                 ],
                //               ),
                //             );
                //           }),
                //         )),
                //   ),
                // ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const DotIndicator(size: 20),
                              const SizedBox(width: 8),
                              Text(widget.route[0].name!,
                                  style: const TextStyle(
                                      color: AppColors.blueDarkColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: Row(
>>>>>>> a202b713087509ea237295a297b032d18f39c5d2
                              children: [
                                const SizedBox(width: 16),
                                Text(
                                  widget.time!,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.skyColor,
                                      fontSize: 30),
                                ),
                                const SizedBox(width: 8),
                                const Text("",
                                    style: TextStyle(
                                        color:AppColors.blueDarkColor, fontSize: 16))
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
                                      fontSize: 30),
                                ),
                                const SizedBox(width: 8),
                                const Text("Stops",
                                    style: TextStyle(
                                        color:AppColors.blueDarkColor, fontSize: 16))
                              ],
                            ),

                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
                              decoration: BoxDecoration(
                                  color: const Color(0xff50B2CC),
                                  borderRadius: BorderRadius.circular(18)),
                              child: const Text("PURCHASE TICKET",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                            ),
                            const SizedBox(width: 6),
                            InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Tracking(route:widget.route)));
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 12),
                                decoration: BoxDecoration(
                                    border: Border.all(color: const Color(0xff50B2CC)),
                                    borderRadius: BorderRadius.circular(18)),
                                child: Row(
                                  children: const [
                                    Icon(Icons.near_me, color: Color(0xff50B2CC)),
                                  ],
                                ),
                              ),
                            )
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
                    Image.asset('assets/images/start.png',width: 30,height: 30),
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
                                    Text(
                                        "${widget.route.length - 4} Stops Before",
                                        style: const TextStyle(
                                            color: AppColors.skyColor,
                                            fontSize: 16)),
                                    isShow == false
                                        ? const Icon(Icons.arrow_drop_down,
                                        color: AppColors.skyColor)
                                        : const Icon(Icons.arrow_drop_up,
                                        color: AppColors.skyColor)
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
                                padding: const EdgeInsets.only(left: 6),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        const DotIndicator(size: 20),
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
                                          EdgeInsets.only(left: 8.0),
                                          child: SizedBox(
                                            height: 20.0,
                                            child: SolidLineConnector(color:Colors.grey),
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
                            Image.asset('assets/images/end.png',width: 30,height: 30),
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
              )),
        );
      },
    );
  }

  // Future<void> initMarkers() async {
  //   controller.allStations.isEmpty ? null : await 2.seconds.delay();
  //   await controller.getAllContains();
  //   // await controller.getAllLines();
  //   // controller.setPolyLineData();
  //   for (var element in controller.allStations) {
  //     controller.initStationMarkers(element, "Station_${element.Name}");
  //   }
  //   for (var element in controller.allBuses) {
  //     controller.initBusMarkers(element, "Bus_${element.Number}");
  //   }
  //   controller.setAllMarkers();
  // }
}

