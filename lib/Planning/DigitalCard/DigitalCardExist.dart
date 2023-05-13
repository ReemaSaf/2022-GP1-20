// ignore_for_file: file_names, avoid_print, empty_statements, prefer_interpolation_to_compose_strings, sized_box_for_whitespace, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:sekkah_app/others/auth_controller.dart';

import '../../Profile/widgets/show_loading_dialoges.dart';

class DigitalCardExist extends StatefulWidget {
  const DigitalCardExist({Key? key}) : super(key: key);
  @override
  State<DigitalCardExist> createState() => _DigitalCardExist();
}

class _DigitalCardExist extends State<DigitalCardExist> {
  @override
  void initState() {
    super.initState();

    AuthController.checkIfUserHasPass().then((result) {
      print("Days");
      print(result);
      setState(() {});
    });
    ;
  }

  bool isChoosed = false;
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blueDarkColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 20),
              child: Center(
                child: Text(
                  'Digital Card',
                  style: poppinsMedium.copyWith(
                    fontSize: 18.0,
                    color: AppColors.whiteColor,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                 width: width(context),
                decoration: const BoxDecoration(
                  color: Color(0xFFFAFAFA),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40),
                    topLeft: Radius.circular(40),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 30),
                        Container(
                          decoration: const BoxDecoration(),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(23),
                                child: Image.asset(
                                  'assets/images/cardd.png',
                                  fit: BoxFit.cover,
                                  width: 350,
                                  height: 200,
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(18),
                                  child: Text(
                                      'Left Duration: ${AuthController.LeftDuration == null ? '' : AuthController.LeftDuration.toString()}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 25,
                                          color: Colors.white)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text('Get New Pass',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 30,
                                color: Color(0xFF273169))),

                        const Text(
                          'Your pass is about to finish? ',
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(fontSize: 15, color: Color(0xFF273169)),
                        ),
                        const Text(
                          'Get a new one now! ',
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(fontSize: 15, color: Color(0xFF273169)),
                        ),

                        //const SizedBox(height: 5),
                        Container(
                          width: 330,
                          //height: 20,
                          padding: const EdgeInsets.only(
                            top: 20,
                            left: 8,
                            right: 8,
                            bottom: 0,
                          ),
                          decoration: BoxDecoration(
                            //color: const Color(0xffECEEF3),
                            borderRadius: BorderRadius.circular(10),
                          ),

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedIndex = 0;
                                  });
                                  print('p1');
                                  // Add your code here to handle the tap event on the daily container
                                },
                                child: Container(
                                  width: 260,
                                  height: 50,
                                  padding: const EdgeInsets.only(
                                      top: 15, left: 14, right: 14),
                                  decoration: BoxDecoration(
                                    color: selectedIndex == 0
                                        ? const Color.fromARGB(95, 80, 177, 204)
                                        : const Color(0xffECEEF3),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text('Daily',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18,
                                              color: Color(0xFF273169))),
                                      Text('5SAR',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Color(0xff50B2CC))),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedIndex = 1;
                                  });
                                  print(
                                      'p2'); // Add your code here to handle the tap event on the daily container
                                },
                                child: Container(
                                  width: 260,
                                  height: 50,
                                  padding: const EdgeInsets.only(
                                      top: 15, left: 14, right: 14),
                                  decoration: BoxDecoration(
                                    color: selectedIndex == 1
                                        ? const Color.fromARGB(95, 80, 177, 204)
                                        : const Color(0xffECEEF3),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text('Weekly',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18,
                                              color: Color(0xFF273169))),
                                      Text('30SAR',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Color(0xff50B2CC))),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedIndex = 2;
                                  });
                                  print(
                                      'p3'); // Add your code here to handle the tap event on the daily container
                                },
                                onDoubleTap: () {
                                  setState(() {
                                    selectedIndex = -1;
                                  });
                                  print(
                                      'pp'); // Add your code here to handle the tap event on the daily container
                                },
                                hoverColor: AppColors.skyColor,
                                child: Container(
                                  width: 260,
                                  height: 50,
                                  padding: const EdgeInsets.only(
                                      top: 15, left: 14, right: 14),
                                  decoration: BoxDecoration(
                                    color: selectedIndex == 2
                                        ? const Color.fromARGB(95, 80, 177, 204)
                                        : const Color(0xffECEEF3),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text('Monthly',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18,
                                              color: Color(0xFF273169))),
                                      Text('100SAR',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Color(0xff50B2CC))),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              Container(
                                height: 40,
                                width: 120,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: AppColors.skyColor,
                                  ),
                                  child: Text(
                                    'Pay',
                                    style: poppinsMedium.copyWith(
                                      fontSize: 18.0,
                                      color: AppColors.blueDarkColor,
                                    ),
                                  ),
                                  onPressed: () {
                                    if (selectedIndex == -1) {
                                      showDialog(
                                        context: context,
                                        builder: (ctx) => const AlertDialog(
                                          title:
                                              Text("Please Choose An Option"),
                                        ),
                                      );
                                    } else {
                                      handlePass(context);
                                    }
                                  },
                                ),
                              ),
                              Container(
                                  child: Text(
                                      isChoosed == true ? 'please choose' : ''))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
          ],
        ),
      ),
    );
  }

  void handlePass(BuildContext context) {
    var name = '';
    var days = 0;
    var price = 0;
    if (selectedIndex == 0) {
      name = "Daily, Only 5 SAR";
      days = 1;
      price = 5;
    } else if (selectedIndex == 1) {
      name = "Weekly,  Only 30 SAR";
      price = 30;
      days = 7;
    } else if (selectedIndex == 2) {
      name = "Monthly, Only 100 SAR";
      price = 100;
      days = 30;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => UsePaypal(
          sandboxMode: true,
          clientId:
              "AVa3kt6bS7e_hbkKE_vUpAWaG5br8dV2OhnzQbEdrespe_TYw2bYeaYqp3jBUnw8SkhadffVGDnLZS6q",
          secretKey:
              "EDQ8OKZThArzCJx_b6UX95T7_ZBMpnaLK6NlQHkx7xTKdrhXX1aLb47OvUOOvKimAO8g0M-3j0HYzrKE",
          returnURL: "https://samplesite.com/return",
          cancelURL: "https://samplesite.com/cancel",
          transactions: [
            {
              "amount": {
                "total": price.toString(),
                "currency": "USD",
                "details": {
                  "subtotal": price.toString(),
                  "shipping": '0',
                  "shipping_discount": 0
                }
              },
              "description": "The payment transaction description.",
              // "payment_options": {
              //   "allowed_payment_method":
              //       "INSTANT_FUNDING_SOURCE"
              // },
              "item_list": {
                "items": [
                  {
                    "name": "A demo product",
                    "quantity": 1,
                    "price": price.toString(),
                    "currency": "USD"
                  }
                ],

                // shipping address is not required though
                "shipping_address": const {
                  "recipient_name": "Jane Foster",
                  "line1": "Travis County",
                  "line2": "",
                  "city": "Austin",
                  "country_code": "US",
                  "postal_code": "73301",
                  "phone": "+00000000",
                  "state": "Texas"
                },
              }
            }
          ],
          note: "Contact us for any questions on your order.",
          onSuccess: (Map params) {
            print("onSuccess: $params");
            showLoadingDialog(message: "Saving");
            AuthController.savePass(days, name).then((value) => {
                  AuthController.checkIfUserHasPass().then((result) {
                    hideLoadingDialog();
                    setState(() {});
                  })
                });
          },
          onError: (error) {
            print("onError: $error");
            Navigator.of(context).pop();
          },
          onCancel: (params) {
            print('cancelled: $params');
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}

TextStyle poppinsLight = GoogleFonts.poppins(
  fontWeight: FontWeight.w300,
  height: 1.5,
);

TextStyle poppinsRegular = GoogleFonts.poppins(
  fontWeight: FontWeight.normal,
  height: 1.5,
);

TextStyle poppinsMedium = GoogleFonts.poppins(
  fontWeight: FontWeight.w600,
  height: 1.5,
);

TextStyle poppinsSemiBold = GoogleFonts.poppins(
  fontWeight: FontWeight.w700,
  height: 1.5,
);

TextStyle poppinsBold = GoogleFonts.poppins(
  fontWeight: FontWeight.w800,
  height: 1.5,
);

class AppColors {
  static const Color blueDarkColor = Color(0xff273A69);
  static const Color whiteColor = Color(0xffFFFFFF);
  static const Color blackColor = Color(0xff000000);
  static const Color greyLightColor = Color(0xffBABEC5);
  static const Color whiteLightColor = Color(0xffF2F2F2);
  static const Color greyColor = Color(0xffD8D8D8);
  static const Color skyColor = Color(0xff50B2CC);
  static const Color dashColor = Color(0xffECEEF3);
  static const Color greyDarkColor = Color(0xffB3B7C3);
}

double height(context) {
  return MediaQuery.of(context).size.height;
}

double width(context) {
  return MediaQuery.of(context).size.width;
}
