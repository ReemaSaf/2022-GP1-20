// ignore_for_file: prefer_const_literals_to_create_immutables, file_names, prefer_interpolation_to_compose_strings

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sekkah_app/helpers/user_model.dart';

import '../Homepage/components/user_nav.dart';
import '../Planning/DigitalCard/DigitalCardExist.dart';
import '../helpers/route_model.dart';
import 'TicketWidget.dart';

class Tickets extends StatefulWidget {
  const Tickets(
      {Key? key,
      required this.start,
      required this.end,
      required this.date,
      required this.tickets,
      required this.routeTime,
      required this.route,})
      : super(key: key);

  final String start;
  final String end;
  final DateTime date;
  final int tickets;
  final String routeTime;
  final List<RouteModel> route;
  @override
  State<Tickets> createState() => _Tickets();
}

class _Tickets extends State<Tickets> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
  }

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: StreamBuilder<UserModel>(
          stream: _firestore
              .collection('Passenger') //from passengers collection
              .doc(auth.currentUser!.uid)
              .snapshots()
              .map((event) => UserModel.fromMap(event.data() as Map<String,
                  dynamic>)), //Converting data from stream to Usermodel
          builder: (context, snapshot) {
            //Check State, If is Waiting  show Circular Indicator
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            UserModel? user = snapshot.data!;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30, bottom: 20),
                  child: Center(
                    child: Text(
                      'My Ticket',
                      style: poppinsMedium.copyWith(
                        fontSize: 18.0,
                        color: AppColors.blueDarkColor,
                      ),
                    ),
                  ),
                ),
               
                   Expanded(
                    child:Container(
                    
                    width: width(context),
                    padding: EdgeInsets.symmetric(
                        horizontal: height(context) * 0.01,
                        vertical: height(context) * 0.02),
                    decoration: const BoxDecoration(
                        color: AppColors.blueDarkColor,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(40),
                            topLeft: Radius.circular(40))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 25),
                        TripDurationBox(
                          routeTime: widget.routeTime,
                          start: widget.start,
                          end: widget.end,
                          date: widget.date,
                          tickets: widget.tickets,
                          username: user.firstName + " " + user.lastName,
                          route: widget.route,
                        ),
                        const SizedBox(height: 100),
                        SizedBox(
                          // height: 35, //height of button
                          width: 200,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.skyColor,
                            ),
                            onPressed: () {
                              print('tranfer to history');
                              Get.offAll(const NavScreen(inh: 3));
                            },
                            child: Text(
                              'Go To Tickets',
                              style: poppinsMedium.copyWith(
                                fontSize: 16.0,
                                color: AppColors.whiteColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                   ),
                
                // const Expanded(
                //     child: Scaffold(
                //   backgroundColor: Color(0xFFFAFAFA),
                // ))
              ],
            );
          },
        ),
      ),
    );
  }
}
