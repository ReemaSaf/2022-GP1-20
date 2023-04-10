// ignore_for_file: file_names, depend_on_referenced_packages, unused_import, library_private_types_in_public_api, non_constant_identifier_names, unused_field, avoid_print, curly_braces_in_flow_control_structures, prefer_interpolation_to_compose_strings, unused_local_variable, sized_box_for_whitespace, unnecessary_null_comparison, sort_child_properties_last

import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sekkah_app/Homepage/components/user_nav.dart';
import 'package:sekkah_app/helpers/user_model.dart';
import 'package:sekkah_app/others/auth_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Tickets/Ticket1.dart';
import 'constants/app_colors.dart';
import 'constants/app_icons.dart';
import 'constants/app_sizes.dart';
import 'constants/app_text_styles.dart';
import 'helpers/dialog_alert.dart';
import 'helpers/route_model.dart';

class BuyTicket extends StatefulWidget {
  final String startLocation;
  final String endLocation;
  final int stops;
  final List<RouteModel> allRoutes;
  final String routeTime;

  const BuyTicket(
      {super.key,
      required this.startLocation,
      required this.endLocation,
      required this.stops,
      required this.allRoutes,
      required this.routeTime});

  @override
  _BuyTicketState createState() => _BuyTicketState();
}

class _BuyTicketState extends State<BuyTicket> {
  int? _selectedOption = 0;
  bool isDigitalCard = false;
  FirebaseAuth auth = FirebaseAuth.instance;

  String time='';

  void _incrementPassengerCount() {
    setState(() {
      if (_selectedOption == 2) {
        _passengerCount = 1;
        return;
      }
      if (_passengerCount < 6) {
        _passengerCount++;
        _price = _passengerCount * 4;
        _sarPrice = _price * 0.267;
         _formattedUSPrice = _sarPrice.toStringAsFixed(2);
      }
    });
  }

  void _decrementPassengerCount() {
    setState(() {
      if (_passengerCount > 1) {
        _passengerCount--;
        _price = _passengerCount * 4;
        _sarPrice = (_price * 0.267);
        _formattedUSPrice = _sarPrice.toStringAsFixed(2);
      }
    });
  }

  int _passengerCount = 1;
  int _price = 4;
  late double _sarPrice;
   String _formattedUSPrice="1.07";

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String startAddress = "";
  String endAddress = "";
  String allRoutesCombine = "";
  String passtime = "";

