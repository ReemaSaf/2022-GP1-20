// ignore_for_file: file_names, library_private_types_in_public_api, depend_on_referenced_packages, non_constant_identifier_names, unused_field, unused_local_variable, sized_box_for_whitespace, avoid_print, sort_child_properties_last

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:intl/intl.dart';
import 'constants/app_colors.dart';
import 'constants/app_text_styles.dart';

class BuyTicket extends StatefulWidget {
   const BuyTicket({super.key});

  @override
  _BuyTicketState createState() => _BuyTicketState();
}

class _BuyTicketState extends State<BuyTicket> {
  int? _selectedOption = 0;

  get $_price => _price;

  void _incrementPassengerCount() {
    setState(() {
      if (_passengerCount < 6) {
        _passengerCount++;
        _price = _passengerCount * 5;
        _sarPrice = (_price * 0.267);
      }
    });
  }

  void _decrementPassengerCount() {
    setState(() {
      if (_passengerCount > 1) {
        _passengerCount--;
        _price = _passengerCount * 5;
        _sarPrice = (_price * 0.267);
      }
    });
  }

  int _passengerCount = 1;
  int _price = 5;
  double _sarPrice = (5 * 0.267);

  DateTime _dateTime = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      DateTime.now().hour,
      (((DateTime.now().minute / 15).round() + 1) * 15) % 60);

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: AppColors.blueDarkColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          'Select a route',
          style: poppinsMedium.copyWith(
            fontSize: 18.0,
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

              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [

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
                      onClicked: () => Utils.showSheet(
                        context,
                        child: buildDateTimePicker(),
                        onClicked: () {
                          final value =
                              DateFormat('MM/dd/yyyy HH:mm').format(_dateTime);
                          // Utils.showSnackBar(context, 'Selected "$value"');

                          Navigator.pop(context);
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
                      height: 54,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            child: Container(
                              padding: const EdgeInsets.only(bottom: 7),
                              height: 54,
                              width: 155,
                              decoration: const BoxDecoration(
                                color: AppColors.whiteLightColor,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(7.0),
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
                                        color: AppColors.skyColor,
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
                              child: Container(
                            height: 54,
                            width: 155,
                            decoration: const BoxDecoration(
                              color: AppColors.whiteLightColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(7.0),
                              ),
                            ),

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
                                      color: AppColors.skyColor,
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
                          )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        'Total Price: $_price SAR',
                        style: poppinsMedium.copyWith(
                          fontSize: 16.0,
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
                            onPressed: () => {
                                  if (_selectedOption == 1)
                                    {
                                      Navigator.of(context).push(
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
                                                  transactions: const [
                                                    {
                                                      "amount": {
                                                        "total": '10',
                                                        "currency": "USD",
                                                        "details": {
                                                          "subtotal": '10',
                                                          "shipping": '0',
                                                          "shipping_discount": 0
                                                        }
                                                      },
                                                      "description":
                                                          "The payment transaction description.",
                                                      // "payment_options": {
                                                      //   "allowed_payment_method":
                                                      //       "INSTANT_FUNDING_SOURCE"
                                                      // },
                                                      "item_list": {
                                                        "items": [
                                                          {
                                                            "name":
                                                                "A demo product",
                                                            "quantity": 1,
                                                            "price": '10',
                                                            "currency": "USD"
                                                          }
                                                        ],

                                                        // shipping address is not required though
                                                        "shipping_address": {
                                                          "recipient_name":
                                                              "Jane Foster",
                                                          "line1":
                                                              "Travis County",
                                                          "line2": "",
                                                          "city": "Austin",
                                                          "country_code": "US",
                                                          "postal_code":
                                                              "73301",
                                                          "phone": "+00000000",
                                                          "state": "Texas"
                                                        },
                                                      }
                                                    }
                                                  ],
                                                  note:
                                                      "Contact us for any questions on your order.",
                                                  onSuccess:
                                                      (Map params) async {
                                                    print("onSuccess: $params");
                                                  },
                                                  onError: (error) {
                                                    print("onError: $error");
                                                  },
                                                  onCancel: (params) {
                                                    print('cancelled: $params');
                                                  }),
                                        ),
                                      )
                                    }
                                  else if (_selectedOption == 2)
                                    {print('transfer to ticket')}
                                  else
                                    print('choose option')
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

class YourClass {
  int passengerCount = 1;
  int price = 5;
  double sarPrice = (5 * 0.267);
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

  const ButtonWidget({
    Key? key,
    required this.onClicked,
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
          children: const [
            Icon(Icons.more_time, size: 28),
            //const SizedBox(width: 8),
          ],
        ),
      );
}
