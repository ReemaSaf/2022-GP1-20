// ignore_for_file: unused_field, use_build_context_synchronously, avoid_function_literals_in_foreach_calls, avoid_print, unnecessary_brace_in_string_interps, await_only_futures, duplicate_ignore, null_check_always_fails, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:sekkah_app/constants/app_colors.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:sekkah_app/helpers/bus_station_model.dart';
import 'package:timelines/timelines.dart';
import '../Homepage/components/user_nav.dart';
import '../Homepage/providers/locationProvider.dart';
import '../Homepage/viewmap.dart';
import '../ReachedScreen.dart';
import '../core/const.dart';
import '../helpers/route_model.dart';
import '../others/map_controller.dart';
import 'dart:ui' as ui;

class Tracking extends StatefulWidget {
  final List<RouteModel> route;
  final String? time;

  const Tracking({super.key, required this.route, this.time});

  @override
  State<Tracking> createState() => _TrackingState();
}

class _TrackingState extends State<Tracking> {
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
  BitmapDescriptor dotIcon = BitmapDescriptor.defaultMarker;
  PolylinePoints polylinePoints = PolylinePoints();
  List<LatLng> polylineCoordinates = [];
  List<LatLng> startToStation = [];
  bool isShow = false;
  int stationNumber = 0;
  bool isLoad = true;
  int currentLocationNumber = 1;
  bool isReachedStation = false;
  int num1 = 0;
  int alert = 200;
  bool isShowdelay = false;

  Future<void> getCurrentLocation() async {
    Location location = Location();
    await location.getLocation().then((location) {
      currentLocation = location;
    });
    location.onLocationChanged.listen((event) {
      setState(() {
        currentLocation = event;
      });
      afterLocationLine(lat: event.latitude, lng: event.longitude);
    });
  }