  DateTime _dateTime = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      DateTime.now().hour,
      (((DateTime.now().minute / 15).round() + 1) * 15) % 60);

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    checkCard();
    print(widget.routeTime);

    if (!auth.currentUser!.isAnonymous)
      AuthController.checkIfUserHasPass().then((result) {
        print("Days");
        print(result);
        passtime = result.toString();
        setState(() {});
      });

    super.initState();
  }

  checkCard() async {
    DocumentSnapshot doc = await _firestore
        .collection('Passenger') //from passengers collection
        .doc(_auth.currentUser!.uid)
        .get();

    UserModel user = UserModel.fromMap(doc.data() as Map<String, dynamic>);
    log("here is the result :${user.Pass_Expired_date != "0"}");

    setState(() {
      if (user.Pass_Expired_date == "0") {
        isDigitalCard = false;
      } else if (user.Pass_Expired_date != "0") {
        var alreadyTime = DateTime.fromMillisecondsSinceEpoch(
            int.parse(user.Pass_Expired_date));
        isDigitalCard = !alreadyTime.isBefore(DateTime.now());
        print("Expired => " + alreadyTime.isBefore(DateTime.now()).toString());
      }
    });
  }

  @override
  Widget build(BuildContext buildContext) => Scaffold(
      backgroundColor: AppColors.blueDarkColor,
      appBar: AppBar(
        leading: IconButton(
    icon:const Icon(Icons.arrow_back, color: Colors.white),
    onPressed: () => Navigator.of(context).pop(),
  ), 
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          'Purchase A Ticket',
          style: poppinsMedium.copyWith(
            fontSize: 18.sp,
            color: AppColors.whiteColor,
          ),
        ),
      ),

      /// body
      body: Padding(
          padding: const EdgeInsets.only(top: 150),
          child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              padding: const EdgeInsets.only(left: 20, top: 10),
              // margin: const EdgeInsets.only(bottom: 20),
              width: double.infinity,

              //  height: height(context) * 0.8,

              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: width(buildContext),
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
                                top: 12.h,
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
                                  padding:
                                      const EdgeInsets.only(left: 10.0, top: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        widget.startLocation,
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
                                      vertical: height(buildContext) * 0.015),
                                  child: Divider(
                                    color: AppColors.greyLightColor
                                        .withOpacity(0.3),
                                    height: 1,
                                    thickness: 1,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        widget.endLocation,
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
                    const Padding(padding: EdgeInsets.only(top: 20, left: 20)),
                    Text(
                      'Time:',
                      // textAlign: TextAlign.left,
                      style: poppinsMedium.copyWith(
                        fontSize: 15.0,
                        color: AppColors.blueDarkColor,
                      ),
                    ),
                    ButtonWidget(
                      time: time,
                      onClicked: () => Utils.showSheet(
                        buildContext,
                        child: buildDateTimePicker(),
                        onClicked: () {
                          final value =
                              DateFormat('dd/MM/yyyy HH:mm').format(_dateTime);
                              time= value;
                              setState(() {

                               });
           
                          Navigator.pop(buildContext);
                        },
                      ),
                       
                      
                    ),
                    
                    Text(
                      'Passengers:',
                      // textAlign: TextAlign.left,
                      style: poppinsMedium.copyWith(
                        fontSize: 15.0,
                        color: AppColors.blueDarkColor,
                      ),
                    ),
                    Container(
                      width: 350,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: AppColors.whiteLightColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(20.0),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.account_circle_outlined,
                              size: 35, color: AppColors.skyColor),
                          const SizedBox(width: 200),
                          SizedBox(
                            height: 35, //height of button
                            width: 30,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.blueDarkColor,
                                shape: const CircleBorder(),
                                padding: EdgeInsets.zero,
                              ),
                              onPressed: _decrementPassengerCount,
                              child: const Icon(Icons.remove),
                            ),
                          ),
                          const SizedBox(width: 7),
                          SizedBox(
                            width: 7,
                            child: Text(
                              _passengerCount.toString(),
                              style: poppinsMedium.copyWith(
                                fontSize: 18.0,
                                color: AppColors.blueDarkColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 11),
                          SizedBox(
                            height: 35, //height of button
                            width: 30,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.blueDarkColor,
                                shape: const CircleBorder(),
                                padding: EdgeInsets.zero,
                              ),
                              onPressed: _incrementPassengerCount,
                              child: const Icon(Icons.add),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Payment:',
                      // textAlign: TextAlign.left,
                      style: poppinsMedium.copyWith(
                        fontSize: 15.0,
                        color: AppColors.blueDarkColor,
                      ),
                    ),
                    Container(
                      width: 350,
                      height: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              padding: const EdgeInsets.only(bottom: 7),
                              height: 47,
                              width: 350,
                              decoration: const BoxDecoration(
                                color: AppColors.whiteLightColor,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20.0),
                                ),
                              ),
                              child: ListView(
                                // padding: EdgeInsets.only(left: 10,bottom: 15),

                                children: [
                                  RadioListTile(
                                    // contentPadding: EdgeInsets.only(bottom: 15,left: 10),
                                    value: 1,

                                    activeColor: AppColors.blueDarkColor,
                                    groupValue: _selectedOption,
                                    title: Text(
                                      'PayPal',
                                      style: poppinsMedium.copyWith(
                                        fontSize: 15.0,
                                        color: AppColors.blueDarkColor,
                                      ),
                                    ),
                                    onChanged: (int? value) {
                                      setState(() {
                                        _selectedOption = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Align(
                             
                              child: Row(
                                children: [
                                  Container(
                                    height: 47,
                                    width: 175,
                                    decoration: const BoxDecoration(
                                      color: AppColors.whiteLightColor,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20.0),
                                        bottomLeft: Radius.circular(20.0),
                                      ),
                                    ),

                                    // padding: EdgeInsets.only(bottom: 10),
                                    //alignment: Alignment.center,

                                    child: ListView(
                                      children: [
                                        RadioListTile(
                                          value: 2,
                                          activeColor: AppColors.blueDarkColor,
                                          groupValue: _selectedOption,
                                          title: Text(
                                            'By Pass',
                                            style: poppinsMedium.copyWith(
                                              fontSize: 15.0,
                                              color: AppColors.blueDarkColor,
                                            ),
                                          ),
                                          onChanged: (int? value) {
                                            if (_passengerCount > 1)
                                            Get.snackbar(
                                                'Alert',
                                                "Pass Is Limited For One Passenger",
                                                colorText: Colors.white,
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 80, 159, 204));

                                            setState(() {
                                              _selectedOption = value;
                                              _passengerCount = 1;
                                              _price = _passengerCount * 4;
                                              _sarPrice = _price * 0.267;
                                              _formattedUSPrice = _sarPrice.toStringAsFixed(2);
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (!auth.currentUser!.isAnonymous && isDigitalCard)
                                    Container(
                                      height: 47,
                                      width: 175,
                                      padding: const EdgeInsets.only(
                                        right: 10,
                                      ),
                                      decoration: const BoxDecoration(
                                        color: AppColors.whiteLightColor,
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20.0),
                                          bottomRight: Radius.circular(20.0),
                                        ),
                                      ),
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        'Pass Expires In $passtime',
                                        style: poppinsMedium.copyWith(
                                          fontSize: 13.0,
                                          color: AppColors.skyColor,
                                        ),
                                      ),
                                    ),

                                     if (auth.currentUser!.isAnonymous || !isDigitalCard)
                                    Container(
                                      height: 47,
                                      width: 175,
                                      padding: const EdgeInsets.only(
                                        right: 10,
                                      ),
                                      decoration: const BoxDecoration(
                                        color: AppColors.whiteLightColor,
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20.0),
                                          bottomRight: Radius.circular(20.0),
                                        ),
                                      ),
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        "* No Active Pass ",
                                        style: poppinsMedium.copyWith(
                                          fontSize: 13.0,
                                          color: AppColors.skyColor,
                                        ),
                                      ),
                                    )
                                    
                                ],
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    Center(
                      child: Text(
                        'Total Price: $_price SAR',
                        style: poppinsMedium.copyWith(
                          fontSize: 20.0,
                          color: AppColors.blueDarkColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Container(
                        width: 200,
                        height: 40,
                        child: ElevatedButton(
                            style: TextButton.styleFrom(
                              backgroundColor: AppColors.skyColor,
                            ),
                            child: Text(
                              'Continue',
                              style: poppinsMedium.copyWith(
                                fontSize: 16.0,
                                color: AppColors.whiteColor,
                              ),
                            ),
                            onPressed: () async {
                              if (auth.currentUser!.isAnonymous) {
                                Get.snackbar(
                                    'Alert', 'You have to Register First',
                                    colorText: Colors.white,
                                    backgroundColor:
                                        const Color.fromARGB(255, 204, 84, 80));
                                return;
                              }
                              if (_dateTime == null ||
                                  _passengerCount <= 0 ||
                                  _selectedOption == 0) {
                                Get.snackbar(
                                    'Alert', 'Select Payment Type First',
                                    colorText: Colors.white,
                                    backgroundColor:
                                        const Color.fromARGB(255, 204, 84, 80));
                                return;
                              }
                              if (_selectedOption == 1) {
                                Navigator.of(buildContext).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        UsePaypal(
                                            sandboxMode: true,
                                            clientId:
                                                "AVa3kt6bS7e_hbkKE_vUpAWaG5br8dV2OhnzQbEdrespe_TYw2bYeaYqp3jBUnw8SkhadffVGDnLZS6q",
                                            secretKey:
                                                "EDQ8OKZThArzCJx_b6UX95T7_ZBMpnaLK6NlQHkx7xTKdrhXX1aLb47OvUOOvKimAO8g0M-3j0HYzrKE",
                                            returnURL:
                                                "https://samplesite.com/return",
                                            cancelURL:
                                                "https://samplesite.com/cancel",
                                            transactions: [
                                              {
                                                "amount": {
                                                  "total": _formattedUSPrice,
                                                  "currency": "USD",
                                                  "details": {
                                                    "subtotal": _formattedUSPrice,
                                                    "shipping": '0',
                                                    "shipping_discount": 0
                                                  }
                                                },
                                                "description":
                                                    "To Buy A Metro Card.",
                                                // "payment_options": {
                                                //   "allowed_payment_method":
                                                //       "INSTANT_FUNDING_SOURCE"
                                                // },
                                                "item_list": {
                                                  "items": [
                                                    {
                                                      "name": "Metro Ticket",
                                                      "quantity": 1,
                                                      "price": _formattedUSPrice,
                                                      "currency": "USD"
                                                    }
                                                  ],

                                                  // shipping address is not required though
                                                  "shipping_address": const {
                                                    "recipient_name":
                                                        "SEKKAH",
                                                    "line1": "King Khaled Road",
                                                    "line2": "",
                                                    "city": "Riyadh",
                                                    "country_code": "US",
                                                    "postal_code": "11111",
                                                    "phone": "+966592000422",
                                                    "state": "Riyadh"
                                                  },
                                                }
                                              }
                                            ],
                                            note:
                                                "Contact us for any questions on your order.",
                                            onSuccess: (Map params) async {
                                              FirebaseFirestore.instance
                                                  .collection('tickets')
                                                  .add({
                                                'startLocation':
                                                    widget.startLocation,
                                                "endLocation":
                                                    widget.endLocation,
                                                'tickets': _passengerCount,
                                                'time': _dateTime,
                                                'user': auth.currentUser!.uid,
                                                'paymentType': "Paypal",
                                              }).then((value) {
                                                Navigator.of(buildContext).push(
                                                  MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        Tickets(
                                                      routeTime:
                                                          widget.routeTime,
                                                      start:
                                                          widget.startLocation,
                                                      end: widget.endLocation,
                                                      date: _dateTime,
                                                      tickets: _passengerCount,
                                                      paymentType: "Paypal",
                                                    ),
                                                  ),
                                                );
                                              });
                                            },
                                            onError: (error) {
                                              print("onError: $error");
                                            },
                                            onCancel: (params) {
                                              print('cancelled: $params');
                                            }),
                                  ),
                                );
                              } else if (_selectedOption == 2) {
                                if (!isDigitalCard) {
                                  await showConfirmationDialog(
                                      heading: "Alert",
                                      message:
                                          "You Don't Have An Active Digital Card",
                                      okText: "Activate",
                                      onPressedOk:() {
                                                Get.offAll(
                                                    const NavScreen(inh: 2));
                                              },
                                      cancel: () {
                                        Get.back();
                                        
                                      });
                                      
                                } else {
                                  FirebaseFirestore.instance
                                      .collection('tickets')
                                      .add({
                                    'startLocation': widget.startLocation,
                                    "endLocation": widget.endLocation,
                                    'time': _dateTime,
                                    'tickets': _passengerCount,
                                    'user': auth.currentUser!.uid,
                                    'paymentType': "Card",
                                  }).then((value) {
                                    Navigator.of(buildContext).push(
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            Tickets(
                                          routeTime: widget.routeTime,
                                          start: widget.startLocation,
                                          end: widget.endLocation,
                                          date: _dateTime,
                                          tickets: _passengerCount,
                                          paymentType: "Card",
                                        ),
                                      ),
                                    );
                                  });
                                }
                              }
                            }),
                      ),
                    ),
                  ]))));

  Widget buildDateTimePicker() => SizedBox(
        height: 180,
        child: CupertinoDatePicker( 
          mode: CupertinoDatePickerMode.dateAndTime,
          minimumDate: DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
              DateTime.now().hour,
              (((DateTime.now().minute / 15).round() + 1) * 15) % 60),
          maximumDate: DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day + 4),
          use24hFormat: true,
          minuteInterval: 15,
          initialDateTime: _dateTime,
          onDateTimeChanged: (dateTime) => setState(() => _dateTime = dateTime),
        ),
      );
}




class Utils {
  static void showSheet(
    BuildContext context, {
    required Widget child,
    required VoidCallback onClicked,
     
    
  }) =>
      showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
          actions: [
            child,
          ],
          cancelButton: CupertinoActionSheetAction(
            child: const Text('Done'),
            onPressed: onClicked,
          ),
        ),
      );
}

class ButtonWidget extends StatelessWidget {
  final VoidCallback onClicked;
  final String time;

  const ButtonWidget({
    Key? key,
    required this.onClicked,
    required this.time
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
        style: ElevatedButton.styleFrom(
            foregroundColor: const Color.fromARGB(255, 118, 171, 201),
            backgroundColor: AppColors.whiteLightColor,
            minimumSize: const Size(350, 42)),
        onPressed: onClicked,
        
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children:  [
            const Icon(Icons.more_time, size: 28),
const SizedBox(width: 8),
            Text(time,style: const TextStyle(fontSize: 15,),)
          ],
        ),
      );
}
