// ignore_for_file: public_member_api_docs, sort_constructors_first, avoid_function_literals_in_foreach_calls, duplicate_ignore, avoid_print
// ignore_for_file: unused_import, unnecessary_null_comparison

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:location/location.dart' as loc;
import 'package:sekkah_app/Homepage/services/locationServices.dart';
import 'package:sekkah_app/constants/app_icons.dart';
import 'package:uuid/uuid.dart';

import 'package:sekkah_app/Planning/plan_route_screen.dart';
import 'package:sekkah_app/Planning/widgets/custom_textfield.dart';
import 'package:sekkah_app/core/const.dart';
import 'package:sekkah_app/data/constants.dart';
import 'package:sekkah_app/data/typography.dart';
import 'package:sekkah_app/helpers/user_model.dart';

import 'routeHelpers/currentLocation.dart';
import 'widgets/plan_route_map.dart';
import 'widgets/search_button.dart';

class PlanARoute extends StatefulWidget {
  const PlanARoute({Key? key}) : super(key: key);

  @override
  State<PlanARoute> createState() => _PlanARoute();
}

class _PlanARoute extends State<PlanARoute> {
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  TextEditingController arrivaltimeController = TextEditingController();
  bool isFromFieldFocus = false;
  bool isToFieldFocus = false;
  var uuid = const Uuid();
  String sessionToken = '123456';
  List<dynamic> description = [];
  List<dynamic> placeId = [];
  List originLatLong = [];
  List destinationLatLong = [];
  double currentLocationLat=0;
  double currentLocationLng=0;

  @override
  void initState() {
    toController.addListener(() {
      toOnChanged();
      if (toController.text == '') {
        description = [];
        placeId = [];
      }
    });
    fromController.addListener(() {
      fromOnchanged();
      if (fromController.text == '') {
        description = [];
        placeId = [];
      }
    });
    super.initState();
  }

  void toOnChanged() {
    if (sessionToken == null) {
      setState(() {
        sessionToken = const Uuid().v4();
      });
    }
    getSuggestion(toController.text);
  }

  void fromOnchanged() {
    if (sessionToken == null) {
      setState(() {
        sessionToken = uuid.v4();
      });
    }
    getSuggestion(fromController.text);
  }

  Future<void> getSuggestion(String input) async {
    final places = await GoogleMapsPlaces(
      apiKey: Const.apiKey,
      apiHeaders: await const GoogleApiHeaders().getHeaders(),
    ).autocomplete(input,
        region: 'SA',
        origin: Location(
          lat: 24.7136,
          lng: 46.6753,
        ),
        location: Location(
          lat: 24.7136,
          lng: 46.6753,
        ),
        radius: 10000,
        strictbounds: true,
        sessionToken: const Uuid().v4());

    places.isNotFound
        ? Get.snackbar('Not Found', 'Place Not found please change the keyword')
        : const SizedBox();
    // ignore: avoid_function_literals_in_foreach_calls
    setState(() {
      description=[];
      placeId=[];
    });
    places.predictions.forEach((pred) {
      setState(() {
        description.add(pred.description);
        placeId.add(pred.placeId);
      });
    });
  }