  Future<void> afterLocationLine({double? lat, double? lng}) async {
    print("this is to check $isReachedStation");
    var dis1 = Geolocator.distanceBetween(
        lat!, lng!, widget.route[1].lat!, widget.route[1].lng!);
    if (dis1 < 10) {
      setState(() {
        isReachedStation = true;
      });
    }
    if (isReachedStation == false) {
      print("station check ${startToStation[0].latitude}");
      var dis2 = Geolocator.distanceBetween(
          lat!, lng!, startToStation[0].latitude, startToStation[0].longitude);
      print("this is distance $dis2");
      if (dis2 == 0) {
        setState(() {
          num1 = num1 + 1;
        });
      } else {
        if (dis2 > alert) {
          Get.snackbar('Alert', 'You are on wrong path',
              colorText: Colors.white,
              backgroundColor: const Color.fromARGB(255, 204, 84, 80));
          setState(() {
            alert = alert + 1000;
          });
        }
      }
    }
    var dis = Geolocator.distanceBetween(
        lat!, lng!, widget.route[num].lat!, widget.route[num].lng!);
    if (num == 1) {
      if (dis > 50) {
        isShowdelay = true;
        setState(() {});
      }
    }

    if (widget.route[num].isChange == true) {
      if (dis < 300) {
        MotionToast.warning(
            barrierColor: widget.route[num].lineColor!,
            title: Text("You Need To change line to ${widget.route[num].line}"),
            description: Text("${widget.route[num].name}"));
      }
    }
    if (dis < 50) {
      print("your have reached station");
      if (num == 1) {
        await getDisPolyLine(
            startLat: latlan[0].latitude,
            startLng: latlan[0].longitude,
            endLng: latlan[1].longitude,
            endLat: latlan[1].latitude,
            isDash: false,
            color: AppColors.blueDarkColor,
            id: 4568);
      } else {
        print(
            "num --------------------------------------------------------------------------------------------- $num");
        print(
            "length --------------------------------------------------------------------------------------------- ${widget.route.length}");
        num == widget.route.length - 1
            ? await getDisPolyLine(
                startLat: latlan[widget.route.length - 2].latitude,
                startLng: latlan[widget.route.length - 2].longitude,
                endLng: latlan[widget.route.length-1].longitude,
                endLat: latlan[widget.route.length-1].latitude,
                isDash: false,
                color: AppColors.blueDarkColor,
                id: 78956)
            : _polyline.add(Polyline(
                color: AppColors.blueDarkColor,
                width: 3,
                polylineId: PolylineId(num.toString()),
                points: [
                    LatLng(latlan[num - 1].latitude, latlan[num - 1].longitude),
                    LatLng(latlan[num].latitude, latlan[num].longitude)
                  ]));
      }
      // await getDisPolyLine(
      //   startLat: latlan[latlan.length - 2].latitude,
      //   startLng: latlan[latlan.length - 2].longitude,
      //   endLat: latlan[latlan.length - 1].latitude,
      //   endLng: latlan[latlan.length - 1].longitude,
      //
      // );
      setState(() {
        stationNumber = stationNumber - 1;
        currentLocationNumber = currentLocationNumber + 1;
        _marker = {};
        for (int i = 0; i < latlan.length; i++) {
          if (i == 0 || i == latlan.length - 1) {
            _marker.add(Marker(
                markerId: MarkerId(i.toString()),
                visible: false,
                icon: widget.route[i].type == "Bus" ? busIcon : metroIcon,
                infoWindow:
                    InfoWindow(title: 'Station', snippet: widget.route[i].name),
                position: latlan[i]));
          } else {
            if (i == currentLocationNumber) {
              _marker.add(Marker(
                  markerId: MarkerId(i.toString()),
                  visible: true,
                  infoWindow: InfoWindow(
                      title: 'Station', snippet: widget.route[i].name),
                  icon: widget.route[i].type=="Bus"?busIcon:metroIcon,
                  position: latlan[currentLocationNumber]));
            } else {
              _marker.add(Marker(
                  markerId: MarkerId(i.toString()),
                  visible: true,
                  icon: dotIcon,
                  infoWindow: InfoWindow(
                      title: 'Station', snippet: widget.route[i].name),
                  position: latlan[i]));
            }
          }
        }
      });
      MotionToast.error(
              title: const Text("Your Have Reached"),
              description: Text("${widget.route[num].name}"))
          .show(context);
      setState(() {
        num = num + 1;
      });
      print("thisisi =========================================================================== $num");
      print("thisisi =========================================================================== $num");
      print("thisisi =========================================================================== $num");
      print("thisisi =========================================================================== $num");
      if (num == widget.route.length ) {

        await const Duration(seconds: 6).delay();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const ReachedScreen(),
            ));
      }
    }
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
            ImageConfiguration.empty, 'assets/images/dot_circle.png')
        .then((value) {
      dotIcon = value;
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
    setState(() {
      stationNumber = widget.route.length - 2;
    });
    busStationNames();
    getPoline();
  }

  List<BusStationModel> buses = [];
  Set<String> stationNames = {};
  bool isItdelayed = false;

  busStationNames() {
    print('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
    for (int i = 0; i < widget.route.length; i++) {
      if (widget.route[i].type!.toLowerCase() == 'bus') {
        stationNames.add(widget.route[i].name!);
      }
    }
    print('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
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
        if (i == currentLocationNumber) {
          _marker.add(Marker(
              markerId: MarkerId(i.toString()),
              visible: true,
              icon: widget.route[i].type == 'Bus' ? busIcon : metroIcon,
              infoWindow: InfoWindow(
                  title: widget.route[i].type == 'Bus'
                      ? 'Bus Station'
                      : 'Metro Station',
                  snippet: widget.route[i].name),
              position: latlan[currentLocationNumber]));
        } else {
          _marker.add(Marker(
              markerId: MarkerId(i.toString()),
              visible: true,
              icon: dotIcon,
              infoWindow: InfoWindow(
                  title: widget.route[i].type == 'Bus'
                      ? 'Bus Station'
                      : 'Metro Station',
                  snippet: widget.route[i].name),
              position: latlan[i]));
        }
      }
      if (i == 0) {
        await getDisPolyLine(
            startLat: latlan[0].latitude,
            startLng: latlan[0].longitude,
            endLng: latlan[1].longitude,
            endLat: latlan[1].latitude,
            id: 154);
      } else if (i == latlan.length - 1) {
        await getDisPolyLine(
            startLat: latlan[latlan.length - 2].latitude,
            startLng: latlan[latlan.length - 2].longitude,
            endLat: latlan[latlan.length - 1].latitude,
            endLng: latlan[latlan.length - 1].longitude,
            id: 13);
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

  getDisPolyLine(
      {double? startLat,
      double? startLng,
      double? endLat,
      double? endLng,
      bool? isDash,
      Color? color,
      required int id}) async {
    polylineCoordinates = [];
    print("called for creating line =========================== ");
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
    if (startLat == latlan[0].latitude && startLng == latlan[0].longitude) {
      setState(() {
        startToStation = polylineCoordinates;
      });
    }
    _addPolyLine(isDash: isDash, color: color);
  }

  _addPolyLine({bool? isDash, Color? color}) {
    _polyline.add(Polyline(
      width: 3,
      polylineId: PolylineId("poly ${color.toString()}"),
      color: isDash == false ? color! : const Color(0xff4CA7C3),
      patterns: isDash == false
          ? [
              PatternItem.dash(1),
            ]
          : [PatternItem.dash(8), PatternItem.gap(15)],
      points: polylineCoordinates,
    ));

    setState(() {});
  }

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          mapWidget(),
          bottomDetailsSheet(),
          Positioned(
            top: (MediaQuery.of(context).viewPadding.top) + 10,
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
          ),
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
                : GoogleMap(
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
                      target: LatLng(currentLocation!.latitude!,
                          currentLocation!.longitude!),
                      zoom: 12,
                    ),
                    zoomControlsEnabled: false,
                    zoomGesturesEnabled: true,
                    onMapCreated: (GoogleMapController controller) async {
                      String style = await DefaultAssetBundle.of(context)
                          .loadString('assets/mapstyle.json');
                      //customize your map style at: https://mapstyle.withgoogle.com/
                      controller.setMapStyle(style);

                      _mapController = controller;
                    })),
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
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40))),
              child: SingleChildScrollView(
                controller: scrollController,
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 22),
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
                                  (stationNumber < 0 || stationNumber == 0)
                                      ? const SizedBox()
                                      : Row(
                                          children: [
                                            const SizedBox(width: 16),
                                            Text(
                                              "$stationNumber",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      AppColors.blueDarkColor,
                                                  fontSize: 30),
                                            ),
                                            const SizedBox(width: 8),
                                            stationNumber == 1
                                                ? const Text("Stop",
                                                    style: TextStyle(
                                                        color: AppColors
                                                            .blueDarkColor,
                                                        fontSize: 30,
                                                        fontWeight:
                                                            FontWeight.bold))
                                                : const Text("Stops",
                                                    style: TextStyle(
                                                        color: AppColors
                                                            .blueDarkColor,
                                                        fontSize: 30,
                                                        fontWeight:
                                                            FontWeight.bold))
                                          ],
                                        ),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 16, top: 8),
                                child: Row(
                                  children: [
                                    const Text(
                                      "On Route",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.skyColor,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 16,
                                      ),
                                      child: StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection('Bus_Station')
                                              .snapshots(),
                                          builder: (_,
                                              AsyncSnapshot<
                                                      QuerySnapshot<
                                                          Map<String, dynamic>>>
                                                  snapshots) {
                                            if (snapshots.hasData) {
                                              Set<BusStationModel> temp = {};
                                              buses = [];
                                              if (snapshots.data == null) {
                                                return const Text(
                                                    'Something went wrong');
                                              }
                                              if (snapshots
                                                  .data!.docs.isNotEmpty) {
                                                for (var doc
                                                    in snapshots.data!.docs) {
                                                  var data = doc.data();
                                                  var bus =
                                                      BusStationModel.fromMap(
                                                          data);
                                                  buses.add(bus);
                                                }
                                              }
                                              if (buses.isNotEmpty) {
                                                for (var name in stationNames) {
                                                  temp.add(buses.firstWhere(
                                                      (element) =>
                                                          name.toLowerCase() ==
                                                          element.Name
                                                              .toLowerCase()));
                                                }
                                              }
                                              if (temp.isNotEmpty) {
                                                for (int i = 0;
                                                    i < widget.route.length;
                                                    i++) {
                                                  if (widget.route[i].type!
                                                          .toLowerCase() ==
                                                      'bus') {
                                                    bool ontime = temp
                                                        .firstWhere((element) =>
                                                            element.Name
                                                                .toLowerCase() ==
                                                            widget
                                                                .route[i].name!
                                                                .toLowerCase())
                                                        .OnTime!;
                                                    widget.route[i].OnTime =
                                                        ontime;
                                                  }
                                                }
                                              }
                                              isItdelayed = false;
                                              for (int i = 0;
                                                  i < widget.route.length;
                                                  i++) {
                                                if (widget.route[i].type!
                                                        .toLowerCase() ==
                                                    'bus') {
                                                  if (widget.route[i].OnTime ==
                                                      false) {
                                                    isItdelayed = true;
                                                    break;
                                                  }
                                                }
                                              }

                                              return isItdelayed
                                                  ? const DelayWidget()
                                                  : const Text(
                                                      "",
                                                    );
                                            } else {
                                              return const Text(
                                                "",
                                              );
                                            }
                                          }),
                                    ),
                                  ],
                                ),
                              ),
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
                              DotIndicator(
                                  size: 20,
                                  color: currentLocationNumber >= 2
                                      ? Colors.grey
                                      : Colors.blue),
                              const SizedBox(width: 8),
                              Text(widget.route[0].name!,
                                  style: const TextStyle(
                                      color: AppColors.blueDarkColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 50.0,
                                  child: SolidLineConnector(
                                      color: currentLocationNumber >= 2
                                          ? Colors.grey
                                          : Colors.blue),
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
                                      isShow == false
                                          ? Text(
                                              "${widget.route.length - 2} Stops Before",
                                              style: const TextStyle(
                                                  color: AppColors.skyColor,
                                                  fontSize: 16))
                                          : const Text(""),
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
                                      return Column(
                                        children: [
                                          Row(
                                            children: [
                                              DotIndicator(
                                                  size: 20,
                                                  color: index + 2 <=
                                                          currentLocationNumber
                                                      ? Colors.grey
                                                      : num - 1 ==
                                                              widget
                                                                  .route.length
                                                          ? Colors.grey
                                                          : Colors.blue),
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
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: SizedBox(
                                                  height: 20.0,
                                                  child: SolidLineConnector(
                                                      color: index + 2 <=
                                                              currentLocationNumber
                                                          ? Colors.grey
                                                          : num - 1 ==
                                                                  widget.route
                                                                      .length
                                                              ? Colors.grey
                                                              : Colors.blue),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    }),
                                  ),
                                )
                              : const SizedBox(),
                          Row(
                            children: [
                              const DotIndicator(size: 20),
                              const SizedBox(width: 8),
                              Text(widget.route[widget.route.length - 1].name!,
                                  style: const TextStyle(
                                    color: AppColors.blueDarkColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ))
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

class DelayWidget extends StatelessWidget {
  const DelayWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Padding(
          padding: EdgeInsets.only(
            left: 6,
          ),
          child: Icon(
            Icons.bus_alert,
            color: Colors.red,
            size: 20,
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Padding(
          padding: EdgeInsets.only(top: 3.0),
          child: Text(
            'Slight Delay ',
            style: TextStyle(
              fontSize: 15,
              color: Colors.red,
              fontWeight: FontWeight.w600,
            ),
          ),
        )
      ],
    );
  }
}
