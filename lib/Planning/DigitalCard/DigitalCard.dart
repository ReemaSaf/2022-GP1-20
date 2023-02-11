import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_paypal/flutter_paypal.dart';
import '../../data/constants.dart';

class DigitalCard extends StatefulWidget {
  const DigitalCard({Key? key}) : super(key: key);
  @override
  State<DigitalCard> createState() => _DigitalCard();
}

class _DigitalCard extends State<DigitalCard> {
  int? _selectedOption;
  @override
  void initState() {
    super.initState();
    _selectedOption = 0; // Initialize _selectedOption to a non-null value
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      
        backgroundColor: CustomColor.kprimaryblue,
        body: SafeArea(
            child: Column(
              children: [
                const Padding(
                    padding: EdgeInsets.only(top: 30, bottom: 20),
                    child: Center(
                      child: Text(
                        "Digital Card",
                        style: TextStyle(color: Colors.white),
                      ),
                      ),
                      ),
                    

                AspectRatio(
                  aspectRatio: Get.width/(Get.height*0.79),
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
                                    child: Stack(children: [
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
                                                fontSize: 25,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 0,
                              bottom: 0,
                              child: GestureDetector(
                                onTap: () {
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
                                            builder: (BuildContext context,setState) {
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
                                      );
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
                          color:  const Color(0xffECEEF3),
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
                              padding: const EdgeInsets.only(top: 12, left:14),
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
         ) ,
          const Expanded(
              child: Scaffold(
                backgroundColor: Color(0xFFFAFAFA),
              )
            )
         ],
         ),
    ),
     
    );
          
  }
}
