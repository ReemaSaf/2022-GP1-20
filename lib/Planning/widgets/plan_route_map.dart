
// ignore_for_file: prefer_final_fields, unused_import, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sekkah_app/core/const.dart';

import '../routeHelpers/currentLocation.dart';

class PlanRouteMap extends StatefulWidget {
  const PlanRouteMap({
    Key? key,
    required this.originLatLong,
    required this.destinationLatLong,
    required this.currentLat,
    required this.currentLng,
  }) : super(key: key);

  final List originLatLong;
  final List destinationLatLong;
  final double currentLat;
  final double currentLng;

  @override
  State<PlanRouteMap> createState() => _PlanRouteMapState();
}

class _PlanRouteMapState extends State<PlanRouteMap> {
  GoogleMapController? mapController;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  Set<Marker> _markers = {};
  double currentLocationLat = 0;
  double currentLocationLng = 0;

  @override
  void initState() {
    currentLocation();
    _getPolyline();
    setMapPins();
    super.initState();
    
  }
  currentLocation() async {
    print("this is called ======================================================");
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentLocationLat=position.latitude;
    currentLocationLng=position.longitude;
    setState(() {

    });
    print("==================================== this is the current location ====== $currentLocationLat 4444 $currentLocationLng");
  }


  _addPolyLine() {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
        width: 5,
        polylineId: id,
        color: Colors.grey,
        patterns: [PatternItem.dash(30), PatternItem.gap(20)],
        points: polylineCoordinates);

    polylines[id] = polyline;
    setState(() {});
  }


  _getPolyline() async {
    if (widget.originLatLong.isNotEmpty &&
        widget.destinationLatLong.isNotEmpty) {
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        Const.apiKey,
        PointLatLng(widget.originLatLong[0], widget.originLatLong[1]),
        PointLatLng(widget.destinationLatLong[0], widget.destinationLatLong[1]),
        travelMode: TravelMode.driving,
      );
      if (result.points.isNotEmpty) {
        // ignore: avoid_function_literals_in_foreach_calls
        result.points.forEach((PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });
      }
    }
    _addPolyLine();

  }

  void setMapPins() async  {
    _markers.add(Marker(
        icon: await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(150.h, 150.h)), 'assets/images/start.png'),
        markerId: const MarkerId('sourcePin'),
        position: LatLng(widget.originLatLong[0], widget.originLatLong[1]),
      ));
      // destination pin
      _markers.add(Marker(
        icon: await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(280.h, 280.h)), 'assets/images/end.png'),
        markerId: const MarkerId('destPin'),
       
        position:
            LatLng(widget.destinationLatLong[0], widget.destinationLatLong[1]),
      ));
    _markers.add(Marker(
      icon: await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(280.h, 280.h)), 'assets/images/rec8.png'),
      markerId: const MarkerId('1'),

      position:
      LatLng(widget.currentLat, widget.currentLng),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target:
            (widget.originLatLong.isEmpty || widget.destinationLatLong.isEmpty)
                ? const LatLng(24.71619956670347, 46.68385748947401)
                : LatLng(
                    widget.originLatLong[0],
                    widget.originLatLong[1],
                  ),
        zoom: 12,
      ),
      zoomControlsEnabled: false,
      zoomGesturesEnabled: true,
      polylines: Set<Polyline>.of(polylines.values),
      markers: Set<Marker>.of(_markers),
        onMapCreated:
            (GoogleMapController controller) async {
          String style =
          await DefaultAssetBundle.of(context)
              .loadString(
              'assets/mapstyle.json');
          //customize your map style at: https://mapstyle.withgoogle.com/
          controller.setMapStyle(style);
        }
    );
  }
}