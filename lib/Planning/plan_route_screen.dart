// ignore_for_file: unused_import, avoid_function_literals_in_foreach_calls, await_only_futures

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/directions.dart';
import 'package:http/http.dart';
import 'package:sekkah_app/Planning/polyline_map/polyline_map.dart';
import 'package:sekkah_app/constants/app_icons.dart';
import 'package:sekkah_app/constants/app_text_styles.dart';
import 'package:sekkah_app/Planning/components/trip_duration_box.dart';
import 'package:sekkah_app/core/const.dart';

import '../RoutMap.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../helpers/route_model.dart';
import 'components/ticket_widget.dart';

class PlanRouteScreen extends StatefulWidget {
  final List<List<RouteModel>>? exproute;
  final List originLatLong;
  final List destinationLatLang;
  final String originAddress;
  final String destinationAddress;

  const PlanRouteScreen({super.key, this.exproute,required this.destinationLatLang,required this.destinationAddress,required this.originLatLong,required this.originAddress});

  @override
  State<PlanRouteScreen> createState() => _PlanRouteScreenState();
}

class _PlanRouteScreenState extends State<PlanRouteScreen> {
  List totalDuration = [];
  List totalDistance = [];
  List polylinePoints = [];
  List addresses = [];
  List turnOver = [];
  List distance = [];
  List duration = [];
  String specificRoutePolyline = '';
  bool isShow = false;
  int selectedIndex = 0;
  int? selectdIndexColor;

  @override
  void initState() {
    getAllPossibleRoutes();
    super.initState();
  }