  Future<void> putSpecificLocation(int index) async {
    final plist = GoogleMapsPlaces(
      apiKey: Const.apiKey,
      apiHeaders: await const GoogleApiHeaders().getHeaders(),
    );
    final detail = await plist.getDetailsByPlaceId(placeId[index]);
    final geometry = detail.result.geometry!;
    final lat = geometry.location.lat;
    final lang = geometry.location.lng;
    setState(() {
      if (isFromFieldFocus && isToFieldFocus == false) {
        fromController.text = description[index];
        originLatLong=[];
        originLatLong.add(lat);
        originLatLong.add(lang);
      } else if (isToFieldFocus && isFromFieldFocus == false) {
        toController.text = description[index];
        destinationLatLong=[];
        destinationLatLong.add(lat);
        destinationLatLong.add(lang);
      }
      isFromFieldFocus = false;
      isToFieldFocus = false;
    });
  }
  Future<void> getCurrentLocation() async {
    await CurrentLocationLng().then((value) {
      currentLocationLng=value;
      setState(() {

      });
    });
    await CurrentLocationLat().then((value) {
      currentLocationLat=value;
      setState(() {
      });
    });
    fromController.text ="Your Current Location";
    print("lakdskjsjhfkfhlkjf $currentLocationLat  $currentLocationLng");
    originLatLong=[];
    originLatLong.add(currentLocationLat);
    originLatLong.add(currentLocationLng);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.kprimaryblue,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 30, bottom: 20),
                child: Center(
                  child: Text(
                    "Plan Your Trip",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    isFromFieldFocus = false;
                    isToFieldFocus = false;
                  });
                },
                child: AspectRatio(
                  aspectRatio: Get.width /
                      (isFromFieldFocus || isToFieldFocus
                          ? 600.h //Get.height*0.5-10
                          : 319.h//Get.height * 0.44
                          ),
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Color(0xFFFAFAFA),
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(40),
                            topLeft: Radius.circular(40))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                        Padding(
                           padding: EdgeInsets.only(
                                  top: isFromFieldFocus || isToFieldFocus ? 80.h : 100.h,
                                  left: 13.h,
                                  right: 5.h),
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
                                  height: 45.h,
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
                            ]
                              ),
                        ),
                        Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 17.h),
                                StreamBuilder(
                                    stream: FirebaseAuth.instance
                                        .authStateChanges(),
                                    builder: (context, snapshot) {
                                      User? user = snapshot.data as User?;
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Text(
                                          'Loading...',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: CustomFontWeight
                                                  .kLightFontWeight,
                                              color: CustomColor.kgrey),
                                        );
                                      }
                                      return user!.isAnonymous
                                          ? Text(
                                              'Hi there',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: CustomFontWeight
                                                      .kLightFontWeight,
                                                  color: CustomColor.kgrey),
                                            )
                                          : StreamBuilder<UserModel>(
                                              stream: FirebaseFirestore.instance
                                                  .collection('Passenger')
                                                  .doc(user.uid)
                                                  .snapshots()
                                                  .map((event) =>
                                                      UserModel.fromMap(
                                                          event.data() as Map<
                                                              String,
                                                              dynamic>)),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return Text(
                                                    'Loading...',
                                                    style: TextStyle(
                                                        fontSize: 12.sp,
                                                        fontWeight:
                                                            CustomFontWeight
                                                                .kLightFontWeight,
                                                        color:
                                                            CustomColor.kgrey),
                                                  );
                                                }
                                                UserModel myuser =
                                                    snapshot.data as UserModel;
                                                String username =
                                                    myuser.firstName;
                                                return Text(
                                                  'Hi $username',
                                                  style: TextStyle(
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          CustomFontWeight
                                                              .kLightFontWeight,
                                                      color: CustomColor.kgrey),
                                                );
                                              });
                                    }),
                                SizedBox(height: 4.h),
                                isFromFieldFocus || isToFieldFocus
                                    ? const SizedBox()
                                    : Text(
                                        "Where would you like to go?",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: CustomFontWeight
                                                .kSemiBoldFontWeight,
                                            color: CustomColor.klightblue),
                                      ),
                              SizedBox(height: 11.h),
                                Text(
                                  "From",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight:
                                          CustomFontWeight.kLightFontWeight,
                                      color: CustomColor.ksemigrey),
                                ),
                                SizedBox(height: 3.h),
                                Row(
                                  children: [
                                    FocusScope(
                                      child: Focus(
                                        onFocusChange: (focus) => setState(() {
                                          isFromFieldFocus = focus;
                                        }),
                                        child: SizedBox(
                                          height: Get.height * 0.05,
                                          width: Get.width * 0.8,
                                          child: CustomTextField(
                                            controller: fromController,
                                            textInputType: TextInputType.text,
                                            hintText: '',
                                            showCalenderIcon: false,
                                            oncross: () {
                                              fromController.clear();
                                            },
                                            onChanged: (String value) {
                                              getSuggestion(value);
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(onTap:() {
                                      getCurrentLocation();
                                    },child: Image.asset('assets/images/currentLocation.png',height: 34,width: 34))
                                  ],
                                ),
                               SizedBox(height: 8.h),
                                Text(
                                  "To",
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight:
                                          CustomFontWeight.kLightFontWeight,
                                      color: CustomColor.ksemigrey),
                                ),
                                // const SizedBox(height: 3),
                                FocusScope(
                                  child: Focus(
                                    onFocusChange: (focus) => setState(() {
                                      isToFieldFocus = focus;
                                    }),
                                    child: SizedBox(
                                      height: Get.height * 0.05,
                                      width: Get.width * 0.8,
                                      child: CustomTextField(
                                        controller: toController,
                                        textInputType: TextInputType.text,
                                        hintText: '',
                                        showCalenderIcon: false,
                                        oncross: () {
                                          toController.clear();
                                        },
                                        onChanged: (String value) {},
                                      ),
                                    ),
                                  ),
                                ),
                              SizedBox(height: 8.h),
                        //         Text(
                        //           "Departing / Arrival time",
                        //           style: TextStyle(
                        //               fontSize: 12,
                        //               fontWeight:
                        //                   CustomFontWeight.kLightFontWeight,
                        //               color: CustomColor.ksemigrey),
                        //         ),
                        //         const SizedBox(height: 3),
                        //         SizedBox(
                        //           height: Get.height * 0.05,
                        //           width: Get.width * 0.8,
                        //           child: CustomTextField(
                        //             controller: arrivaltimeController,
                        //             textInputType: TextInputType.none,
                        //             hintText: 'now',
                        //             showCalenderIcon: true,
                        //             oncross: () {},
                        //             onChanged: (String value) {},
                        //           ),
                        //         ),
                              ],
                             )
                           ],
                         ),
                        
                        isFromFieldFocus || isToFieldFocus
                            ? const SizedBox()
                            : SearchRoutesButton(
                                originLatLong: originLatLong,
                                destinationLatLang: destinationLatLong,
                                originAddress: fromController.text,
                                destinationAddress: toController.text,
                              ),
                        isFromFieldFocus || isToFieldFocus
                            ? SizedBox(
                                height: 300.h,
                                width: double.infinity * .80,
                                child: ListView.builder(
                                  itemCount: description.length,
                                  itemBuilder: ((context, index) {
                                    return ListTile(
                                      onTap: () async {
                                        await putSpecificLocation(index);
                                      },
                                      leading: const Icon(Icons.location_on),
                                      title: Text(description[index]),
                                    );
                                  }),
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ),
              ),
              isFromFieldFocus || isToFieldFocus
                  ? const SizedBox()
                  : SizedBox(
                    height: 390.h,
                    width: double.infinity,
                    child: PlanRouteMap(
                        originLatLong: originLatLong,
                        destinationLatLong: destinationLatLong,
                      ),
                  )
            ],
          ),
        ),
      ),
    );
  }
}
