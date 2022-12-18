// ignore_for_file: unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sekkah_app/Planning/plan_route_screen.dart';
import 'package:sekkah_app/Planning/widgets/custom_textfield.dart';
import 'package:sekkah_app/core/const.dart';
import 'package:sekkah_app/data/constants.dart';
import 'package:sekkah_app/data/typography.dart';
import 'package:sekkah_app/helpers/user_model.dart';


class PlanARoute extends StatefulWidget {
  const PlanARoute({Key? key}) : super(key: key);

  @override
  State<PlanARoute> createState() => _PlanARoute();
}

class _PlanARoute extends State<PlanARoute> {
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  TextEditingController arrivaltimeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.kprimaryblue,
      body: SafeArea(
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
            AspectRatio(
              aspectRatio: Get.width / (Get.height * 0.44),
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
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: (Get.height * 0.1) + 20, left: 13, right: 5),
                          child: SizedBox(
                            child: SvgPicture.asset(
                              'assets/images/location_icon.svg',
                              height: ((Get.height * 0.1) + 10),
                              width: ((Get.width * 0.1) + 10),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 17),
                            StreamBuilder(
                                stream:
                                    FirebaseAuth.instance.authStateChanges(),
                                builder: (context, snapshot) {
                                  User? user = snapshot.data as User?;
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return  Text('Loading...',
                                     style: TextStyle(
                                                   fontSize: 12,
                                                fontWeight: CustomFontWeight.kLightFontWeight,
                                                color: CustomColor.kgrey),
                                    );
                                  }
                                  return user!.isAnonymous
                                        ? Text(
                                            'Hi there',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: CustomFontWeight.kLightFontWeight,
                                                color: CustomColor.kgrey),
                                )
                                      : StreamBuilder<UserModel>(
                                          stream: FirebaseFirestore.instance
                                              .collection('Passenger')
                                              .doc(user.uid)
                                              .snapshots()
                                              .map((event) => UserModel.fromMap(
                                                  event.data()
                                                      as Map<String, dynamic>)),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Text('Loading...',
                                     style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: CustomFontWeight
                                                      .kLightFontWeight,
                                                  color: CustomColor.kgrey),
                                    );
                                  }
                                            UserModel myuser = snapshot.data as UserModel;
                                            String username = myuser.firstName;
                                            return Text(
                                              'Hi $username',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: CustomFontWeight
                                                      .kLightFontWeight,
                                                  color: CustomColor.kgrey),
                                            );
                                          });
                                }),
                                
                            const SizedBox(height: 4),
                            Text(
                              "Where would you like to go?",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight:
                                      CustomFontWeight.kSemiBoldFontWeight,
                                  color: CustomColor.klightblue),
                            ),
                            const SizedBox(height: 11),
                            Text(
                              "From",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: CustomFontWeight.kLightFontWeight,
                                  color: CustomColor.ksemigrey),
                            ),
                            const SizedBox(height: 3),
                            SizedBox(
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
                                onChanged: (String value) {},
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "To",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: CustomFontWeight.kLightFontWeight,
                                  color: CustomColor.ksemigrey),
                            ),
                            const SizedBox(height: 3),
                            SizedBox(
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
                            const SizedBox(height: 8),
                            Text(
                              "Departing / Arrival time",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: CustomFontWeight.kLightFontWeight,
                                  color: CustomColor.ksemigrey),
                            ),
                            const SizedBox(height: 3),
                            SizedBox(
                              height: Get.height * 0.05,
                              width: Get.width * 0.8,
                              child: CustomTextField(
                                controller: arrivaltimeController,
                                textInputType: TextInputType.none,
                                hintText: 'now',
                                showCalenderIcon: true,
                                oncross: () {},
                                onChanged: (String value) {},
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 15),
                      child: SizedBox(
                        height: Get.height * 0.05,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: CustomColor.kprimaryblue,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24))),
                          onPressed: () {
                             Get.to(const PlanRouteScreen());
                          },
                          child: Text(
                            "Search Routes",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: CustomFontWeight.kBoldFontWeight,
                                color: CustomColor.kWhite),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Expanded(
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(24.71619956670347, 46.68385748947401),
                  zoom: 11,
                ),
                zoomControlsEnabled: false,
                zoomGesturesEnabled: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}