  String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    setState(() {
      addresses.add(htmlText.replaceAll(exp, ''));
    });
    return htmlText.replaceAll(exp, '');
  }

  Future<void> getAllPossibleRoutes() async {
    GoogleMapsDirections directions = GoogleMapsDirections(
      apiKey: Const.apiKey,
      apiHeaders: await const GoogleApiHeaders().getHeaders(),
    );

    final response = await directions.directionsWithLocation(
      Location(
        lat: widget.originLatLong[0].toDouble(),
        lng: widget.originLatLong[1].toDouble(),
      ),
      Location(
        lat: widget.destinationLatLang[0].toDouble(),
        lng: widget.destinationLatLang[1].toDouble(),
      ),
      alternatives: true,
    );
    response.routes.forEach((element) {
      polylinePoints.add(element.overviewPolyline.toJson());
      element.legs.forEach((legs) {
        setState(() {
          totalDuration.add(legs.duration.text);
          totalDistance.add(legs.distance.text);
        });
        legs.steps.forEach((step) {
          removeAllHtmlTags(step.htmlInstructions);

          setState(() {
            turnOver.add(step.maneuver);
            distance.add(step.distance);
            duration.add(step.duration);
          });
        });
      });
    });
    await const Duration(seconds: 3);
     setState(() {
       isShow = true;
     });
  }

  @override
  void dispose() {
    totalDuration = [];
    totalDistance = [];
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    if(widget.exproute!.length>totalDuration.length){
      widget.exproute!.forEach((element) {
        totalDuration.add(totalDuration[0]);
        totalDistance.add(totalDistance[0]);
      });
      setState(() {
        isShow = true;
      });

    }else{
      setState(() {
        isShow = true;
      });
    }
    print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5 this is the size of list ${widget.exproute!.length}");
    return Scaffold(
      backgroundColor: AppColors.blueDarkColor,

      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          'Select a route',
          style: poppinsMedium.copyWith(
            fontSize: 18.sp,
            color: AppColors.whiteColor,
          ),
        ),
      ),

      /// body
      body: isShow == false
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                /// top box
                SizedBox(height: height(context) * 0.024),

                Container(
                  width: width(context),
                  margin:
                      EdgeInsets.symmetric(horizontal: height(context) * 0.03),
                  padding: EdgeInsets.only(
                    left: height(context) * 0.016,
                    top: height(context) * 0.016,
                    right: height(context) * 0.024,
                    bottom: height(context) * 0.032,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: AppColors.whiteColor,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: 28.h,
                            //left: 5.w,
                            right: 5.w),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                child: SvgPicture.asset(
                                  AppIcons.fromicon,
                                  height: 26.h,
                                  width: 28.w,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              SizedBox(
                                child: SvgPicture.asset(
                                  AppIcons.lines,
                                  height: 55.h,
                                  width: 1.w,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              SizedBox(
                                child: SvgPicture.asset(
                                  AppIcons.toicon,
                                  height: 26.h,
                                  width: 28.w,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ]),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'From',
                                    maxLines: 1,
                                    style: poppinsRegular.copyWith(
                                      fontSize: 12.0,
                                      color: AppColors.greyLightColor,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    widget.originAddress,
                                    // Get.arguments[2],
                                    maxLines: 1,
                                    style: poppinsMedium.copyWith(
                                      fontSize: 14.0,
                                      color: AppColors.blueDarkColor,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: height(context) * 0.015),
                              child: Divider(
                                color:
                                    AppColors.greyLightColor.withOpacity(0.3),
                                height: 1,
                                thickness: 1,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'To',
                                    maxLines: 1,
                                    style: poppinsRegular.copyWith(
                                      fontSize: 12.0,
                                      color: AppColors.greyLightColor,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    widget.destinationAddress,
                                    // Get.arguments[3],
                                    maxLines: 1,
                                    style: poppinsMedium.copyWith(
                                      fontSize: 14.0,
                                      color: AppColors.blueDarkColor,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: height(context) * 0.04),

                /// trip duration area
                Expanded(
                  child: Container(
                    width: width(context),
                    padding: EdgeInsets.symmetric(
                        horizontal: height(context) * 0.02),
                    decoration: BoxDecoration(
                      color: const Color(0xffFAFAFA).withOpacity(0.98),
                      // borderRadius: const BorderRadius.only(
                      //   topRight: Radius.circular(40.0),
                      //   topLeft: Radius.circular(40.0),
                      // ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        /// pin point
                        SizedBox(height: height(context) * 0.024),
                        Center(
                          child: Container(
                            height: 5.0,
                            width: height(context) * 0.045,
                            decoration: BoxDecoration(
                              color: AppColors.greyColor,
                              borderRadius: BorderRadius.circular(3.0),
                            ),
                          ),
                        ),

                        ///
                        SizedBox(height: height(context) * 0.02),
                        Text(
                          'Trip duration:',
                          style: poppinsMedium.copyWith(
                            fontSize: 16,
                            color: AppColors.blueDarkColor,
                          ),
                        ),

                        /// boxes
                        Expanded(
                          child: ListView.builder(
                            itemCount: widget.exproute!.length,
                            padding: const EdgeInsets.only(bottom: 50),
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              if(widget.exproute!.length>totalDuration.length){

                              }
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    specificRoutePolyline =
                                        polylinePoints[index]['points'];
                                  });
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: height(context) * 0.02),
                                  child: TicketWidget(
                                    width: width(context),
                                    height: 180.h,
                                    isCornerRounded: true,
                                    padding: EdgeInsets.all(10.h),
                                    color: selectdIndexColor == index
                                        ? AppColors.skyColor
                                        : Colors.white,
                                    onPressed: () {
                                      setState(() {
                                        if (selectdIndexColor != index) {
                                          selectdIndexColor = index;
                                          Future.delayed(
                                            const Duration(seconds: 1),
                                            () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          RouteMap(
                                                            route: widget
                                                                    .exproute![
                                                                index],
                                                            time: totalDuration[
                                                                index],
                                                            routeNo: index,
                                                          )));
                                            },
                                          );
                                        } else {
                                          selectdIndexColor = null;
                                        }
                                      });
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              totalDuration[index],
                                              style: poppinsMedium.copyWith(
                                                fontSize: 24.0,
                                                color:
                                                    selectdIndexColor == index
                                                        ? Colors.white
                                                        : AppColors.skyColor,
                                              ),
                                            ),
                                            SizedBox(width: 3.h),
                                            Text(
                                              totalDistance[index],
                                              style: poppinsMedium.copyWith(
                                                fontSize: 24.0,
                                                color: selectdIndexColor ==
                                                        index
                                                    ? Colors.white
                                                    : AppColors.blueDarkColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 12.h,
                                        ),
                                        SizedBox(
                                          height: 24.h,
                                          width: 320.w,
                                          child: Image.asset(
                                            AppIcons.ticketcomponent,
                                            fit: BoxFit.fitWidth,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 30.h,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        RouteMap(
                                                          route: widget
                                                              .exproute![index],
                                                          time: totalDuration[
                                                              index],
                                                          routeNo: index,
                                                        )));
                                          },
                                          child: Text(
                                            'Details',
                                            style: poppinsSemiBold.copyWith(
                                              fontSize: 14.sp,
                                              color: selectdIndexColor == index
                                                  ? Colors.white
                                                  : AppColors.skyColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
