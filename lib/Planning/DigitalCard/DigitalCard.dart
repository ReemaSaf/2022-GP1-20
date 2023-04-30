// ignore_for_file: file_names, sized_box_for_whitespace, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:get/get.dart';
import 'package:sekkah_app/Planning/DigitalCard/DigitalCardExist.dart';

import '../../Profile/widgets/show_loading_dialoges.dart';
import '../../data/constants.dart';
import '../../helpers/dialog_alert.dart';
import '../../helpers/user_model.dart';
import '../../others/auth_controller.dart';

class DigitalCard extends StatefulWidget {
  const DigitalCard({Key? key}) : super(key: key);
  @override
  State<DigitalCard> createState() => _DigitalCard();
}

class _DigitalCard extends State<DigitalCard> {
  int? _selectedOption;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
    _selectedOption = 0; // Initialize _selectedOption to a non-null value
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.kprimaryblue,
      body: SafeArea(
          child: _auth.currentUser!.isAnonymous
              ? getDigitalCard()
              : StreamBuilder<UserModel>(
                  stream: _firestore
                      .collection('Passenger') //from passengers collection
                      .doc(_auth.currentUser!.uid)
                      .snapshots()
                      .map((event) => UserModel.fromMap(event.data() as Map<
                          String,
                          dynamic>)), //Converting data from stream to Usermodel
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    UserModel? user = snapshot.data!;

                    return user.Pass_Expired_date != "0"
                        ? const DigitalCardExist()
                        : getDigitalCard();
                  })),
    );
  }

  Widget getDigitalCard() {
    return Column(
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
        AspectRatio(
          aspectRatio: Get.width / (Get.height * 0.79),
          child: Container(
            decoration: const BoxDecoration(
                color: Color(0xFFFAFAFA),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40),
                    topLeft: Radius.circular(40))),
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
                          const Positioned(
                            bottom: 0,
                            left: 0,
                            child: Padding(
                              padding: EdgeInsets.all(18),
                              child: Text(
                                'Activate Your Card',
                                style: TextStyle(
                                    fontSize: 25, color: Colors.white),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: GestureDetector(
                              onTap: () {
                                if (FirebaseAuth
                                    .instance.currentUser!.isAnonymous) {
                                  showConfirmationDialog(
                                      heading: "Alert",
                                      message:
                                          "You must register to add a pass.",
                                      okText: "Register",
                                      onPressedOk: () {
                                        Get.back();
                                        AuthController().signOut();
                                      },
                                      cancel: () {
                                        Get.back();
                                        // 1.seconds.delay().then((value) {
                                        //   setState(() {
                                        //     index = 0;
                                        //   });
                                        // });
                                      });
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Choose Your Pass',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 25,
                                                color: Color(0xFF273169))),
                                        actions: [
                                          StatefulBuilder(
                                            builder: (BuildContext context,
                                                setState) {
                                              return Container(
                                                width: double.maxFinite,
                                                height: 200,
                                                child: ListView(
                                                  children: [
                                                    RadioListTile(
                                                      value: 1,
                                                      groupValue:
                                                          _selectedOption,
                                                      title: const Text(
                                                          'Daily,      Only 5 SAR',
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              color: Color(
                                                                  0xFF273169))),
                                                      onChanged: (int? value) {
                                                        setState(() {
                                                          _selectedOption =
                                                              value;
                                                        });
                                                      },
                                                    ),
                                                    RadioListTile(
                                                      value: 2,
                                                      groupValue:
                                                          _selectedOption,
                                                      title: const Text(
                                                          'Weekly,  Only 30 SAR',
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              color: Color(
                                                                  0xFF273169))),
                                                      onChanged: (int? value) {
                                                        setState(() {
                                                          _selectedOption =
                                                              value;
                                                        });
                                                      },
                                                    ),
                                                    RadioListTile(
                                                      value: 3,
                                                      groupValue:
                                                          _selectedOption,
                                                      title: const Text(
                                                          'Monthly, Only 100 SAR',
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              color: Color(
                                                                  0xFF273169))),
                                                      onChanged: (int? value) {
                                                        setState(() {
                                                          _selectedOption =
                                                              value;
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                          Align(
                                            alignment: Alignment.bottomCenter,
                                            child: TextButton(
                                              child: const Text('Pay',
                                                  style: TextStyle(
                                                      fontSize: 25,
                                                      color:
                                                          Color(0xFF50B2CC))),
                                              onPressed: () {
                                                if (_selectedOption != 0) {
                                                  handlePass(context);
                                                }
                                              },
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                        ],
                                        contentPadding:
                                            const EdgeInsets.all(15),
                                      );
                                    },
                                  );
                                }
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(13),
                                child: Icon(
                                  Icons.add,
                                  size: 40,
                                  color: Color(0xFF50B2CC),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: 330,
                      height: 320,
                      padding: const EdgeInsets.only(
                        top: 20,
                        left: 8,
                        right: 8,
                        bottom: 0,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xffECEEF3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Align(
                            alignment: Alignment.topCenter,
                            child: Text(
                              'Save more with our different passes, Discover the passes ',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 22, color: Color(0xFF273169)),
                            ),
                          ),
                          Container(
                            width: 260,
                            height: 65,
                            padding: const EdgeInsets.only(top: 12, left: 14),
                            decoration: BoxDecoration(
                              color: const Color(0xFFcfe6e9),
                              borderRadius: BorderRadius.circular(17),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text('Daily',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20,
                                        color: Color(0xFF273169))),
                                Text('Unlimited  Access Through The Day',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF273169))),
                              ],
                            ),
                          ),
                          Container(
                            width: 260,
                            height: 65,
                            padding: const EdgeInsets.only(top: 12, left: 14),
                            decoration: BoxDecoration(
                              color: const Color(0xFFacdae3),
                              borderRadius: BorderRadius.circular(17),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text('Weekly',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20,
                                        color: Color(0xFF273169))),
                                Text('Unlimited  Access Through 7 Days',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF273169))),
                              ],
                            ),
                          ),
                          Container(
                            width: 260,
                            height: 65,
                            padding: const EdgeInsets.only(top: 12, left: 14),
                            decoration: BoxDecoration(
                              color: const Color(0xFF8ED0DE),
                              borderRadius: BorderRadius.circular(17),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text('Monthly',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20,
                                        color: Color(0xFF273169))),
                                Text('Unlimited  Access Through 30 Days',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF273169))),
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const Expanded(
            child: Scaffold(
          backgroundColor: Color(0xFFFAFAFA),
        ))
      ],
    );
  }

  void handlePass(BuildContext context) {
    var name = '';
    var days = 0;
    var price = 0;
    if (_selectedOption == 1) {
      name = "Daily, Only 5 SAR";
      days = 1;
      price = 5;
    } else if (_selectedOption == 2) {
      name = "Weekly,  Only 30 SAR";
      price = 30;
      days = 7;
    } else if (_selectedOption == 3) {
      name = "Monthly, Only 100 SAR";
      price = 100;
      days = 30;
    }
    Navigator.of(context).pop();
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
