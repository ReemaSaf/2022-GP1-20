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
import 'package:sekkah_app/constants/app_colors.dart';
import 'package:sekkah_app/constants/app_icons.dart';
import 'package:uuid/uuid.dart';

import 'package:sekkah_app/Planning/plan_route_screen.dart';
import 'package:sekkah_app/Planning/widgets/custom_textfield.dart';
import 'package:sekkah_app/core/const.dart';
import 'package:sekkah_app/data/constants.dart';
import 'package:sekkah_app/data/typography.dart';
import 'package:sekkah_app/helpers/user_model.dart';

import '../constants/app_text_styles.dart';
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
  List exchangeLatLong = [];
  String? exchangeName;
  double currentLocationLat = 0;
  double currentLocationLng = 0;

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
    currentLocation();
    super.initState();
  }
  currentLocation() async {
    await  CurrentLocationLat().then((value) {
      currentLocationLat = value;
      setState(() {});
    });
    await CurrentLocationLng().then((value) {
      currentLocationLng = value;
      setState(() {});
    });
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
      description = [];
      placeId = [];
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
        originLatLong = [];
        originLatLong.add(lat);
        originLatLong.add(lang);
        currentLocation();
      } else if (isToFieldFocus && isFromFieldFocus == false) {
        if (originLatLong.isEmpty) {
          fromController.text = "Your Current Location";
          originLatLong = [];
          originLatLong.add(currentLocationLat);
          originLatLong.add(currentLocationLng);
        }
        toController.text = description[index];
        destinationLatLong = [];
        destinationLatLong.add(lat);
        destinationLatLong.add(lang);
        currentLocation();

        FocusManager.instance.primaryFocus?.unfocus();
      }
      isFromFieldFocus = false;
      isToFieldFocus = false;
    });
  }

  Future<void> getCurrentLocation() async {
    await CurrentLocationLng().then((value) {
      currentLocationLng = value;
      setState(() {});
    });
    await CurrentLocationLat().then((value) {
      currentLocationLat = value;
      setState(() {});
    });
    fromController.text = "Your Current Location";
    originLatLong = [];
    originLatLong.add(currentLocationLat);
    originLatLong.add(currentLocationLng);
  }

  onExchange() {
    setState(() {
      exchangeName = fromController.text;
      exchangeLatLong = originLatLong;
      originLatLong = [];
      originLatLong = destinationLatLong;
      fromController.text = toController.text;
      destinationLatLong = [];
      destinationLatLong = exchangeLatLong;
      toController.text = exchangeName!;
    });
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
              Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 20),
              child: Center(
                child: Text(
                  'Plan Your Trip',
                  style: poppinsMedium.copyWith(
                    fontSize: 18.0,
                    color: AppColors.whiteColor,
                  ),
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
                          ? 600.h 
                          : 319.h 
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
                                  top: isFromFieldFocus || isToFieldFocus
                                      ? 80.h
                                      : 100.h,
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
                                  ]),
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
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          CustomFontWeight
                                                              .kLightFontWeight,
                                                      color: CustomColor.kgrey),
                                                );
                                              });
                                    }),
                                SizedBox(height: 4.h),
                                Text(
                                  "Where would you like to go?",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight:
                                          CustomFontWeight.kSemiBoldFontWeight,
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
                                            oncross: () async {
                                              setState(() {
                                                isFromFieldFocus = true;
                                              });
                                              fromController.clear();
                                              setState(() {
                                                originLatLong=[];
                                              })
                                              ;
                                              await Future.delayed(
                                                  const Duration(milliseconds: 50));
                                              setState(() {
                                                isFromFieldFocus = false;
                                              });
                                            },
                                            onChanged: (String value) {
                                              getSuggestion(value);
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                        onTap: () async {
                                          setState(() {
                                            isFromFieldFocus = true;
                                          });
                                          await getCurrentLocation();
                                          await Future.delayed(
                                              const Duration(milliseconds: 50));
                                          setState(() {
                                            isFromFieldFocus = false;
                                          });

                                        },
                                        child: Image.asset(
                                            'assets/images/currentLocation.png',
                                            height: 30,
                                            width: 30))
                                  ],
                                ),
                                SizedBox(height: 8.h),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "To",
                                      style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight:
                                              CustomFontWeight.kLightFontWeight,
                                          color: CustomColor.ksemigrey),
                                    ),
                                    SizedBox(width: Get.width * 0.8 - 12),
                                  ],
                                ),
                                Row(
                                  children: [
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
                                            oncross: () async {
                                              setState(() {
                                                isFromFieldFocus = true;
                                              });
                                              toController.clear();
                                              setState(() {
                                                destinationLatLong=[];
                                              });
                                              await Future.delayed(
                                                  const Duration(milliseconds: 50));
                                              setState(() {
                                                isFromFieldFocus = false;
                                              });
                                            },
                                            onChanged: (String value) {},
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        setState(() {
                                          isFromFieldFocus = true;
                                        });
                                        await onExchange();
                                        await Future.delayed(
                                            const Duration(milliseconds: 50));
                                        setState(() {
                                          isFromFieldFocus = false;
                                        });
                                      },
                                      child: Image.asset(
                                          "assets/images/arrows.png",
                                          height: 30,
                                          width: 30),
                                    )
                                  ],
                                ),
                                SizedBox(height: 8.h),
                              ],
                            )
                          ],
                        ),
                        isFromFieldFocus || isToFieldFocus
                            ? const SizedBox()
                            : InkWell(
                                onTap: () {
                                  if (originLatLong == []) {
                                    fromController.text =
                                        "Your Current Location";
                                    originLatLong = [];
                                    originLatLong.add(currentLocationLat);
                                    originLatLong.add(currentLocationLng);
                                  }
                                },
                                child: SearchRoutesButton(
                                  originLatLong: originLatLong,
                                  destinationLatLang: destinationLatLong,
                                  originAddress: fromController.text,
                                  destinationAddress: toController.text,
                                ),
                              ),
                        isFromFieldFocus || isToFieldFocus
                            ? SizedBox(
                                height: 300.h,
                                width: double.infinity * .80,
                                child: Scrollbar(
                                  thumbVisibility: true,
                                  trackVisibility: true,
                                  radius: const Radius.circular(6),
                                  thickness: 10,
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
                      height: 416.h,
                      width: double.infinity,
                      child: PlanRouteMap(
                        originLatLong: originLatLong,
                        destinationLatLong: destinationLatLong,
                        currentLat:currentLocationLat ,
                        currentLng:currentLocationLng ,
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
